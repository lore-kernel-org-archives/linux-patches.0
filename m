Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4369826E6F6;
	Mon, 13 Oct 2025 15:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370283; cv=none; b=Kh8ljbprJ4K1IffNUYBImb4JJlkvQwRwPMYgjQRRO9lt3zB6cGYAxEB7aXGFSjKvL5DxNqFAx28OiQ9WmRVaDbcQgcLZKhF+lUgwTLGEPIbRT4QrfGEvNbRp7nm42uxDIVSBMhDdJJ/eu6SU15Qvw8ayTzlARj6gAejvpeqY0qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370283; c=relaxed/simple;
	bh=cFXYt2lb3TiGPyLV9+2z5gutV/PW3HRV7CdIJdwp2t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6M1nJQV6kW7+a5NHZqIHVTgJkZNl4V4QwizUz/u8eEna3wkttjTClJhNh0ckuTikFMtXr5yTan4IRM9bvGiZdF5EUBF6vZSsHOJC9fC+YdsUQQgYvhroAwqRuFKNf/XlTJwxtt8LcV3m6cEakiCMJYXcvVf8UJymyJMk+pqqcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usxzMKEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usxzMKEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBBDC4CEE7;
	Mon, 13 Oct 2025 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370283;
	bh=cFXYt2lb3TiGPyLV9+2z5gutV/PW3HRV7CdIJdwp2t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usxzMKEwwy/i7kHMNow9Whfbm4vKpNgH+M8Dr2lLtpzn5Nmd0ehPYFt7MXW/x+KVG
	 PpvD2Y34I6XwyooDYnN4eSoKILnAaE9813ca1t2WqwQVRnFW88p8RiNBE1nyNsEak/
	 u4dD8hY9luysj6D1nBC3Ya2/DkFyeUlAdEu1J1c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.17 542/563] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()
Date: Mon, 13 Oct 2025 16:46:43 +0200
Message-ID: <20251013144430.943266414@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -850,11 +850,22 @@ static int ndtest_probe(struct platform_
 
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


