Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB381728;
	Mon,  6 Jan 2025 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178824; cv=none; b=rhPtx0qrO1JaD14tivKnHWVyow502meSjdynBCDJvDAHKk7QRjoK+rYLsjyhCHt6M6F09r+nchI4D9ur09zpCXM8Qud3Z9dbYjuh60XGudwT//AUywnWX3hE6vCBBirmh0k3/qOf5rC2v4D320/Mh8ckRBdZ+eaurYxWWuZwy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178824; c=relaxed/simple;
	bh=LMEqeSQ2oINxim4yPTLM6KNmErOzAP+HM4Q4VpcFBbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNcJ/j2JqQCXftX9FXvUVQPV7sEZqWK+LEilalLdLt3TYrkIF3a4uxyGnS07yFLLMNxzWrBwiyne9CEhHfONS0GyNk3xbRJdYUmPYi6Prtzbni5/RtC1QazlXihrL+MqLiQq9X9pMNvvS4y2zVaxRsYSrCORESMWt3CxFrWfevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIt45HHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIt45HHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59337C4CED2;
	Mon,  6 Jan 2025 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178823;
	bh=LMEqeSQ2oINxim4yPTLM6KNmErOzAP+HM4Q4VpcFBbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIt45HHsiKVqdyLSqF6n6lrD0xL4DIExka8SPB4wP9j0Ruo+Kk34c5XKoXUh/P3GQ
	 2gZOABOU302BsiXUnyB0TLeKRAg+6VHPflUFeOGyRCOq0ZqTFcnqFMgCiPH3ixErWk
	 efXX4HqOYEQdqkM6eEiBczZ99e6EY+4INgd7m3Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 073/168] dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset
Date: Mon,  6 Jan 2025 16:16:21 +0100
Message-ID: <20250106151141.224320764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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
@@ -1280,6 +1280,8 @@ at_xdmac_prep_dma_memset(struct dma_chan
 		return NULL;
 
 	desc = at_xdmac_memset_create_desc(chan, atchan, dest, len, value);
+	if (!desc)
+		return NULL;
 	list_add_tail(&desc->desc_node, &desc->descs_list);
 
 	desc->tx_dma_desc.cookie = -EBUSY;


