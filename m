Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663181586D6;
	Mon, 29 Jan 2024 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548052; cv=none; b=nVC2TnjyfeDwakz1H+puAqludr49B5QPi113dPRgCzRfybEFqOBA/lrdbOpF3Henkp2sT/GMWCdKyM4OPWd5opT/xwzFhKtb2AThrNc5qq1qdtRn6N95druAifbiEBZNO8P+juMOWg7XcuxzrdabSf+TAS226UPImgHfjHSdvZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548052; c=relaxed/simple;
	bh=t0kzZ04TPBMKbJkS6WuDKcFXEbhmg12taJ21Z+PnKhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp6OnBf+oBAdRLobda1MjhNW7Y7piZMBH/RwwhWiVGCoYkLqFZbSNAgLC+UY2mEGj34cQCUXCWtqW5UP/HWhdXLic9hkzaUwYGU484caec4MMUuP18GUvNXlTSQRVQ8nGuXVh42BR6/CJ1/sGx1kAO8uHIye8Vi3Ei2yIx/cHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOjgscdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOjgscdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59351C433C7;
	Mon, 29 Jan 2024 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548051;
	bh=t0kzZ04TPBMKbJkS6WuDKcFXEbhmg12taJ21Z+PnKhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOjgscdAWZ6Fy91U0XU7NAhG+72JeHpSYWzx2D49cwNcDsmgiU7etkEYr8e6mS5Mp
	 OP5qE7j6u11WB5oh8dHIYIj8N9A9sXWlDN3hJlE795jQs9tIjCfil8opc8582psqiV
	 Xkyki7YE7AuVZELVpoq7ibBTNKrgjv3sXUBNiDf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Zhang <rex.zhang@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 053/346] dmaengine: idxd: Move dma_free_coherent() out of spinlocked context
Date: Mon, 29 Jan 2024 09:01:24 -0800
Message-ID: <20240129170017.951638141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Zhang <rex.zhang@intel.com>

[ Upstream commit e271c0ba3f919c48e90c64b703538fbb7865cb63 ]

Task may be rescheduled within dma_free_coherent(). So dma_free_coherent()
can't be called between spin_lock() and spin_unlock() to avoid Call Trace:
    Call Trace:
    <TASK>
    dump_stack_lvl+0x37/0x50
    __might_resched+0x16a/0x1c0
    vunmap+0x2c/0x70
    __iommu_dma_free+0x96/0x100
    idxd_device_evl_free+0xd5/0x100 [idxd]
    device_release_driver_internal+0x197/0x200
    unbind_store+0xa1/0xb0
    kernfs_fop_write_iter+0x120/0x1c0
    vfs_write+0x2d3/0x400
    ksys_write+0x63/0xe0
    do_syscall_64+0x44/0xa0
    entry_SYSCALL_64_after_hwframe+0x6e/0xd8
Move it out of the context.

Fixes: 244da66cda35 ("dmaengine: idxd: setup event log configuration")
Signed-off-by: Rex Zhang <rex.zhang@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20231212022158.358619-2-rex.zhang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 8f754f922217..fa0f880beae6 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -802,6 +802,9 @@ static int idxd_device_evl_setup(struct idxd_device *idxd)
 
 static void idxd_device_evl_free(struct idxd_device *idxd)
 {
+	void *evl_log;
+	unsigned int evl_log_size;
+	dma_addr_t evl_dma;
 	union gencfg_reg gencfg;
 	union genctrl_reg genctrl;
 	struct device *dev = &idxd->pdev->dev;
@@ -822,11 +825,15 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	iowrite64(0, idxd->reg_base + IDXD_EVLCFG_OFFSET);
 	iowrite64(0, idxd->reg_base + IDXD_EVLCFG_OFFSET + 8);
 
-	dma_free_coherent(dev, evl->log_size, evl->log, evl->dma);
 	bitmap_free(evl->bmap);
+	evl_log = evl->log;
+	evl_log_size = evl->log_size;
+	evl_dma = evl->dma;
 	evl->log = NULL;
 	evl->size = IDXD_EVL_SIZE_MIN;
 	spin_unlock(&evl->lock);
+
+	dma_free_coherent(dev, evl_log_size, evl_log, evl_dma);
 }
 
 static void idxd_group_config_write(struct idxd_group *group)
-- 
2.43.0



