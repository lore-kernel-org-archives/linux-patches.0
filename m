Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FC71C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E57BC433D2;
	Mon, 20 Mar 2023 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324557;
	bh=SFBggJYkVHnCEZcZfLMB/8VKkg2NrKqNkLzN9FgAHNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqsumxbZCbinR39ALTNewXEYvMpPR427CfTLWKSAn2D4ZQFIsMcF79vLE2cYygEas
	 APPNCXZpDOcuVr+NMCwqeHbkjRDRg73Mt32+pDs4lhB4Y8zMkgZzchqepNSVr1BLS2
	 bgKDT3XTXkT2K4n+5/WtbdwmgKYQj9xams4z/pbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/99] ipvlan: Make skb->skb_iif track skb->dev for l3s mode
Date: Mon, 20 Mar 2023 15:53:55 +0100
Message-Id: <20230320145444.087576263@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit 59a0b022aa249e3f5735d93de0849341722c4754 ]

For l3s mode, skb->dev is set to ipvlan interface in ipvlan_nf_input():
  skb->dev = addr->master->dev
but, skb->skb_iif remain unchanged, this will cause socket lookup failed
if a target socket is bound to a interface, like the following example:

  ip link add ipvlan0 link eth0 type ipvlan mode l3s
  ip addr add dev ipvlan0 192.168.124.111/24
  ip link set ipvlan0 up

  ping -c 1 -I ipvlan0 8.8.8.8
  100% packet loss

This is because there is no match sk in __raw_v4_lookup() as sk->sk_bound_dev_if != dif(skb->skb_iif).
Fix this by make skb->skb_iif track skb->dev in ipvlan_nf_input().

Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/29865b1f-6db7-c07a-de89-949d3721ea30@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_l3s.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f5..71712ea25403d 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;
 
 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
-- 
2.39.2



