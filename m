Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA651403EA1;
	Tue, 21 Jul 2026 23:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674850; cv=none; b=VSYxrla30YiWNLHIpWZzI8tl9KMFlM4G8RV9mXW5ex52t7SaC7Gt+1flUG4IwThA/wQLkvWS149hY1lvwLvZ3BSbcGnH2gLsSglZHb968GsPwcrlcg4GohMTkBeTtBmiYVh9PU8yYXihgRozh8sUHw4Yp6Wd6kqc1EG9y7pphco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674850; c=relaxed/simple;
	bh=RAKtnLvW6vZ2Mw4ZrQWqInEdwW4+9HIWVbLHMRMd2EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZh4zcYV9izVk5ZlW7+PBPqfSKeVERZzQQc8+zrxHzq+DKuO4tdhzFe4K2neEXnHmO+IGBa7q3BMh5+VJc4FIM6ftu855ny9VfYjEZonbSzEZtOxfEeWjTvVmYfXI9ss8PB95LLxWglinXfmOr54bzNw/yS6znpOPTkMFoSxVjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVW8GR1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVW8GR1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217DC1F000E9;
	Tue, 21 Jul 2026 23:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674849;
	bh=3+ir1ffahwvp76+Qo+u1ZoO8ejnNPxvIEcjopnetyaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVW8GR1J+AFI2cdQBOj4rExXpFtFsELZ6KYUnVp1BsxlBGXUALYrbyWhqUMtxwc5A
	 tLgEmgRMDJM2ylHafaGAP6E9rEe0jm1ntjN0LEZlEkrDWi+wKIGDP74KP6ikaX37rX
	 tNTljx3QlD4VVEX0F8BBPHqWFgx8wnr7VjnMdN1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a9400cabb1d784e49abf@syzkaller.appspotmail.com,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Taehee Yoo <ap420073@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 697/699] ipv6: mcast: fix data-race in ipv6_mc_down / mld_ifc_work
Date: Tue, 21 Jul 2026 17:27:36 +0200
Message-ID: <20260721152411.501575851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 2e7ef287f07c74985f1bf2858bedc62bd9ebf155 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2754,8 +2754,12 @@ void ipv6_mc_down(struct inet6_dev *idev
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
 


