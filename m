Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DC101F2;
	Tue, 26 Aug 2025 13:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213272; cv=none; b=opXZdk7aOD5hJsWCgva8L8ahDTTYPzz6edFY0XGmMySIFaoT+18aMzdwklqx09CuaZ+dqbhKsQ61HywJW8E7SGM67RK7SlhMrIWhG4UHqAb33eZxxbzMF6ICW2MZkjW3Pc4MrXg5rxLbt2wKiOI7wGu1yWB8L8adDT/7lu+BUd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213272; c=relaxed/simple;
	bh=JSxMf92zV17Z/OZCsD1CXG4dYZLOtNpD3zhquWduUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfrAGHUM/18Z1R6ZeL53ILl3wLvK5tjfQ4T69C95jik4ZxlKXfZXnOyaeqa3sdhV8Rxvbv503NmjgyEBK8SBvZh935r2Oka/G7BZGj6HFMah/tqHFnH7oV0EgM6eTblMmbrGRBhFx1wVmvDZbDTlm6ePfhbp2m2zCt1vVUP6WNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtyelozI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtyelozI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0C7C4CEF1;
	Tue, 26 Aug 2025 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213272;
	bh=JSxMf92zV17Z/OZCsD1CXG4dYZLOtNpD3zhquWduUtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtyelozIKkJGEF720Hl/Mqh64aatcWWGc8xnQm9rZIUAapzDIjeRxeO2wZr9VSyHH
	 0pj8utQw/oL6jThKwyjFFLIz1J1y/WzVJ4+tpLkSvMlEPEb8F7k3uUT/3XLSTM19RB
	 tcaBrWEFcs5BgdPXAKO2Cbi1R9t+7bwVsYWFTXak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 258/587] crypto: octeontx2 - add timeout for load_fvc completion poll
Date: Tue, 26 Aug 2025 13:06:47 +0200
Message-ID: <20250826110959.494828815@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bharat Bhushan <bbhushan2@marvell.com>

[ Upstream commit 2157e50f65d2030f07ea27ef7ac4cfba772e98ac ]

Adds timeout to exit from possible infinite loop, which polls
on CPT instruction(load_fvc) completion.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c  | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 1958b797a421..682e7d80adb8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1485,6 +1485,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1547,16 +1548,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 							 etype);
 		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+		timeout = 10000;
 
 		while (lfs->ops->cpt_get_compcode(result) ==
-						OTX2_CPT_COMPLETION_CODE_INIT)
+						OTX2_CPT_COMPLETION_CODE_INIT) {
 			cpu_relax();
+			udelay(1);
+			timeout--;
+			if (!timeout) {
+				ret = -ENODEV;
+				cptpf->is_eng_caps_discovered = false;
+				dev_warn(&pdev->dev, "Timeout on CPT load_fvc completion poll\n");
+				goto error_no_response;
+			}
+		}
 
 		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
 	}
-	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 	cptpf->is_eng_caps_discovered = true;
 
+error_no_response:
+	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 free_result:
 	kfree(result);
 lf_cleanup:
-- 
2.39.5



