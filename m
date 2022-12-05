Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F87015C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD5EC433D6;
	Mon,  5 Dec 2022 19:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267930;
	bh=Lig3E6wMBEtV4OeE4yo+tqLPK2yCj11/52hSl1WASjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOlMFYdhK73L1X6CfHwLAJ2iuR7GT8mHmErKT/mAtHsewc9ivrXpOVJgudsAAb8e/
	 /cvCI1C+vZw4PZ3AdsSRQhTc7E2aCbUd8NJ4ZAPJchSeKVO9CUsL4UU/naPXO0ziGz
	 GmZPZ0O5Y0TLNLxFY0ghwZ0r36z6Xk5tQ7Iw6u8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/105] tipc: check skb_linearize() return value in tipc_disc_rcv()
Date: Mon,  5 Dec 2022 20:08:57 +0100
Message-Id: <20221205190803.994270275@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit cd0f6421162201e4b22ce757a1966729323185eb ]

If skb_linearize() fails in tipc_disc_rcv(), we need to free the skb instead of
handle it.

Fixes: 25b0b9c4e835 ("tipc: handle collisions of 32-bit node address hash values")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/20221119072832.7896-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/discover.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index 0006c9f87199..0436c8f2967d 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -208,7 +208,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
 	u32 self;
 	int err;
 
-	skb_linearize(skb);
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		return;
+	}
 	hdr = buf_msg(skb);
 
 	if (caps & TIPC_NODE_ID128)
-- 
2.35.1



