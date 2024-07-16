Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202A19DFB9;
	Tue, 16 Jul 2024 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145292; cv=none; b=hIL9U1xW3OUDdCLPlJGQrZjBZgLmp61TD7ksh1OL6LbJ5L6J+inzHNhk7jPCTxhxTUZ+CMH71S51r8hqEjW6jwm51uT1vTcX8jZqcP9jU8/nX46+96MTJH8dTLrzarbmwBKhYq8J7jaGb3gyENh3i3n+hm7N2mSRord904kCxXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145292; c=relaxed/simple;
	bh=zdOjB4/OJbI8jWoR4P1INqHRwvsDT35m5nmkAQqNCi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El5tfW8YufZhIm/tMRqrVDIONWAUHVfzKNK7S2tokuiTQ90yezegiUmsgkHNhMQL2ziF6gCAooZohJbvBtrLp0yuN6x8vp+uKFZLZ+afOD3Hou6YRelL2QWVcKaDcGJRQWAQKFHLndodIr8TX/dugyZo6v34vicz6Oy3flpI66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YCJJLuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YCJJLuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA48C116B1;
	Tue, 16 Jul 2024 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145292;
	bh=zdOjB4/OJbI8jWoR4P1INqHRwvsDT35m5nmkAQqNCi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YCJJLuhMROMJ7gPlv3CAYNonjxqQGvxktP50knRKVdqgfivuFqMpgBySDQjuEeeH
	 ey2mNBNTgAYOdQADOZj4BMDdR2jtO5btAwAejg6XPx/Y/K3ilmv06NDwsCuHRK1n+B
	 5woyu+1+lPbtwu9Tv6GlAPlqF+h+XpZua3zVpVUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/96] net: ethernet: lantiq_etop: fix double free in detach
Date: Tue, 16 Jul 2024 17:31:29 +0200
Message-ID: <20240716152747.218147643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



