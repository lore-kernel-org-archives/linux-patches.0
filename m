Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553466FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:28:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C839BC433D6;
	Wed, 30 Nov 2022 18:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832924;
	bh=g53hb0b6F5F6lbypay0JNJNo0d4BghcPRYihPdWj9Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk2YaAyVglzB8/hC+SRfy4VCGn2y0iBXQKkUbOBTflqKTa9wkKwxQjUrnHhr6AzTZ
	 QiJVUIH97DdGDk/uIRSumadRnSe3gPSvCCPMl/WZR1K0XVN6IuTT+kRYsZlRomXeHg
	 hM9Sp3W8n7fZSDlcTmbgb5u1IiRlI8ACOwR3Vmqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/162] tipc: check skb_linearize() return value in tipc_disc_rcv()
Date: Wed, 30 Nov 2022 19:22:32 +0100
Message-Id: <20221130180530.431332300@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index 2ae268b67465..2730310249e3 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -210,7 +210,10 @@ void tipc_disc_rcv(struct net *net, struct sk_buff *skb,
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



