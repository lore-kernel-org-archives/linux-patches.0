Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78581DF59;
	Wed,  5 Feb 2025 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768185; cv=none; b=mwAjbJCR12dgLlhkk63oS8nqmtXWD+V0VWJee3h/3yCI93nsi+GtsgV37uc3oQsBJgDxvBm9ftTN7241aKSyddWFEp+iwUx+jFeaAJJaOC48/SOUps7O2Zjel3WDPQhUqFyP/3eebmk5kbbpzDexs/5qMf1aBSYXge3VRSqrKuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768185; c=relaxed/simple;
	bh=NDb0ASaZf2osiZf13ECG54/sBnxkRGPtdd1VD8QF67s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5yOO1BO+QgQRCFmqTmEIC+73Hify2xFHZ2qTaunVeVQzzPqzX4GlO83EpbS2NeaX8CRDJN0tCq9sPgYUYFPX4qOUteZjODY7dpcmWYAFyCwJKTsRemopuS8B7BtTJu8DjRHE6kRVN/ZiTat9k5FCUahUwqsMn4LoPFcYS0XLdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pcc26zaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pcc26zaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D729EC4CED1;
	Wed,  5 Feb 2025 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768185;
	bh=NDb0ASaZf2osiZf13ECG54/sBnxkRGPtdd1VD8QF67s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pcc26zaVDo07S/xWTCZ4v1bp4RK3o5nsFJD1KpdRRc2tQDYbPFAlaHWrCx6H5vxLs
	 eLnmVDgyDzoq+7e+76yq5dldQfEMFWgE/SkFZXFTFgVJ0tspfp+Q5r7ABQHOHEgUBk
	 oms7JkqfKLoSeE8+en2BIillLJCbT3YkrePfm2uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5cfae50c0e5f2c500013@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 509/623] ipmr: do not call mr_mfc_uses_dev() for unres entries
Date: Wed,  5 Feb 2025 14:44:11 +0100
Message-ID: <20250205134515.691326628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 15a901361ec3fb1c393f91880e1cbf24ec0a88bd ]

syzbot found that calling mr_mfc_uses_dev() for unres entries
would crash [1], because c->mfc_un.res.minvif / c->mfc_un.res.maxvif
alias to "struct sk_buff_head unresolved", which contain two pointers.

This code never worked, lets remove it.

[1]
Unable to handle kernel paging request at virtual address ffff5fff2d536613
KASAN: maybe wild-memory-access in range [0xfffefff96a9b3098-0xfffefff96a9b309f]
Modules linked in:
CPU: 1 UID: 0 PID: 7321 Comm: syz.0.16 Not tainted 6.13.0-rc7-syzkaller-g1950a0af2d55 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : mr_mfc_uses_dev net/ipv4/ipmr_base.c:290 [inline]
 pc : mr_table_dump+0x5a4/0x8b0 net/ipv4/ipmr_base.c:334
 lr : mr_mfc_uses_dev net/ipv4/ipmr_base.c:289 [inline]
 lr : mr_table_dump+0x694/0x8b0 net/ipv4/ipmr_base.c:334
Call trace:
  mr_mfc_uses_dev net/ipv4/ipmr_base.c:290 [inline] (P)
  mr_table_dump+0x5a4/0x8b0 net/ipv4/ipmr_base.c:334 (P)
  mr_rtm_dumproute+0x254/0x454 net/ipv4/ipmr_base.c:382
  ipmr_rtm_dumproute+0x248/0x4b4 net/ipv4/ipmr.c:2648
  rtnl_dump_all+0x2e4/0x4e8 net/core/rtnetlink.c:4327
  rtnl_dumpit+0x98/0x1d0 net/core/rtnetlink.c:6791
  netlink_dump+0x4f0/0xbc0 net/netlink/af_netlink.c:2317
  netlink_recvmsg+0x56c/0xe64 net/netlink/af_netlink.c:1973
  sock_recvmsg_nosec net/socket.c:1033 [inline]
  sock_recvmsg net/socket.c:1055 [inline]
  sock_read_iter+0x2d8/0x40c net/socket.c:1125
  new_sync_read fs/read_write.c:484 [inline]
  vfs_read+0x740/0x970 fs/read_write.c:565
  ksys_read+0x15c/0x26c fs/read_write.c:708

Fixes: cb167893f41e ("net: Plumb support for filtering ipv4 and ipv6 multicast route dumps")
Reported-by: syzbot+5cfae50c0e5f2c500013@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/678fe2d1.050a0220.15cac.00b3.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250121181241.841212-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr_base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 03b6eee407a24..28d77d454d442 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -330,9 +330,6 @@ int mr_table_dump(struct mr_table *mrt, struct sk_buff *skb,
 	list_for_each_entry(mfc, &mrt->mfc_unres_queue, list) {
 		if (e < s_e)
 			goto next_entry2;
-		if (filter->dev &&
-		    !mr_mfc_uses_dev(mrt, mfc, filter->dev))
-			goto next_entry2;
 
 		err = fill(mrt, skb, NETLINK_CB(cb->skb).portid,
 			   cb->nlh->nlmsg_seq, mfc, RTM_NEWROUTE, flags);
-- 
2.39.5



