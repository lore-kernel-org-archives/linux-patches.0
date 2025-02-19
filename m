Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D393F1DEFE4;
	Wed, 19 Feb 2025 09:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957508; cv=none; b=Blb9hLTKwH7UY4/av2jDitrgR6QtOhFY4nTtmPhLpSGQ0elgZjwGfMC/PiqvtcnMpVaIZ04bEk5KuQcemY8oD3oJIkrmhD/uaf7uPAF0vNo8HN2yY0WTj0U369hAYf0Llwy2CQK/TMetZkbQXelc9yKv9fv7N2tXMlHwWFGOdq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957508; c=relaxed/simple;
	bh=YLdO4iVHPFWkVWFOjCGvEZCI3cb9eLINWfSnb+lPzrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCH2igkSuktwwmyxQmOMBSUpVHal+nyAAmS0aK7TBOL4qCf851WP8j9Ku00AKYpUeX3UYTPw/B6snyy9HeKXUpsVv4B4gr0cwomwGeXJDFR5p3uO38yOzN6Jou61EBVirntQMptqXbT9Nc3ruwJ67jlHpZbxoKzIajo56eXHtZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyjrK3j3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyjrK3j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06687C4CEE6;
	Wed, 19 Feb 2025 09:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957508;
	bh=YLdO4iVHPFWkVWFOjCGvEZCI3cb9eLINWfSnb+lPzrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyjrK3j3ZThGVrSEkF+D5p0wCaZwVKhrpT4V+ty5bLBm9VrfAefYpBAtq0x4olM9g
	 XPcZP/GB6vMrPpCEM/khG5Qa5vbiHpDo9N0TWDusRR3MvIqjm2/KBxl//LkMJxy+wh
	 peea9RDQw85AV4FRLS+DEoIDzY57agWhf3gJBgSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 549/578] ndisc: use RCU protection in ndisc_alloc_skb()
Date: Wed, 19 Feb 2025 09:29:13 +0100
Message-ID: <20250219082714.558803757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 628e6d18930bbd21f2d4562228afe27694f66da9 ]

ndisc_alloc_skb() can be called without RTNL or RCU being held.

Add RCU protection to avoid possible UAF.

Fixes: de09334b9326 ("ndisc: Introduce ndisc_alloc_skb() helper.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 6df3f4aadf641..2e8e0847631e3 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -418,15 +418,11 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
 {
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	struct sock *sk = dev_net(dev)->ipv6.ndisc_sk;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(hlen + sizeof(struct ipv6hdr) + len + tlen, GFP_ATOMIC);
-	if (!skb) {
-		ND_PRINTK(0, err, "ndisc: %s failed to allocate an skb\n",
-			  __func__);
+	if (!skb)
 		return NULL;
-	}
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
@@ -437,7 +433,9 @@ static struct sk_buff *ndisc_alloc_skb(struct net_device *dev,
 	/* Manually assign socket ownership as we avoid calling
 	 * sock_alloc_send_pskb() to bypass wmem buffer limits
 	 */
-	skb_set_owner_w(skb, sk);
+	rcu_read_lock();
+	skb_set_owner_w(skb, dev_net_rcu(dev)->ipv6.ndisc_sk);
+	rcu_read_unlock();
 
 	return skb;
 }
-- 
2.39.5



