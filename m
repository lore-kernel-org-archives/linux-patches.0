Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724F71DDCE;
	Tue, 16 Jul 2024 16:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145702; cv=none; b=dal2wB8qESxICrnDFafrtVmUqwy8ZpSqVZOEAIi0xXQVGwIjdA5AqQ2cnhyZ6fZ2vXbcEDCiKSQgVF/JGZSYEnhFrtyF+GQynWoCW2GzbHrshLKHxUZNdeeDvcS6WH0Y6AHY31uREJ+A5bt1mX3/itaBmpijBi68LpczTEULLuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145702; c=relaxed/simple;
	bh=ZP1m4zw+XEm3kuHTQzxBkipjMvjIqu29+mDUegnL0Cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEMxK2Am1G4vLtygaN3fuBt3s87sXHuElhx+IG30E63NM+3Z/MTzoLAw+QNoGcTS6ydU+adNQJI1zs/dnHpC8PXgAvQVudicXnaOrvfL1q9T2SBkhXnPKdxbSJuCf7c0qm7CUWQgwItqoQZBQoZodWCTspSEVESUB7AFmM1kbxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXYF2Qo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXYF2Qo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71F8C116B1;
	Tue, 16 Jul 2024 16:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145702;
	bh=ZP1m4zw+XEm3kuHTQzxBkipjMvjIqu29+mDUegnL0Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXYF2Qo0tkdlu17mpxA9WjKmEaT31t2+Z5w+1ShtT9qiFAulFhYIif6+p8TFErQX/
	 mnMUG2WGFOZC8CiRe48i8qvVtxG7RK/HW0/jA/4ADGkjcEo8VwgwyCn4JFmWzqkZbu
	 9zxiXRBBW2YWdNqyw/qnDf+6cXqCIB9NnABRAwr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/121] net: ethernet: lantiq_etop: fix double free in detach
Date: Tue, 16 Jul 2024 17:31:27 +0200
Message-ID: <20240716152752.292522455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5961bdcc4809..61baf1da76eea 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -217,9 +217,9 @@ ltq_etop_free_channel(struct net_device *dev, struct ltq_etop_chan *ch)
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



