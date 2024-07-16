Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D881919DF70;
	Tue, 16 Jul 2024 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144713; cv=none; b=BS2nFiRLRJwOR8xLSfpA3pinOEtrykWSkJNb8lrng3FiqUBLp3ff3LE5ZggQaMi+HRjD3EUSWfknzbERKfZtcOmeRtpo88CswXNqb64MzNQLBqMx2n8j00tL+LluS4fJwIEJWBG3TqlAQSUfnlG0v3UKww6PfWbhqZFlHKRxT3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144713; c=relaxed/simple;
	bh=IycMh13wCJna4TlYyJwbhQC5K99P1YDyf1rb3WGIfI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjoR27G908lyAiI9nElA02yMbHgsCOWg/d0MSR7SX6XiHTXCAV1l83uJcExLGSB6y/NtYVcNqEz+Ld+q+g4ltX8LhtGwClh6D49SZD8RSP2PDGwBsiFNrg+LoO+eckeJRcdoK8Y70L8xEVqabm6r8l7Ph1T7wVdhI53ns8Zvvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFjCn9LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFjCn9LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA60C116B1;
	Tue, 16 Jul 2024 15:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144713;
	bh=IycMh13wCJna4TlYyJwbhQC5K99P1YDyf1rb3WGIfI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFjCn9LLrUMcCTO9uwYbuGnU0lqZSV9FSMAygBacesKbRUowven47ekhW34B03f5M
	 CiDm8EuyrbGkVuqDgsjjXfupmOotkGOyQFrBOaAYWP6ErylW40ROsZ0rJQs7m+qGi1
	 //vbhm0KhesMbc2vkuldD1fA1BiEjOew1CPn7WhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/108] net: ethernet: lantiq_etop: fix double free in detach
Date: Tue, 16 Jul 2024 17:31:20 +0200
Message-ID: <20240716152748.478641354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62300d46d9186..1d7c0b872c594 100644
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



