Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9ED1DDCE;
	Tue, 16 Jul 2024 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146206; cv=none; b=XRCEOfidOBqLTBDm8xClmjiun37GvHasnG4ZuCSlwUBCYgB3wyc0VFBYCgOmDYH2Ffb+AXmgOZ7ECgRDVnPwhAkCu8BGbtoCGzVtwBUXoG9xPdJH3fVp1Fs+aKKsh8RU4uyZ2BHeVFbsJaYPmQT/Lcko4VuuJ+yvP17r0I+UmH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146206; c=relaxed/simple;
	bh=7pZP5nVweRrZhD6PKX73ar33On7SheMNVs4tzNQCQ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2xYkmMGzN5CWoBDEnMvfFJ10cTj7YzE8CLGFwTu3fQzs/92yymUqPtGBa+IN2qbv0WjZdWHW3zqdQAHmV5MDswxQPCnbExL2GbQbhU0zhNw8kHt+krdjoOXXrrmn6+s5ru9BL3pCaLYCiqPqx0dsl3Hni1ZFKxTuTxYnhgdVi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1t7Wg1he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1t7Wg1he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D675C116B1;
	Tue, 16 Jul 2024 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146206;
	bh=7pZP5nVweRrZhD6PKX73ar33On7SheMNVs4tzNQCQ/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1t7Wg1heTWSegUlcbYzRmLs37ZgTPUqYHr/CNEiQuQpbo64xl/si7Ipth4ktiIiPx
	 SqhkgBkyNKoBLu0Wrhq0ieae13FxU+XP/yhno4BBUPlnG3PQ0zJSNRUl4/AlDLCFHe
	 AgdWLT4n/cj+OAXYqkt3dA/3JpRdheoaAnJ2wOnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/144] net: ethernet: lantiq_etop: fix double free in detach
Date: Tue, 16 Jul 2024 17:32:38 +0200
Message-ID: <20240716152755.963379160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit e1533b6319ab9c3a97dad314dd88b3783bc41b69 ]

The number of the currently released descriptor is never incremented
which results in the same skb being released multiple times.

Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
Reported-by: Joe Perches <joe@perches.com>
Closes: https://lore.kernel.org/all/fc1bf93d92bb5b2f99c6c62745507cc22f3a7b2d.camel@perches.com/
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240708205826.5176-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index d9911b3b9172d..c5faeda30c0b4 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -213,9 +213,9 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
 	if (ch->dma.irq)
 		free_irq(ch->dma.irq, priv);
 	if (IS_RX(ch->idx)) {
-		int desc;
+		struct ltq_dma_channel *dma = &ch->dma;
 
-		for (desc = 0; desc < LTQ_DESC_NUM; desc++)
+		for (dma->desc = 0; dma->desc < LTQ_DESC_NUM; dma->desc++)
 			dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 	}
 }
-- 
2.43.0



