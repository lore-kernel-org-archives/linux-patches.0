Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA9D1C5F0C;
	Wed, 19 Feb 2025 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954555; cv=none; b=qvupUytDRtKyZW6GnfxvR/bZjR7mHV0IzWD9i2Qy2A34B39lbe+AWb7UeKoCy9/pHN5bVSc5P23eyu4PjTGzedSQzOZTSnNW+by4Kna8quaAmiiKOADcpEIE5Yicgy4tCntDDkJNzvF5eSAfXSWhw7nB5YjaALqHnFNgJLucGtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954555; c=relaxed/simple;
	bh=8cZsoPvpbdp5K6+VwvvB8MPh4kWI3LQAIVI0SmZnD8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwRhrwb2YkcSBEw1D0h79Q+e+gXdJ2po+i4x34XIFgGfhafUv7J1MeY6GdcriR1Z3P+3ajvmDu3YuXjJ0huac0ay9rxteLhIeFjmJEFeuJzVD3GiMDtmG1R91ZowLXAz8S8vHEXGBolSFwRNwjUg1nLTc7XiWoktL+7U2XFHfJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XN/dskdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XN/dskdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5554C4CED1;
	Wed, 19 Feb 2025 08:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954555;
	bh=8cZsoPvpbdp5K6+VwvvB8MPh4kWI3LQAIVI0SmZnD8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN/dskdSxcBkHV1JsjhH6tEU7sDfDGlC+BZ6ic4mjvUdK9vuDmo0AopSy1UwRE8C2
	 Pe97ZvIx+RgyCDnul5AGLmnSCA5Wrg5REfQ7tgiHtSiQQHrDoCfStDwYih/W+01D87
	 6tbb00Mplq4SyrC/51h/+7TWYkM1It8lWjy/n+3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 238/274] arp: use RCU protection in arp_xmit()
Date: Wed, 19 Feb 2025 09:28:12 +0100
Message-ID: <20250219082618.895385377@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index cb9a7ed8abd3a..f23a1ec6694cb 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -659,10 +659,12 @@ static int arp_xmit_finish(struct net *net, struct sock *sk, struct sk_buff *skb
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



