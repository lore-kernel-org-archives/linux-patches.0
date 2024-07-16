Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DCDF9E8;
	Tue, 16 Jul 2024 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144101; cv=none; b=g9sQfNKIgM+CTqh/KHfye2iXRFyNAMlLttewq17tHTgCgUcsQLBOGqPGmehGxTeCYMrZXrBzZ3XvF2BD76EVwiccPDXgfcFaG+aJq6byFnVdfmHzX47XKVxGLm7KJeU/gIXQq5oQDwU50kMtOPvSNS6btXx0wXDurtOAjQWSBSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144101; c=relaxed/simple;
	bh=4eWd5TMdpGR3WJgXTu3c+RNVcWYGkRYAUI/ISznnlV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbVcKOmiuYYRss88BUjMHJI5fRKiiICZ4ij8S/MtFLMAN1CJxItLgtwBthdPMaDKP6cSkmG2Aut7aWo7WGvlBlFNlJ1Vgb8GIO1r2IobMhForw3HPBJPPAdVcRHFASSt89ZKQSSRREiNOcaneyxqNEbR9yF3YVUoUvPCjV446+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTJhZKwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTJhZKwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FB7C116B1;
	Tue, 16 Jul 2024 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144100;
	bh=4eWd5TMdpGR3WJgXTu3c+RNVcWYGkRYAUI/ISznnlV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTJhZKwjAJt97e7V5u2TE8BL5+oz7MWO+6zPxExvEZ0K5RIXccSBZ9ReEBVkafWRi
	 lUiC5n029UPEdZgR+ChdFR/F8xOYz9ApovsqN4RBlsDT03+V8Q6ui9i/7CWI5VZvhH
	 tvpj/fM8QKsYpk4EP/rxfuTgDustYWuvJQ7IDvCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Shigeru Yoshida <syoshida@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/66] inet_diag: Initialize pad field in struct inet_diag_req_v2
Date: Tue, 16 Jul 2024 17:31:03 +0200
Message-ID: <20240716152739.239237250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
References: <20240716152738.161055634@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 61cf1c739f08190a4cbf047b9fbb192a94d87e3f ]

KMSAN reported uninit-value access in raw_lookup() [1]. Diag for raw
sockets uses the pad field in struct inet_diag_req_v2 for the
underlying protocol. This field corresponds to the sdiag_raw_protocol
field in struct inet_diag_req_raw.

inet_diag_get_exact_compat() converts inet_diag_req to
inet_diag_req_v2, but leaves the pad field uninitialized. So the issue
occurs when raw_lookup() accesses the sdiag_raw_protocol field.

Fix this by initializing the pad field in
inet_diag_get_exact_compat(). Also, do the same fix in
inet_diag_dump_compat() to avoid the similar issue in the future.

[1]
BUG: KMSAN: uninit-value in raw_lookup net/ipv4/raw_diag.c:49 [inline]
BUG: KMSAN: uninit-value in raw_sock_get+0x657/0x800 net/ipv4/raw_diag.c:71
 raw_lookup net/ipv4/raw_diag.c:49 [inline]
 raw_sock_get+0x657/0x800 net/ipv4/raw_diag.c:71
 raw_diag_dump_one+0xa1/0x660 net/ipv4/raw_diag.c:99
 inet_diag_cmd_exact+0x7d9/0x980
 inet_diag_get_exact_compat net/ipv4/inet_diag.c:1404 [inline]
 inet_diag_rcv_msg_compat+0x469/0x530 net/ipv4/inet_diag.c:1426
 sock_diag_rcv_msg+0x23d/0x740 net/core/sock_diag.c:282
 netlink_rcv_skb+0x537/0x670 net/netlink/af_netlink.c:2564
 sock_diag_rcv+0x35/0x40 net/core/sock_diag.c:297
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0xe74/0x1240 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x10c6/0x1260 net/netlink/af_netlink.c:1905
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x332/0x3d0 net/socket.c:745
 ____sys_sendmsg+0x7f0/0xb70 net/socket.c:2585
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2639
 __sys_sendmsg net/socket.c:2668 [inline]
 __do_sys_sendmsg net/socket.c:2677 [inline]
 __se_sys_sendmsg net/socket.c:2675 [inline]
 __x64_sys_sendmsg+0x27e/0x4a0 net/socket.c:2675
 x64_sys_call+0x135e/0x3ce0 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd9/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 raw_sock_get+0x650/0x800 net/ipv4/raw_diag.c:71
 raw_diag_dump_one+0xa1/0x660 net/ipv4/raw_diag.c:99
 inet_diag_cmd_exact+0x7d9/0x980
 inet_diag_get_exact_compat net/ipv4/inet_diag.c:1404 [inline]
 inet_diag_rcv_msg_compat+0x469/0x530 net/ipv4/inet_diag.c:1426
 sock_diag_rcv_msg+0x23d/0x740 net/core/sock_diag.c:282
 netlink_rcv_skb+0x537/0x670 net/netlink/af_netlink.c:2564
 sock_diag_rcv+0x35/0x40 net/core/sock_diag.c:297
 netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
 netlink_unicast+0xe74/0x1240 net/netlink/af_netlink.c:1361
 netlink_sendmsg+0x10c6/0x1260 net/netlink/af_netlink.c:1905
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x332/0x3d0 net/socket.c:745
 ____sys_sendmsg+0x7f0/0xb70 net/socket.c:2585
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2639
 __sys_sendmsg net/socket.c:2668 [inline]
 __do_sys_sendmsg net/socket.c:2677 [inline]
 __se_sys_sendmsg net/socket.c:2675 [inline]
 __x64_sys_sendmsg+0x27e/0x4a0 net/socket.c:2675
 x64_sys_call+0x135e/0x3ce0 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd9/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable req.i created at:
 inet_diag_get_exact_compat net/ipv4/inet_diag.c:1396 [inline]
 inet_diag_rcv_msg_compat+0x2a6/0x530 net/ipv4/inet_diag.c:1426
 sock_diag_rcv_msg+0x23d/0x740 net/core/sock_diag.c:282

CPU: 1 PID: 8888 Comm: syz-executor.6 Not tainted 6.10.0-rc4-00217-g35bb670d65fc #32
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014

Fixes: 432490f9d455 ("net: ip, diag -- Add diag interface for raw sockets")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240703091649.111773-1-syoshida@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_diag.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index d07917059d70f..a876991ecb2ca 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -1097,6 +1097,7 @@ static int inet_diag_dump_compat(struct sk_buff *skb,
 	req.sdiag_family = AF_UNSPEC; /* compatibility */
 	req.sdiag_protocol = inet_diag_type2proto(cb->nlh->nlmsg_type);
 	req.idiag_ext = rc->idiag_ext;
+	req.pad = 0;
 	req.idiag_states = rc->idiag_states;
 	req.id = rc->id;
 
@@ -1115,6 +1116,7 @@ static int inet_diag_get_exact_compat(struct sk_buff *in_skb,
 	req.sdiag_family = rc->idiag_family;
 	req.sdiag_protocol = inet_diag_type2proto(nlh->nlmsg_type);
 	req.idiag_ext = rc->idiag_ext;
+	req.pad = 0;
 	req.idiag_states = rc->idiag_states;
 	req.id = rc->id;
 
-- 
2.43.0



