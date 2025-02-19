Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10771CAA8E;
	Wed, 19 Feb 2025 09:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955848; cv=none; b=hjoxyd+3JmCWxE7E0KqcPfCTnqyS6dZhAovJAXVpS4D//+FvLRP80u0wlFp9zsSguLF9enQ9WjfAWckAsQ+tFeu9lLO/Lj5a/K/olyKeBw4QJ3U/8b4sgLrRxRYClF671KPxPGkI+6nEi6TPzFHNHhb0wtMPQuSg/NEIfc0S0o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955848; c=relaxed/simple;
	bh=cVtC4dihLgK0nl9aj02bZvwtn0XuM9z8j8lL60p+Jyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppc9PtEtQCxMukdlK9SsC98HaY1a7M5f2bSY6z9QZPRLrMPYd6/CtDLPKbyOpHv6t9uMKsxOsIXdqR4nPPLDqtGVghPbaAxou5vKe/suNO0eyRdIVGQgvhQLQ2m9slWULwvtk7CcxGMKSt2enrSXAhdmhj/+99/vEeD0754Ujp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTw/WHgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTw/WHgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E8DC4CED1;
	Wed, 19 Feb 2025 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955848;
	bh=cVtC4dihLgK0nl9aj02bZvwtn0XuM9z8j8lL60p+Jyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTw/WHgwhHdalx6m0U2qsgS5+PX/PtyEHgjqyLQZJ8Dy9Y0gMPXI2QzFH71gRHECi
	 crmtn5ljOpQuvPEW68ud8djAo0zoZHakRrfZaP98vkpZovRuyFUyN8Dop1USjsc9qW
	 dpWc/zE2MyJjbOpLpyVokg84fO7UfFvjAf1zlNIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/152] ipv4: use RCU protection in ipv4_default_advmss()
Date: Wed, 19 Feb 2025 09:28:35 +0100
Message-ID: <20250219082554.094610438@linuxfoundation.org>
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

[ Upstream commit 71b8471c93fa0bcab911fcb65da1eb6c4f5f735f ]

ipv4_default_advmss() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: 2e9589ff809e ("ipv4: Namespaceify min_adv_mss sysctl knob")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 61fc2166a870e..15cf2949ce951 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1306,10 +1306,15 @@ static void set_class_tag(struct rtable *rt, u32 tag)
 
 static unsigned int ipv4_default_advmss(const struct dst_entry *dst)
 {
-	struct net *net = dev_net(dst->dev);
 	unsigned int header_size = sizeof(struct tcphdr) + sizeof(struct iphdr);
-	unsigned int advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
-				    net->ipv4.ip_rt_min_advmss);
+	unsigned int advmss;
+	struct net *net;
+
+	rcu_read_lock();
+	net = dev_net_rcu(dst->dev);
+	advmss = max_t(unsigned int, ipv4_mtu(dst) - header_size,
+				   net->ipv4.ip_rt_min_advmss);
+	rcu_read_unlock();
 
 	return min(advmss, IPV4_MAX_PMTU - header_size);
 }
-- 
2.39.5



