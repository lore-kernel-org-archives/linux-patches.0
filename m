Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE8208D0;
	Thu,  2 Jul 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010110; cv=none; b=QyerYVWU7zYrSiwfbK4v7/JJnWPqfLcYWrfbitXTYO3iIjS+P8j7vU9NLvXQ1giQL2qoocCUwy72GpHJvqcR4AFtSxwXTyjLpca6bXTkGIpUVSV/frGLKEXm9qKMAWwdMUShM3YKC0tOT1HtuV1BNWGBHXoxG8dgHoN6xYw3MKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010110; c=relaxed/simple;
	bh=KyMesS+zvVHn8Os56w6itG4DO2Uxg7C9lrKyRxyDLlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pIxSP4NrLDaopfU77FmK6qBf/ySgvAFX/dXyUA+6YN+THBzoQh/jnh/cjtCjg3Mtjz/CpyFIfZf7GGnpSbidgdbwuGjVsr6bpStDdJ9bwYRcgSgFlR48ruyjkR8qpCFlDuUZT9jcHn8oLkbLBVs01AVgNf0sLI2+0bN6TaeibMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo8oq9uW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo8oq9uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84B01F000E9;
	Thu,  2 Jul 2026 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010109;
	bh=qtGr0BXHqVaBZ2iPUq3ycdZvK7/fGp+cNRN/f90w3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bo8oq9uWjN7onYLU4WXcrzcnX0EnuqgDC7E3C7ejMVxI8dlGiAVEe4Xvu/JOxbkiT
	 dAkMxQJgk9L9vUCHffOpBvsZi1M7Ht57Eo9JW2sx+z78cBpYHJicR2VpXNfYs1WqVd
	 UEEfCATu7L+/J4odWpMp4zQuGQV+ioDSH1JzidqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/129] misc: fastrpc: Add dma_mask to fastrpc_channel_ctx
Date: Thu,  2 Jul 2026 18:20:34 +0200
Message-ID: <20260702155114.524870075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,6 +262,7 @@ struct fastrpc_channel_ctx {
 	struct fastrpc_device *fdevice;
 	bool secure;
 	bool unsigned_support;
+	u64 dma_mask;
 };
 
 struct fastrpc_device {
@@ -2175,6 +2176,7 @@ static int fastrpc_rpmsg_probe(struct rp
 	kref_init(&data->refcount);
 
 	dev_set_drvdata(&rpdev->dev, data);
+	rdev->dma_mask = &data->dma_mask;
 	dma_set_mask_and_coherent(rdev, DMA_BIT_MASK(32));
 	INIT_LIST_HEAD(&data->users);
 	spin_lock_init(&data->lock);


