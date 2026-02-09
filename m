Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CFC28725B;
	Mon,  9 Feb 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648560; cv=none; b=WLmiOw1CFpAJsD9h3RrZYRD2R8BAEy/ks4kc/kj6BedKgpIqOakru14GZwFFC4OawNlLXrHd5oaSUlmaAIZuzA6TPFEIUBMMT8pWo5mVbuR2csSXVxJ59C9PZ1nkxsKMAXqNTPZk5qQHuXYsg/XDOETTxrD/cx/7SZsdN6/WOxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648560; c=relaxed/simple;
	bh=+zOdDjMUlugcusDKSQyPB/RkXnSTcrEJlG280bdizWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKH/TRHGRUPYmQBDl6W3XGQ/Ur8pH9MIvXfcFCxLy7H/rHUKOBAUZLs/pHxCuThKU6/t1kLUxO792WVylep/KKNsYAEHApV6R/stSmAcpdv0KBwh77EkKn3JSDiQPsrtBoxlAVYcpGdLwFCvTpFV4wyTZsORt3I+/KI+d6oL+Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aqp8FTMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aqp8FTMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841AAC116C6;
	Mon,  9 Feb 2026 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648560;
	bh=+zOdDjMUlugcusDKSQyPB/RkXnSTcrEJlG280bdizWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aqp8FTMj8f8aA8hcn3wQoyIqoFpAKInP/7Ttv0ZcmQ+m3EykH2cGns4HKdzYKwpV7
	 Ob0pvmkBqS1KaR9UjoSnRyyyzr3XNa41DsS5oyveo/5OhdQCGQ/dcnpbuvkTbJSP7+
	 h27VDLPePJazpGp0Z9VMUPkmUVAK3RlcRI0vq/zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb809def1baaac68ab92@syzkaller.appspotmail.com,
	Shigeru Yoshida <syoshida@redhat.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 75/86] ipv6: Fix ECMP sibling count mismatch when clearing RTF_ADDRCONF
Date: Mon,  9 Feb 2026 15:24:38 +0100
Message-ID: <20260209142307.474941853@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit bbf4a17ad9ffc4e3d7ec13d73ecd59dea149ed25 ]

syzbot reported a kernel BUG in fib6_add_rt2node() when adding an IPv6
route. [0]

Commit f72514b3c569 ("ipv6: clear RA flags when adding a static
route") introduced logic to clear RTF_ADDRCONF from existing routes
when a static route with the same nexthop is added. However, this
causes a problem when the existing route has a gateway.

When RTF_ADDRCONF is cleared from a route that has a gateway, that
route becomes eligible for ECMP, i.e. rt6_qualify_for_ecmp() returns
true. The issue is that this route was never added to the
fib6_siblings list.

This leads to a mismatch between the following counts:

- The sibling count computed by iterating fib6_next chain, which
  includes the newly ECMP-eligible route

- The actual siblings in fib6_siblings list, which does not include
  that route

When a subsequent ECMP route is added, fib6_add_rt2node() hits
BUG_ON(sibling->fib6_nsiblings != rt->fib6_nsiblings) because the
counts don't match.

Fix this by only clearing RTF_ADDRCONF when the existing route does
not have a gateway. Routes without a gateway cannot qualify for ECMP
anyway (rt6_qualify_for_ecmp() requires fib_nh_gw_family), so clearing
RTF_ADDRCONF on them is safe and matches the original intent of the
commit.

[0]:
kernel BUG at net/ipv6/ip6_fib.c:1217!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6010 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:fib6_add_rt2node+0x3433/0x3470 net/ipv6/ip6_fib.c:1217
[...]
Call Trace:
 <TASK>
 fib6_add+0x8da/0x18a0 net/ipv6/ip6_fib.c:1532
 __ip6_ins_rt net/ipv6/route.c:1351 [inline]
 ip6_route_add+0xde/0x1b0 net/ipv6/route.c:3946
 ipv6_route_ioctl+0x35c/0x480 net/ipv6/route.c:4571
 inet6_ioctl+0x219/0x280 net/ipv6/af_inet6.c:577
 sock_do_ioctl+0xdc/0x300 net/socket.c:1245
 sock_ioctl+0x576/0x790 net/socket.c:1366
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: f72514b3c569 ("ipv6: clear RA flags when adding a static route")
Reported-by: syzbot+cb809def1baaac68ab92@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cb809def1baaac68ab92
Tested-by: syzbot+cb809def1baaac68ab92@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260204095837.1285552-1-syoshida@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 646ff1276aff2..fe57884ca7238 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1136,7 +1136,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 					fib6_set_expires(iter, rt->expires);
 					fib6_add_gc_list(iter);
 				}
-				if (!(rt->fib6_flags & (RTF_ADDRCONF | RTF_PREFIX_RT))) {
+				if (!(rt->fib6_flags & (RTF_ADDRCONF | RTF_PREFIX_RT)) &&
+				    !iter->fib6_nh->fib_nh_gw_family) {
 					iter->fib6_flags &= ~RTF_ADDRCONF;
 					iter->fib6_flags &= ~RTF_PREFIX_RT;
 				}
-- 
2.51.0



