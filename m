Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF187604CF;
	Tue, 23 Jan 2024 00:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970833; cv=none; b=W1/RQen3BfMd5AVRZt1rz58tsLHqRrrek//UUjtybQGqKJOoM9Z06fwceBNekqFxRbtaYZ32cfO46+H2Ws9a1rwbMI8qTX0u3lBxugLaEP9r2qW+u19ytUHSkm4HLfr0GAd+pFVP29yIgrxTWmlQxCqwSLSv3RnPHZi/zbyEAxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970833; c=relaxed/simple;
	bh=QtRqOzQGX9Xlwi6yp5kz8eTS/Ws947WfjtkKNZOABw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kv92xXxbx4OHmHlUscMxD84TX6C/bUNCsw2sqMVYmMWps8seTBD0npYpsKdKR4cGvXmv7ZUlw/BmJsXWORk6cZEUAwpraRbCwtlEV8xHSMvIgID16lZ7UJ/Rw3Vc5vIXJT6azW6JQSlimy5oSk1oij+UUN8NZTaVkJLWZ6QBqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkW+Hylj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkW+Hylj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205CAC433F1;
	Tue, 23 Jan 2024 00:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970833;
	bh=QtRqOzQGX9Xlwi6yp5kz8eTS/Ws947WfjtkKNZOABw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkW+HyljF8toQ1MWxZFY/UnNjlWyOXIRB+8L+ivnnW4qYg2ESQYiW6amN/aVhp0dF
	 yEGiQqMZqakHrPFHmgJ/V7XEKJAQMj5Y2pfhtEtbfyH40liEjxmFE0ZBNQIApwoytm
	 KB4EYh0SGIkrU3+tP5adEDJWhuGH5PocPkiOVupA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leone Fernando <leone4fernando@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/417] ipmr: support IP_PKTINFO on cache report IGMP msg
Date: Mon, 22 Jan 2024 15:54:49 -0800
Message-ID: <20240122235755.982005412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Leone Fernando <leone4fernando@gmail.com>

[ Upstream commit bb7403655b3c3eb245d0ee330047cd3e20b3c4af ]

In order to support IP_PKTINFO on those packets, we need to call
ipv4_pktinfo_prepare.

When sending mrouted/pimd daemons a cache report IGMP msg, it is
unnecessary to set dst on the newly created skb.
It used to be necessary on older versions until
commit d826eb14ecef ("ipv4: PKTINFO doesnt need dst reference") which
changed the way IP_PKTINFO struct is been retrieved.

Changes from v1:
1. Undo changes in ipv4_pktinfo_prepare function. use it directly
   and copy the control block.

Fixes: d826eb14ecef ("ipv4: PKTINFO doesnt need dst reference")
Signed-off-by: Leone Fernando <leone4fernando@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index e04544ac4b45..b807197475a5 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1025,6 +1025,10 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 	struct sk_buff *skb;
 	int ret;
 
+	mroute_sk = rcu_dereference(mrt->mroute_sk);
+	if (!mroute_sk)
+		return -EINVAL;
+
 	if (assert == IGMPMSG_WHOLEPKT || assert == IGMPMSG_WRVIFWHOLE)
 		skb = skb_realloc_headroom(pkt, sizeof(struct iphdr));
 	else
@@ -1069,7 +1073,8 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg = (struct igmpmsg *)skb_network_header(skb);
 		msg->im_vif = vifi;
 		msg->im_vif_hi = vifi >> 8;
-		skb_dst_set(skb, dst_clone(skb_dst(pkt)));
+		ipv4_pktinfo_prepare(mroute_sk, pkt);
+		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
 		/* Add our header */
 		igmp = skb_put(skb, sizeof(struct igmphdr));
 		igmp->type = assert;
@@ -1079,12 +1084,6 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		skb->transport_header = skb->network_header;
 	}
 
-	mroute_sk = rcu_dereference(mrt->mroute_sk);
-	if (!mroute_sk) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
 	igmpmsg_netlink_event(mrt, skb);
 
 	/* Deliver to mrouted */
-- 
2.43.0



