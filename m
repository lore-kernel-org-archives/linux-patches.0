Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD39126056D;
	Wed, 25 Feb 2026 01:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983579; cv=none; b=jx/V6run7ho0HdAt6ZRFq6iAUBP/z8sypHqZ/dqSXqCJciQOEXHng6GrSlElcPLNr6AnE/neqWFwiXZ62CaxqTTCZVfEMD2Q9iJHSNWt40/MeiTtPGHJs2QTlAPHK3fMZsvpKNuL55YpFsuesG4A9B4cAw9SkhJF3p/9a3LcmVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983579; c=relaxed/simple;
	bh=ZcMkM3lmq+xL1JcEghWhJ0s7MDZPOmGyxKcfDHc61W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S66I5zmK7vXSPWW1PnTtw5+lcYu0Kum2kCq5kmR59BH4/qGB86d/JN8ekXVCRX+CE4Dq3ctMSct/BMIhI/EvhSO61qaHj7AZIbb3xBe93ngR7V42qiPvaUV83jV7O2gkmEWPvTCpUY2bDo4YLh9eoWwngY82ilpkc69ToJK9ShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYZ8U7H8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYZ8U7H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D40EC116D0;
	Wed, 25 Feb 2026 01:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983579;
	bh=ZcMkM3lmq+xL1JcEghWhJ0s7MDZPOmGyxKcfDHc61W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYZ8U7H8Uw46hqirf84SKqiyoe0uoH0To0ehzoRdag1PZf00fzTw6oOyP92Vge5r8
	 zmabxiMHtdhnOjjXzZc+FgmPKSpAqa9UUdDJ/iBKp+5hOpOES9uNKz3tD8jd72RyQj
	 NiLWtew9U5NGBJcPat0PWBhOVzTjyTjplgg1GvSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 680/781] ipv6: icmp: remove obsolete code in icmpv6_xrlim_allow()
Date: Tue, 24 Feb 2026 17:23:09 -0800
Message-ID: <20260225012416.455185626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0201eedb69b24a6be9b7c1716287a89c4dde2320 ]

Following part was needed before the blamed commit, because
inet_getpeer_v6() second argument was the prefix.

	/* Give more bandwidth to wider prefixes. */
	if (rt->rt6i_dst.plen < 128)
		tmo >>= ((128 - rt->rt6i_dst.plen)>>5);

Now inet_getpeer_v6() retrieves hosts, we need to remove
@tmo adjustement or wider prefixes likes /24 allow 8x
more ICMP to be sent for a given ratelimit.

As we had this issue for a while, this patch changes net.ipv6.icmp.ratelimit
default value from 1000ms to 100ms to avoid potential regressions.

Also add a READ_ONCE() when reading net->ipv6.sysctl.icmpv6_time.

Fixes: fd0273d7939f ("ipv6: Remove external dependency on rt6i_dst and rt6i_src")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260216142832.3834174-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 7 ++++---
 net/ipv6/af_inet6.c                    | 2 +-
 net/ipv6/icmp.c                        | 7 +------
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index bc9a01606daf5..2c65d57103fb1 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3232,12 +3232,13 @@ enhanced_dad - BOOLEAN
 ===========
 
 ratelimit - INTEGER
-	Limit the maximal rates for sending ICMPv6 messages.
+	Limit the maximal rates for sending ICMPv6 messages to a particular
+	peer.
 
 	0 to disable any limiting,
-	otherwise the minimal space between responses in milliseconds.
+	otherwise the space between responses in milliseconds.
 
-	Default: 1000
+	Default: 100
 
 ratemask - list of comma separated ranges
 	For ICMPv6 message types matching the ranges in the ratemask, limit
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b705751eb73c6..d3534bdb805da 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -955,7 +955,7 @@ static int __net_init inet6_net_init(struct net *net)
 	int err = 0;
 
 	net->ipv6.sysctl.bindv6only = 0;
-	net->ipv6.sysctl.icmpv6_time = 1*HZ;
+	net->ipv6.sysctl.icmpv6_time = HZ / 10;
 	net->ipv6.sysctl.icmpv6_echo_ignore_all = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_multicast = 0;
 	net->ipv6.sysctl.icmpv6_echo_ignore_anycast = 0;
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a77f3113ef23b..55b1aa75ab802 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -217,14 +217,9 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 	} else if (dev && (dev->flags & IFF_LOOPBACK)) {
 		res = true;
 	} else {
-		struct rt6_info *rt = dst_rt6_info(dst);
-		int tmo = net->ipv6.sysctl.icmpv6_time;
+		int tmo = READ_ONCE(net->ipv6.sysctl.icmpv6_time);
 		struct inet_peer *peer;
 
-		/* Give more bandwidth to wider prefixes. */
-		if (rt->rt6i_dst.plen < 128)
-			tmo >>= ((128 - rt->rt6i_dst.plen)>>5);
-
 		peer = inet_getpeer_v6(net->ipv6.peers, &fl6->daddr);
 		res = inet_peer_xrlim_allow(peer, tmo);
 	}
-- 
2.51.0



