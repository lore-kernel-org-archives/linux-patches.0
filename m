Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB18242D9B;
	Wed, 25 Feb 2026 01:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982962; cv=none; b=fouOcLMqN40rj+eqiNkU3bVUocqNNvz+u0zYhRVSClCDeDIGPmrSQSJHeI7vRIOCDk1QEYwmHSia5KEBv5/cafVmsvs5CjB2NnjVcO9uMfvSfKufvszG+enpNCmmIKK9C26eirvJVst2arsu+RhzsnwvAL0p/HROL1IARRl580g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982962; c=relaxed/simple;
	bh=JhWLXe9r+9J2v6QbGkliz+bO4ZHzQkzBgx1ipKwe0cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iahp+aAumiK3aTc57RK8LeiUsuLUOhc5pTKEhnQuFW/6gRd60qLAHORK3z8K2Hp04XWhhAQuEZjzRzQaE9coWg50cfs3CPf+vtP70lsmuWXEB3+AYqV2bx/gHi8vynHjuQHlM2c6f3sSVSWBVEaL7a1rAyHO0+eoddRUpkYRgJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXtscyxu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXtscyxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C01C116D0;
	Wed, 25 Feb 2026 01:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982962;
	bh=JhWLXe9r+9J2v6QbGkliz+bO4ZHzQkzBgx1ipKwe0cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXtscyxu2j/CUOHDOXEqdGIoFfrylKE9er0I1g+K//T15+Fa1VlKGw1vojqW/KR65
	 8AXrFUl+FGJW0mB/q+5RUmrhjimTjLRnANvhyJHa/wcrvD43NAVt2CEv9QQGzRoUgM
	 wt8ALB5P+beatbPPyq3utsuZgfG7BLHU7D0mAIRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Ritvik Tanksalkar <stanksal@purdue.edu>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 138/781] pstore/ram: fix buffer overflow in persistent_ram_save_old()
Date: Tue, 24 Feb 2026 17:14:07 -0800
Message-ID: <20260225012403.055212265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



