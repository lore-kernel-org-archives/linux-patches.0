Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D6A33B975;
	Thu,  2 Jul 2026 16:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009546; cv=none; b=MGpldhgvRbZCI1HLUePZqUrLqynX5S22O/Z3Ks6QUM0SP+A6P67dTyPeZW8jnuahZLbuOsnSArHetYiQwiuUmmkYKPyaH1aFyHcWGeQ7fRacalNyE4w69HVfKQ5x/piQ1i4MBCN0rpDFUxoXIn1JuJ9Fzju3zPDx2OGLoV5pYZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009546; c=relaxed/simple;
	bh=+u+1UHtoT0nFOQwegiI2Li7fYC6DjWmwAt6hN3mTdGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksWhM6oib2RN1r86A7ADphzGja333+zA3jEnKrwCZVYqL1L/CWyF5Wj2tryWkta3DcAnfY56s8XyKiQEKCpDWFpX4LArQwPDxlh6oP8vVU5DOxkahEL46wrn37nxnk8zehtQenn4N3UcokXKllXNyMbUmiAVFqVDrm1SZzYkzGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kB/Mr8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kB/Mr8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0DB1F000E9;
	Thu,  2 Jul 2026 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009539;
	bh=UahGHHJSmUitUPFqqVK/0vyZrNEvQNoeiiCLy/sC8ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kB/Mr8vNsCpgNri8jUDeuxmzfLQRqVi0IkcNsg6nPMxKczgHKPvv6FHWtQrqxAlr
	 6BPJGoYSNZv9MlgPpZAPoaIZcHM6bTqgGQkhJ7X80cPgMGb4ElrAhq5Dx9ompae33t
	 IUw/LvDAP/+HkslxUDO2oOdMcCWKE7Iy2FocI2xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 88/96] misc: fastrpc: Add dma_mask to fastrpc_channel_ctx
Date: Thu,  2 Jul 2026 18:20:20 +0200
Message-ID: <20260702155110.832341069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1689,6 +1690,7 @@ static int fastrpc_rpmsg_probe(struct rp
 	kref_init(&data->refcount);
 
 	dev_set_drvdata(&rpdev->dev, data);
+	rdev->dma_mask = &data->dma_mask;
 	dma_set_mask_and_coherent(rdev, DMA_BIT_MASK(32));
 	INIT_LIST_HEAD(&data->users);
 	spin_lock_init(&data->lock);


