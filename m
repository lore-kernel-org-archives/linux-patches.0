Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD323BCFD;
	Mon, 23 Mar 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274408; cv=none; b=RLK5j5mg5+c+j3x6J+9Q++7CIfwD3pGB9VYNSc0pOdgc5a7mofCI+zJXoCw8DXLeuovtrphzDiSeNA+h9lj8pF+BB0joOmhQ00R2pPX/nwr6mJNHdQlbiNnz0jrtGPlmP10c6Y7jV0TM+oKiyDk3k9ctStfA0xUIlrwpKDuKO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274408; c=relaxed/simple;
	bh=VRyb8ZaP21Wos65m34n/rhvQR65bvlaNlx3L2kGZrCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+awAIsCwZHaYb2Ro5JW5ICGSh4NQjDfINyTaGibyBBihI4ZZT90BZNEcrK6qO26ZJcSago70Dyd0csxPKdOvT6T9sdIDsb1Q0wO8wt6UWGmZcvpSklYIjgMeQoNLegpLDh9obJToB5cQIUwYHTz0jNIp43M6Qe6k/HINugvQ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmn8brZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmn8brZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4492FC2BC9E;
	Mon, 23 Mar 2026 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274408;
	bh=VRyb8ZaP21Wos65m34n/rhvQR65bvlaNlx3L2kGZrCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmn8brZ8c4aLwnUHakkH47xUM26dqQhXheo0MDtpe6oHctsIvGz+BQpW7t18ElW9X
	 JdpBhrghBporChsH1OIf3qv8vt4n9tVMODyP3vN+SBrxzCCoS4jcUm0dWFa2Y8OLUi
	 wRmKfjkq8U6GIfY9T+RCB+cTcXiG6HKtCj+sKkhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 171/220] udp_tunnel: fix NULL deref caused by udp_sock_create6 when CONFIG_IPV6=n
Date: Mon, 23 Mar 2026 14:45:48 +0100
Message-ID: <20260323134509.993570597@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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
index 9acef2fbd2fdc..d97ee26ba4f66 100644
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



