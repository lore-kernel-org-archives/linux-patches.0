Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259EF17756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973CDC433C7;
	Wed,  9 Aug 2023 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580125;
	bh=b8H5f5BgJ+MBPKA/gk31XAfuexskVXZS2eEksLApj3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gegir/Henw+i0G9MC1sbJbmcaKhgkaSWPwvCfAzGYRRFeV1YuZvX32FCRd6iv8GS1
	 62bAY2XicU78fQlUwRcjffV+5WnBh3xwi5UGFP3+kKjyfAcy6k6pDe6cndcBR+8fIs
	 5t1SdfDltVcTl35Aoon1TcDhIrElifFfn/NUqdxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 205/323] net:ipv6: check return value of pskb_trim()
Date: Wed,  9 Aug 2023 12:40:43 +0200
Message-ID: <20230809103707.528097257@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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
index 45c304b51b2b7..aa8ada354a399 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -960,7 +960,8 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		goto tx_err;
 
 	if (skb->len > dev->mtu + dev->hard_header_len) {
-		pskb_trim(skb, dev->mtu + dev->hard_header_len);
+		if (pskb_trim(skb, dev->mtu + dev->hard_header_len))
+			goto tx_err;
 		truncate = true;
 	}
 
-- 
2.39.2



