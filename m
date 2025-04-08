Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FAB207E14;
	Tue,  8 Apr 2025 11:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112275; cv=none; b=ZIi2SSp+04Irw0pNxeSt7oxQRpXKtWVfyhi/O/i7/KCbO+TjP+tj+njQe2quE9Oq9K6dw1cvZAqmP7hkfCjCXrLmwG3PyJqf0LsEu+xwIAesGOZVG9kFAlMlcOdQuQa9bU7zNSkALdBqezqE/5pso7ns30ZTFYRYXtKH3TKknj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112275; c=relaxed/simple;
	bh=fJ+fYPnmEiPqt2ZWhdTkqTxIDeeFhwrT8enLGJ35+pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv/fYQvPt0HjzB5D5lcGNaOAD4zlZ1hwwWJuMAML/A4TyQ5shIIlZVjyIBDOBwO0vO+tfwEAPYdj6lzC5ZJvvG7rRd6e5bPPvdm1qUEDFS99FuvM/tDujeWF20NkjzByd0NfjLqMWnIBMIdxcKBYOYuReSZpzN7VsnENMjHv+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6YHIwN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6YHIwN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B862BC4CEE7;
	Tue,  8 Apr 2025 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112275;
	bh=fJ+fYPnmEiPqt2ZWhdTkqTxIDeeFhwrT8enLGJ35+pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W6YHIwN3B+FE9iYcx2JbomlsibhWy9IaEwQ3R22UGf8p260YJcKs9xo4WsTdUCsWL
	 R5Or8Z9ekKZn3an0sSTySKHLiKKFyM+1J4JhMF9e2rQxNnSVAOw+ECgv+PrbzKNr4x
	 XlFR/kt8V9h85/tT8DVbeyZL4i0UG1iZuOCOufZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 001/279] vlan: fix memory leak in vlan_newlink()
Date: Tue,  8 Apr 2025 12:46:24 +0200
Message-ID: <20250408104826.367428030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 72a0b329114b1caa8e69dfa7cdad1dd3c69b8602 upstream.

Blamed commit added back a bug I fixed in commit 9bbd917e0bec
("vlan: fix memory leak in vlan_dev_set_egress_priority")

If a memory allocation fails in vlan_changelink() after other allocations
succeeded, we need to call vlan_dev_free_egress_priority()
to free all allocated memory because after a failed ->newlink()
we do not call any methods like ndo_uninit() or dev->priv_destructor().

In following example, if the allocation for last element 2000:2001 fails,
we need to free eight prior allocations:

ip link add link dummy0 dummy0.100 type vlan id 100 \
	egress-qos-map 1:2 2:3 3:4 4:5 5:6 6:7 7:8 8:9 2000:2001

syzbot report was:

BUG: memory leak
unreferenced object 0xffff888117bd1060 (size 32):
comm "syz-executor408", pid 3759, jiffies 4294956555 (age 34.090s)
hex dump (first 32 bytes):
09 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<ffffffff83fc60ad>] kmalloc include/linux/slab.h:600 [inline]
[<ffffffff83fc60ad>] vlan_dev_set_egress_priority+0xed/0x170 net/8021q/vlan_dev.c:193
[<ffffffff83fc6628>] vlan_changelink+0x178/0x1d0 net/8021q/vlan_netlink.c:128
[<ffffffff83fc67c8>] vlan_newlink+0x148/0x260 net/8021q/vlan_netlink.c:185
[<ffffffff838b1278>] rtnl_newlink_create net/core/rtnetlink.c:3363 [inline]
[<ffffffff838b1278>] __rtnl_newlink+0xa58/0xdc0 net/core/rtnetlink.c:3580
[<ffffffff838b1629>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3593
[<ffffffff838ac66c>] rtnetlink_rcv_msg+0x21c/0x5c0 net/core/rtnetlink.c:6089
[<ffffffff839f9c37>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2501
[<ffffffff839f8da7>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
[<ffffffff839f8da7>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
[<ffffffff839f9266>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
[<ffffffff8384dbf6>] sock_sendmsg_nosec net/socket.c:714 [inline]
[<ffffffff8384dbf6>] sock_sendmsg+0x56/0x80 net/socket.c:734
[<ffffffff8384e15c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2488
[<ffffffff838523cb>] ___sys_sendmsg+0x8b/0xd0 net/socket.c:2542
[<ffffffff838525b8>] __sys_sendmsg net/socket.c:2571 [inline]
[<ffffffff838525b8>] __do_sys_sendmsg net/socket.c:2580 [inline]
[<ffffffff838525b8>] __se_sys_sendmsg net/socket.c:2578 [inline]
[<ffffffff838525b8>] __x64_sys_sendmsg+0x78/0xf0 net/socket.c:2578
[<ffffffff845ad8d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff845ad8d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
[<ffffffff8460006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 37aa50c539bc ("vlan: introduce vlan_dev_free_egress_priority")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_netlink.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -186,10 +186,14 @@ static int vlan_newlink(struct net *src_
 	else if (dev->mtu > max_mtu)
 		return -EINVAL;
 
+	/* Note: If this initial vlan_changelink() fails, we need
+	 * to call vlan_dev_free_egress_priority() to free memory.
+	 */
 	err = vlan_changelink(dev, tb, data, extack);
-	if (err)
-		return err;
-	err = register_vlan_dev(dev, extack);
+
+	if (!err)
+		err = register_vlan_dev(dev, extack);
+
 	if (err)
 		vlan_dev_free_egress_priority(dev);
 	return err;


