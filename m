Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047862;
	b=O1+BX14SBR/OFYuEZF5WnN4Sq3hczA1cCK+knoihbKW5t+EjHBaRlIBUKwjMfoL9gcc2
	 DXDLGGVtVeQsu30S7MNtRQzI7Mc7/TydETOW96H42wcx+Lne+dqcXRKHyUOYM/swJb7S2
	 J6tXFkD/ggm4s5Vx1aZWO9RVfahWSyVu0inqOuqt37jrpnch7ovPJn1EdocujhJzR4bhT
	 eKbsbsl8Q8KoF7yMp8PLyQfCUSPR7q2C3D+5uhuOtjCfgLytDuyN0EpjjZFjqGmG4sInZ
	 0FXjbK0zG66ulydYOtzDJXfkX4tODCNmU+QNcem5f3j0JNL5P+SKPtOytSiHZsHmaBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0xz5xUdA6su8MiJShqu0NJ+qpYwaMHhYep5CU5vQrjs=;
	b=vyyJgPJhmGYojQO/g8ops54I+NDvF7WZI5taRxCMrSVAsqUpHLl7dPyVOqwRVYqG74vA
	 5hgGdcpxbKDBZ2+gZUVAV4EMOcpjtodoCeIQO6q/7HU/C0I21/6wTV9OoMwucFBVJCshT
	 NFP+wslC59Qhn9v4lW6JV+f49S5IwKIyDvEpWF4KQDPDcf7ZyZY4rug31EZcaCtoHDXdF
	 q7QNTnZB4Bd1Ib0bAYQxKD8i8eZvEs9eDxouYl/7/tIPjk+TfocP+WEu8p4ieKJERFVp/
	 RUirleBHYht4jj10XKHtm+/Fn1IEbP7B/rGyY1VGaLbki5jlAbtRsY0kFuxsYKpyMwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbVQMAh3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974B60A2600;
	Thu, 19 Nov 2026 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fbVQMAh3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8732B1F000C9;
	Thu, 19 Nov 2026 00:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047862;
	bh=0xz5xUdA6su8MiJShqu0NJ+qpYwaMHhYep5CU5vQrjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbVQMAh3vNWpOVnN5oelYGmuV49Odikd4kgBlWYtJKOqQV4vV8jB1XRoxQSSsjJ0z
	 pS+dDEOJCgJiqdQfhujWma21UvcGVkjrOYVdCTraptuEyT/sQteg51Jcf1+9TR1WVX
	 8ArNDRkutVX/WG5+BB+r9r99fxQn0P1tyWOTbZ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1790/2857] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:47:04 +0100
Message-ID: <20261118150305.717599009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d805aa5b6088b193debabaa80cc0991bfa2bd057 ]

fsl_re_free_chan_resources() loops alloc_count times calling
list_first_entry() on free_q without checking whether the list still
has entries. If descriptors remain un-acked or pending in submit_q /
active_q / ack_q when the channel resources are freed, free_q becomes
smaller than alloc_count and list_first_entry() returns the list head,
causing list_del() to corrupt the list head and dereference a bogus
pointer.

Walk free_q with list_for_each_entry_safe() until it is empty,
decrementing alloc_count per freed descriptor, instead of relying on
the alloc_count count.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718235227.385108-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 562a3a3f75f16..facd8b0f48f47 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -612,18 +612,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 static void fsl_re_free_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_re_chan *re_chan;
-	struct fsl_re_desc *desc;
+	struct fsl_re_desc *desc, *_desc;
 
 	re_chan = container_of(chan, struct fsl_re_chan, chan);
-	while (re_chan->alloc_count--) {
-		desc = list_first_entry(&re_chan->free_q,
-					struct fsl_re_desc,
-					node);
-
+	list_for_each_entry_safe(desc, _desc, &re_chan->free_q, node) {
 		list_del(&desc->node);
 		dma_pool_free(re_chan->re_dev->cf_desc_pool, desc->cf_addr,
 			      desc->cf_paddr);
 		kfree(desc);
+		re_chan->alloc_count--;
 	}
 
 	if (!list_empty(&re_chan->free_q))
-- 
2.53.0



