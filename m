Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A081AA8;
	Wed, 28 Jan 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616100; cv=none; b=ToSYwmMFzXP8b+qEXv0ZwcLZFO2c9frdJjIm6T7rE0tXM6H27o4FBXFOhqJQAi5B9DOZmt1bPt/9EO0Md4s95ve8vOf9NHmUYinzmyAqYGP02mSUaJ/CE5lG6rqmYAwYPAWT40c9ncKHDitaSlm3nrlLEMPUeU+OXy0FkOdiq54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616100; c=relaxed/simple;
	bh=LXFa4VoPxVHpekAajJHCjORDjPF9c8WQCjK/CELfaLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3p4IlNRLawmoah6628IpzGjOHZIAXrtoCffiOOG2kqsDi0vRxt6HHcbvPpEACbWdUMHKT9/oxfTWysQ5JNJcmo9cVuBSFG3RC6bBWbExPv9bNODeKGgwHA/OYkNXwR9lTYfOvtlVydEt8Q1a84j4yleDTDtn8wILxw50TIXPNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJhm7LNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJhm7LNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DFBC4CEF1;
	Wed, 28 Jan 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616100;
	bh=LXFa4VoPxVHpekAajJHCjORDjPF9c8WQCjK/CELfaLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJhm7LNZZ6bgaLEO3TbLy4Qqpu9YzhXwqmyRhoXIQReX233PV4C/8sjUG8Nyqa+VC
	 03XOwaUgUiS5mDIkN28PWGc6jsT5wL5NuwtTuquok6X6WH2XgjZQGhXx+Ks/8zxZ98
	 Vg/xF1Yi6gx+rVpuD576SodLyCPDiLnAIjBu/MMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 174/227] wifi: ath10k: fix dma_free_coherent() pointer
Date: Wed, 28 Jan 2026 16:23:39 +0100
Message-ID: <20260128145350.711621517@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1727,8 +1727,8 @@ static void _ath10k_ce_free_pipe(struct
 				  (ce_state->src_ring->nentries *
 				   sizeof(struct ce_desc) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->src_ring->base_addr_owner_space,
-				  ce_state->src_ring->base_addr_ce_space);
+				  ce_state->src_ring->base_addr_owner_space_unaligned,
+				  ce_state->src_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->src_ring);
 	}
 
@@ -1737,8 +1737,8 @@ static void _ath10k_ce_free_pipe(struct
 				  (ce_state->dest_ring->nentries *
 				   sizeof(struct ce_desc) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->dest_ring->base_addr_owner_space,
-				  ce_state->dest_ring->base_addr_ce_space);
+				  ce_state->dest_ring->base_addr_owner_space_unaligned,
+				  ce_state->dest_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->dest_ring);
 	}
 
@@ -1758,8 +1758,8 @@ static void _ath10k_ce_free_pipe_64(stru
 				  (ce_state->src_ring->nentries *
 				   sizeof(struct ce_desc_64) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->src_ring->base_addr_owner_space,
-				  ce_state->src_ring->base_addr_ce_space);
+				  ce_state->src_ring->base_addr_owner_space_unaligned,
+				  ce_state->src_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->src_ring);
 	}
 
@@ -1768,8 +1768,8 @@ static void _ath10k_ce_free_pipe_64(stru
 				  (ce_state->dest_ring->nentries *
 				   sizeof(struct ce_desc_64) +
 				   CE_DESC_RING_ALIGN),
-				  ce_state->dest_ring->base_addr_owner_space,
-				  ce_state->dest_ring->base_addr_ce_space);
+				  ce_state->dest_ring->base_addr_owner_space_unaligned,
+				  ce_state->dest_ring->base_addr_ce_space_unaligned);
 		kfree(ce_state->dest_ring);
 	}
 


