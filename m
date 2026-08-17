Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D320424D72;
	Mon, 17 Aug 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978192; cv=none; b=JlpLKpCRKVH771LbsnSB/HyzcGIo9MZl9oL1yL23blAYz8n6oCgKGIGwhkCKnr20eD9ZWpo/86CGgrDgeRyN49Xq2oke/bPh9Fc9y6NTYySeQlGpNAo8+6qhM9O1eL7PNV8VEQwIcNBBBUhWUjhY9jiC4CFnnEEgh/F0QND/7MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978192; c=relaxed/simple;
	bh=djFbG7OH4Hw/CZcwvgY31D7ZBl15Je6WkmMeIeHzxGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVZbOnTkrTIL4V9PXzRUyabLARjgMcA+J/LuRBftbc52d/EALtAc4i9CJw83PsHz+HTzlNrdPJhXxuC9HPBNcehcH35TCoYSyQ8A4VC9hs69VBtLsi4Aw2JIgn/Lvsv7XQIwEvzJvFcL5CeFk4/SspDTsNAnDKNmCSic8srm9po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQzxtBDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQzxtBDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29611F000E9;
	Mon, 17 Aug 2026 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978191;
	bh=j77gci5IUk3VQR8V1es53uZJA/XYIyEfiNCZLADnLCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQzxtBDc2Yx2W4wWsHnf9iSLdodhBRwgTP5b2yM+4A7CDZF6AnXzXX1wsVcE94ltm
	 NZZrsdRI82RMYtz9wUb2c4/vxt0juvvO9wm8GQ2MZ8fw/lS566WL04kVqaf+RNWbDu
	 Su8fwIvYPcErV1ALyGsyyVdMwB9/rdX+W9iRZ3jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 134/181] ring-buffer: Fix crash passing ERR_PTR to kthread_stop()
Date: Mon, 17 Aug 2026 15:33:48 +0200
Message-ID: <20260817132540.893206488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7604,7 +7604,7 @@ static __init int test_ringbuffer(void)
 
  out_free:
 	for_each_online_cpu(cpu) {
-		if (!rb_threads[cpu])
+		if (IS_ERR_OR_NULL(rb_threads[cpu]))
 			break;
 		kthread_stop(rb_threads[cpu]);
 	}


