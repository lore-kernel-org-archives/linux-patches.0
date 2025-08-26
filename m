Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD02FE58A;
	Tue, 26 Aug 2025 11:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207050; cv=none; b=YCcIBbf8sXvR869u9gaJovXPTDtAl84bWpIVNi2CtQqR6iM386wFZpH3pfA8lu0An8ua5Yw/Pt8C9R9CHrWeTuxES4wAm9caZ4g9o9yrUzGMYf2/GEpLtkBNJ3gCT2I0lgzSB/+xqJMU0Qb7/Xx+nApVqRI60v59/0QZme486zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207050; c=relaxed/simple;
	bh=MqaGYmalKEyDgh3pFSk5YWLms4D0r4ncd76zPw9+k6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDXhTHR03oQU02twF7L1ibB+auDfGU1cFR2xydYYImf5cXKi1swgLM8sbACuPEDMhQj3jsV3ZKhRqeWQMMWVbz1+3ZlJ3cUAfp0RHWSJuGHvs+3ydHwrKIuD6/mg0JSz3kbWkPsVmhHJd6qnS8OBjUnDTjH4oX6yuUbyDmfhbS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sPkH6Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sPkH6Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EDBC116B1;
	Tue, 26 Aug 2025 11:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207050;
	bh=MqaGYmalKEyDgh3pFSk5YWLms4D0r4ncd76zPw9+k6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sPkH6QsYzWUCsmpjFohpRf0JICM796V1QB6KwDPWMnp7iadF1ZbcE9a3ugx0crtt
	 /2RK/XyqXvC72aMneCnKgBUiXHqqYIU3o4j+ypRKdMZOZbM+ziivhqDDnuiVJvZr2W
	 YwqFoUZCDoQKE3SsB0Ukdt9bgzmaltkzI5rfRGPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.16 031/457] crypto: octeontx2 - Fix address alignment on CN10KB and CN10KA-B0
Date: Tue, 26 Aug 2025 13:05:15 +0200
Message-ID: <20250826110938.107238626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharat Bhushan <bbhushan2@marvell.com>

commit a091a58b8a1eba2f243b0c05bcc82bdc2a4a338d upstream.

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()

Memory allocated are used for following purpose:
 - Input data or scatter list address - 8-Byte alignment
 - Output data or gather list address - 8-Byte alignment
 - Completion address - 32-Byte alignment.

This patch ensures all addresses are aligned as mentioned above.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> # v6.8+
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h |   61 +++++++++++++++------
 1 file changed, 45 insertions(+), 16 deletions(-)

--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -350,22 +350,48 @@ static inline struct otx2_cpt_inst_info
 cn10k_sgv2_info_create(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
 		       gfp_t gfp)
 {
-	u32 dlen = 0, g_len, sg_len, info_len;
-	int align = OTX2_CPT_DMA_MINALIGN;
+	u32 dlen = 0, g_len, s_len, sg_len, info_len;
 	struct otx2_cpt_inst_info *info;
-	u16 g_sz_bytes, s_sz_bytes;
 	u32 total_mem_len;
 	int i;
 
-	g_sz_bytes = ((req->in_cnt + 2) / 3) *
-		      sizeof(struct cn10kb_cpt_sglist_component);
-	s_sz_bytes = ((req->out_cnt + 2) / 3) *
-		      sizeof(struct cn10kb_cpt_sglist_component);
-
-	g_len = ALIGN(g_sz_bytes, align);
-	sg_len = ALIGN(g_len + s_sz_bytes, align);
-	info_len = ALIGN(sizeof(*info), align);
-	total_mem_len = sg_len + info_len + sizeof(union otx2_cpt_res_s);
+	/* Allocate memory to meet below alignment requirement:
+	 *  ------------------------------------
+	 * |    struct otx2_cpt_inst_info       |
+	 * |    (No alignment required)         |
+	 * |    --------------------------------|
+	 * |   | padding for ARCH_DMA_MINALIGN  |
+	 * |   | alignment                      |
+	 * |------------------------------------|
+	 * |    SG List Gather/Input memory     |
+	 * |    Length = multiple of 32Bytes    |
+	 * |    Alignment = 8Byte               |
+	 * |----------------------------------  |
+	 * |    SG List Scatter/Output memory   |
+	 * |    Length = multiple of 32Bytes    |
+	 * |    Alignment = 8Byte               |
+	 * |     -------------------------------|
+	 * |    | padding for 32B alignment     |
+	 * |------------------------------------|
+	 * |    Result response memory          |
+	 * |    Alignment = 32Byte              |
+	 *  ------------------------------------
+	 */
+
+	info_len = sizeof(*info);
+
+	g_len = ((req->in_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	s_len = ((req->out_cnt + 2) / 3) *
+		 sizeof(struct cn10kb_cpt_sglist_component);
+	sg_len = g_len + s_len;
+
+	/* Allocate extra memory for SG and response address alignment */
+	total_mem_len = ALIGN(info_len, OTX2_CPT_DPTR_RPTR_ALIGN);
+	total_mem_len += (ARCH_DMA_MINALIGN - 1) &
+			  ~(OTX2_CPT_DPTR_RPTR_ALIGN - 1);
+	total_mem_len += ALIGN(sg_len, OTX2_CPT_RES_ADDR_ALIGN);
+	total_mem_len += sizeof(union otx2_cpt_res_s);
 
 	info = kzalloc(total_mem_len, gfp);
 	if (unlikely(!info))
@@ -375,7 +401,8 @@ cn10k_sgv2_info_create(struct pci_dev *p
 		dlen += req->in[i].size;
 
 	info->dlen = dlen;
-	info->in_buffer = (u8 *)info + info_len;
+	info->in_buffer = PTR_ALIGN((u8 *)info + info_len, ARCH_DMA_MINALIGN);
+	info->out_buffer = info->in_buffer + g_len;
 	info->gthr_sz = req->in_cnt;
 	info->sctr_sz = req->out_cnt;
 
@@ -387,7 +414,7 @@ cn10k_sgv2_info_create(struct pci_dev *p
 	}
 
 	if (sgv2io_components_setup(pdev, req->out, req->out_cnt,
-				    &info->in_buffer[g_len])) {
+				    info->out_buffer)) {
 		dev_err(&pdev->dev, "Failed to setup scatter list\n");
 		goto destroy_info;
 	}
@@ -404,8 +431,10 @@ cn10k_sgv2_info_create(struct pci_dev *p
 	 * Get buffer for union otx2_cpt_res_s response
 	 * structure and its physical address
 	 */
-	info->completion_addr = info->in_buffer + sg_len;
-	info->comp_baddr = info->dptr_baddr + sg_len;
+	info->completion_addr = PTR_ALIGN((info->in_buffer + sg_len),
+					  OTX2_CPT_RES_ADDR_ALIGN);
+	info->comp_baddr = ALIGN((info->dptr_baddr + sg_len),
+				 OTX2_CPT_RES_ADDR_ALIGN);
 
 	return info;
 


