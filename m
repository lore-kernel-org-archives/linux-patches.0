Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF1C15B0E3;
	Mon, 29 Jan 2024 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548417; cv=none; b=eF7WUtJNgE9C3sAdSXMdMzvShJ02W3tHdmbjM4f9kWCh177H1nkENBMhmpCuauPQ22D9YQVGaqeVagY7S0BAe7SPpyb0/5lHQIQRQuTq6zF/iQxlubg5/U1Uu4FK8Z0MU6OPc4B1i6twEtkYO+T5ss+aVLwZyJsGwGv3y0zDwWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548417; c=relaxed/simple;
	bh=SWLEkjEcUFjDrGp59Nff1uyKMFsMrjDtYO/j/pck3OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G58x3OdASiqPTWYWtWfdrtYt9tYmbQGhgkswQO1Y4M6df0qKG6KnW2PIkzGrStGCxWu5yjcfQdA3RyT07VZr90XM2BqIBJ1CMWQAxA4RxWd4b3ikgv/3TATdS84LJbD9mUbNTBJMDs2QziLpRCiBUZ7hrVbungJdm3yvSQOITv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZG71Nl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZG71Nl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3838EC433C7;
	Mon, 29 Jan 2024 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548417;
	bh=SWLEkjEcUFjDrGp59Nff1uyKMFsMrjDtYO/j/pck3OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZG71Nl7P2Xz7P+OaOTPClcqThXLLB7jUXHdkyzsyBJVB5l8wWT8kVL2xKHVTtV6/
	 cdiAoKrSxKIcBfwdDKmp3qwR1jGDaWI2BN9L+c6rV9ehSBOdetsgN8Wb176ZB3TE5I
	 CG/VzvbFF0a74dl1J2WcWfTiVNp78CBa3t3rNqf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Zhang <rex.zhang@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/331] dmaengine: idxd: Move dma_free_coherent() out of spinlocked context
Date: Mon, 29 Jan 2024 09:01:19 -0800
Message-ID: <20240129170015.411134778@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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



