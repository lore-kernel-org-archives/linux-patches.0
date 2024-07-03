Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441C317C9EE;
	Wed,  3 Jul 2024 11:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004732; cv=none; b=O8EOLIoJnhnz/bTfp+6eOAfRMSQjJplchIqKDatYozjgpYZHgtkWBo/A4FH2EecT+rc8U38zYN9ShaaaVODvL1rjN3GqYmtthCEIhVGz6euY7KpvV5ATyNq8xBMpH5JzaEcY7ABab47shDTV/gRe1UVaTDzEMVeZgRotJYjE3kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004732; c=relaxed/simple;
	bh=eI/GPEKWk7TViKJkMoq+oszNZ3RrcnsNOVDM86F0Yrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2YXntluk6Nu0j5EwNgBn1Zb0SztZGntL28E6Ehh7eyHPyyHyxlJAJILk0XUU2+umgXCJDZFucTt+FRTOyDytJrlOLMkhwOyU8EE+HHBIN0t4SyYklvwgFw8RhWfOoJCP79kqYetI/pNrPm7RcGaOzm9qZdBpBf4Ohzn+qm4Ops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eu1H6bXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eu1H6bXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE73FC2BD10;
	Wed,  3 Jul 2024 11:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004732;
	bh=eI/GPEKWk7TViKJkMoq+oszNZ3RrcnsNOVDM86F0Yrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eu1H6bXWo14ngzxM0gOkZ/2V4F22WmjYsg/yF+rOciVJpWIUIgdA9xqv7Cu1c5mMG
	 HCat9jhEO1krDzRKmLZSJERCki3sX+9YpalCRboaJlO//xXojbmt6pBhEX/tPhwjW6
	 3msuTNMGu0X+XWdmGSTwxdzrsmL6F2INER4nediw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/290] ipv6: prevent possible NULL deref in fib6_nh_init()
Date: Wed,  3 Jul 2024 12:38:41 +0200
Message-ID: <20240703102909.474257086@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

[ Upstream commit 2eab4543a2204092c3a7af81d7d6c506e59a03a6 ]

syzbot reminds us that in6_dev_get() can return NULL.

fib6_nh_init()
    ip6_validate_gw(  &idev  )
        ip6_route_check_nh(  idev  )
            *idev = in6_dev_get(dev); // can be NULL

Oops: general protection fault, probably for non-canonical address 0xdffffc00000000bc: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000005e0-0x00000000000005e7]
CPU: 0 PID: 11237 Comm: syz-executor.3 Not tainted 6.10.0-rc2-syzkaller-00249-gbe27b8965297 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
 RIP: 0010:fib6_nh_init+0x640/0x2160 net/ipv6/route.c:3606
Code: 00 00 fc ff df 4c 8b 64 24 58 48 8b 44 24 28 4c 8b 74 24 30 48 89 c1 48 89 44 24 28 48 8d 98 e0 05 00 00 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 b3 17 00 00 8b 1b 31 ff 89 de e8 b8 8b
RSP: 0018:ffffc900032775a0 EFLAGS: 00010202
RAX: 00000000000000bc RBX: 00000000000005e0 RCX: 0000000000000000
RDX: 0000000000000010 RSI: ffffc90003277a54 RDI: ffff88802b3a08d8
RBP: ffffc900032778b0 R08: 00000000000002fc R09: 0000000000000000
R10: 00000000000002fc R11: 0000000000000000 R12: ffff88802b3a08b8
R13: 1ffff9200064eec8 R14: ffffc90003277a00 R15: dffffc0000000000
FS:  00007f940feb06c0(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000245e8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  ip6_route_info_create+0x99e/0x12b0 net/ipv6/route.c:3809
  ip6_route_add+0x28/0x160 net/ipv6/route.c:3853
  ipv6_route_ioctl+0x588/0x870 net/ipv6/route.c:4483
  inet6_ioctl+0x21a/0x280 net/ipv6/af_inet6.c:579
  sock_do_ioctl+0x158/0x460 net/socket.c:1222
  sock_ioctl+0x629/0x8e0 net/socket.c:1341
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f940f07cea9

Fixes: 428604fb118f ("ipv6: do not set routes if disable_ipv6 has been enabled")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240614082002.26407-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 00e3daaafed82..9ea865f22c790 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3488,7 +3488,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	if (!dev)
 		goto out;
 
-	if (idev->cnf.disable_ipv6) {
+	if (!idev || idev->cnf.disable_ipv6) {
 		NL_SET_ERR_MSG(extack, "IPv6 is disabled on nexthop device");
 		err = -EACCES;
 		goto out;
-- 
2.43.0



