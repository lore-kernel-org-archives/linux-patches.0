Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A698451996;
	Thu, 30 Jul 2026 16:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428355; cv=none; b=CmqM3FjIrQc0//l8VGzblM5ylhaasBRvHYAZecDTcDok11c+Py/+1aZJhhrOJ8RUiaMEqrX+OsVy1u8QQEzNNhtYEuduMekXn/+3+mBPukW2U7RNLvvjJDkF+DI8r0cdCuE0U+AtGADYjrc0j8ITcDhDHZPVsqB24Mx0HrjHFXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428355; c=relaxed/simple;
	bh=aAbuq0SpajKcVOB0YK8WmMRZX0EfSYzxcp53iccQu64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByjJlnh06WViY9MG9qdvTjh0JzXa1CNBXu8jkW0gK6R5PPKo5ar3wpxre1wvG8atoz5JUPvuOOBl9D6M+HhRSc+cLLDPty/DCrITwLWEp0guJ18tPA4NO5stgMAtqSNxV5XvCaLgJVw0BRTnP5Fm5A4CD0CUNn2KlsRokVZ6Jbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4LrcAZJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4LrcAZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF541F000E9;
	Thu, 30 Jul 2026 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428353;
	bh=xPd0nHzvQ5DCmNeK99qX1nvtFaeDl+Kb+l47PcTUE5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4LrcAZJUF/QnarrLtbeIIDUymQe0ws2eKnqdiCeAGwmPRFfEpIoTWa/cu2T7nFPl
	 lQ1i1GWWHng+a8Q2n7TR2clOufu+zCYiLhOSDfPWa3isYmZ+Kth4T//xWdZxcXKdZt
	 /gnKIiuIOWNv/3TOCYaOWrvA0y5D6ZbVrWjNVAts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 463/484] net: ip6_tunnel: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 30 Jul 2026 16:16:00 +0200
Message-ID: <20260730141433.543668535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2055,6 +2055,9 @@ static int ip6_tnl_changelink(struct net
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	struct ip_tunnel_encap ipencap;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 


