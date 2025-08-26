Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E9434A333;
	Tue, 26 Aug 2025 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216434; cv=none; b=HzGnl5W73kRTtgXI7VoJOT2sg0+HamO9iqXl2DXg1nPHvH5NdBSg2K54ERIMv26+XZ4C9hZGO+fqDGwbZ5KqZAx+mGgJh6F4H4gqExlp17cBBO3S6DFn77XP+6bJ8L8NGiABzX2QWd0+ZPXP/A8azgsTQlpPneBhnxDQCFdenvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216434; c=relaxed/simple;
	bh=N8vLU7TZ1woUYh6TbHNYG/ZVhSezFwUNvaTMrz/R7fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iK6xjEqvLeWTUjl3ghmOP5w3XKouwe8vgahWU99Q7p27sDu7IZsZ2Yiff3SVPKtqFE9g56sOjY2pSah3eBzU+JQ+tvKwR0KVVxfXBQNZxaORWn/+7kb9XwWrleAHoMsw+AjFdH+LCs712UcLES2ezcwnGb0wHbYzy2Tke8DrnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyWWIPKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyWWIPKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2B5C4CEF1;
	Tue, 26 Aug 2025 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216434;
	bh=N8vLU7TZ1woUYh6TbHNYG/ZVhSezFwUNvaTMrz/R7fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyWWIPKmey7z8st5yux9IBCMa5ClUhxMZ27QVkqkr3dEModnfbiy7zVvpLweTTsmH
	 EM0elGtM4HcjgtILOugWH0RpGY3eg7wg1eLJ/4i9uUCV7yOHmmnZGEdmDqp3YPnP2g
	 fxYU2P8OqiIVD2gyNN1WLoMV9sevy9wHSKNTzpSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/644] crypto: octeontx2 - add timeout for load_fvc completion poll
Date: Tue, 26 Aug 2025 13:08:22 +0200
Message-ID: <20250826110956.640779618@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c1b92aaab39..6bee19394857 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1419,6 +1419,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1483,16 +1484,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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



