Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A982DF138;
	Wed, 28 Jan 2026 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615342; cv=none; b=hZtIlYx0SX4SpcJdNwE3hyYMBaCOxzShk/8/750RBNd7o7EMq0NES5sOY6anq77NJjrMdspCHHf+JPMWkE/eM8wdy3Ppw0Q/sdYqU+tSKf7Z8Wtm1ezEvKdqmM0k/y0y/PWyNFzqo5gZH2LlZDX+epPig9Hctt/+7ZgXQcD00XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615342; c=relaxed/simple;
	bh=SSX6pP0bwPMS++pmG4Gz2yavVjC1XkaX3A5gxUpe28M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ot5fSAPFIONETC3fZA8zaBACFnah3xEu3vNUNOIiFK7PqHCBz5i3c5RFNUZaibsuPKUKI1p0FZ0zVcUaJDbfV4aD19iefCx4TYyOJzpU52cNlhnro4RwUV5wEo56M8IvlNPXh1NRzDN09kwOdML1n1VV/XyZxVAZE11KKFHdLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkqXEMIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkqXEMIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EFFC4CEF1;
	Wed, 28 Jan 2026 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615342;
	bh=SSX6pP0bwPMS++pmG4Gz2yavVjC1XkaX3A5gxUpe28M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkqXEMIxMMJIFm6/pr7jXtyECmZdDKj1818rwY05XKBO/sXhkTFfFFiA2dKx9t7/4
	 f6tc+mALU2NryulK5OioJgA3tMAUSaTvkjHRpqIqTyf0zyBH0fHoEZr53kRYzhijh6
	 W5p2kj+49utNN6FEGPiwI+YBBo/WVgNdTq0zAn2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 118/169] wifi: ath12k: fix dma_free_coherent() pointer
Date: Wed, 28 Jan 2026 16:23:21 +0100
Message-ID: <20260128145338.250585875@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit bb97131fbf9b708dd9616ac2bdc793ad102b5c48 upstream.

dma_alloc_coherent() allocates a DMA mapped buffer and stores the
addresses in XXX_unaligned fields.  Those should be reused when freeing
the buffer rather than the aligned addresses.

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260106084905.18622-2-fourier.thomas@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/ce.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/ce.c
+++ b/drivers/net/wireless/ath/ath12k/ce.c
@@ -893,8 +893,8 @@ void ath12k_ce_free_pipes(struct ath12k_
 			dma_free_coherent(ab->dev,
 					  pipe->src_ring->nentries * desc_sz +
 					  CE_DESC_RING_ALIGN,
-					  pipe->src_ring->base_addr_owner_space,
-					  pipe->src_ring->base_addr_ce_space);
+					  pipe->src_ring->base_addr_owner_space_unaligned,
+					  pipe->src_ring->base_addr_ce_space_unaligned);
 			kfree(pipe->src_ring);
 			pipe->src_ring = NULL;
 		}
@@ -904,8 +904,8 @@ void ath12k_ce_free_pipes(struct ath12k_
 			dma_free_coherent(ab->dev,
 					  pipe->dest_ring->nentries * desc_sz +
 					  CE_DESC_RING_ALIGN,
-					  pipe->dest_ring->base_addr_owner_space,
-					  pipe->dest_ring->base_addr_ce_space);
+					  pipe->dest_ring->base_addr_owner_space_unaligned,
+					  pipe->dest_ring->base_addr_ce_space_unaligned);
 			kfree(pipe->dest_ring);
 			pipe->dest_ring = NULL;
 		}
@@ -916,8 +916,8 @@ void ath12k_ce_free_pipes(struct ath12k_
 			dma_free_coherent(ab->dev,
 					  pipe->status_ring->nentries * desc_sz +
 					  CE_DESC_RING_ALIGN,
-					  pipe->status_ring->base_addr_owner_space,
-					  pipe->status_ring->base_addr_ce_space);
+					  pipe->status_ring->base_addr_owner_space_unaligned,
+					  pipe->status_ring->base_addr_ce_space_unaligned);
 			kfree(pipe->status_ring);
 			pipe->status_ring = NULL;
 		}


