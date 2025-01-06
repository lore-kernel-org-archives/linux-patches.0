Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AF8282F5;
	Mon,  6 Jan 2025 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179151; cv=none; b=QsLV2tmluliEF8AUwh+AFeCCc1w/M5irriO1JGAeTu169bkIsydgPdzuSqj5aTDzCFELMY9FD4NPRb9aOQn0/iX0D9P3RPwwUeX0IFeEbvY7fpV/ErKxQrI3c8LefTij1SI1XWiiAiwfjZLmnDc4+DJCLq7BRuvBjJzuIM7kFfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179151; c=relaxed/simple;
	bh=n+k7v4ss1fOjdm8EVEcxPU61MEiW6Iy3mEi5HNrR+0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw6ADFvg68adriJ2NR/kaMdAEPqlsDyyCA7HebT+o2eP+Krar03SvJRHkPkVL0OJOeVpdhilIyvvL93Obp5toOEAhexmGSMgIrXVeIMNU0bQUBcyHTmChTdCYnRALkLMwe2j/+LZAm8BSsVmXxEtWhiVrSLE/uSmxmY4ObTO6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7ctVQPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7ctVQPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC15C4CED2;
	Mon,  6 Jan 2025 15:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179150;
	bh=n+k7v4ss1fOjdm8EVEcxPU61MEiW6Iy3mEi5HNrR+0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7ctVQPzanc3wabQoVnUdXWuw1aUjOHY6+TKjn3wYgO0Rcl1zUvCHD5+qlLnBIFkM
	 Yi6SDBAe5ItjIewudARHhPH3GQYIs4+bWuQWXuDmJR8UJFgX8OQcrsL9lMXAhnAU+9
	 H50lflOk4pJZTbDWzKoBsscHPbb/IG+6h5s9HWIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 42/93] dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset
Date: Mon,  6 Jan 2025 16:17:18 +0100
Message-ID: <20250106151130.289797671@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

commit c43ec96e8d34399bd9dab2f2dc316b904892133f upstream.

The at_xdmac_memset_create_desc may return NULL, which will lead to a
null pointer dereference. For example, the len input is error, or the
atchan->free_descs_list is empty and memory is exhausted. Therefore, add
check to avoid this.

Fixes: b206d9a23ac7 ("dmaengine: xdmac: Add memset support")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Link: https://lore.kernel.org/r/20241029082845.1185380-1-chenridong@huaweicloud.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_xdmac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1214,6 +1214,8 @@ at_xdmac_prep_dma_memset(struct dma_chan
 		return NULL;
 
 	desc = at_xdmac_memset_create_desc(chan, atchan, dest, len, value);
+	if (!desc)
+		return NULL;
 	list_add_tail(&desc->desc_node, &desc->descs_list);
 
 	desc->tx_dma_desc.cookie = -EBUSY;


