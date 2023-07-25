Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF2E1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7125AC433C7;
	Tue, 25 Jul 2023 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285706;
	bh=UUj7oShgFtXBwIPVOq13oPOpkx7SH95FVLtIOJyO4Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSwgyC8vDNoGAJzZBY8zuUxJJ/DOysr1zVWu34eJ1PMqMpJY/5Ob5n5GlyuIHmL8J
	 uV18wsFriNpIC6HKCruHm9CYOi9XFMKmn7npnVW2ezfyRiyZgaAzpMUc46fhdvYfKV
	 h0Auw/h864gKqfOuGdiRxneseD/QKBmrnIx33rI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 301/313] net:ipv6: check return value of pskb_trim()
Date: Tue, 25 Jul 2023 12:47:34 +0200
Message-ID: <20230725104534.168130500@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit 4258faa130be4ea43e5e2d839467da421b8ff274 ]

goto tx_err if an unexpected result is returned by pskb_tirm()
in ip6erspan_tunnel_xmit().

Fixes: 5a963eb61b7c ("ip6_gre: Add ERSPAN native tunnel support")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 0977137b00dc4..2d34bd98fccea 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -941,7 +941,8 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		goto tx_err;
 
 	if (skb->len > dev->mtu + dev->hard_header_len) {
-		pskb_trim(skb, dev->mtu + dev->hard_header_len);
+		if (pskb_trim(skb, dev->mtu + dev->hard_header_len))
+			goto tx_err;
 		truncate = true;
 	}
 
-- 
2.39.2



