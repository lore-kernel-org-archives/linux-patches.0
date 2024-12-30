Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45B62594B6;
	Mon, 30 Dec 2024 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573641; cv=none; b=HjGdaR/DzwAf01SxYPCvksO3McIOvmhoQIoNBjbLKeEqTQqdsjY6qVf9+KIgCyedIEcvQHLavF8pFr6LmvXOsSfV9+xFQGJZlZGKJy6//1bkeeDIO92gtFgCb/pMLvZdZ3Kq4iF0qQdQYeXkN7sYytZ1J48n3JgwGmi0N/EyJko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573641; c=relaxed/simple;
	bh=8ognPNBH4MztWPtXklsFEuev/HFLMN7AFkZNPtUEZbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFyaqy7QABuLo5vwaISHKm/7uC8ET5rbKAmtFbai/8ZGZiYsghEKsfZV4wMu4dGuI46Tr0dREuvJLjdciR0JKKfqxeLWxsimsozs6Bw9vUHChvyTbYVABrBFOJhdvofoU9srkA2mzvDo8ifNS0SPns+kckMnyPST0mBiX/Z0qtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvuzcUXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvuzcUXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDFC4CED0;
	Mon, 30 Dec 2024 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573641;
	bh=8ognPNBH4MztWPtXklsFEuev/HFLMN7AFkZNPtUEZbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yvuzcUXMGlICvODfuibvtksWvavS1yGfPDrREY6JNVj2DZxQjfQygG9wPxbnc2cYU
	 yOajQbZKJeUi4zMhV6HYeawzqqAbkVo8eG7oO/YpvevuS+2L0QbWYxbTz4fpjtsqLn
	 Od52BW1OMGkGDdkUnSiGjNkzU1DCL/gtHaBNV8Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 22/60] dmaengine: at_xdmac: avoid null_prt_deref in at_xdmac_prep_dma_memset
Date: Mon, 30 Dec 2024 16:42:32 +0100
Message-ID: <20241230154208.128282504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1287,6 +1287,8 @@ at_xdmac_prep_dma_memset(struct dma_chan
 		return NULL;
 
 	desc = at_xdmac_memset_create_desc(chan, atchan, dest, len, value);
+	if (!desc)
+		return NULL;
 	list_add_tail(&desc->desc_node, &desc->descs_list);
 
 	desc->tx_dma_desc.cookie = -EBUSY;


