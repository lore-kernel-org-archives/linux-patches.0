Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EA131B102;
	Mon, 18 Aug 2025 13:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522458; cv=none; b=a0IUq/WDVKiwE31W1lcFL6AAH/XPhWebowE96CmreLX7gLOEvh5Ke9j53VCfS14zCFqY87O0bbKzVieT6zOQf6rCE/LKZswQntZpvkmXhYtIZR0WStfkVsnZJG6ggal7MTe1vIo5VBu11UoWtvMA+5z6ix6wB9vQvRaVUnN2COk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522458; c=relaxed/simple;
	bh=3mUlfk0cVRiCUK8MirVrgaoq07WCZRPJcKCp0Eto4HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKER5uWFc9CZ51Ts8GIm8r8UTB46P5lydifv4IngrdEuaZti9IAhchTZeHgAuN9Y1vbXbx8pxaMCqiYrVcppwvJz6vRDQ8DF0HqaJIujia1akxesc3oGx0dnb44m+1juei/YFvbX1ePnp80ehH7vp2TnLlCMkpGnPeYaH4hg5uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCQo/6Yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCQo/6Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ABFC4CEEB;
	Mon, 18 Aug 2025 13:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522458;
	bh=3mUlfk0cVRiCUK8MirVrgaoq07WCZRPJcKCp0Eto4HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCQo/6YqYg0JmY0mXU57jPbHeM1TNQttEo0ThHH3F+APzsgnJQZPho6gsHvDx/dWf
	 TiSAUImYJdvReNJ6XVT651wI2B66r6QAKO1wzjBR27+vkXeUrPjkHjFneMpDjxh2se
	 k8+EdhDe08SRvM73uS6gtsZX0mz/S6AUZqLFQb1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/444] crypto: octeontx2 - add timeout for load_fvc completion poll
Date: Mon, 18 Aug 2025 14:45:47 +0200
Message-ID: <20250818124500.980609129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c9484646172..357a7c6ac837 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1493,6 +1493,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1555,16 +1556,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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



