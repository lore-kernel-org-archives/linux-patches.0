Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C628FE;
	Sat, 30 Dec 2023 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0X/bOvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D2C433C8;
	Sat, 30 Dec 2023 12:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937687;
	bh=118/epCOGP+xE0mExB8mSJNxwRiL9HC4k7Na5F3TRgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0X/bOvCVYgQyGglwJa3qE5rZzMijwmqg5/vk3PkmPOf0CUCIFeedxwX0A4/XMuVL
	 YWP2/6bwur3MtKsaa1pcfGiIXcOkGcplxKSHX5V6xAfB0SzFz+X0YqvRi9FATB7isA
	 9ZFnL4jLVp5LLvREy+BMXd96pYoc0wEQn5XqwXlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+62d7eef57b09bfebcd84@syzkaller.appspotmail.com
Subject: [PATCH 6.6 023/156] wifi: mac80211: check if the existing link config remains unchanged
Date: Sat, 30 Dec 2023 11:57:57 +0000
Message-ID: <20231230115813.131817554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit c1393c132b906fbdf91f6d1c9eb2ef7a00cce64e ]

[Syz report]
WARNING: CPU: 1 PID: 5067 at net/mac80211/rate.c:48 rate_control_rate_init+0x540/0x690 net/mac80211/rate.c:48
Modules linked in:
CPU: 1 PID: 5067 Comm: syz-executor413 Not tainted 6.7.0-rc3-syzkaller-00014-gdf60cee26a2e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/10/2023
RIP: 0010:rate_control_rate_init+0x540/0x690 net/mac80211/rate.c:48
Code: 48 c7 c2 00 46 0c 8c be 08 03 00 00 48 c7 c7 c0 45 0c 8c c6 05 70 79 0b 05 01 e8 1b a0 6f f7 e9 e0 fd ff ff e8 61 b3 8f f7 90 <0f> 0b 90 e9 36 ff ff ff e8 53 b3 8f f7 e8 5e 0b 78 f7 31 ff 89 c3
RSP: 0018:ffffc90003c57248 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888016bc4000 RCX: ffffffff89f7d519
RDX: ffff888076d43b80 RSI: ffffffff89f7d6df RDI: 0000000000000005
RBP: ffff88801daaae20 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000000001
R13: 0000000000000000 R14: ffff888020030e20 R15: ffff888078f08000
FS:  0000555556b94380(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000005fdeb8 CR3: 0000000076d22000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sta_apply_auth_flags.constprop.0+0x4b7/0x510 net/mac80211/cfg.c:1674
 sta_apply_parameters+0xaf1/0x16c0 net/mac80211/cfg.c:2002
 ieee80211_add_station+0x3fa/0x6c0 net/mac80211/cfg.c:2068
 rdev_add_station net/wireless/rdev-ops.h:201 [inline]
 nl80211_new_station+0x13ba/0x1a70 net/wireless/nl80211.c:7603
 genl_family_rcv_msg_doit+0x1fc/0x2e0 net/netlink/genetlink.c:972
 genl_family_rcv_msg net/netlink/genetlink.c:1052 [inline]
 genl_rcv_msg+0x561/0x800 net/netlink/genetlink.c:1067
 netlink_rcv_skb+0x16b/0x440 net/netlink/af_netlink.c:2545
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1342 [inline]
 netlink_unicast+0x53b/0x810 net/netlink/af_netlink.c:1368
 netlink_sendmsg+0x93c/0xe40 net/netlink/af_netlink.c:1910
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0xd5/0x180 net/socket.c:745
 ____sys_sendmsg+0x6ac/0x940 net/socket.c:2584
 ___sys_sendmsg+0x135/0x1d0 net/socket.c:2638
 __sys_sendmsg+0x117/0x1e0 net/socket.c:2667
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x40/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

[Analysis]
It is inappropriate to make a link configuration change judgment on an
non-existent and non new link.

[Fix]
Quickly exit when there is a existent link and the link configuration has not
changed.

Fixes: b303835dabe0 ("wifi: mac80211: accept STA changes without link changes")
Reported-and-tested-by: syzbot+62d7eef57b09bfebcd84@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_DE67FF86DB92ED465489A36ECD2EDDCC8C06@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 715da615f0359..f7cb50b0dd4ed 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1806,10 +1806,10 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					  lockdep_is_held(&local->sta_mtx));
 
 	/*
-	 * If there are no changes, then accept a link that doesn't exist,
+	 * If there are no changes, then accept a link that exist,
 	 * unless it's a new link.
 	 */
-	if (params->link_id < 0 && !new_link &&
+	if (params->link_id >= 0 && !new_link &&
 	    !params->link_mac && !params->txpwr_set &&
 	    !params->supported_rates_len &&
 	    !params->ht_capa && !params->vht_capa &&
-- 
2.43.0



