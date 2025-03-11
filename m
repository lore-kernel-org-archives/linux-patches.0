Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B136E1925AF;
	Tue, 11 Mar 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706596; cv=none; b=YEC2B/0OEkkZqFrtiLpGsJ0/VS0llfI0dd4kHY/sYmOfXOKZPY4fiH/WgaE25I0ofUopwUbRFglm9n9zyKfeu+fYZP6yE6GXrqTH+9Ttsv4TbUvYEuZLYlp+tsD+xATmaYuLuflVpads7MjCGtab9K60EU/jYaQjpZr+dW2cydc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706596; c=relaxed/simple;
	bh=9nKVx0zRN4TlKYbpBa9nuXTIma1n0E0ZE8q6lPHfoPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmFVL7EvV0PrTx4ME+ODbLwoAH7Vnqm5a4zv+Xh5oZugeug604XeE/fopoVlXbFHPeNtG8AuMaCrc1gX6FgsE2dnxtBZmW7Rkw+q2AXDeNsfaAyJVktG3nbi9SJ8dRsPqCsqgB/VqPPfCme4/pnRM3O7mCbOhknrXwOOT0UmdVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xf8FYQCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xf8FYQCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B076C4CEE9;
	Tue, 11 Mar 2025 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706596;
	bh=9nKVx0zRN4TlKYbpBa9nuXTIma1n0E0ZE8q6lPHfoPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xf8FYQCARDbE4/h+fAw6E2NqiQS63eX5lhIEv0X8ICKp1TA+srCMzgM3h7VAwc2LA
	 4Zgjvh0pmfkxYekVI6EJ60Eep25So7Zu2r16s163swBdJwhwgDcSZ5qgyhWX3d6fda
	 chwF2Nix6ozONiqy9mhGHqoFPYWB2d081wKFdy1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5cfae50c0e5f2c500013@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/462] ipmr: do not call mr_mfc_uses_dev() for unres entries
Date: Tue, 11 Mar 2025 15:56:08 +0100
Message-ID: <20250311145802.389857370@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c45cb7cb57590..8b5b6f196cdc4 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -321,9 +321,6 @@ int mr_table_dump(struct mr_table *mrt, struct sk_buff *skb,
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



