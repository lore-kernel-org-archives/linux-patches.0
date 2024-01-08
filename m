Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6657F6D6DC;
	Mon,  8 Jan 2024 15:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6y0w68H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D65C433CC;
	Mon,  8 Jan 2024 15:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726910;
	bh=bMnuKhriAJR9ZOnJ0z9KjgKyJzEb841PHXFiZ54e/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6y0w68HxiWJu2Ef2AXFgf9PLFnhSEX4whQjwBpZzafnyiZuLZS764JjmaxHerB8H
	 kghQuTGIN0N0Iml8qBN3F+j/XEWxTEOv3GBRuRwD9MkhxXtp64S0HwPcMfo0F5Kb3C
	 RL1bnQDZ/qnlFrIUq9coB4wtBAm2YbgPvhix1+y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/124] dmaengine: fsl-edma: Add judgment on enabling round robin arbitration
Date: Mon,  8 Jan 2024 16:08:34 +0100
Message-ID: <20240108150607.039091180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 3448397a47c08c291c3fccb7ac5f0f429fd547e0 ]

Add judgment on enabling round robin arbitration to avoid
exceptions if this function is not supported.

Call trace:
 fsl_edma_resume_early+0x1d4/0x208
 dpm_run_callback+0xd4/0x304
 device_resume_early+0xb0/0x208
 dpm_resume_early+0x224/0x528
 suspend_devices_and_enter+0x3e4/0xd00
 pm_suspend+0x3c4/0x910
 state_store+0x90/0x124
 kobj_attr_store+0x48/0x64
 sysfs_kf_write+0x84/0xb4
 kernfs_fop_write_iter+0x19c/0x264
 vfs_write+0x664/0x858
 ksys_write+0xc8/0x180
 __arm64_sys_write+0x44/0x58
 invoke_syscall+0x5c/0x178
 el0_svc_common.constprop.0+0x11c/0x14c
 do_el0_svc+0x30/0x40
 el0_svc+0x58/0xa8
 el0t_64_sync_handler+0xc0/0xc4
 el0t_64_sync+0x190/0x194

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231113225713.1892643-3-xiaolei.wang@windriver.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index 242a70cf85f4b..db6cd8431f30a 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -674,7 +674,8 @@ static int fsl_edma_resume_early(struct device *dev)
 			fsl_edma_chan_mux(fsl_chan, fsl_chan->slave_id, true);
 	}
 
-	edma_writel(fsl_edma, EDMA_CR_ERGA | EDMA_CR_ERCA, regs->cr);
+	if (!(fsl_edma->drvdata->flags & FSL_EDMA_DRV_SPLIT_REG))
+		edma_writel(fsl_edma, EDMA_CR_ERGA | EDMA_CR_ERCA, regs->cr);
 
 	return 0;
 }
-- 
2.43.0



