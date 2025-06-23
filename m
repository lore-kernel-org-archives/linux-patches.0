Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5E19E7F9;
	Mon, 23 Jun 2025 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717143; cv=none; b=D6iATIqMeMoy5nkaXMH/8kEGKL0BQUvTGlGYxdlpkox37knxxVz4NNrQaq7avKmBgWZ9rCiJNLqlp/SJ0cvBAwwKdNchEWPRCAC27/s3SbobxuWwNJnF2dInWxRkCrN7s0oIxZHEUJW7SBLNh2ncAYyZqwT4CikrHUhwY02GtMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717143; c=relaxed/simple;
	bh=uLwoo1ZBOftwbD7S1of6mE+1HG9USKbNX1PbcpyWLMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmDqMZzoZYeLrdC64n0kbQloDGCP3zcd+gs5Hb7Ua14Z5Q/k3tTvsQ4RLPmoZ/HpgphKWen/VtSIi1odHklb05tQElUjzF09ZBk7ZpcAeMePsamZ0N/ofJZaZy5Xq1bP6aJWTVgZ8Xda5w8XKsF7TS9vQbL7lRHLGW/kcGHUT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZDbOWK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZDbOWK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B8CC4CEEA;
	Mon, 23 Jun 2025 22:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717143;
	bh=uLwoo1ZBOftwbD7S1of6mE+1HG9USKbNX1PbcpyWLMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZDbOWK/RHHynVwhxddnoE5pPGK21FZT8+A86jhoN1Ec0HOmJuWZVQcYaa9r7aWO6
	 p4tAkZ3gC2VXhrbJmxsLpgTvvZO5v19byxTGLFxehBDAozE5TvCjMc/NTC8FbdNSWy
	 D+vsriymqMCRQnY3cFmjTAJHtQwpJ0A3FJLpMImE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+aaf0488c83d1d5f4f029@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 6.12 329/414] wifi: cfg80211: init wiphy_work before allocating rfkill fails
Date: Mon, 23 Jun 2025 15:07:46 +0200
Message-ID: <20250623130650.214262525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit fc88dee89d7b63eeb17699393eb659aadf9d9b7c upstream.

syzbort reported a uninitialize wiphy_work_lock in cfg80211_dev_free. [1]

After rfkill allocation fails, the wiphy release process will be performed,
which will cause cfg80211_dev_free to access the uninitialized wiphy_work
related data.

Move the initialization of wiphy_work to before rfkill initialization to
avoid this issue.

[1]
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5935 Comm: syz-executor550 Not tainted 6.14.0-rc6-syzkaller-00103-g4003c9e78778 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:983 [inline]
 register_lock_class+0xc39/0x1240 kernel/locking/lockdep.c:1297
 __lock_acquire+0x135/0x3c40 kernel/locking/lockdep.c:5103
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:162
 cfg80211_dev_free+0x30/0x3d0 net/wireless/core.c:1196
 device_release+0xa1/0x240 drivers/base/core.c:2568
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1e4/0x5a0 lib/kobject.c:737
 put_device+0x1f/0x30 drivers/base/core.c:3774
 wiphy_free net/wireless/core.c:1224 [inline]
 wiphy_new_nm+0x1c1f/0x2160 net/wireless/core.c:562
 ieee80211_alloc_hw_nm+0x1b7a/0x2260 net/mac80211/main.c:835
 mac80211_hwsim_new_radio+0x1d6/0x54e0 drivers/net/wireless/virtual/mac80211_hwsim.c:5185
 hwsim_new_radio_nl+0xb42/0x12b0 drivers/net/wireless/virtual/mac80211_hwsim.c:6242
 genl_family_rcv_msg_doit+0x202/0x2f0 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x565/0x800 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x16b/0x440 net/netlink/af_netlink.c:2533
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x53c/0x7f0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x8b8/0xd70 net/netlink/af_netlink.c:1882
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg net/socket.c:733 [inline]
 ____sys_sendmsg+0xaaf/0xc90 net/socket.c:2573
 ___sys_sendmsg+0x135/0x1e0 net/socket.c:2627
 __sys_sendmsg+0x16e/0x220 net/socket.c:2659
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83

Fixes: 72d520476a2f ("wifi: cfg80211: cancel wiphy_work before freeing wiphy")
Reported-by: syzbot+aaf0488c83d1d5f4f029@syzkaller.appspotmail.com
Close: https://syzkaller.appspot.com/bug?extid=aaf0488c83d1d5f4f029
Tested-by: syzbot+aaf0488c83d1d5f4f029@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://patch.msgid.link/tencent_258DD9121DDDB9DD9A1939CFAA0D8625B107@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -553,6 +553,9 @@ use_default_name:
 	INIT_WORK(&rdev->mgmt_registrations_update_wk,
 		  cfg80211_mgmt_registrations_update_wk);
 	spin_lock_init(&rdev->mgmt_registrations_lock);
+	INIT_WORK(&rdev->wiphy_work, cfg80211_wiphy_work);
+	INIT_LIST_HEAD(&rdev->wiphy_work_list);
+	spin_lock_init(&rdev->wiphy_work_lock);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -570,9 +573,6 @@ use_default_name:
 		return NULL;
 	}
 
-	INIT_WORK(&rdev->wiphy_work, cfg80211_wiphy_work);
-	INIT_LIST_HEAD(&rdev->wiphy_work_list);
-	spin_lock_init(&rdev->wiphy_work_lock);
 	INIT_WORK(&rdev->rfkill_block, cfg80211_rfkill_block_work);
 	INIT_WORK(&rdev->conn_work, cfg80211_conn_work);
 	INIT_WORK(&rdev->event_work, cfg80211_event_work);


