Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7015115FCFE;
	Mon, 27 May 2024 19:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837770; cv=none; b=dAZ2YqoS7ilVX7XeUBONbaLcoB1LjNjKOip3cr1/UJGcDD6l3izKds2L7wr9ziYnQtSjLewg3YBXpKLXRlnUbWHhlrCtEEGokjWUgQ8wPOwMDImQGmADQmx6Al1Z8sKOlBM+uEktFhjZjSZSqMlSxcrZHBC0j2E9x8+9/xxpC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837770; c=relaxed/simple;
	bh=3/AutRcbiJjRpCFf1XF+NOy1LFk7KV8Zx4Gwcrpeb7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeXrw/RykpY6y1AjwhrBnSFRfk7Rfn3/iXmkAPdcjjAbN09tez/sWILELxheiW5dwlPQ47wYp4wQnH/m+fPcZ8FABqHMszI+dYdp2Ya/DLNpZKRJ//0lwbAM3Nph34kNIcq7m6Z7pUrFNxtAurihTUo0fwOeaN9BItEvwSWuIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRYETYbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRYETYbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E29C2BBFC;
	Mon, 27 May 2024 19:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837770;
	bh=3/AutRcbiJjRpCFf1XF+NOy1LFk7KV8Zx4Gwcrpeb7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRYETYbSnOe0ye8SqtyZrJ2sb/LkS0ZZkN2+ApkAFjoNR2LX7INA50oFMUVFkjZGw
	 XMFFuJB7Xu6FWgROaD6ROFQl6QMPphNdcRLEtg8xMvducMkQhJsPox4xGhB+WsRD8t
	 YVfr7hm+TWa3TOCZaX/XAOAhdanQw3GsiwSWVW7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 139/493] crypto: octeontx2 - add missing check for dma_map_single
Date: Mon, 27 May 2024 20:52:21 +0200
Message-ID: <20240527185635.003884377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 6a6d6a3a328a59ed0d8ae2e65696ef38e49133a0 ]

Add check for dma_map_single() and return error if it fails in order
to avoid invalid dma address.

Fixes: e92971117c2c ("crypto: octeontx2 - add ctx_val workaround")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
index 79b4e74804f6d..6bfc59e677478 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -138,6 +138,10 @@ int cn10k_cpt_hw_ctx_init(struct pci_dev *pdev,
 		return -ENOMEM;
 	cptr_dma = dma_map_single(&pdev->dev, hctx, CN10K_CPT_HW_CTX_SIZE,
 				  DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&pdev->dev, cptr_dma)) {
+		kfree(hctx);
+		return -ENOMEM;
+	}
 
 	cn10k_cpt_hw_ctx_set(hctx, 1);
 	er_ctx->hw_ctx = hctx;
-- 
2.43.0



