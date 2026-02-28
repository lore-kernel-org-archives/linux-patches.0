Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E935AC01
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302679; cv=none; b=D+Hk044Ve2TbYDLPLk1Z6sfpO+EjmMkTiXjRqoEje23Wvjgggl/3zhm5KKzb86pTj9ocPyNk8Qt0HxCyRRLlK9DbKNNtPiUqC2pp1gY9tV8FwSuCdyQogXQwiAIY18/uA6hMMPaZVEnyRrUwWgTl7QIriLqi0wbAz176G4wlVDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302679; c=relaxed/simple;
	bh=HQYxzix8FnXNdIvDBD7CvjSjjOVOI1BLQ4lXS7vPxXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1RtftJ8oM/wNHTtRSeQlv07AizT2gVheWBtFFZuq3v0dTrSSFEMxfQNBZLqtkbgxiQe8eMRprrNLRALPmRBxXwdVyIGQjbQK9PKicQ9Mzr8QTBhdjKiV/F48rR8nZcX9Dt6r4yuFkNNxVfag66SJo4cHtrp+eniVRJQs1IkKTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AAejDUK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AAejDUK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503A1C19424;
	Sat, 28 Feb 2026 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302679;
	bh=HQYxzix8FnXNdIvDBD7CvjSjjOVOI1BLQ4lXS7vPxXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAejDUK72TSq0kZKNUf91f7KDsc6bTP08LrIfXqvjP8zA1/0EXIlEVPQSLwIAoqln
	 FmtsITAqRfsHcN/xRr9zkarRuRP97rymagtatBVKdPdYHTkbpvuQqlPfLO8/K5zQDI
	 SkrQEMV1E8YtAAFKl4hfJ5SYWaJ32leoH/LCztdi99Abfnefyx8t8j17TMubUL8gU/
	 9WY6YVXRcwhWLPpOY+w4uEBW0zPvuNclTa+axsqAvORnO6Vtu7U3zeg/zMlwUfVOcL
	 k/QedfHV5jS3I1X60X83KwW7fza2wG/nRBq7bQogtKV469sueGRPUU8UXQWp4QdBvo
	 LMMIt69s9NLTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sai Ritvik Tanksalkar <stanksal@purdue.edu>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/147] pstore/ram: fix buffer overflow in persistent_ram_save_old()
Date: Sat, 28 Feb 2026 13:15:38 -0500
Message-ID: <20260228181736.1605592-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 5ac9b1f155a81..97ec9041b9b98 100644
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
 		prz->old_log = kmalloc(size, GFP_KERNEL);
-- 
2.51.0

