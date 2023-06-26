Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE7AC8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2317EC433C0;
	Mon, 26 Jun 2023 18:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687805001;
	bh=80gq+VNT11erKbA/MukUFAU0f4hnJbin1ASb9CFBQGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbDh8/Kgt2DkuLEQQ5z96SvSwvQkTmh3uoz7VZoMok/DoWnA6rb929SCyjdKUevvT
	 9FP13fyOl8XOeN+98UvQlHbEKmTk3VBlgZAC39GG1EvRWhF0isA5pmDzRSiK1hn72d
	 ZGIW3Wzg1XWo7RqCkNr6hjwje6OZMDOjIt867eg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 17/81] mmc: meson-gx: remove redundant mmc_request_done() call from irq context
Date: Mon, 26 Jun 2023 20:11:59 +0200
Message-ID: <20230626180745.163944493@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>
References: <20230626180744.453069285@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Hundebøll <martin@geanix.com>

commit 3c40eb8145325b0f5b93b8a169146078cb2c49d6 upstream.

The call to mmc_request_done() can schedule, so it must not be called
from irq context. Wake the irq thread if it needs to be called, and let
its existing logic do its work.

Fixes the following kernel bug, which appears when running an RT patched
kernel on the AmLogic Meson AXG A113X SoC:
[   11.111407] BUG: scheduling while atomic: kworker/0:1H/75/0x00010001
[   11.111438] Modules linked in:
[   11.111451] CPU: 0 PID: 75 Comm: kworker/0:1H Not tainted 6.4.0-rc3-rt2-rtx-00081-gfd07f41ed6b4-dirty #1
[   11.111461] Hardware name: RTX AXG A113X Linux Platform Board (DT)
[   11.111469] Workqueue: kblockd blk_mq_run_work_fn
[   11.111492] Call trace:
[   11.111497]  dump_backtrace+0xac/0xe8
[   11.111510]  show_stack+0x18/0x28
[   11.111518]  dump_stack_lvl+0x48/0x60
[   11.111530]  dump_stack+0x18/0x24
[   11.111537]  __schedule_bug+0x4c/0x68
[   11.111548]  __schedule+0x80/0x574
[   11.111558]  schedule_loop+0x2c/0x50
[   11.111567]  schedule_rtlock+0x14/0x20
[   11.111576]  rtlock_slowlock_locked+0x468/0x730
[   11.111587]  rt_spin_lock+0x40/0x64
[   11.111596]  __wake_up_common_lock+0x5c/0xc4
[   11.111610]  __wake_up+0x18/0x24
[   11.111620]  mmc_blk_mq_req_done+0x68/0x138
[   11.111633]  mmc_request_done+0x104/0x118
[   11.111644]  meson_mmc_request_done+0x38/0x48
[   11.111654]  meson_mmc_irq+0x128/0x1f0
[   11.111663]  __handle_irq_event_percpu+0x70/0x114
[   11.111674]  handle_irq_event_percpu+0x18/0x4c
[   11.111683]  handle_irq_event+0x80/0xb8
[   11.111691]  handle_fasteoi_irq+0xa4/0x120
[   11.111704]  handle_irq_desc+0x20/0x38
[   11.111712]  generic_handle_domain_irq+0x1c/0x28
[   11.111721]  gic_handle_irq+0x8c/0xa8
[   11.111735]  call_on_irq_stack+0x24/0x4c
[   11.111746]  do_interrupt_handler+0x88/0x94
[   11.111757]  el1_interrupt+0x34/0x64
[   11.111769]  el1h_64_irq_handler+0x18/0x24
[   11.111779]  el1h_64_irq+0x64/0x68
[   11.111786]  __add_wait_queue+0x0/0x4c
[   11.111795]  mmc_blk_rw_wait+0x84/0x118
[   11.111804]  mmc_blk_mq_issue_rq+0x5c4/0x654
[   11.111814]  mmc_mq_queue_rq+0x194/0x214
[   11.111822]  blk_mq_dispatch_rq_list+0x3ac/0x528
[   11.111834]  __blk_mq_sched_dispatch_requests+0x340/0x4d0
[   11.111847]  blk_mq_sched_dispatch_requests+0x38/0x70
[   11.111858]  blk_mq_run_work_fn+0x3c/0x70
[   11.111865]  process_one_work+0x17c/0x1f0
[   11.111876]  worker_thread+0x1d4/0x26c
[   11.111885]  kthread+0xe4/0xf4
[   11.111894]  ret_from_fork+0x10/0x20

Fixes: 51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/r/20230607082713.517157-1-martin@geanix.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/meson-gx-mmc.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -970,11 +970,8 @@ static irqreturn_t meson_mmc_irq(int irq
 	if (status & (IRQ_END_OF_CHAIN | IRQ_RESP_STATUS)) {
 		if (data && !cmd->error)
 			data->bytes_xfered = data->blksz * data->blocks;
-		if (meson_mmc_bounce_buf_read(data) ||
-		    meson_mmc_get_next_command(cmd))
-			ret = IRQ_WAKE_THREAD;
-		else
-			ret = IRQ_HANDLED;
+
+		return IRQ_WAKE_THREAD;
 	}
 
 out:
@@ -986,9 +983,6 @@ out:
 		writel(start, host->regs + SD_EMMC_START);
 	}
 
-	if (ret == IRQ_HANDLED)
-		meson_mmc_request_done(host->mmc, cmd->mrq);
-
 	return ret;
 }
 


