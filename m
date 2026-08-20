Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE00247A0D4;
	Thu, 20 Aug 2026 16:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244306; cv=none; b=HwzkdMK65mOXXvrjLiu7z8My7fQ3UV9FcZNZEHxjiLpXHF0AQ8ljW8RGdS+TdmycMmVSk7z0wROC+7e9TEnRcm+pxcHAojMhltLMJLd3MHX0JI0rfEMHOqi2jh2msqo/GDZnjsdG4g0ZCVT00Vi0W5LePo4/w4LJ0afqSH6Sylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244306; c=relaxed/simple;
	bh=/AoVpz27Jo/RCzqjlvvBQ3H/lYWi09Vbhpr2T+yhuzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBbJJ+/Zkxg+NxwO85wm+LSFlPYV3qXuEO777HbxAVYQYH2GKG0M/QgZTMMfTJWhHBuaE8ch6Hzy9BAJYZOPZYUFLYPO/mHgxgjK1n1UvkKO0IqoX9qJvOxmGVZ1VxnDQy6eC6XiYmSvHer7eW1DZKQyXlP9QjKYBppE+Gqcw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3BRBwz2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3BRBwz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180BC1F000E9;
	Thu, 20 Aug 2026 16:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244305;
	bh=oT8B6T8UohcXaD3B8P46+gE9P/IulNj3Zq0ZLxwSvqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3BRBwz24cvfW2YFuB8Qn8dNrxNTCWqwOPPecCA463+4WoBum6/BzoyeTbjVcGYBi
	 rw7MK6E/8slcHWFPemG32oSzjTyq4jO/C9EVny1qi/ohW5y94DernyNxNAmV8Yuxwy
	 8724Yh+qg6bzeDO/Qb6mwm8VHZ9sdrszzvd8Od4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/235] net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 20 Aug 2026 16:55:59 +0200
Message-ID: <20260820145220.170095552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit 2496fa0b7d180b3ad356b514e7ff93bb14e6140a ]

ip6_tnl_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate ip6_tnl_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 0bd8762824e7 ("ip6tnl: add x-netns support")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-5-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -2083,6 +2083,9 @@ static int ip6_tnl_changelink(struct net
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	struct ip_tunnel_encap ipencap;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 


