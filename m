Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909A19E7E5;
	Tue, 16 Jul 2024 15:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144824; cv=none; b=qk+ExTunCVuhG9rtLzlmt1wcam1PkQUxJT+Lu74RSozPQiVe0Gllp7pTZrmNDVb7QLAIP65yob5bV+UNeFeZYzO3Y2XlDutstFN3pWH6tRA8EEIA3u6BPATCmPEHjZX9RADSnrqRBH8TyJZKuPsz3qKPnhMzjLq95UR3iB7WXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144824; c=relaxed/simple;
	bh=Z8OD7PVSn+Aplvp+fiRgp+/V2fhd69ayfxqfNgIHv1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSiwc7fMTUfqvJSyjB6qud17m7V+RFcGFkOeX9OHPAxvfGHvnn+V36zpv2ouUr+AvZDCO5iVINf1O/Kv6ltEu6uayuR/NcnW8hjFGUzQ2+ViwEB9jamXFwuvux14ok1fxKjrdKXvgjaDjrH7jDB6/BxBzr6NiWyVC5g+TrJVizU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dumEUXvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dumEUXvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB24C116B1;
	Tue, 16 Jul 2024 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144824;
	bh=Z8OD7PVSn+Aplvp+fiRgp+/V2fhd69ayfxqfNgIHv1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dumEUXvR6lJ6ivowkc0wVymBYrjf5hF5w9xqL6NnCdAxYJSsjIsArIGCjCfhEdpcv
	 CGqj7a2FZ+9ope9LJtneqZG+X/fRKi3TB+qJikYd+xA+uecsQTXVflZOR+nJCnyrar
	 5uLnqqDo/W24XVfn7ZJll7nFd5h6mk4w+7i9pGwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Subject: [PATCH 5.10 096/108] ipv6: annotate data-races around cnf.disable_ipv6
Date: Tue, 16 Jul 2024 17:31:51 +0200
Message-ID: <20240716152749.676626026@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit d289ab65b89c1d4d88417cb6c03e923f21f95fae upstream.

disable_ipv6 is read locklessly, add appropriate READ_ONCE()
and WRITE_ONCE() annotations.

v2: do not preload net before rtnl_trylock() in
    addrconf_disable_ipv6() (Jiri)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Ashwin: Regenerated the Patch for v5.10]
Signed-off-by: Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c   |    9 +++++----
 net/ipv6/ip6_input.c  |    2 +-
 net/ipv6/ip6_output.c |    2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4107,7 +4107,7 @@ static void addrconf_dad_work(struct wor
 			if (!ipv6_generate_eui64(addr.s6_addr + 8, idev->dev) &&
 			    ipv6_addr_equal(&ifp->addr, &addr)) {
 				/* DAD failed for link-local based on MAC */
-				idev->cnf.disable_ipv6 = 1;
+				WRITE_ONCE(idev->cnf.disable_ipv6, 1);
 
 				pr_info("%s: IPv6 being disabled!\n",
 					ifp->idev->dev->name);
@@ -6220,7 +6220,8 @@ static void addrconf_disable_change(stru
 		idev = __in6_dev_get(dev);
 		if (idev) {
 			int changed = (!idev->cnf.disable_ipv6) ^ (!newf);
-			idev->cnf.disable_ipv6 = newf;
+
+			WRITE_ONCE(idev->cnf.disable_ipv6, newf);
 			if (changed)
 				dev_disable_change(idev);
 		}
@@ -6237,7 +6238,7 @@ static int addrconf_disable_ipv6(struct
 
 	net = (struct net *)table->extra2;
 	old = *p;
-	*p = newf;
+	WRITE_ONCE(*p, newf);
 
 	if (p == &net->ipv6.devconf_dflt->disable_ipv6) {
 		rtnl_unlock();
@@ -6245,7 +6246,7 @@ static int addrconf_disable_ipv6(struct
 	}
 
 	if (p == &net->ipv6.devconf_all->disable_ipv6) {
-		net->ipv6.devconf_dflt->disable_ipv6 = newf;
+		WRITE_ONCE(net->ipv6.devconf_dflt->disable_ipv6, newf);
 		addrconf_disable_change(net, newf);
 	} else if ((!newf) ^ (!old))
 		dev_disable_change((struct inet6_dev *)table->extra1);
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -165,7 +165,7 @@ static struct sk_buff *ip6_rcv_core(stru
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
-	    !idev || unlikely(idev->cnf.disable_ipv6)) {
+	    !idev || unlikely(READ_ONCE(idev->cnf.disable_ipv6))) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
 		goto drop;
 	}
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -240,7 +240,7 @@ int ip6_output(struct net *net, struct s
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
 
-	if (unlikely(idev->cnf.disable_ipv6)) {
+	if (unlikely(READ_ONCE(idev->cnf.disable_ipv6))) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 		kfree_skb(skb);
 		return 0;


