Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07673D994;
	Wed,  4 Feb 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217954; cv=none; b=r3LrFuJQ8MMA/gkVgmJqVbEQAVmJ/QXoR6GiEdFcImPN3w/zXpAilTB2EXZY0Z03ZaLD4ce8KsZ+hcP0rjyEG/v9hQI8qwOCIjmFNB1urLwgZPWCrHW5FqZeEz4UCKv6Vmfqt/TjS1tenbSskgCPkrir22/3EUZ2EByhXj0jMBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217954; c=relaxed/simple;
	bh=v2PGRn2LaozXpu8/p9fQq1Ty3tjZIjT3VaukQj1ODZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxM2+Zgv0fMmHqAnen1hMdvvHrIlOMa1/InlkevgZh2eOfk9GVWGfOm9+ejx3bPBHAut+HDaorm7ReqgF3sUTjeeku50xXJlk8tL5NmkUVivOaPmK+0rWQBb/faQesTv/8LLhPmbmewgnepwK1TEdHElsoj6uwnCHCwB67YorXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCHav/eR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCHav/eR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAFAC116C6;
	Wed,  4 Feb 2026 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217953;
	bh=v2PGRn2LaozXpu8/p9fQq1Ty3tjZIjT3VaukQj1ODZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCHav/eRxqQX17EJ9OLuIahRYqNATxXm1gXNIB3ChY2v0PDAwvluKR7RdMFaPVe8+
	 HTmJZQJs8zWZsjl2clwqHa+UoCISmgagFxkVNSZs3z4PqaguBkWgP17MOfzWA2yHVz
	 XwXVWu0zWKnElCix99CYgPH9RWOSdzEAyaO6DrXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 169/280] octeontx2: Fix otx2_dma_map_page() error return code
Date: Wed,  4 Feb 2026 15:39:03 +0100
Message-ID: <20260204143915.702449741@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -864,13 +864,8 @@ static inline dma_addr_t otx2_dma_map_pa
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


