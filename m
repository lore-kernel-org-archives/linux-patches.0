Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F21286A4;
	Wed,  4 Feb 2026 14:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216739; cv=none; b=Qt3N5zNkehBgMU8bQmXNl0CvBJeTtw438xRCuXN83tpzHg2rlY6ilv5iE6sH939c87BHTJr2hI78IIwD21nQg4Xq/ko2yuDitxW1kUS8y5EMshtbcIaeEr/HJHI2E5dVZA6k+5Mvakuji//lMmguqhCS5C7XvW7ROA4O0Gi3pVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216739; c=relaxed/simple;
	bh=uJ8XXqVrv4tA0TlChBzkgB29wf5HsKYMkm6MQTFHvqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1YgZHP2jUeKz0fyhkqBdxwtXwJQ90PBqv7vkJEKvcQTeWJKz4h54CsByKf7z3AqcdKKaxVJh0GgerxefHuKH9F9jnNEUZJN7eakaJ5XDMFYBqkQYDUGlyEoemAu6Zio3p/djKT6dbCNYmG03kKMmCJrOUMWhr0bzH7lWWt8zoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quxSMu9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quxSMu9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7341C4CEF7;
	Wed,  4 Feb 2026 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216739;
	bh=uJ8XXqVrv4tA0TlChBzkgB29wf5HsKYMkm6MQTFHvqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quxSMu9x3Eeq+qnvxrBFvowNMGbi4n+whyY8+Csx1HhjdKVwCTD68HDt16OGw47yQ
	 +AbqfcKD8cKzK4qoTDqT9RZJScf+pt9tHTzyWk1R7TrrVjo9SH6o+uEdMJrJ/Tkj6R
	 EKm63KwHYDtU+lCo/8BQ+sYiiIHEtwd1rfhn5UaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/206] dmaengine: tegra-adma: Fix use-after-free
Date: Wed,  4 Feb 2026 15:37:28 +0100
Message-ID: <20260204143858.823109454@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheetal <sheetal@nvidia.com>

[ Upstream commit 2efd07a7c36949e6fa36a69183df24d368bf9e96 ]

A use-after-free bug exists in the Tegra ADMA driver when audio streams
are terminated, particularly during XRUN conditions. The issue occurs
when the DMA buffer is freed by tegra_adma_terminate_all() before the
vchan completion tasklet finishes accessing it.

The race condition follows this sequence:

  1. DMA transfer completes, triggering an interrupt that schedules the
     completion tasklet (tasklet has not executed yet)
  2. Audio playback stops, calling tegra_adma_terminate_all() which
     frees the DMA buffer memory via kfree()
  3. The scheduled tasklet finally executes, calling vchan_complete()
     which attempts to access the already-freed memory

Since tasklets can execute at any time after being scheduled, there is
no guarantee that the buffer will remain valid when vchan_complete()
runs.

Fix this by properly synchronizing the virtual channel completion:
 - Calling vchan_terminate_vdesc() in tegra_adma_stop() to mark the
   descriptors as terminated instead of freeing the descriptor.
 - Add the callback tegra_adma_synchronize() that calls
   vchan_synchronize() which kills any pending tasklets and frees any
   terminated descriptors.

Crash logs:
[  337.427523] BUG: KASAN: use-after-free in vchan_complete+0x124/0x3b0
[  337.427544] Read of size 8 at addr ffff000132055428 by task swapper/0/0

[  337.427562] Call trace:
[  337.427564]  dump_backtrace+0x0/0x320
[  337.427571]  show_stack+0x20/0x30
[  337.427575]  dump_stack_lvl+0x68/0x84
[  337.427584]  print_address_description.constprop.0+0x74/0x2b8
[  337.427590]  kasan_report+0x1f4/0x210
[  337.427598]  __asan_load8+0xa0/0xd0
[  337.427603]  vchan_complete+0x124/0x3b0
[  337.427609]  tasklet_action_common.constprop.0+0x190/0x1d0
[  337.427617]  tasklet_action+0x30/0x40
[  337.427623]  __do_softirq+0x1a0/0x5c4
[  337.427628]  irq_exit+0x110/0x140
[  337.427633]  handle_domain_irq+0xa4/0xe0
[  337.427640]  gic_handle_irq+0x64/0x160
[  337.427644]  call_on_irq_stack+0x20/0x4c
[  337.427649]  do_interrupt_handler+0x7c/0x90
[  337.427654]  el1_interrupt+0x30/0x80
[  337.427659]  el1h_64_irq_handler+0x18/0x30
[  337.427663]  el1h_64_irq+0x7c/0x80
[  337.427667]  cpuidle_enter_state+0xe4/0x540
[  337.427674]  cpuidle_enter+0x54/0x80
[  337.427679]  do_idle+0x2e0/0x380
[  337.427685]  cpu_startup_entry+0x2c/0x70
[  337.427690]  rest_init+0x114/0x130
[  337.427695]  arch_call_rest_init+0x18/0x24
[  337.427702]  start_kernel+0x380/0x3b4
[  337.427706]  __primary_switched+0xc0/0xc8

Fixes: f46b195799b5 ("dmaengine: tegra-adma: Add support for Tegra210 ADMA")
Signed-off-by: Sheetal <sheetal@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20251110142445.3842036-1-sheetal@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra210-adma.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/tegra210-adma.c b/drivers/dma/tegra210-adma.c
index f4f722eacee2b..94ac5240ab200 100644
--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -344,10 +344,17 @@ static void tegra_adma_stop(struct tegra_adma_chan *tdc)
 		return;
 	}
 
-	kfree(tdc->desc);
+	vchan_terminate_vdesc(&tdc->desc->vd);
 	tdc->desc = NULL;
 }
 
+static void tegra_adma_synchronize(struct dma_chan *dc)
+{
+	struct tegra_adma_chan *tdc = to_tegra_adma_chan(dc);
+
+	vchan_synchronize(&tdc->vc);
+}
+
 static void tegra_adma_start(struct tegra_adma_chan *tdc)
 {
 	struct virt_dma_desc *vd = vchan_next_desc(&tdc->vc);
@@ -889,6 +896,7 @@ static int tegra_adma_probe(struct platform_device *pdev)
 	tdma->dma_dev.device_config = tegra_adma_slave_config;
 	tdma->dma_dev.device_tx_status = tegra_adma_tx_status;
 	tdma->dma_dev.device_terminate_all = tegra_adma_terminate_all;
+	tdma->dma_dev.device_synchronize = tegra_adma_synchronize;
 	tdma->dma_dev.src_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
 	tdma->dma_dev.dst_addr_widths = BIT(DMA_SLAVE_BUSWIDTH_4_BYTES);
 	tdma->dma_dev.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.51.0



