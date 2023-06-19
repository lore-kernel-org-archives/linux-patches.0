Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1BBE4B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DB7C433C0;
	Mon, 19 Jun 2023 10:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171956;
	bh=Y6MBSY97SJc6gArE0pDXarPoM4AXlqY9EeogjInlCE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLq+G7wFCRqylylUw6+X5vwkurf0JYs1RLTFwV4ivRVnvCMx6N+E+7G5pbEGaqGwI
	 N2my0Um18E2a5oqHDDiyFkRfEBMFpDzKtWxes4br2LmUS4coutnWwN2PDsqEkeDy8M
	 74NPJ7YRULGd6Fd9lhalAme0O6KNpJsgmgeTPvVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/64] ipvlan: fix bound dev checking for IPv6 l3s mode
Date: Mon, 19 Jun 2023 12:30:45 +0200
Message-ID: <20230619102135.426844579@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
References: <20230619102132.808972458@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit ce57adc222aba32431c42632b396e9213d0eb0b8 ]

The commit 59a0b022aa24 ("ipvlan: Make skb->skb_iif track skb->dev for l3s
mode") fixed ipvlan bonded dev checking by updating skb skb_iif. This fix
works for IPv4, as in raw_v4_input() the dif is from inet_iif(skb), which
is skb->skb_iif when there is no route.

But for IPv6, the fix is not enough, because in ipv6_raw_deliver() ->
raw_v6_match(), the dif is inet6_iif(skb), which is returns IP6CB(skb)->iif
instead of skb->skb_iif if it's not a l3_slave. To fix the IPv6 part
issue. Let's set IP6CB(skb)->iif to correct ifindex.

BTW, ipvlan handles NS/NA specifically. Since it works fine, I will not
reset IP6CB(skb)->iif when addr->atype is IPVL_ICMPV6.

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2196710
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 71712ea25403d..d5b05e8032199 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -102,6 +102,10 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 
 	skb->dev = addr->master->dev;
 	skb->skb_iif = skb->dev->ifindex;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (addr->atype == IPVL_IPV6)
+		IP6CB(skb)->iif = skb->dev->ifindex;
+#endif
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
-- 
2.39.2



