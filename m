Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E8B1DFE20;
	Wed, 19 Feb 2025 08:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954504; cv=none; b=qCmG9iOTfds6C8XP13/w2VQuy0UOwKCmR9npwWSik5sIPpeba7g0/baEXzSs0u0Enea1GKi5y33GtH3JAIAU0/zX9RSu5bi5etZHnOGAbVvHepa880QGzmkwLYd/x1lwNCfP/2m1OO5P/0OuFv9m89bFzeyIGQ6nO3j/8UW75cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954504; c=relaxed/simple;
	bh=/xvzvIVMN33+N0IXxo/uBjNT9EYyO/XHo2bjR1Niwm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBUA2TdfosdOJz6a8DZVJB7WglTzyb/fkvLVVEbPHre8SSGTIddfvcwb2KRSKPmmHNinfR8jYivzFGF75VIqrVRXgSphN/k6qkSewOOxd9TupPk1DXoCuxnScckpzOLj4BTXDDTIojF16cH93VTn1oUfvcXW9GOO5BMorASC/NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyZdR80v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyZdR80v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A599C4CEE7;
	Wed, 19 Feb 2025 08:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954502;
	bh=/xvzvIVMN33+N0IXxo/uBjNT9EYyO/XHo2bjR1Niwm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyZdR80v0xlYIcopUpgyE0RYjwBMxGOW9H/4Qk5x9NCWUzv0pwrFEM2/sMvrDk8Tq
	 CReVswrVcOF3/D1zr5qGJDRHZC83YwV51PUKn2CDVb2Vnjgd9SBKFNxwvqLv7s05pf
	 GB55iTb2F7VvlZp4JD8A6fR7UoozPV6pVJj93Lgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 223/274] ipv6: use RCU protection in ip6_default_advmss()
Date: Wed, 19 Feb 2025 09:27:57 +0100
Message-ID: <20250219082618.303122551@linuxfoundation.org>
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

[ Upstream commit 3c8ffcd248da34fc41e52a46e51505900115fc2a ]

ip6_default_advmss() needs rcu protection to make
sure the net structure it reads does not disappear.

Fixes: 5578689a4e3c ("[NETNS][IPV6] route6 - make route6 per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-11-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 67ff16c047180..997e2e4f441d2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3196,13 +3196,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 {
 	struct net_device *dev = dst->dev;
 	unsigned int mtu = dst_mtu(dst);
-	struct net *net = dev_net(dev);
+	struct net *net;
 
 	mtu -= sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(dev);
 	if (mtu < net->ipv6.sysctl.ip6_rt_min_advmss)
 		mtu = net->ipv6.sysctl.ip6_rt_min_advmss;
 
+	rcu_read_unlock();
+
 	/*
 	 * Maximal non-jumbo IPv6 payload is IPV6_MAXPLEN and
 	 * corresponding MSS is IPV6_MAXPLEN - tcp_header_size.
-- 
2.39.5



