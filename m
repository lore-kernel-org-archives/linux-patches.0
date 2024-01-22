Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C51141981;
	Tue, 23 Jan 2024 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972047; cv=none; b=FVojpnKgnp50a3J895OuR0QJO3hMu3IndvUqVxO8RknYLM4oHIkBuJYpUOhORASyGSKXzxNKo/aaZxhwe1iA3Bev0UIU/iK2BkcsarIYNMdXUFvuoG2Isx16NibnN6/fe/hPmWejOq0X22FXljIKKt0dN0edCSUcefT0mI1+ZA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972047; c=relaxed/simple;
	bh=feedNJJEGr0ZPU+AX+iQQ8s4WD3cbZfiNu3W568gQK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/MaxKgGEVKd0fLmAyDLhZHqHHa84wOtmliAo3g8o6G1kCAvKlYM84a5hhqf6Jti5nf/9giQwZFKfsdhzD9fFWX+qn2ZrUeWU2wqAgwIIUnFG1pKktYB8O45kX2KbIB7yxN0SqywJgwZXDFd2lblNmiPwf+OxPOwFYovhpQD0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YseHda8V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YseHda8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F38DC433F1;
	Tue, 23 Jan 2024 01:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972047;
	bh=feedNJJEGr0ZPU+AX+iQQ8s4WD3cbZfiNu3W568gQK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YseHda8V7nVYI1u/dKcH68ZtDByK2/h6ie5ubKKhTANiJ3lOHNrxmHzatboq/bxKL
	 xODXGlv4s3g0GR0KnzdoEJks1qrbrOIc75bhq73gdro+fFhajdHU0qPRF3Rrysc0jB
	 3hyWcmG8eGYrBEIc9GVo9I/WxFqSI5Thmgt0Ng4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9400cabb1d784e49abf@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/417] ipv6: mcast: fix data-race in ipv6_mc_down / mld_ifc_work
Date: Mon, 22 Jan 2024 15:59:41 -0800
Message-ID: <20240122235805.995298290@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 2e7ef287f07c74985f1bf2858bedc62bd9ebf155 ]

idev->mc_ifc_count can be written over without proper locking.

Originally found by syzbot [1], fix this issue by encapsulating calls
to mld_ifc_stop_work() (and mld_gq_stop_work() for good measure) with
mutex_lock() and mutex_unlock() accordingly as these functions
should only be called with mc_lock per their declarations.

[1]
BUG: KCSAN: data-race in ipv6_mc_down / mld_ifc_work

write to 0xffff88813a80c832 of 1 bytes by task 3771 on cpu 0:
 mld_ifc_stop_work net/ipv6/mcast.c:1080 [inline]
 ipv6_mc_down+0x10a/0x280 net/ipv6/mcast.c:2725
 addrconf_ifdown+0xe32/0xf10 net/ipv6/addrconf.c:3949
 addrconf_notify+0x310/0x980
 notifier_call_chain kernel/notifier.c:93 [inline]
 raw_notifier_call_chain+0x6b/0x1c0 kernel/notifier.c:461
 __dev_notify_flags+0x205/0x3d0
 dev_change_flags+0xab/0xd0 net/core/dev.c:8685
 do_setlink+0x9f6/0x2430 net/core/rtnetlink.c:2916
 rtnl_group_changelink net/core/rtnetlink.c:3458 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3717 [inline]
 rtnl_newlink+0xbb3/0x1670 net/core/rtnetlink.c:3754
 rtnetlink_rcv_msg+0x807/0x8c0 net/core/rtnetlink.c:6558
 netlink_rcv_skb+0x126/0x220 net/netlink/af_netlink.c:2545
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:6576
 netlink_unicast_kernel net/netlink/af_netlink.c:1342 [inline]
 netlink_unicast+0x589/0x650 net/netlink/af_netlink.c:1368
 netlink_sendmsg+0x66e/0x770 net/netlink/af_netlink.c:1910
 ...

write to 0xffff88813a80c832 of 1 bytes by task 22 on cpu 1:
 mld_ifc_work+0x54c/0x7b0 net/ipv6/mcast.c:2653
 process_one_work kernel/workqueue.c:2627 [inline]
 process_scheduled_works+0x5b8/0xa30 kernel/workqueue.c:2700
 worker_thread+0x525/0x730 kernel/workqueue.c:2781
 ...

Fixes: 2d9a93b4902b ("mld: convert from timer to delayed work")
Reported-by: syzbot+a9400cabb1d784e49abf@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000994e09060ebcdffb@google.com/
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Acked-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240117172102.12001-1-n.zhandarovich@fintech.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7860383295d8..566f3b7b957e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2725,8 +2725,12 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	synchronize_net();
 	mld_query_stop_work(idev);
 	mld_report_stop_work(idev);
+
+	mutex_lock(&idev->mc_lock);
 	mld_ifc_stop_work(idev);
 	mld_gq_stop_work(idev);
+	mutex_unlock(&idev->mc_lock);
+
 	mld_dad_stop_work(idev);
 }
 
-- 
2.43.0



