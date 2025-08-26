Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEB517332C;
	Tue, 26 Aug 2025 11:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208208; cv=none; b=Iu3YrRREjxaGepEGs7lnqxpxDPcdy1sVMsOsGcHQjSR61BuVA0aS54VFKqsleTWdI7mJJ8ZevDwbrONDsT6N6PhEABDCQoY8OrnTzzSzSeqOHqZ7s7yPY9x59LZ6foQBMtWlSVYi391sFT0k4DtVTa67fjA8gyHaFrGVCCAZYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208208; c=relaxed/simple;
	bh=F5ZHnhJupTimbTTnHgTKBdSMYfQNzE/MXdag3VgD7z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+IGEBKkIufrM//1WNPVRnLADLT1lzMt7TXGyExJHcbFDgszR71ePlfCBOFLnjFHjnDLIarkWDcfAw1PUzkbtJWORACA3JKV9LfO0OCNwqqJgh6H+0oCDJ5BpEo4KeTfNo4lkqk6FrcsLFTTPeV1APbaKuwrklrytAOgiCnPdks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZpMvzK8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZpMvzK8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF5FC4CEF1;
	Tue, 26 Aug 2025 11:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208208;
	bh=F5ZHnhJupTimbTTnHgTKBdSMYfQNzE/MXdag3VgD7z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZpMvzK83n2xH3+w2kjr/3xHdDokpRGQdE2bUaXV6h2MRPxAjczxxsTM/jDBZsHfB
	 8qXK+CPPy4n7s2KRpMh7n+Zm9MPg/M4fltTGWfwH2g3diPwAqje+2ZumWw7XwQ6r5z
	 i6GkPZo1lHX2+5XdAPAf8UsuCAV+7Kao/Q0Wa3K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 022/322] crypto: octeontx2 - Fix address alignment issue on ucode loading
Date: Tue, 26 Aug 2025 13:07:17 +0200
Message-ID: <20250826110915.826923273@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

commit b7b88b4939e71ef2aed8238976a2bbabcb63a790 upstream.

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()"

Completion address should be 32-Byte alignment when loading
microcode.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c |   35 ++++++++++++--------
 1 file changed, 21 insertions(+), 14 deletions(-)

--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1490,12 +1490,13 @@ int otx2_cpt_discover_eng_capabilities(s
 	union otx2_cpt_opcode opcode;
 	union otx2_cpt_res_s *result;
 	union otx2_cpt_inst_s inst;
+	dma_addr_t result_baddr;
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
-	u32 len, compl_rlen;
 	int timeout = 10000;
+	void *base, *rptr;
 	int ret, etype;
-	void *rptr;
+	u32 len;
 
 	/*
 	 * We don't get capabilities if it was already done
@@ -1520,22 +1521,28 @@ int otx2_cpt_discover_eng_capabilities(s
 	if (ret)
 		goto delete_grps;
 
-	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
-	len = compl_rlen + LOADFVC_RLEN;
+	/* Allocate extra memory for "rptr" and "result" pointer alignment */
+	len = LOADFVC_RLEN + ARCH_DMA_MINALIGN +
+	       sizeof(union otx2_cpt_res_s) + OTX2_CPT_RES_ADDR_ALIGN;
 
-	result = kzalloc(len, GFP_KERNEL);
-	if (!result) {
+	base = kzalloc(len, GFP_KERNEL);
+	if (!base) {
 		ret = -ENOMEM;
 		goto lf_cleanup;
 	}
-	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
-				    DMA_BIDIRECTIONAL);
+
+	rptr = PTR_ALIGN(base, ARCH_DMA_MINALIGN);
+	rptr_baddr = dma_map_single(&pdev->dev, rptr, len, DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
 		dev_err(&pdev->dev, "DMA mapping failed\n");
 		ret = -EFAULT;
-		goto free_result;
+		goto free_rptr;
 	}
-	rptr = (u8 *)result + compl_rlen;
+
+	result = (union otx2_cpt_res_s *)PTR_ALIGN(rptr + LOADFVC_RLEN,
+						   OTX2_CPT_RES_ADDR_ALIGN);
+	result_baddr = ALIGN(rptr_baddr + LOADFVC_RLEN,
+			     OTX2_CPT_RES_ADDR_ALIGN);
 
 	/* Fill in the command */
 	opcode.s.major = LOADFVC_MAJOR_OP;
@@ -1547,14 +1554,14 @@ int otx2_cpt_discover_eng_capabilities(s
 	/* 64-bit swap for microcode data reads, not needed for addresses */
 	cpu_to_be64s(&iq_cmd.cmd.u);
 	iq_cmd.dptr = 0;
-	iq_cmd.rptr = rptr_baddr + compl_rlen;
+	iq_cmd.rptr = rptr_baddr;
 	iq_cmd.cptr.u = 0;
 
 	for (etype = 1; etype < OTX2_CPT_MAX_ENG_TYPES; etype++) {
 		result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
 		iq_cmd.cptr.s.grp = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
 							 etype);
-		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
+		otx2_cpt_fill_inst(&inst, &iq_cmd, result_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
 		timeout = 10000;
 
@@ -1577,8 +1584,8 @@ int otx2_cpt_discover_eng_capabilities(s
 
 error_no_response:
 	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
-free_result:
-	kfree(result);
+free_rptr:
+	kfree(base);
 lf_cleanup:
 	otx2_cptlf_shutdown(lfs);
 delete_grps:


