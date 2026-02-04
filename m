Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B09221F17;
	Wed,  4 Feb 2026 14:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216467; cv=none; b=IMFIYeUAD9TXgieOpKfZlqC0tf5RuxNU3eiQx3LsEDlyyb1Tne9ByycPjbFMBjV/TUggsLoKajvu+K0A1O4xh11JY7AQGETfOWbTzK7vYo9XVtEiXPDDrC5LUjBpO9bbfrz8sqsSPuITrwaKuaeDdomW/dT0oy9v7Oi8o9ov1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216467; c=relaxed/simple;
	bh=T0oXPex2cVYUwT/7Dl8cjqeedn+noozU1Ms/zomlnFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jvob1vDX8IhhVAvNyc108OPlS+hOZH10xVnSOBhgmtH8DLAbCHqF5UuozKy4UCP9XpQs3F1JNqk68Q4LxV+L6tImsqeCjbRQJ2+IMVkMEn8FtxErUTcw2qGaT0Ps+qv+ziW6ylrz0SyUwWTJiKf6u/xiLUaQp6G5j6YBXjOuRhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSCNLBWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSCNLBWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5350C116C6;
	Wed,  4 Feb 2026 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216467;
	bh=T0oXPex2cVYUwT/7Dl8cjqeedn+noozU1Ms/zomlnFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSCNLBWNbODhfdT2brqf/3gGTUDN7XwNmQoOpK7VPVk81RUyC8vtA9isWkV+iBa43
	 PpJwHXHTG83VyLuCGChrcwWuUD2mnp7kGS1LwLs1aMg4DMa2sMTlVJjy5UbFd0evdM
	 2oKBZkpfY3HEsyzZzCxPk3QWTXTWYXZSVWI33qdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.10 095/161] wifi: ath10k: fix dma_free_coherent() pointer
Date: Wed,  4 Feb 2026 15:39:18 +0100
Message-ID: <20260204143855.161370450@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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
 


