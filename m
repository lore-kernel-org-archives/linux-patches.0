Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B3D30AAC5;
	Mon, 13 Oct 2025 15:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368667; cv=none; b=gASPkJuz5MWIitQR6Nr+QLeXzWCqpF5bt410qd30hIucihU9vdZ5dOmJO4u5jFk6pTsD2A7Ce0LIjvc/NHqXYcQKhoKuD33tBCSpuFXMCy9LGIkCgIJG7YPScmH4cOebRW4OMNShQyGjOWGBTUR+eUME9y4Zlhdj79NLGiH7Mw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368667; c=relaxed/simple;
	bh=ADvhm+VkO019plS7ru1m4pHLxOxECyX/NZld75surPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6T6KGDZsE+C4Vrevl8ooRW6YPDGVviF3oW2P1vQuO36ihSxpX9p1w8v+JkG9KwvVcBbhXUaD/WuDIuV7gx4gvy99WncDelf84hxLcTirSD1Yfd9kvH//6xkfIoSoFr6z7F7Zza/xG5ZldxZO0+poDxlUdW5U4eYPrVIVLNKdwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu38Ai9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu38Ai9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F71BC4CEE7;
	Mon, 13 Oct 2025 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368666;
	bh=ADvhm+VkO019plS7ru1m4pHLxOxECyX/NZld75surPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu38Ai9jDtt/KaOue5vw/RFFVCKzgm0xf/5IZI4XG3yd3CVxk0Oqhb7zc5kRuxyGT
	 nT2UPjl1WIFjeEkGq7AZI1f8ulQJJtvWJQeceCCgXffHje33z+hy7seUoW+Yc+v22l
	 vfTBq58DwQYdp7A/qYjokVkhQ6UK90usfkOFTVcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/262] idpf: fix mismatched free function for dma_alloc_coherent
Date: Mon, 13 Oct 2025 16:45:55 +0200
Message-ID: <20251013144333.916024732@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit b9bd25f47eb79c9eb275e3d9ac3983dc88577dd4 ]

The mailbox receive path allocates coherent DMA memory with
dma_alloc_coherent(), but frees it with dmam_free_coherent().
This is incorrect since dmam_free_coherent() is only valid for
buffers allocated with dmam_alloc_coherent().

Fix the mismatch by using dma_free_coherent() instead of
dmam_free_coherent

Fixes: e54232da1238 ("idpf: refactor idpf_recv_mb_msg")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Link: https://patch.msgid.link/20250925180212.415093-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index f27a8cf3816db..d1f374da00981 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -727,9 +727,9 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter)
 		/* If post failed clear the only buffer we supplied */
 		if (post_err) {
 			if (dma_mem)
-				dmam_free_coherent(&adapter->pdev->dev,
-						   dma_mem->size, dma_mem->va,
-						   dma_mem->pa);
+				dma_free_coherent(&adapter->pdev->dev,
+						  dma_mem->size, dma_mem->va,
+						  dma_mem->pa);
 			break;
 		}
 
-- 
2.51.0



