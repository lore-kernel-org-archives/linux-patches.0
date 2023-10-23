Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F24114A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnvmYFdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E633C433C7;
	Mon, 23 Oct 2023 11:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059537;
	bh=g0LhbdN5v1HR7G62+4TdMi6YsiYq0ZD+VJKpB6wFEz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnvmYFdQey5haBsVGZD2HBtJigDyE+tGZY/UcFZ+cnKy0DACwID2DRzlXgDrU92A7
	 lW8NKQ3d243D/yGeq2RpEbjDFJfOCrhd1MsV+GI+TSrhR19X7p5FZu9QIKBCRKyKq4
	 lvlX7EcjyJD7taIkev2nsOXsgijMPPn7OZh0Rx/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Sun <pablo.sun@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioachino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.5 173/241] mmc: mtk-sd: Use readl_poll_timeout_atomic in msdc_reset_hw
Date: Mon, 23 Oct 2023 12:55:59 +0200
Message-ID: <20231023104838.101938791@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Sun <pablo.sun@mediatek.com>

commit c7bb120c1c66672b657e95d0942c989b8275aeb3 upstream.

Use atomic readl_poll_timeout_atomic, because msdc_reset_hw
may be invoked in IRQ handler in the following context:

  msdc_irq() -> msdc_cmd_done() -> msdc_reset_hw()

The following kernel BUG stack trace can be observed on
Genio 1200 EVK after initializing MSDC1 hardware during kernel boot:

[    1.187441] BUG: scheduling while atomic: swapper/0/0/0x00010002
[    1.189157] Modules linked in:
[    1.204633] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.15.42-mtk+modified #1
[    1.205713] Hardware name: MediaTek Genio 1200 EVK-P1V2-EMMC (DT)
[    1.206484] Call trace:
[    1.206796]  dump_backtrace+0x0/0x1ac
[    1.207266]  show_stack+0x24/0x30
[    1.207692]  dump_stack_lvl+0x68/0x84
[    1.208162]  dump_stack+0x1c/0x38
[    1.208587]  __schedule_bug+0x68/0x80
[    1.209056]  __schedule+0x6ec/0x7c0
[    1.209502]  schedule+0x7c/0x110
[    1.209915]  schedule_hrtimeout_range_clock+0xc4/0x1f0
[    1.210569]  schedule_hrtimeout_range+0x20/0x30
[    1.211148]  usleep_range_state+0x84/0xc0
[    1.211661]  msdc_reset_hw+0xc8/0x1b0
[    1.212134]  msdc_cmd_done.isra.0+0x4ac/0x5f0
[    1.212693]  msdc_irq+0x104/0x2d4
[    1.213121]  __handle_irq_event_percpu+0x68/0x280
[    1.213725]  handle_irq_event+0x70/0x15c
[    1.214230]  handle_fasteoi_irq+0xb0/0x1a4
[    1.214755]  handle_domain_irq+0x6c/0x9c
[    1.215260]  gic_handle_irq+0xc4/0x180
[    1.215741]  call_on_irq_stack+0x2c/0x54
[    1.216245]  do_interrupt_handler+0x5c/0x70
[    1.216782]  el1_interrupt+0x30/0x80
[    1.217242]  el1h_64_irq_handler+0x1c/0x2c
[    1.217769]  el1h_64_irq+0x78/0x7c
[    1.218206]  cpuidle_enter_state+0xc8/0x600
[    1.218744]  cpuidle_enter+0x44/0x5c
[    1.219205]  do_idle+0x224/0x2d0
[    1.219624]  cpu_startup_entry+0x30/0x80
[    1.220129]  rest_init+0x108/0x134
[    1.220568]  arch_call_rest_init+0x1c/0x28
[    1.221094]  start_kernel+0x6c0/0x700
[    1.221564]  __primary_switched+0xc0/0xc8

Fixes: ffaea6ebfe9c ("mmc: mtk-sd: Use readl_poll_timeout instead of open-coded polling")
Signed-off-by: Pablo Sun <pablo.sun@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioachino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230922095348.22182-1-pablo.sun@mediatek.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -671,11 +671,11 @@ static void msdc_reset_hw(struct msdc_ho
 	u32 val;
 
 	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_RST);
-	readl_poll_timeout(host->base + MSDC_CFG, val, !(val & MSDC_CFG_RST), 0, 0);
+	readl_poll_timeout_atomic(host->base + MSDC_CFG, val, !(val & MSDC_CFG_RST), 0, 0);
 
 	sdr_set_bits(host->base + MSDC_FIFOCS, MSDC_FIFOCS_CLR);
-	readl_poll_timeout(host->base + MSDC_FIFOCS, val,
-			   !(val & MSDC_FIFOCS_CLR), 0, 0);
+	readl_poll_timeout_atomic(host->base + MSDC_FIFOCS, val,
+				  !(val & MSDC_FIFOCS_CLR), 0, 0);
 
 	val = readl(host->base + MSDC_INT);
 	writel(val, host->base + MSDC_INT);


