Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB041C7B62;
	Wed, 19 Feb 2025 09:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955771; cv=none; b=V5hirWtxsIGzYcJ+EGhYGG709ZEGwypWwACpTL3CUnfA2ahdfGYbmwXj3pTIFB3mKHrGR5XyU1nKMpAZVBfxnvlp7e3SUzvaoLfrv/MoLohGgpmrsf56WFQUKDH9LhNP1cotowisQnZ+4fHckGMATcraMfz7niu5I+AQKAkwNio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955771; c=relaxed/simple;
	bh=bYcb16dE9y3qXe/2Toxt1yr0fuye7Q6HFM6+wMWlhxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjPjve4+Vf34RMeGqbl8A43Ooi4RV4874YUhWpPKdb03A0Jl4xArHlS84AkvqUadBlJTU6zOYq0zA3py/toXRVz9NeMi+9M3Y1i/VwsyfQuYQ3Kc9SjgAPXifWxFz8G8LMofNhdf1GSCr6NpoQcXdWHc2nurpAtfuwmCN/l1jsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgZOMpba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgZOMpba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A6C4CEE6;
	Wed, 19 Feb 2025 09:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955771;
	bh=bYcb16dE9y3qXe/2Toxt1yr0fuye7Q6HFM6+wMWlhxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgZOMpbanVBk8dRbJD3uSpPsbnjNFY5+JH0A5yKSpUPWNeDCT0Mb4fLm0lKM07gAe
	 c4CvOcK963TXipA7Wm/PztSvpRHXmW8qEvimonH/jO1ghWOWq69nHBVsvXv02xITsT
	 0fUYizHx0lI4lxdjdbeQPZXY0riU+h/bUDAVF8BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/152] ipv6: use RCU protection in ip6_default_advmss()
Date: Wed, 19 Feb 2025 09:28:42 +0100
Message-ID: <20250219082554.369634559@linuxfoundation.org>
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
index c5cee40a658b4..5715d54f3d0be 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3188,13 +3188,18 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
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



