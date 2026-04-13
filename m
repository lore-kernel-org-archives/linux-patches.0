Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E030EF80;
	Mon, 13 Apr 2026 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097798; cv=none; b=lahZ6iThTk5JWATVZ4FBlHGLqIPjdLy3iRlhCHKHte94K6m3ge/xof6jz1w71Xtnqwy+A3R8R0THssevZTpaRGWpyBW8jCHCBNaMG0xE/mV4lYxYO0JE0yXWKOuH/lRKi5VrW71x5PxA0aFW6QFLJ7eqJYhXtwFlxYdw8PIG9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097798; c=relaxed/simple;
	bh=3lrCzLPI8P2zRrBOtZTPStKbb1GxbxHP7kjvW0F4KAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmtN2XaPR2Jthqw74VXX6a0SzJqWd3nXTAgrgn0bCRrCi5fkoFKBDZSX7gpbvNCQQD1ak01zWgL6sneWcXE2Qdj4kIa4eJji4yoaRc9FhcrRz0Sm9Erv5CTehfD32u1VyDMvg6jdhezyG0I/LnJdyFmfxPPoQBta2dRj5ynqtP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2WD8Wr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2WD8Wr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C724C2BCAF;
	Mon, 13 Apr 2026 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097797;
	bh=3lrCzLPI8P2zRrBOtZTPStKbb1GxbxHP7kjvW0F4KAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2WD8Wr66yuu8BJ1KXgbT8o2H/x4CADe1WDdDCR/V1YqJeccuuecBd/X+Ym80ZL0d
	 knVAyPDwQO3FjC7QDAt3M2Rw+3PnHbhhJHrlFoQPcGToW/5jGKyZxoLkWWQy3qwFIM
	 mcGzR73WuLGRtmOGmT0byZCZlrBsg1CKCjPfU6cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/570] udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n
Date: Mon, 13 Apr 2026 17:56:48 +0200
Message-ID: <20260413155840.858783289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit b3a6df291fecf5f8a308953b65ca72b7fc9e015d ]

When CONFIG_IPV6 is disabled, the udp_sock_create6() function returns 0
(success) without actually creating a socket. Callers such as
fou_create() then proceed to dereference the uninitialized socket
pointer, resulting in a NULL pointer dereference.

The captured NULL deref crash:
  BUG: kernel NULL pointer dereference, address: 0000000000000018
  RIP: 0010:fou_nl_add_doit (net/ipv4/fou_core.c:590 net/ipv4/fou_core.c:764)
  [...]
  Call Trace:
    <TASK>
    genl_family_rcv_msg_doit.constprop.0 (net/netlink/genetlink.c:1114)
    genl_rcv_msg (net/netlink/genetlink.c:1194 net/netlink/genetlink.c:1209)
    [...]
    netlink_rcv_skb (net/netlink/af_netlink.c:2550)
    genl_rcv (net/netlink/genetlink.c:1219)
    netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
    netlink_sendmsg (net/netlink/af_netlink.c:1894)
    __sock_sendmsg (net/socket.c:727 (discriminator 1) net/socket.c:742 (discriminator 1))
    __sys_sendto (./include/linux/file.h:62 (discriminator 1) ./include/linux/file.h:83 (discriminator 1) net/socket.c:2183 (discriminator 1))
    __x64_sys_sendto (net/socket.c:2213 (discriminator 1) net/socket.c:2209 (discriminator 1) net/socket.c:2209 (discriminator 1))
    do_syscall_64 (arch/x86/entry/syscall_64.c:63 (discriminator 1) arch/x86/entry/syscall_64.c:94 (discriminator 1))
    entry_SYSCALL_64_after_hwframe (net/arch/x86/entry/entry_64.S:130)

This patch makes udp_sock_create6 return -EPFNOSUPPORT instead, so
callers correctly take their error paths. There is only one caller of
the vulnerable function and only privileged users can trigger it.

Fixes: fd384412e199b ("udp_tunnel: Seperate ipv6 functions into its own file.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260317010241.1893893-1-xmei5@asu.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/udp_tunnel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 72394f441dad8..b6af537abdc5a 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -47,7 +47,7 @@ int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 static inline int udp_sock_create6(struct net *net, struct udp_port_cfg *cfg,
 				   struct socket **sockp)
 {
-	return 0;
+	return -EPFNOSUPPORT;
 }
 #endif
 
-- 
2.51.0



