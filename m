Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12918379EE4
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301698; cv=none; b=F4Jpk3hliPbGZ02Ha368vb9LZ6ZahZ6JKfkuUjX/9w/xjZi8gVpTv9U6Li112rzMw9Vt/6wnCnszmmMfc7WcSKjLZ+61vYi/p2lSaRFs15Ewo+B7ZeJ0NgN+dfz9ySJG6lM1GsHAcWCxg7VdJS9YHBnCGgnjmUaAi0er4C0GE9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301698; c=relaxed/simple;
	bh=LetwyJ8txSrCKq4meC++UwO+UDC5DQhN87AgOgaAObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbFVnd2Av13hDS9FNmsX7KcMQXqrFFBkRPPIJP8C/olCaiI7QD3clziyf0lCQrQ1MfbBwqRcc3LSWyONtOzgb8c5W37w79plYphXEpjFH8EPWjHvnJgPit4QVGWvMRy1E4Rxrt8Z6djpZWFNvyHFubiCU5nUmR3JRPwY3H6PVz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGCN7RKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGCN7RKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7456BC19425;
	Sat, 28 Feb 2026 18:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301698;
	bh=LetwyJ8txSrCKq4meC++UwO+UDC5DQhN87AgOgaAObw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGCN7RKH55j8b1yTNc5EyY5bmknYmWfzQ4mYrd76v+cV6xx1hHlndn2t1P0Bjy5rx
	 aklWrsDLT3yQdMIdvo7n02YWoUyrQdRlG5OpREtnZOJK4JoNWgPG5F3gafLBlVY+ik
	 SHQEkvj19WnKaOm5xdsci4OAJu8A+egBOoIcKbcpyDvsYniAANJelhQ5Y6dnrY/5E9
	 2orAmItTK1dDGq+b726Rzyfk+foR8DgcRydcem4gYVuzXZvucLaOTFxW2aGO9KCg7l
	 m+rs6aMYDW9TcBCfkih1X/QBWjgUCkmBq731F3K1Ku8OZtBb1nyYtC1/RoQ3eLHggT
	 2Hw09TVveeY8Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sai Ritvik Tanksalkar <stanksal@purdue.edu>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/385] pstore/ram: fix buffer overflow in persistent_ram_save_old()
Date: Sat, 28 Feb 2026 12:55:12 -0500
Message-ID: <20260228180011.1568201-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sai Ritvik Tanksalkar <stanksal@purdue.edu>

[ Upstream commit 5669645c052f235726a85f443769b6fc02f66762 ]

persistent_ram_save_old() can be called multiple times for the same
persistent_ram_zone (e.g., via ramoops_pstore_read -> ramoops_get_next_prz
for PSTORE_TYPE_DMESG records).

Currently, the function only allocates prz->old_log when it is NULL,
but it unconditionally updates prz->old_log_size to the current buffer
size and then performs memcpy_fromio() using this new size. If the
buffer size has grown since the first allocation (which can happen
across different kernel boot cycles), this leads to:

1. A heap buffer overflow (OOB write) in the memcpy_fromio() calls
2. A subsequent OOB read when ramoops_pstore_read() accesses the buffer
   using the incorrect (larger) old_log_size

The KASAN splat would look similar to:
  BUG: KASAN: slab-out-of-bounds in ramoops_pstore_read+0x...
  Read of size N at addr ... by task ...

The conditions are likely extremely hard to hit:

  0. Crash with a ramoops write of less-than-record-max-size bytes.
  1. Reboot: ramoops registers, pstore_get_records(0) reads old crash,
     allocates old_log with size X
  2. Crash handler registered, timer started (if pstore_update_ms >= 0)
  3. Oops happens (non-fatal, system continues)
  4. pstore_dump() writes oops via ramoops_pstore_write() size Y (>X)
  5. pstore_new_entry = 1, pstore_timer_kick() called
  6. System continues running (not a panic oops)
  7. Timer fires after pstore_update_ms milliseconds
  8. pstore_timefunc() → schedule_work() → pstore_dowork() → pstore_get_records(1)
  9. ramoops_get_next_prz() → persistent_ram_save_old()
 10. buffer_size() returns Y, but old_log is X bytes
 11. Y > X: memcpy_fromio() overflows heap

  Requirements:
  - a prior crash record exists that did not fill the record size
    (almost impossible since the crash handler writes as much as it
    can possibly fit into the record, capped by max record size and
    the kmsg buffer almost always exceeds the max record size)
  - pstore_update_ms >= 0 (disabled by default)
  - Non-fatal oops (system survives)

Free and reallocate the buffer when the new size differs from the
previously allocated size. This ensures old_log always has sufficient
space for the data being copied.

Fixes: 201e4aca5aa1 ("pstore/ram: Should update old dmesg buffer before reading")
Signed-off-by: Sai Ritvik Tanksalkar <stanksal@purdue.edu>
Link: https://patch.msgid.link/20260201132240.2948732-1-stanksal@purdue.edu
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index f1848cdd6d348..c9eaacdec37e4 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -298,6 +298,17 @@ void persistent_ram_save_old(struct persistent_ram_zone *prz)
 	if (!size)
 		return;
 
+	/*
+	 * If the existing buffer is differently sized, free it so a new
+	 * one is allocated. This can happen when persistent_ram_save_old()
+	 * is called early in boot and later for a timer-triggered
+	 * survivable crash when the crash dumps don't match in size
+	 * (which would be extremely unlikely given kmsg buffers usually
+	 * exceed prz buffer sizes).
+	 */
+	if (prz->old_log && prz->old_log_size != size)
+		persistent_ram_free_old(prz);
+
 	if (!prz->old_log) {
 		persistent_ram_ecc_old(prz);
 		prz->old_log = kvzalloc(size, GFP_KERNEL);
-- 
2.51.0

