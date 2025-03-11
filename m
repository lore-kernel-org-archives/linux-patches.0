Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D75525DAEC;
	Tue, 11 Mar 2025 15:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707216; cv=none; b=mJv9KlMC20tGFkhEgCWR8OC3QAjsR3hIrWhBkuoXMfzdaAz5vyTYL41hViX5dxkiD5rAS/rd1wHur9QpRK8K23M4H4yAOvJ1tCLWNr/BCnlZLuR/dmGTOHogjd3lFYtEkEC03QFhFSskOVTWUEXTiLRlRKYmGxoEDMp18DFc/w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707216; c=relaxed/simple;
	bh=ncMlQixep3xJShpvVPWmqUjAfigtAVALOQjaZEj0pqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFEFSlT/wDRay+Ts/cOPFqPoCNTZGEhIBO8k+quiCk+rbj/ujvuDp859K1rDqjp4889Rdhjt+zQaK90+rWzbWc2XfIfzYN3WL5zHe++dZQcO3+40RGpyg4eVaZqWhwrngqg+Cn9Tjht6xN9K0FfvHYhksA8KlclXwGNz5Smzr3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgtLySMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgtLySMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F4CC4CEEA;
	Tue, 11 Mar 2025 15:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707216;
	bh=ncMlQixep3xJShpvVPWmqUjAfigtAVALOQjaZEj0pqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgtLySMINLVF/X4UCA+RJn0Xxj+SMNbLV1AsiHbeGGrh1IDRQjrHIVV24zK0TcFJ4
	 xE3HLv3gcwFiPY850k7c4bUnB+5hqSDTfZ8z0uH5q/3PecbTREarMX59RtzLm7/NiJ
	 /IcZR9MWuAhFMUaYX/6IIqN7V+nGqbvOeNqE+Rp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 283/462] ipv6: use RCU protection in ip6_default_advmss()
Date: Tue, 11 Mar 2025 15:59:09 +0100
Message-ID: <20250311145809.552767289@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d7d600cb15a8d..178c56f6f6185 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3056,13 +3056,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
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



