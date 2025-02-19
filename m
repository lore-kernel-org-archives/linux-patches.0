Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEF51D54E9;
	Wed, 19 Feb 2025 09:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957316; cv=none; b=LNwDsXa8m/exB8XeMtLxKbQvFrspJhtnu3JqvwnHb2yQqiZKf2cJOqxExkD8L6DbQyeaAb2bR+QuMF02GL024Y8cQ7XjCRRi2glJGz2e0PgbBIfvzlZn4JN8iURD1nz/I1nwuXXs49ICxtiekVKvSarcDOk4dyoKRzYzcwvyq7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957316; c=relaxed/simple;
	bh=gW3tlZQwgo/SLmSCGUVtlIvrC6nTuDFQKJ84B7Xqwyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTNxSXA/ywOaMsK5HBmq/YhY2/AsJcfMUyDF5Cb1nce8LC9uAhhGBLLIYSMVH+YaBHZrzai856R03dEkITlubLCwdw4jKvZ/NTLucfN38k28Aj9+q9B80J1y/n8LSzKH13Eyw/fC31KyxkbFKd2s+q0MnMFjLiO51J58SrgogGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ne0Io4SK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ne0Io4SK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65461C4CED1;
	Wed, 19 Feb 2025 09:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957316;
	bh=gW3tlZQwgo/SLmSCGUVtlIvrC6nTuDFQKJ84B7Xqwyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ne0Io4SKw6sgYEScpjhkVwqTyuWeqNzgV51cn+1MxCGVrMDRmda2+8AHPMrFJNHNh
	 OXD2aHJ22Kc6Hk1pekHeO3+JVi/zwJHlwNidHki899NOxMAqttmx1NEygzQsGizXwb
	 mn7vztFM2GzswK6WV3ZTHEYQ6/TOvPGXdXRqQ4E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 482/578] fbdev: omap: use threaded IRQ for LCD DMA
Date: Wed, 19 Feb 2025 09:28:06 +0100
Message-ID: <20250219082711.963859345@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit e4b6b665df815b4841e71b72f06446884e8aad40 ]

When using touchscreen and framebuffer, Nokia 770 crashes easily with:

    BUG: scheduling while atomic: irq/144-ads7846/82/0x00010000
    Modules linked in: usb_f_ecm g_ether usb_f_rndis u_ether libcomposite configfs omap_udc ohci_omap ohci_hcd
    CPU: 0 UID: 0 PID: 82 Comm: irq/144-ads7846 Not tainted 6.12.7-770 #2
    Hardware name: Nokia 770
    Call trace:
     unwind_backtrace from show_stack+0x10/0x14
     show_stack from dump_stack_lvl+0x54/0x5c
     dump_stack_lvl from __schedule_bug+0x50/0x70
     __schedule_bug from __schedule+0x4d4/0x5bc
     __schedule from schedule+0x34/0xa0
     schedule from schedule_preempt_disabled+0xc/0x10
     schedule_preempt_disabled from __mutex_lock.constprop.0+0x218/0x3b4
     __mutex_lock.constprop.0 from clk_prepare_lock+0x38/0xe4
     clk_prepare_lock from clk_set_rate+0x18/0x154
     clk_set_rate from sossi_read_data+0x4c/0x168
     sossi_read_data from hwa742_read_reg+0x5c/0x8c
     hwa742_read_reg from send_frame_handler+0xfc/0x300
     send_frame_handler from process_pending_requests+0x74/0xd0
     process_pending_requests from lcd_dma_irq_handler+0x50/0x74
     lcd_dma_irq_handler from __handle_irq_event_percpu+0x44/0x130
     __handle_irq_event_percpu from handle_irq_event+0x28/0x68
     handle_irq_event from handle_level_irq+0x9c/0x170
     handle_level_irq from generic_handle_domain_irq+0x2c/0x3c
     generic_handle_domain_irq from omap1_handle_irq+0x40/0x8c
     omap1_handle_irq from generic_handle_arch_irq+0x28/0x3c
     generic_handle_arch_irq from call_with_stack+0x1c/0x24
     call_with_stack from __irq_svc+0x94/0xa8
    Exception stack(0xc5255da0 to 0xc5255de8)
    5da0: 00000001 c22fc620 00000000 00000000 c08384a8 c106fc00 00000000 c240c248
    5dc0: c113a600 c3f6ec30 00000001 00000000 c22fc620 c5255df0 c22fc620 c0279a94
    5de0: 60000013 ffffffff
     __irq_svc from clk_prepare_lock+0x4c/0xe4
     clk_prepare_lock from clk_get_rate+0x10/0x74
     clk_get_rate from uwire_setup_transfer+0x40/0x180
     uwire_setup_transfer from spi_bitbang_transfer_one+0x2c/0x9c
     spi_bitbang_transfer_one from spi_transfer_one_message+0x2d0/0x664
     spi_transfer_one_message from __spi_pump_transfer_message+0x29c/0x498
     __spi_pump_transfer_message from __spi_sync+0x1f8/0x2e8
     __spi_sync from spi_sync+0x24/0x40
     spi_sync from ads7846_halfd_read_state+0x5c/0x1c0
     ads7846_halfd_read_state from ads7846_irq+0x58/0x348
     ads7846_irq from irq_thread_fn+0x1c/0x78
     irq_thread_fn from irq_thread+0x120/0x228
     irq_thread from kthread+0xc8/0xe8
     kthread from ret_from_fork+0x14/0x28

As a quick fix, switch to a threaded IRQ which provides a stable system.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap/lcd_dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap/lcd_dma.c b/drivers/video/fbdev/omap/lcd_dma.c
index f85817635a8c2..0da23c57e4757 100644
--- a/drivers/video/fbdev/omap/lcd_dma.c
+++ b/drivers/video/fbdev/omap/lcd_dma.c
@@ -432,8 +432,8 @@ static int __init omap_init_lcd_dma(void)
 
 	spin_lock_init(&lcd_dma.lock);
 
-	r = request_irq(INT_DMA_LCD, lcd_dma_irq_handler, 0,
-			"LCD DMA", NULL);
+	r = request_threaded_irq(INT_DMA_LCD, NULL, lcd_dma_irq_handler,
+				 IRQF_ONESHOT, "LCD DMA", NULL);
 	if (r != 0)
 		pr_err("unable to request IRQ for LCD DMA (error %d)\n", r);
 
-- 
2.39.5



