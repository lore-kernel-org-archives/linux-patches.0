Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12474EA37A;
	Thu,  2 Jul 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009782; cv=none; b=j1xXp6m6RHVfgxW3L+VnOotbCIP/uS1UWOW1rQUrtKL3lF2lV7H14tDwPN+/18wLiQkMxI0AjJl4Re3Aqg8brNxikPP5eRSuX9ES1g/Abg/fjTWvsngp63hj7AHZLeDjLCRmg9IzXOZehsgGfWcgKLzmtVLTuJrSnVhRJ0iPBRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009782; c=relaxed/simple;
	bh=dtFOCCMPnGpF6ZVPTWqzNdnQQFX+BKw040LHplbnEbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+/QkCvnnwQ9HQ/Q0UdlaxuOIvT7t82Ec2SrsjnhIUOknIfLQLr2+LGtwhyo5YVAaMUhy0B+nECHDa114NvtAXbYofS281C/4Iwvls2D1PwCQeIe/UXRSSLzac483U8sCJyLucPc8ceXkZhMW/ABtRVGtdncra4R673I90xZ1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtuiq5Zw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtuiq5Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774C1F00A3A;
	Thu,  2 Jul 2026 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009780;
	bh=YgqKAdiIKLMGZq7y3gfOrj7Ar+dHtc7E9yE9TrzHhkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtuiq5ZwR9GOiHBRqH0IrZLVXmlWX+XeB6pCDB5afkNYZ8onF+/GrMEjAYm996fgj
	 glla9ae3H/zIDBa9TWe02/aZt8Pi2MblxVBU1b+/OKS6swbCR2oskDHMtD/GwZxQhj
	 H1i8aMDYT4J8g1oS03fgT4siQD0hTHepm9Hod+K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 83/95] misc: fastrpc: Add dma_mask to fastrpc_channel_ctx
Date: Thu,  2 Jul 2026 18:20:26 +0200
Message-ID: <20260702155110.953651351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 9bde43a0e2f469961e18d0a3496a9a74379c22bf ]

dma_set_mask_and_coherent only updates the mask to which the device
dma_mask pointer points to. Add a dma_mask to the channel ctx and set
the device dma_mask to point to that, otherwise the dma_set_mask will
return an error and the dma_set_coherent_mask will be skipped too.

Co-developed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221125071405.148786-11-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5401fb4fe10f ("misc: fastrpc: Fix NULL pointer dereference in rpmsg callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -214,6 +214,7 @@ struct fastrpc_channel_ctx {
 	struct list_head users;
 	struct miscdevice miscdev;
 	struct kref refcount;
+	u64 dma_mask;
 };
 
 struct fastrpc_user {
@@ -1691,6 +1692,7 @@ static int fastrpc_rpmsg_probe(struct rp
 	kref_init(&data->refcount);
 
 	dev_set_drvdata(&rpdev->dev, data);
+	rdev->dma_mask = &data->dma_mask;
 	dma_set_mask_and_coherent(rdev, DMA_BIT_MASK(32));
 	INIT_LIST_HEAD(&data->users);
 	spin_lock_init(&data->lock);


