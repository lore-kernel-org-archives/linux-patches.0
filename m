Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFFF2D9796;
	Wed, 28 Jan 2026 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614660; cv=none; b=YEUSfl9Lb1KCs53JDInZYo1MlBYiQ38s7smtxUAhh8DgISv027FtwFCd61fx2jCcY2U58AFslXBCkAvIZfT/a03s0HouPdcyzn4kDpSGnOqLboomgC/b5417PoYIR4fW71Gfw08sC0Aq3QKBv7pHgIkAPWtEmWu17Job4KE9su8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614660; c=relaxed/simple;
	bh=9fPWsnNu7DfoUJRUdbAPU/X25CKiigMRF/5XcZcrzBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzYIqxGhcNLxqn1j3P86BZKEvtWtzLXgQtlnIJVM0rNRmVQ4hxUyVe7Qki3OpGtsN2oxGU7n5yD/ZOSmVLQB7yECXg7Gczf5hhqh+aJ3U47lRpcszUBzIgmghwKA4DJFNOJCASRllpdGdDj32qIn2/xget933WM1DFfAw5pqMw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL2BJ135; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL2BJ135"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B73C4CEF1;
	Wed, 28 Jan 2026 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614659;
	bh=9fPWsnNu7DfoUJRUdbAPU/X25CKiigMRF/5XcZcrzBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL2BJ13537/toqDr+l4YXS2poksGWH0FX6oTLQ8M9R6DXeJNBlgum6EXxDDQnPzFx
	 vSObIKZmD3VgkSv3dBlip0rEAM63HwOgKXwXTf2sv+29dReOLib/tYs8VpS32L9nBE
	 Y46pYEywLDaiQ/8LQng6/ozwtNGl142OHm4FTXZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 202/254] octeontx2: Fix otx2_dma_map_page() error return code
Date: Wed, 28 Jan 2026 16:22:58 +0100
Message-ID: <20260128145352.063572276@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit d998b0e5afffa90d0f03770bad31083767079858 upstream.

0 is a valid DMA address [1] so using it as the error value can lead to
errors.  The error value of dma_map_XXX() functions is DMA_MAPPING_ERROR
which is ~0.  The callers of otx2_dma_map_page() use dma_mapping_error()
to test the return value of otx2_dma_map_page(). This means that they
would not detect an error in otx2_dma_map_page().

Make otx2_dma_map_page() return the raw value of dma_map_page_attrs().

[1] https://lore.kernel.org/all/f977f68b-cec5-4ab7-b4bd-2cf6aca46267@intel.com

Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20260114123107.42387-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -893,13 +893,8 @@ static inline dma_addr_t otx2_dma_map_pa
 					   size_t offset, size_t size,
 					   enum dma_data_direction dir)
 {
-	dma_addr_t iova;
-
-	iova = dma_map_page_attrs(pfvf->dev, page,
+	return dma_map_page_attrs(pfvf->dev, page,
 				  offset, size, dir, DMA_ATTR_SKIP_CPU_SYNC);
-	if (unlikely(dma_mapping_error(pfvf->dev, iova)))
-		return (dma_addr_t)NULL;
-	return iova;
 }
 
 static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,


