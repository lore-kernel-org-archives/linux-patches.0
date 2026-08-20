Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7277E483BD1;
	Thu, 20 Aug 2026 17:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248330; cv=none; b=m1v9ILqKa82tngsp1ywTlCDTOeYvSDU5fzYaJ35dDXs427fFMmhoc58aRsXD6+u+XEFD5kKdul4xYnb9aWBzG+ZNS6KQNhiiHEATlts+3shGbWAZmK0vfELkvsFg77zRkjbHaMAlzM2BX6z5TBKQ4dUlRTfKx3lUD349C1qfdPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248330; c=relaxed/simple;
	bh=Cq//tcXjcfP8mycbOElkkxw3zpqmgAdq2sK1+za5Lyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3xQfPSYbyyXFGLXRY0PHXbd9dmxnPgADT0bgiuHrlZLiLe/4D/iU9WwWctfSp9nx5zHL9ivfbggkU/xo/COXHi+JC4MoAe9szWmHrC14pUiXkPP7nq5c94rhwuq+MSAEnGCLM7n+nnXDoHKB/2rqmaajWdtmZ4B0sFFWlF8Vbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YS806/Y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YS806/Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02EF1F000E9;
	Thu, 20 Aug 2026 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248329;
	bh=N0iHDqDiwXf0vMD11nYt3YTdw9P3lScfTvACkGBMBB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YS806/Y8W/zD40Reh3o+Ot655KoodJwuVFonFG38OaVnHgpQf94x8aIYhxNf86iNL
	 Za5FoVu9eb+S8JqKx1PJP48i8DKpZ5TYga8Y3Q4y5bc7+Vq6c9HA2/Ey34uFUR7jXA
	 xueRPwghdowgyHUdf2177CATjkwlJU6O3j8KI0Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/303] net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 20 Aug 2026 16:54:47 +0200
Message-ID: <20260820145257.827347042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2060,6 +2060,9 @@ static int ip6_tnl_changelink(struct net
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	struct ip_tunnel_encap ipencap;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 


