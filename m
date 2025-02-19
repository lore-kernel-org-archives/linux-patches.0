Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AA9155753;
	Wed, 19 Feb 2025 08:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953866; cv=none; b=FO8vbWFZ+XBY3rIt10BF2/2bFNtytCmrry+75KvIlH6OhA77rIBWCQcAj/EEzZvrq3CTqSY5xAnNugh3geueQQ/fZEJ8Zs3hy2eovj0plnrjvM9Yqmz8m1opmeBjFjOJ2kAEzWcXFdzUFroonNxkzEQ3gNrjcrErz7X2VsEA1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953866; c=relaxed/simple;
	bh=tviq4NzekAn+OwY20A/8PeSuQMq2O2xKosNupMWzq1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGg1EMevq/87IT7h0UNOZZ7+VuhH9FMn7Evs1hu8m5yCzsNWM+0fpVV5HCtRUYZweCu8XtGECt08SUgEpBI07+Ou2brB1KFtwOdqPlVqMCw8Nj9WOZSbktz+gKBjM4dcnovFtZ8qw1hvZwXkQalOke3UB5gdx+VfSW6I6GGmJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cG0HBIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cG0HBIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7C5C4CEE6;
	Wed, 19 Feb 2025 08:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953865;
	bh=tviq4NzekAn+OwY20A/8PeSuQMq2O2xKosNupMWzq1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cG0HBImoRFkIvZ7Hj62LG6SgyzXTMIGDvjIEL8hlg/ORx93Rm3FOM/Q+dLk+c/oP
	 ULVyebV4gVmjJ/almILzCN31Xug4k6ufAOgtEg33RfoWA0YyOaQVKBG3PrjK8gadB+
	 Ixn0IlwoIN0/eGc0OiPSVtc2LcG3+4sbPrHQDBpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 022/274] ndisc: ndisc_send_redirect() must use dev_get_by_index_rcu()
Date: Wed, 19 Feb 2025 09:24:36 +0100
Message-ID: <20250219082610.407352089@linuxfoundation.org>
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

[ Upstream commit 48145a57d4bbe3496e8e4880b23ea6b511e6e519 ]

ndisc_send_redirect() is called under RCU protection, not RTNL.

It must use dev_get_by_index_rcu() instead of __dev_get_by_index()

Fixes: 2f17becfbea5 ("vrf: check the original netdevice for generating redirect")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index d044c67019de6..264b10a947577 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1694,7 +1694,7 @@ void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 	bool ret;
 
 	if (netif_is_l3_master(skb->dev)) {
-		dev = __dev_get_by_index(dev_net(skb->dev), IPCB(skb)->iif);
+		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
-- 
2.39.5



