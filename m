Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E1D2EF
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C048FC4339B;
	Mon, 15 May 2023 16:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168661;
	bh=4zdhsuLg8Vqs9QRlbSfNY9mAAA98rmCH3VLQxjxS04o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZTtel4qu/ySgXnGHY0Tr+zHfnO4eqF5FK8Cm3y9ExJ88ssGkEjp9r4JDQ7oMHk1R
	 aJ7mN/5tcZZDS8UvrYW09vZWosmvpPFcR8hutL9ewrjGR7xum6pYpwot+k5LD4uOi3
	 cRxViU5HcDKpKy8RNR5nTH3RXT29EjDgTLidrpLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/116] net/sched: act_mirred: Add carrier check
Date: Mon, 15 May 2023 18:26:28 +0200
Message-Id: <20230515161701.290239435@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 526f28bd0fbdc699cda31426928802650c1528e5 ]

There are cases where the device is adminstratively UP, but operationally
down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
who's cable was pulled out, here is its ip link output:

5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
    altname enp179s0f1np1

As you can see, it's administratively UP but operationally down.
In this case, sending a packet to this port caused a nasty kernel hang (so
nasty that we were unable to capture it). Aborting a transmit based on
operational status (in addition to administrative status) fixes the issue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
v1->v2: Add fixes tag
v2->v3: Remove blank line between tags + add change log, suggested by Leon
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index dcfaa4f9c7c5b..0a032c4d26b86 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -181,7 +181,7 @@ static int tcf_mirred(struct sk_buff *skb, const struct tc_action *a,
 		goto out;
 	}
 
-	if (unlikely(!(dev->flags & IFF_UP))) {
+	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
 		goto out;
-- 
2.39.2



