Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A447515E8B;
	Mon, 30 Dec 2024 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574089; cv=none; b=MTfdpjOcBgf21+70vSWAkKKCe+S9OUxH4JM83p6kRU+U3qhGdA/llZtl6ZsmrEGHdWZBYb51O0gBsMdmBvkDVMTPrg5fjSB0WlP6vbd8AlSyfR/YwVvMrKRKmG7A1Zc28y3FnAS6RUjhtF3OTDAHvy4NvfW3zBzZGhiQkR+XAbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574089; c=relaxed/simple;
	bh=6txZf4zqa8+TdVoXsFUMHaqk/gWUFT/jGTUj1395m5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGPIOqw58VITggbangyEMd7IQ8jkfztbe4cBTMz5WXrpISxxl9yjZmxg1AUn//G6kpgFRtxUxP0Q+z/696jBNytdverbN0lAY08dmPAPM69zJ8kh3aJ8dVuzYY2g2MC0x/Bxi7VE5Lkas0hysBx18+6DxmC9KfCe3vF2DjldmcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t34CbgIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t34CbgIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC56C4CED0;
	Mon, 30 Dec 2024 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574089;
	bh=6txZf4zqa8+TdVoXsFUMHaqk/gWUFT/jGTUj1395m5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t34CbgIvQTzU9mPkmtbHGCt15cG44rxG5+Db7yCG1+k8Icfzyfs9tvJbfnyLXBKgM
	 MtQVbnGLHm91Hnqf+eHSPtP7s+Ab9WQQQ59TJCb/NJy6MYqL/m27150IAfBBsQMB7S
	 t/n5RMW/eYO39VutSzqPO9w/NtA31uxQWLHHQH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 034/114] dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset
Date: Mon, 30 Dec 2024 16:42:31 +0100
Message-ID: <20241230154219.376242688@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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
@@ -1363,6 +1363,8 @@ at_xdmac_prep_dma_memset(struct dma_chan
 		return NULL;
 
 	desc = at_xdmac_memset_create_desc(chan, atchan, dest, len, value);
+	if (!desc)
+		return NULL;
 	list_add_tail(&desc->desc_node, &desc->descs_list);
 
 	desc->tx_dma_desc.cookie = -EBUSY;


