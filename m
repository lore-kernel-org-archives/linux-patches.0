Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C9340A6F;
	Sat, 30 May 2026 18:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164471; cv=none; b=XVzY62Ygmbb1L0q8j0MHLDhmYI3mozbEM01vXUL618m3P4VcAoOvug8vosouDMF++d2+i2dqUhrlnYGlbA8+XF857yzO8sGBsr1gipLC4JA2Gxp10cebfO6gTYgchAXyJ3HqnZsOF6ZwuL3j9LiwaGk+Yl9D1Yt3qaVX+D8hgEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164471; c=relaxed/simple;
	bh=tVvPaHweTQCtNb13tXRS8aPxGrlOy4Xk2mK1+MwPEVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpHC2cuaM1gHgWW63xu1DUM8KtMJnSDf0Nb7eUk7EqIJ5ywF9PWH8jOixIYr0n7md1RdbZR5W5crhVV6pCZC4bvgERirYSLFdqL6epx+62wtJY2HMddW9KNPxQOcz0MEIfCfzbQV/z3laH8rHMyYQ0OzuORtul6mlfK3A3yWgDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5GW3O2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5GW3O2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFC41F00893;
	Sat, 30 May 2026 18:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164470;
	bh=2osHbaqF3mhKfy396Dicsh8/kg+0847gnlTquONUsWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5GW3O2QJJTA7YEsAojAVcFuzBdhMM5EALLygAEotkBFQQnsylT2msGIYst/qqotB
	 DtfFtql73wUJDhGlXlxF7nK8owfKHBKgo2WG3DQCS7V8glVlieQA0CphmlAxdwduUD
	 DTj+J9fM1RNo6SjpNU10IMnhb0eJPPIUPv3Apw5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Joe Damato <joe@dama.to>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/776] ipv6: fix possible UAF in icmpv6_rcv()
Date: Sat, 30 May 2026 18:04:39 +0200
Message-ID: <20260530160254.725568077@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f996edd7615e686ada141b7f3395025729ff8ccb ]

Caching saddr and daddr before pskb_pull() is problematic
since skb->head can change.

Remove these temporary variables:

- We only access &ipv6_hdr(skb)->saddr and &ipv6_hdr(skb)->daddr
  when net_dbg_ratelimited() is called in the slow path.

- Avoid potential future misuse after pskb_pull() call.

Fixes: 4b3418fba0fe ("ipv6: icmp: include addresses in debug messages")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Joe Damato <joe@dama.to>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260416103505.2380753-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 6f053874de741..fcfb0f79b07ab 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -883,7 +883,6 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	struct net_device *dev = icmp6_dev(skb);
 	struct inet6_dev *idev = __in6_dev_get(dev);
-	const struct in6_addr *saddr, *daddr;
 	struct icmp6hdr *hdr;
 	u8 type;
 	bool success = false;
@@ -910,12 +909,10 @@ static int icmpv6_rcv(struct sk_buff *skb)
 
 	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_INMSGS);
 
-	saddr = &ipv6_hdr(skb)->saddr;
-	daddr = &ipv6_hdr(skb)->daddr;
-
 	if (skb_checksum_validate(skb, IPPROTO_ICMPV6, ip6_compute_pseudo)) {
 		net_dbg_ratelimited("ICMPv6 checksum failed [%pI6c > %pI6c]\n",
-				    saddr, daddr);
+				    &ipv6_hdr(skb)->saddr,
+				    &ipv6_hdr(skb)->daddr);
 		goto csum_error;
 	}
 
@@ -997,7 +994,8 @@ static int icmpv6_rcv(struct sk_buff *skb)
 			break;
 
 		net_dbg_ratelimited("icmpv6: msg of unknown type [%pI6c > %pI6c]\n",
-				    saddr, daddr);
+				    &ipv6_hdr(skb)->saddr,
+				    &ipv6_hdr(skb)->daddr);
 
 		/*
 		 * error of unknown type.
-- 
2.53.0



