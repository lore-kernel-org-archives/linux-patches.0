Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290C41ED42
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01DBC433C9;
	Tue, 25 Jul 2023 11:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283434;
	bh=xPpFwIdYYv0qcRZq4W1ySyakk8749ywj9aaGBsofu6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmHAEs0gN8XqShw1d+ii15jpeYWalzxNund8x4zvfjmQ9rvKAsOn+qJLGCZzG0DHq
	 l4u1RMt/eaD2j872q25SYDRjHo5TRK/Qu/YnEZAH9PeYVoXQX+0MaIPXOvM0jnJvZk
	 SrlwFcp4AcqxGvulhObNE7JyeqKYulxMI1Pjtx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/78] net:ipv6: check return value of pskb_trim()
Date: Tue, 25 Jul 2023 12:46:48 +0200
Message-ID: <20230725104453.474419848@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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
index 0b041ab79ad90..0efd5b4346b09 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -955,7 +955,8 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		goto tx_err;
 
 	if (skb->len > dev->mtu + dev->hard_header_len) {
-		pskb_trim(skb, dev->mtu + dev->hard_header_len);
+		if (pskb_trim(skb, dev->mtu + dev->hard_header_len))
+			goto tx_err;
 		truncate = true;
 	}
 
-- 
2.39.2



