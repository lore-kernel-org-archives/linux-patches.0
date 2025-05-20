Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A66242D73;
	Tue, 20 May 2025 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750491; cv=none; b=mu84p1jKCO16b5bsUPoEW/NatwmojVVlCi4ef0ClNo50pWBs4sdUvwAxwaaO4FjQVBETjUGpxbhpvfieKkPzIWHOE0Ueuzve3mru1fjeKRAB/7FThbQSuaiwssFY2CUacwWhqiqpyz3QrWXHmAe4/oBVESx43yM+zsqqkNZsWfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750491; c=relaxed/simple;
	bh=QwLFgfIHAj0n9RQwMnygxsMpKc4yYv8dGu7FpEtyWHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0+aMeXut906+S8ghU0XQ0eUaCl24c+tXq3QoRJcZaU/IxwM1vAnasOIfamow4L6CwAgNZIzRL2RuHYTE123WHRsLidJpNCW32XJc+z0c+pjhwHSXyRMLeWZi7c/LnEEHLhWqGrlMBHZvrlLBreuZaGpK560L2gP6+vOoYON/h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmwIGSl9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmwIGSl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F03C4CEE9;
	Tue, 20 May 2025 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750491;
	bh=QwLFgfIHAj0n9RQwMnygxsMpKc4yYv8dGu7FpEtyWHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmwIGSl9xSWz6VJ3SWjswarqZAE4x2b06JjISqlpxYpt0i0rgGnpnO9WdyF18QQ8a
	 29YQvp/IzwBuES+HiAiuJ8wc0mgYzTVPkqc36WMJ5dBTPnKI0Vql3hpE9sk7owELtg
	 1CaL9Xe3kB+fzNKgrivff9AKa2i74pgrnfeUxN74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e2ce9e275ecc70a30b72@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 026/145] RDMA/core: Fix "KASAN: slab-use-after-free Read in ib_register_device" problem
Date: Tue, 20 May 2025 15:49:56 +0200
Message-ID: <20250520125811.582646954@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit d0706bfd3ee40923c001c6827b786a309e2a8713 ]

Call Trace:

 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xc3/0x670 mm/kasan/report.c:521
 kasan_report+0xe0/0x110 mm/kasan/report.c:634
 strlen+0x93/0xa0 lib/string.c:420
 __fortify_strlen include/linux/fortify-string.h:268 [inline]
 get_kobj_path_length lib/kobject.c:118 [inline]
 kobject_get_path+0x3f/0x2a0 lib/kobject.c:158
 kobject_uevent_env+0x289/0x1870 lib/kobject_uevent.c:545
 ib_register_device drivers/infiniband/core/device.c:1472 [inline]
 ib_register_device+0x8cf/0xe00 drivers/infiniband/core/device.c:1393
 rxe_register_device+0x275/0x320 drivers/infiniband/sw/rxe/rxe_verbs.c:1552
 rxe_net_add+0x8e/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:550
 rxe_newlink+0x70/0x190 drivers/infiniband/sw/rxe/rxe.c:225
 nldev_newlink+0x3a3/0x680 drivers/infiniband/core/nldev.c:1796
 rdma_nl_rcv_msg+0x387/0x6e0 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb.constprop.0.isra.0+0x2e5/0x450
 netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
 netlink_unicast+0x53a/0x7f0 net/netlink/af_netlink.c:1339
 netlink_sendmsg+0x8d1/0xdd0 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg net/socket.c:727 [inline]
 ____sys_sendmsg+0xa95/0xc70 net/socket.c:2566
 ___sys_sendmsg+0x134/0x1d0 net/socket.c:2620
 __sys_sendmsg+0x16d/0x220 net/socket.c:2652
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x260 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

This problem is similar to the problem that the
commit 1d6a9e7449e2 ("RDMA/core: Fix use-after-free when rename device name")
fixes.

The root cause is: the function ib_device_rename() renames the name with
lock. But in the function kobject_uevent(), this name is accessed without
lock protection at the same time.

The solution is to add the lock protection when this name is accessed in
the function kobject_uevent().

Fixes: 779e0bf47632 ("RDMA/core: Do not indicate device ready when device enablement fails")
Link: https://patch.msgid.link/r/20250506151008.75701-1-yanjun.zhu@linux.dev
Reported-by: syzbot+e2ce9e275ecc70a30b72@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e2ce9e275ecc70a30b72
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index ee75b99f84bcc..baf12e3e2a7ea 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1352,6 +1352,9 @@ static void ib_device_notify_register(struct ib_device *device)
 
 	down_read(&devices_rwsem);
 
+	/* Mark for userspace that device is ready */
+	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
+
 	ret = rdma_nl_notify_event(device, 0, RDMA_REGISTER_EVENT);
 	if (ret)
 		goto out;
@@ -1468,10 +1471,9 @@ int ib_register_device(struct ib_device *device, const char *name,
 		return ret;
 	}
 	dev_set_uevent_suppress(&device->dev, false);
-	/* Mark for userspace that device is ready */
-	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
 
 	ib_device_notify_register(device);
+
 	ib_device_put(device);
 
 	return 0;
-- 
2.39.5



