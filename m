Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425671F8913;
	Tue, 17 Dec 2024 17:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456613; cv=none; b=MOcOhM/xnBsLbDe4TMxZ6ChyUJj8LCTfi7wqz4baLy9TwqsMrq13uv+RRMxUNGj9JzrrSQx6OGXzcL38PBgXURzEbei6wQ/o3GLXC4DG5UiJykk3NTjUgfRCXoBeVsNf+Tg2gq7i0Qj05HcsTLYBUwth9+KR6fmuLUOQ8x4rpZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456613; c=relaxed/simple;
	bh=zIJQtW/BBaaQF4J/u3k8KVV7i2m16wDmcJDC+s7+Ia0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvbMAYfpQ2AKIwn2kK9Obqe++Kk+e+5but60YjjfCh2rZ6kWkgWRhpgvPxhcMT0qahNL04xPaL9zCG8KDMHkIxKuAPqobXdKlkbMG4WUWaRSUaHhDHeZ1E+t3pkkO9/8HOjdP7nNThEiNRNGkcEoYn8v3v0DLFLQqP0RTmvnv7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L2oe3wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L2oe3wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB57C4CED7;
	Tue, 17 Dec 2024 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456613;
	bh=zIJQtW/BBaaQF4J/u3k8KVV7i2m16wDmcJDC+s7+Ia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0L2oe3wKPe33KeQDnQMewwWqev6nO0Vfb+zkmjHh7DbUDE8EtWb52DYxiH4eB/u53
	 mfDWSDSI5ID3rjsUb3HV4BFDl0WvChQfgZggZVIcOktSuXnnm8ViIYjIxXqjFvz+AZ
	 NbC6BWH2QjKJg/tqyIGgB22IqVd9IOl5MiYbAqjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Cengiz Can <cengiz.can@canonical.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/172] wifi: nl80211: fix NL80211_ATTR_MLO_LINK_ID off-by-one
Date: Tue, 17 Dec 2024 18:07:19 +0100
Message-ID: <20241217170549.731118286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 2e3dbf938656986cce73ac4083500d0bcfbffe24 ]

Since the netlink attribute range validation provides inclusive
checking, the *max* of attribute NL80211_ATTR_MLO_LINK_ID should be
IEEE80211_MLD_MAX_NUM_LINKS - 1 otherwise causing an off-by-one.

One crash stack for demonstration:
==================================================================
BUG: KASAN: wild-memory-access in ieee80211_tx_control_port+0x3b6/0xca0 net/mac80211/tx.c:5939
Read of size 6 at addr 001102080000000c by task fuzzer.386/9508

CPU: 1 PID: 9508 Comm: syz.1.386 Not tainted 6.1.70 #2
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x177/0x231 lib/dump_stack.c:106
 print_report+0xe0/0x750 mm/kasan/report.c:398
 kasan_report+0x139/0x170 mm/kasan/report.c:495
 kasan_check_range+0x287/0x290 mm/kasan/generic.c:189
 memcpy+0x25/0x60 mm/kasan/shadow.c:65
 ieee80211_tx_control_port+0x3b6/0xca0 net/mac80211/tx.c:5939
 rdev_tx_control_port net/wireless/rdev-ops.h:761 [inline]
 nl80211_tx_control_port+0x7b3/0xc40 net/wireless/nl80211.c:15453
 genl_family_rcv_msg_doit+0x22e/0x320 net/netlink/genetlink.c:756
 genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
 genl_rcv_msg+0x539/0x740 net/netlink/genetlink.c:850
 netlink_rcv_skb+0x1de/0x420 net/netlink/af_netlink.c:2508
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:861
 netlink_unicast_kernel net/netlink/af_netlink.c:1326 [inline]
 netlink_unicast+0x74b/0x8c0 net/netlink/af_netlink.c:1352
 netlink_sendmsg+0x882/0xb90 net/netlink/af_netlink.c:1874
 sock_sendmsg_nosec net/socket.c:716 [inline]
 __sock_sendmsg net/socket.c:728 [inline]
 ____sys_sendmsg+0x5cc/0x8f0 net/socket.c:2499
 ___sys_sendmsg+0x21c/0x290 net/socket.c:2553
 __sys_sendmsg net/socket.c:2582 [inline]
 __do_sys_sendmsg net/socket.c:2591 [inline]
 __se_sys_sendmsg+0x19e/0x270 net/socket.c:2589
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x45/0x90 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Update the policy to ensure correct validation.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Suggested-by: Cengiz Can <cengiz.can@canonical.com>
Link: https://patch.msgid.link/20241130170526.96698-1-linma@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9b1b9dc5a7eb..1e78f575fb56 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -814,7 +814,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MLO_LINKS] =
 		NLA_POLICY_NESTED_ARRAY(nl80211_policy),
 	[NL80211_ATTR_MLO_LINK_ID] =
-		NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS),
+		NLA_POLICY_RANGE(NLA_U8, 0, IEEE80211_MLD_MAX_NUM_LINKS - 1),
 	[NL80211_ATTR_MLD_ADDR] = NLA_POLICY_EXACT_LEN(ETH_ALEN),
 	[NL80211_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MAX_NUM_AKM_SUITES] = { .type = NLA_REJECT },
-- 
2.39.5



