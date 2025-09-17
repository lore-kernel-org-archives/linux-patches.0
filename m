Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFF7309DDD;
	Wed, 17 Sep 2025 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113247; cv=none; b=S7bXmsce6bCs2cL+pBTbsCdjhAh6N6grLRcXs9hdJ29uvUjh3qfG+lQnsp3pL4tNHoZpkOVGNH9HzMeMzzjW0CA/c4cWun57mf9avqGOCL/z81+3OEIdaDpn7bdpb3a0kOlLV/oqaudIXuyj2WRmcxm5KsA5diH7eCA1fYXSzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113247; c=relaxed/simple;
	bh=CrsnM1diYIiYXjnkrDnOAPHUU7UlS8HegNPqTBgQs0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwpNynkRKVQWRHer3hxrtCy15RFurtOd6DqjgS1HaRbkTbbrGjDHO9jm40NaDFnmI1IjxG0JovAakKasDxBIHn7OPzTamjrQto3c6PJzfx8oDCfLqXQ6kdb3ZlvWfxm519eWnR8TUOHVoAekXGoP91XPcwRA67tTDzOSZxzUeus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxdshyXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxdshyXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C7C4CEF0;
	Wed, 17 Sep 2025 12:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113246;
	bh=CrsnM1diYIiYXjnkrDnOAPHUU7UlS8HegNPqTBgQs0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxdshyXY/pDBHoODZi2o1xrnEkEmAP8HBHxBIJYXRaWFK/10P7EKeRicQCBUu9Bzr
	 Uootcj8s5yY1uSgxDcLDVzWpMi0dGjSXuzjqjmKtgp/cJMuKTipYVap7tgdsgb3z5X
	 JXEEMAhCj77casqpzmGnp+V3MiSMOWteeH638fgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/140] tracing: Fix tracing_marker may trigger page fault during preempt_disable
Date: Wed, 17 Sep 2025 14:33:19 +0200
Message-ID: <20250917123344.971008787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 3d62ab32df065e4a7797204a918f6489ddb8a237 ]

Both tracing_mark_write and tracing_mark_raw_write call
__copy_from_user_inatomic during preempt_disable. But in some case,
__copy_from_user_inatomic may trigger page fault, and will call schedule()
subtly. And if a task is migrated to other cpu, the following warning will
be trigger:
        if (RB_WARN_ON(cpu_buffer,
                       !local_read(&cpu_buffer->committing)))

An example can illustrate this issue:

process flow						CPU
---------------------------------------------------------------------

tracing_mark_raw_write():				cpu:0
   ...
   ring_buffer_lock_reserve():				cpu:0
      ...
      cpu = raw_smp_processor_id()			cpu:0
      cpu_buffer = buffer->buffers[cpu]			cpu:0
      ...
   ...
   __copy_from_user_inatomic():				cpu:0
      ...
      # page fault
      do_mem_abort():					cpu:0
         ...
         # Call schedule
         schedule()					cpu:0
	 ...
   # the task schedule to cpu1
   __buffer_unlock_commit():				cpu:1
      ...
      ring_buffer_unlock_commit():			cpu:1
	 ...
	 cpu = raw_smp_processor_id()			cpu:1
	 cpu_buffer = buffer->buffers[cpu]		cpu:1

As shown above, the process will acquire cpuid twice and the return values
are not the same.

To fix this problem using copy_from_user_nofault instead of
__copy_from_user_inatomic, as the former performs 'access_ok' before
copying.

Link: https://lore.kernel.org/20250819105152.2766363-1-luogengkun@huaweicloud.com
Fixes: 656c7f0d2d2b ("tracing: Replace kmap with copy_from_user() in trace_marker writing")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ba3358eef34ba..87a43c0f90764 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6949,7 +6949,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	entry = ring_buffer_event_data(event);
 	entry->ip = _THIS_IP_;
 
-	len = __copy_from_user_inatomic(&entry->buf, ubuf, cnt);
+	len = copy_from_user_nofault(&entry->buf, ubuf, cnt);
 	if (len) {
 		memcpy(&entry->buf, FAULTED_STR, FAULTED_SIZE);
 		cnt = FAULTED_SIZE;
@@ -7020,7 +7020,7 @@ tracing_mark_raw_write(struct file *filp, const char __user *ubuf,
 
 	entry = ring_buffer_event_data(event);
 
-	len = __copy_from_user_inatomic(&entry->id, ubuf, cnt);
+	len = copy_from_user_nofault(&entry->id, ubuf, cnt);
 	if (len) {
 		entry->id = -1;
 		memcpy(&entry->buf, FAULTED_STR, FAULTED_SIZE);
-- 
2.51.0



