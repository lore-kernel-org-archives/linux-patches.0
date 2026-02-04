Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDA522E3F0;
	Wed,  4 Feb 2026 15:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218055; cv=none; b=WVvMsZ0Q2fA6KLkeqg2v1E8arAiAI61rzorK3pQ2QPLgbpJ0+NMSlyIgucMjBeqnnZzPnVF5lNeSX8ttBYQktQHCxJAiW0X+S1kWgeuFwI3qLKIZfwDRwaA4iaaaU/eA3U8+o7/fovCR9/58ZZ542kgOE5fD3kHzcaRTvEJcaRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218055; c=relaxed/simple;
	bh=cl+qr1USTCo4TzxGqp1QRmyR1LG4JXMK68Jk+SBCvcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2c/4dtPGsH3SCeJzsI+04evPR5lnHEaSBaOFdeqPAjRN955aGg/OHk5KV7AYO6cgEzry4DPtcoyrjEObdW8+IQH886E2GCwPBxWAYcx3knn5bJmKBiGQ+pwXT9aqU1VzIgMkRY3mPYwO/ku4LVMfzfFR0/Skt/mYzGoUNcOyU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sdk3PqXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sdk3PqXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E1C4CEF7;
	Wed,  4 Feb 2026 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218055;
	bh=cl+qr1USTCo4TzxGqp1QRmyR1LG4JXMK68Jk+SBCvcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sdk3PqXVTfeOQD4WvOQOTLwjdTuM6fDduEPYv4U+PHwgTeymwh914gXOrx1CNXu8W
	 YpokuZ5TSAsb1hPHrsNYedD8dutfVue1fz0hfm4M1EIk9mJH9mQHztlIJF3i9Z6YS9
	 93KohYYThrt31J08Zj8u1NR1cV7CXI4C4qEledbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 164/280] wifi: ath10k: fix dma_free_coherent() pointer
Date: Wed,  4 Feb 2026 15:38:58 +0100
Message-ID: <20260204143915.526146525@linuxfoundation.org>
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

commit 9282a1e171ad8d2205067e8ec3bbe4e3cef4f29f upstream.

dma_alloc_coherent() allocates a DMA mapped buffer and stores the
addresses in XXX_unaligned fields.  Those should be reused when freeing
the buffer rather than the aligned addresses.

Fixes: 2a1e1ad3fd37 ("ath10k: Add support for 64 bit ce descriptor")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260105210439.20131-2-fourier.thomas@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/ce.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1791,8 +1791,8 @@ static void _ath10k_ce_free_pipe(struct
 				  (ce_state->src_ring->nentries *
 				   sizeof(struct ce_desc) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->src_ring->base_addr_owner_space,
-				  ce_state->src_ring->base_addr_ce_space);
+				  ce_state->src_ring->base_addr_owner_space_unaligned,
+				  ce_state->src_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->src_ring);
 	}
 
@@ -1801,8 +1801,8 @@ static void _ath10k_ce_free_pipe(struct
 				  (ce_state->dest_ring->nentries *
 				   sizeof(struct ce_desc) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->dest_ring->base_addr_owner_space,
-				  ce_state->dest_ring->base_addr_ce_space);
+				  ce_state->dest_ring->base_addr_owner_space_unaligned,
+				  ce_state->dest_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->dest_ring);
 	}
 
@@ -1822,8 +1822,8 @@ static void _ath10k_ce_free_pipe_64(stru
 				  (ce_state->src_ring->nentries *
 				   sizeof(struct ce_desc_64) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->src_ring->base_addr_owner_space,
-				  ce_state->src_ring->base_addr_ce_space);
+				  ce_state->src_ring->base_addr_owner_space_unaligned,
+				  ce_state->src_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->src_ring);
 	}
 
@@ -1832,8 +1832,8 @@ static void _ath10k_ce_free_pipe_64(stru
 				  (ce_state->dest_ring->nentries *
 				   sizeof(struct ce_desc_64) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->dest_ring->base_addr_owner_space,
-				  ce_state->dest_ring->base_addr_ce_space);
+				  ce_state->dest_ring->base_addr_owner_space_unaligned,
+				  ce_state->dest_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->dest_ring);
 	}
 


