Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D322309B0;
	Mon, 10 Mar 2025 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630438; cv=none; b=ODc2fD/JQ8ZJH/NIy8GXlqBFkwb3rAiKmYRY+ijkMr1AqLbOwDBQQPeLyrg/rhO3CRYu99CvGNBzbDwbT1dnglX/7oIcLDSORhw//YnpiEJqKTNdvKTMG4rAzyLc/pw6FX3NbxZn+AWHG59Wrr9WvRh7YtpTJf89u9IRLPqmo9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630438; c=relaxed/simple;
	bh=IqTOiPQNJet0PxWXYP/qP93RqL0Ncg8bNMt/b4XNfiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKdhO5fQtWA5VqouJ0e5fY3h3aaTmIuA8FbkTf8dhLB36VSvUdktLrEaTqSVeuXLzw2bslrv0jAq7/ynhMHYrYRxZqZD76ZAoPvd9cadA7fVITsi/nekfl2POi5r5I2nvUHdbiJCLgG5f0ya1gUytB9eKERCRtPKA0plwq/KU5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv5S+iu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv5S+iu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB22C4CEE5;
	Mon, 10 Mar 2025 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630438;
	bh=IqTOiPQNJet0PxWXYP/qP93RqL0Ncg8bNMt/b4XNfiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv5S+iu1QgpxHSAbCyv0pBBz2LUaatXsoUnoi7hrSWvFULCynL5IsqtWAuzyROcsP
	 zp4Y29l0DxPmnFMf1VP7mdy8lF0LEhF+9EkYI7ybiCiHnaNjqIud9Oj3NJFPeoFdVn
	 Rdpv60jqkGC5cd80sZVv+Cd6SC3hgL0RoUbm2WtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/620] arp: use RCU protection in arp_xmit()
Date: Mon, 10 Mar 2025 18:04:12 +0100
Message-ID: <20250310170601.616924205@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a42b69f692165ec39db42d595f4f65a4c8f42e44 ]

arp_xmit() can be called without RTNL or RCU protection.

Use RCU protection to avoid potential UAF.

Fixes: 29a26a568038 ("netfilter: Pass struct net into the netfilter hooks")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/arp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 8ae9bd6f91c19..6879e0b70c769 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -637,10 +637,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
  */
 void arp_xmit(struct sk_buff *skb)
 {
+	rcu_read_lock();
 	/* Send it off, maybe filter it using firewalling first.  */
 	NF_HOOK(NFPROTO_ARP, NF_ARP_OUT,
-		dev_net(skb->dev), NULL, skb, NULL, skb->dev,
+		dev_net_rcu(skb->dev), NULL, skb, NULL, skb->dev,
 		arp_xmit_finish);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(arp_xmit);
 
-- 
2.39.5



