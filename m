Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764661D5CF8;
	Wed, 19 Feb 2025 09:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955821; cv=none; b=Xzt6dNF5GbqRwxwAChKqkV47TiB/pJS+ynpy72vwSVlJJHbz+hhHXUrsrcAJUsUmcpvAEo36JF+6crug0TzMCVDziO3pMGXyvTyEs1XBVE6JUWSdvuH10LCQiYozZgs/tRdezxo3Fd0T9FJTp+k2UmOI+/G7xvq7fABJe2ajD2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955821; c=relaxed/simple;
	bh=wF2tlxvDHX82m/fk7Hr0M2uEMnLpjqehQiwwsLg0v/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMEIpoQMS98NVbVLdoPE3E+im5BqcmhSvCX3CyOFoOVaxN59T6VmJqTZfC4e9vFHCNuRmAxLgxNE0lG/0vlXGwvovW66OhrGZTLs3Dzmq8csiE7zffnXZTGe3s0fiCV1OP6PBpP+jzZbiIdC+qWXye4HWMPrVU2eMSEVbUNr6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRthEZ4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRthEZ4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B90C4CED1;
	Wed, 19 Feb 2025 09:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955821;
	bh=wF2tlxvDHX82m/fk7Hr0M2uEMnLpjqehQiwwsLg0v/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRthEZ4qwg63IoJIELKdPKnT2mwJFfyoVoE7fAiM/sZdXQ7Vh4bYnR7o35PPY2RNE
	 M5ayXAVma4tGQAMGPRUR109EaontdranmIuf5AkLJT65kwLKyd4pnHYA+EzMevjko8
	 JuVvejwy7ymyyY+4+F99uzv1li+RkzUGfe3KbU2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/152] arp: use RCU protection in arp_xmit()
Date: Wed, 19 Feb 2025 09:28:57 +0100
Message-ID: <20250219082554.956345912@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d0d725b46ad0..02776453bf97a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -658,10 +658,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
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



