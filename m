Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6967330B04;
	Fri, 17 Oct 2025 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716310; cv=none; b=L4jGRgDD+oxYL6NlV4Oi1o/MwcirR+NmGIOCCUgRFt4Z9K+w7oU6pOE4tvl4zMfU5R/N+6o7PbOo9Iv3XRQTT2U97ZKqGx2VByMqOEwiWL1To4Nrbzmwp8tGmO9aOLGhsHYd1UCexoD+MCQ0cFjxEE/4jDzyUIe12zQ6+WdFkT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716310; c=relaxed/simple;
	bh=k5XU4aJ+rqo1MYTIzFxVyKGD7IR9IKC8ZeDy0NLYsw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHoeNGXFKKYmh0uIf2I5cYCF63rLSBOunHawUZnYYphHAILXnIWFyt59UPkHcToKoIGE+nQ0lGP0f+2bMX2gkBzDyrouAZKtZCT+kzJ5CXFgpY+K4HjiyBMxVnsJOBA1n5hcjfvT69qbGSTBI31x5Akwj2VrE3U+4FjZoDEQ/SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAc+hEPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAc+hEPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45849C4CEE7;
	Fri, 17 Oct 2025 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716310;
	bh=k5XU4aJ+rqo1MYTIzFxVyKGD7IR9IKC8ZeDy0NLYsw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAc+hEPEdesZvIXV2slRa8cyxmJxUOOpQcjXVkso+jFifcpyZrVWBfBY5+518H3E9
	 ZVahF+Xwy7Vstg2krwPbgaifFBpkEPQKHVgTMufIC+NMrifUPLfmfaac8Vq90B6oiU
	 3mP72DYGTJ+t1pP2pxvTODVKiZ6p3b+THuc9X7EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 5.15 114/276] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()
Date: Fri, 17 Oct 2025 16:53:27 +0200
Message-ID: <20251017145146.640018184@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit a9e6aa994917ee602798bbb03180a194b37865bb upstream.

devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
them in ndtest_nvdimm_init(), which can lead to a NULL pointer
dereference under low-memory conditions.

Check all three allocations and return -ENOMEM if any allocation fails,
jumping to the common error path. Do not emit an extra error message
since the allocator already warns on allocation failure.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/nvdimm/test/ndtest.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -981,11 +981,22 @@ static int ndtest_probe(struct platform_
 
 	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				 sizeof(dma_addr_t), GFP_KERNEL);
+	if (!p->dcr_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	p->label_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				   sizeof(dma_addr_t), GFP_KERNEL);
+	if (!p->label_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				  sizeof(dma_addr_t), GFP_KERNEL);
-
+	if (!p->dimm_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	rc = ndtest_nvdimm_init(p);
 	if (rc)
 		goto err;


