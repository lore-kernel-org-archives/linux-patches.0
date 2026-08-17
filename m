Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA15317144;
	Mon, 17 Aug 2026 13:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975149; cv=none; b=piEpejuojOWfZr/RqbSzN/AbKcdqM7HnE5KvoRzvtzRsKZ3Ce/6swk6icoecsKtzevjTO2rDUi7p+pXSjEKugJZq+Tgd16Ogn2Ev7lvXOpo8Znq7NjoRU+fwzzvZWIH45baH4sP6SHgziZi6nH520T315PriAXzNRVrBGlLTuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975149; c=relaxed/simple;
	bh=D5tBrHKucJayY8CLbriicWQgknsL+37Ywp1LQn19JZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz+LWMXSLw3OMsmt6SX8/YM0eiogLrMwREyZ2NeM9gj88VaBAZn8/zlYdm9lalp5k1rlWrXpU67Shr8VEDJ3V5LaQfIbswywgwqbkZ2jm6+lopzNYkV9YrMUG+s2U6L04JrFNUfT11oNr1CvNEIMJZvVGfFTabpZFfr2urYxZHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuogYsbn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuogYsbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4CD1F000E9;
	Mon, 17 Aug 2026 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975148;
	bh=bcJEPo5yO9TAzXbjsIeYLtwY559bW4HfJiMT9ThuWag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuogYsbnk0NLVC7zewIUVI21ol6JzzHYQs4jdyixNRyYL9ohUWpRfKj9yXzKPeLbk
	 qKtSNLi0mfUQio3idxM6OLXIjVnXsW5PmMyovapfrpWxrfBroKxX5sXvpd+AeFid3R
	 XCZ1ykJX1t7ey+ZruCbuynkgIr26itpWhNLxcTEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 179/250] ring-buffer: Fix crash passing ERR_PTR to kthread_stop()
Date: Mon, 17 Aug 2026 15:32:20 +0200
Message-ID: <20260817132543.908830151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

commit 91542863abade2fd4f2b361991f5386ad9d19c8c upstream.

In test_ringbuffer()'s out_free cleanup loop, the check
`!rb_threads[cpu]` only catches NULL entries and misses entries that
hold an ERR_PTR.

rb_threads[] is static, so unassigned slots are NULL. But when
kthread_run_on_cpu() fails for a cpu, it stores ERR_PTR(-ENOMEM) (or
-EINTR) in rb_threads[cpu] before the creation loop jumps to out_free.
That entry is non-NULL, so the old `!ptr` check does not break, and the
cleanup proceeds to call kthread_stop() on the ERR_PTR. kthread_stop()
then dereferences the bogus pointer, crashing the kernel during the
late_initcall self-test.

crash logs:
  BUG: kernel NULL pointer dereference, address: 000000000000001c
  Oops: 0002 [#1] SMP NOPTI
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 7.2.0-rc6-dirty #7 PREEMPT(lazy)
  RIP: 0010:kthread_stop+0x2e/0x220
  RBX: fffffffffffffff4
  CR2: 000000000000001c
  Call Trace:
   <TASK>
   test_ringbuffer+0x1ec/0x650
   do_one_initcall+0x6c/0x2c0
   kernel_init_freeable+0x21d/0x420
   kernel_init+0x15/0x1c0
   ret_from_fork+0x21b/0x320
   </TASK>
  Kernel panic - not syncing: Fatal exception

Cc: stable@vger.kernel.org
Fixes: 64ed3a049e3e ("ring-buffer: make use of the helper function kthread_run_on_cpu()")
Link: https://patch.msgid.link/20260807154145.2846521-2-sh_def@163.com
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7727,7 +7727,7 @@ static __init int test_ringbuffer(void)
 
  out_free:
 	for_each_online_cpu(cpu) {
-		if (!rb_threads[cpu])
+		if (IS_ERR_OR_NULL(rb_threads[cpu]))
 			break;
 		kthread_stop(rb_threads[cpu]);
 	}


