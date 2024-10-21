Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8641E5728;
	Mon, 21 Oct 2024 10:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506578; cv=none; b=lpEL/lq3SWpwxyQhARPNRpoKXHtsgdhLnUHRLVXYJaVbmHm6p0Mi/MODVIw08P01AAShGO4HrZJ0R45Z0z2fzJWQrJTC4OeL7cXoUvjmNoSDqRrQY46eoP0EfMuAqdrONbUK/cOYbaAW9m4bBmMQ5+SiVQb0KX13X9dS8FkmTGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506578; c=relaxed/simple;
	bh=tEA6cu++Z85ocUStr/3ic/CaYamONFDMnCRnX6nyjyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsT810k+FvUtABONCBwMHA8mVh65hL9gHsuga2Hw6IBqDmS7m0zebShE6GKbCALMPSq1XI3XyloOCttF4OI3TWRwPNTF5Iw9jt30u//yA14ESoknN0vy1TvtvAYH6UNzqKjJE9lhA6UTIqYBAf/ERfa02IbkxrYNyfNqVfTGkB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wuBlUfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wuBlUfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF32C4CEC3;
	Mon, 21 Oct 2024 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506578;
	bh=tEA6cu++Z85ocUStr/3ic/CaYamONFDMnCRnX6nyjyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wuBlUfXCRB4Keemew/xDxn9XcHKlnYEMl0qKLbTR5T7dF/2QfAd0syxpETAoHq5t
	 s+0Bctfs3bztavLhrrXWzmvisxoEbzsDHyDhui2OzpZd0K2S2wBes9XWglxnBeFKnz
	 XtJ8TZDasTH5LKuahVkZPh90KbfBwM0+G0m/KeTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 052/135] io_uring/sqpoll: ensure task state is TASK_RUNNING when running task_work
Date: Mon, 21 Oct 2024 12:23:28 +0200
Message-ID: <20241021102301.366617361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 8f7033aa4089fbaf7a33995f0f2ee6c9d7b9ca1b upstream.

When the sqpoll is exiting and cancels pending work items, it may need
to run task_work. If this happens from within io_uring_cancel_generic(),
then it may be under waiting for the io_uring_task waitqueue. This
results in the below splat from the scheduler, as the ring mutex may be
attempted grabbed while in a TASK_INTERRUPTIBLE state.

Ensure that the task state is set appropriately for that, just like what
is done for the other cases in io_run_task_work().

do not call blocking ops when !TASK_RUNNING; state=1 set at [<0000000029387fd2>] prepare_to_wait+0x88/0x2fc
WARNING: CPU: 6 PID: 59939 at kernel/sched/core.c:8561 __might_sleep+0xf4/0x140
Modules linked in:
CPU: 6 UID: 0 PID: 59939 Comm: iou-sqp-59938 Not tainted 6.12.0-rc3-00113-g8d020023b155 #7456
Hardware name: linux,dummy-virt (DT)
pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
pc : __might_sleep+0xf4/0x140
lr : __might_sleep+0xf4/0x140
sp : ffff80008c5e7830
x29: ffff80008c5e7830 x28: ffff0000d93088c0 x27: ffff60001c2d7230
x26: dfff800000000000 x25: ffff0000e16b9180 x24: ffff80008c5e7a50
x23: 1ffff000118bcf4a x22: ffff0000e16b9180 x21: ffff0000e16b9180
x20: 000000000000011b x19: ffff80008310fac0 x18: 1ffff000118bcd90
x17: 30303c5b20746120 x16: 74657320313d6574 x15: 0720072007200720
x14: 0720072007200720 x13: 0720072007200720 x12: ffff600036c64f0b
x11: 1fffe00036c64f0a x10: ffff600036c64f0a x9 : dfff800000000000
x8 : 00009fffc939b0f6 x7 : ffff0001b6327853 x6 : 0000000000000001
x5 : ffff0001b6327850 x4 : ffff600036c64f0b x3 : ffff8000803c35bc
x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000e16b9180
Call trace:
 __might_sleep+0xf4/0x140
 mutex_lock+0x84/0x124
 io_handle_tw_list+0xf4/0x260
 tctx_task_work_run+0x94/0x340
 io_run_task_work+0x1ec/0x3c0
 io_uring_cancel_generic+0x364/0x524
 io_sq_thread+0x820/0x124c
 ret_from_fork+0x10/0x20

Cc: stable@vger.kernel.org
Fixes: af5d68f8892f ("io_uring/sqpoll: manage task_work privately")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.h |    1 +
 1 file changed, 1 insertion(+)

--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -322,6 +322,7 @@ static inline int io_run_task_work(void)
 		if (current->io_uring) {
 			unsigned int count = 0;
 
+			__set_current_state(TASK_RUNNING);
 			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
 			if (count)
 				ret = true;


