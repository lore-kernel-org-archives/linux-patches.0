Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F683BA25B;
	Mon, 23 Mar 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283181; cv=none; b=JMb8HL0SyyVDraCHFcQQ6UV2xmekURNaEnwnWL62oBr3YVsOLCIh+8+Z5mPvvyFDoUFc0pBr8PgLvJNRZgnY9oHAxG3j/9ZOhJZ9N+pyNnMF1ueTR6dnEjyiI1LNr+ykXu723yWMyNrY/9J5Laew2T7Y9ZkXe3ebejXUSMw3AAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283181; c=relaxed/simple;
	bh=Lzloqu9hTyERji/sv7jR3/UwVC43kCs9a1lqgOv6fPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqSsoGNVFtaZO3AoHwDzXubyxqnNAH5J2m7adK75SC+2WFTxDfOH6emm7xzXLtnMFM+pPh/ZYz2kB08KlNKRatJR84Pel8QtOUxApwgtcBjscE12zOs+kXhM49EIZyqx7h8StxCZ+Fmt0FZv2YctEnRwJJ1n/VBJA2+EUbeMepI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wF1CoKDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wF1CoKDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C6FC2BC9E;
	Mon, 23 Mar 2026 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283180;
	bh=Lzloqu9hTyERji/sv7jR3/UwVC43kCs9a1lqgOv6fPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wF1CoKDbkjG6VTlTu7WmfdKk5XLkRIph+Vv/avE+2WfojmefviFbgpyV9jRE92+RH
	 BA0fjwZDLfhrXVIB8mbH6WcwJWRsqCISDXo7rvn927ke/c6K/YLWh+LZVHXpaikfko
	 6lBnupEJXPpW48F26G/ZKIbmw/ln9MFKn4lUEW7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/481] udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n
Date: Mon, 23 Mar 2026 14:46:55 +0100
Message-ID: <20260323134535.754973083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index e5f81710b18f4..cd2bd3826d168 100644
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



