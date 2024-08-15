Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AD117C9A9;
	Thu, 15 Aug 2024 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730191; cv=none; b=d4ntIt5ZIZ7sw4L/Igcdj44AE43KUexUpDyUs/73cC81h6npEjQRY858qr5PuGhxoNG/aBvIbIy44fOKv/TjSaFvwKl9HKAzgmTeoLfiLV37w020/ypnqEyAvNpjPOAFwLeM0vGTvbGs9hc9H5Scbns67MjHxshjxm4+0dzJBV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730191; c=relaxed/simple;
	bh=/TQ6ABcC5HZcACI/7ByMIBnXKGq20Iz815Ko3Pyydu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5mNVBu6xyOXxJPjvqon9ufR4DJ9hbqAffy6hiR2bqag47mEs0ukUZTQDnYybf3scxX7R9d/WyRpThYspiitsEarBCd+kEhMaYa1TkoEZ/Ivud5wNpoIkrqCb8K/nvT4AWxm3laoHwfUiOe7v2/67Td24xy12yb2TaaOLFHpJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqYHi+01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqYHi+01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0AC32786;
	Thu, 15 Aug 2024 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730191;
	bh=/TQ6ABcC5HZcACI/7ByMIBnXKGq20Iz815Ko3Pyydu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqYHi+0198CQ8o4mRxnM5LgERVuTB//XQ3lGsLFr4LMb7DlL6RLBJi0lTfPQVLjoL
	 BBGuBPJUzLl+t/RLRBFLHu/cPF/SuOjkK7PSf+zpueNbuNp7mLUBWd5bs8q7I6/7BP
	 hkn96aWo+16jHpLgPr5NLTbRFHPwWzsNEQQGIJxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1b5e4e187cc586d05ea0@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 330/484] sched: act_ct: take care of padding in struct zones_ht_key
Date: Thu, 15 Aug 2024 15:23:08 +0200
Message-ID: <20240815131954.158364298@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2191a54f63225b548fd8346be3611c3219a24738 ]

Blamed commit increased lookup key size from 2 bytes to 16 bytes,
because zones_ht_key got a struct net pointer.

Make sure rhashtable_lookup() is not using the padding bytes
which are not initialized.

 BUG: KMSAN: uninit-value in rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
 BUG: KMSAN: uninit-value in __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
 BUG: KMSAN: uninit-value in rhashtable_lookup include/linux/rhashtable.h:646 [inline]
 BUG: KMSAN: uninit-value in rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
 BUG: KMSAN: uninit-value in tcf_ct_flow_table_get+0x611/0x2260 net/sched/act_ct.c:329
  rht_ptr_rcu include/linux/rhashtable.h:376 [inline]
  __rhashtable_lookup include/linux/rhashtable.h:607 [inline]
  rhashtable_lookup include/linux/rhashtable.h:646 [inline]
  rhashtable_lookup_fast include/linux/rhashtable.h:672 [inline]
  tcf_ct_flow_table_get+0x611/0x2260 net/sched/act_ct.c:329
  tcf_ct_init+0xa67/0x2890 net/sched/act_ct.c:1408
  tcf_action_init_1+0x6cc/0xb30 net/sched/act_api.c:1425
  tcf_action_init+0x458/0xf00 net/sched/act_api.c:1488
  tcf_action_add net/sched/act_api.c:2061 [inline]
  tc_ctl_action+0x4be/0x19d0 net/sched/act_api.c:2118
  rtnetlink_rcv_msg+0x12fc/0x1410 net/core/rtnetlink.c:6647
  netlink_rcv_skb+0x375/0x650 net/netlink/af_netlink.c:2550
  rtnetlink_rcv+0x34/0x40 net/core/rtnetlink.c:6665
  netlink_unicast_kernel net/netlink/af_netlink.c:1331 [inline]
  netlink_unicast+0xf52/0x1260 net/netlink/af_netlink.c:1357
  netlink_sendmsg+0x10da/0x11e0 net/netlink/af_netlink.c:1901
  sock_sendmsg_nosec net/socket.c:730 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:745
  ____sys_sendmsg+0x877/0xb60 net/socket.c:2597
  ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2651
  __sys_sendmsg net/socket.c:2680 [inline]
  __do_sys_sendmsg net/socket.c:2689 [inline]
  __se_sys_sendmsg net/socket.c:2687 [inline]
  __x64_sys_sendmsg+0x307/0x4a0 net/socket.c:2687
  x64_sys_call+0x2dd6/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:47
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Local variable key created at:
  tcf_ct_flow_table_get+0x4a/0x2260 net/sched/act_ct.c:324
  tcf_ct_init+0xa67/0x2890 net/sched/act_ct.c:1408

Fixes: 88c67aeb1407 ("sched: act_ct: add netns into the key of tcf_ct_flow_table")
Reported-by: syzbot+1b5e4e187cc586d05ea0@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index c602b0d698f29..a6c3b7145a105 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -41,6 +41,8 @@ static DEFINE_MUTEX(zones_mutex);
 struct zones_ht_key {
 	struct net *net;
 	u16 zone;
+	/* Note : pad[] must be the last field. */
+	u8  pad[];
 };
 
 struct tcf_ct_flow_table {
@@ -57,7 +59,7 @@ struct tcf_ct_flow_table {
 static const struct rhashtable_params zones_params = {
 	.head_offset = offsetof(struct tcf_ct_flow_table, node),
 	.key_offset = offsetof(struct tcf_ct_flow_table, key),
-	.key_len = sizeof_field(struct tcf_ct_flow_table, key),
+	.key_len = offsetof(struct zones_ht_key, pad),
 	.automatic_shrinking = true,
 };
 
-- 
2.43.0



