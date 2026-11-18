Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055105;
	b=cm8FeZoqGTmzLkE7K9/8oEb9gvnRNyTXr8ePQkz7czFlYbADrkPTxT5e4vlXWrldsbgN
	 Mmcxpva0E57r5MpnK/IZyYSYTnR25xA6tRl3dsWFgH6N10Rh6UZM4rDAkhHNHqE+z4MKY
	 TN5kaUykFC665utLDeDLZuG8L7R26rZnDn5sp3dImhGyPM4RAS920cw0zmRFahAZwqR13
	 zqkMl7kNd7YZMQMK3KoZ+RzOPlYb3qHPU/sLcb8qC/anEp7GuGwPZXWChw43pM8SxnZrr
	 87l2WMOCVPpLljNLdNmF6idQZjzQsKD/Fm9yO2GI1epOhlth6clvDWUODPPrsbzoFRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JUC2AZf5W5Tb2C68KvxaoQCUsG2JS0XRMoJtqxQI4Y=;
	b=oYGmIDgXEJMjNT2fiMaCHHTIf/7666IbfaV0fMyJZKewW5d420xudaKmKeMvvoPdLXuc
	 lSho/o+yt2ts6TipsL1E3GhBw4nrekGyuyf6wEh+NEXnfpPpVYrmVQ1cusJlFOHqZan/H
	 QVjeHRtLiDLSYiRTu/jUsg/BIknJ8IdIwr5/9jTpUxCIQMNM42OuMN0DeUCT6uB8f5ta3
	 DvlRAR0HJcEo0JttEFx2nQXUEQtfeQUK7Szi+3RfcKS7UI8BX4HQDe6mNL/mpjPsJTXK5
	 bwxt88CstrQ2vrsN0/e51mTv79kVWQ+yYVURoNMMtjMWhrgMMrrkCEYoBEOli2gd8hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtgrMLA9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47F4606A31C;
	Thu, 19 Nov 2026 02:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtgrMLA9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410221F000C4;
	Thu, 19 Nov 2026 02:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055104;
	bh=4JUC2AZf5W5Tb2C68KvxaoQCUsG2JS0XRMoJtqxQI4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtgrMLA9iLpRChMkaQYA8jieafKxt/7z9z4nzIEma6vsovdj2I4zoxHZcz2PPrVqh
	 oP7D7kmEsNbph+mCzz//8Wlp6ODGRVjMM5hhs0Eml6+qDxMxtAY8kYw/3//4UIFG75
	 h2HONCg2tbqCP6C3yH99BpvkCpB2abF4BsDlqpyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1461/2214] dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access
Date: Wed, 18 Nov 2026 15:52:17 +0100
Message-ID: <20261118150109.508696544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit e6b49f8016ee8b642e8e495d1704342ee0b35d72 ]

axi_chan_list_dump_lli() uses the channel-wide descs_allocated count to
walk the hw_desc[] array of a single transaction. If multiple
transactions have allocated LLIs, the channel count can exceed the
transaction-local nr_hw_descs and make the DMA error path read past the
end of hw_desc[].

Use the descriptor-local nr_hw_descs count when dumping LLIs.

Fixes: ef6fb2d6f1ab ("dmaengine: dw-axi-dmac: simplify descriptor management")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-2-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 32faa698eab88..afae2f218bed1 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1001,10 +1001,7 @@ static void axi_chan_dump_lli(struct axi_dma_chan *chan,
 static void axi_chan_list_dump_lli(struct axi_dma_chan *chan,
 				   struct axi_dma_desc *desc_head)
 {
-	int count = atomic_read(&chan->descs_allocated);
-	int i;
-
-	for (i = 0; i < count; i++)
+	for (unsigned int i = 0; i < desc_head->nr_hw_descs; i++)
 		axi_chan_dump_lli(chan, &desc_head->hw_desc[i]);
 }
 
-- 
2.53.0



