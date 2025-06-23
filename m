Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA074409;
	Mon, 23 Jun 2025 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716027; cv=none; b=c/6uwR3N42svCBwOdtP4abyQ2xFpnGLYDe37EVLPL+pnBBgNb9motupgyd9zzpISj+/CWH14ltZLE5KgNHG+9v6Lcxws9YeCicVUs/zt2Mm+MOQhgzY2bN+TqRGdIU4zoeJHca2EP5yn4Xl+k/Oq/dGKF0Too5RBohLeCnRjjag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716027; c=relaxed/simple;
	bh=oUOIvAwwKSWrNgM+JbGFlPdVQA/cs47Foo4RfZs2k/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMiKTryIWmDXyGDccYWo0j8WT2wlV/hhbbczU/A3DCKzYGRt32c7351Foos3oFIgzygC6voIA8S4kv5G9yJyUO5qDGLYu3NRVozJwtvv3LjzlI0TjvnLgTE7fugIpPvY44ojOijzdpIDTTCc23xdsEFgF5ZLdpTvnFEyux2VP8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sG2KCgxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sG2KCgxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88340C4CEEA;
	Mon, 23 Jun 2025 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716026;
	bh=oUOIvAwwKSWrNgM+JbGFlPdVQA/cs47Foo4RfZs2k/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sG2KCgxMsryo3c6zIrXOoRcSO0eeE5CuH0isCUQ0Pw0fiTr1VxrPUT68kcjpzjyWx
	 lzahEQYtsEmA6B7S2iIbQvppBJxxwLYbdRMIC6pTZBnWEi8EHoHzGOmWxIMwAURrQE
	 7BmvEPE21VKnCtcf5gBT60cNP67OJrCG4POfw8ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b64dec3affaed7b3af5@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/355] net: atm: add lec_mutex
Date: Mon, 23 Jun 2025 15:08:37 +0200
Message-ID: <20250623130636.271446689@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

[ Upstream commit d13a3824bfd2b4774b671a75cf766a16637a0e67 ]

syzbot found its way in net/atm/lec.c, and found an error path
in lecd_attach() could leave a dangling pointer in dev_lec[].

Add a mutex to protect dev_lecp[] uses from lecd_attach(),
lec_vcc_attach() and lec_mcast_attach().

Following patch will use this mutex for /proc/net/atm/lec.

BUG: KASAN: slab-use-after-free in lecd_attach net/atm/lec.c:751 [inline]
BUG: KASAN: slab-use-after-free in lane_ioctl+0x2224/0x23e0 net/atm/lec.c:1008
Read of size 8 at addr ffff88807c7b8e68 by task syz.1.17/6142

CPU: 1 UID: 0 PID: 6142 Comm: syz.1.17 Not tainted 6.16.0-rc1-syzkaller-00239-g08215f5486ec #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:408 [inline]
  print_report+0xcd/0x680 mm/kasan/report.c:521
  kasan_report+0xe0/0x110 mm/kasan/report.c:634
  lecd_attach net/atm/lec.c:751 [inline]
  lane_ioctl+0x2224/0x23e0 net/atm/lec.c:1008
  do_vcc_ioctl+0x12c/0x930 net/atm/ioctl.c:159
  sock_do_ioctl+0x118/0x280 net/socket.c:1190
  sock_ioctl+0x227/0x6b0 net/socket.c:1311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl fs/ioctl.c:893 [inline]
  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 6132:
  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
  __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
  kasan_kmalloc include/linux/kasan.h:260 [inline]
  __do_kmalloc_node mm/slub.c:4328 [inline]
  __kvmalloc_node_noprof+0x27b/0x620 mm/slub.c:5015
  alloc_netdev_mqs+0xd2/0x1570 net/core/dev.c:11711
  lecd_attach net/atm/lec.c:737 [inline]
  lane_ioctl+0x17db/0x23e0 net/atm/lec.c:1008
  do_vcc_ioctl+0x12c/0x930 net/atm/ioctl.c:159
  sock_do_ioctl+0x118/0x280 net/socket.c:1190
  sock_ioctl+0x227/0x6b0 net/socket.c:1311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl fs/ioctl.c:893 [inline]
  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6132:
  kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
  kasan_save_track+0x14/0x30 mm/kasan/common.c:68
  kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
  poison_slab_object mm/kasan/common.c:247 [inline]
  __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
  kasan_slab_free include/linux/kasan.h:233 [inline]
  slab_free_hook mm/slub.c:2381 [inline]
  slab_free mm/slub.c:4643 [inline]
  kfree+0x2b4/0x4d0 mm/slub.c:4842
  free_netdev+0x6c5/0x910 net/core/dev.c:11892
  lecd_attach net/atm/lec.c:744 [inline]
  lane_ioctl+0x1ce8/0x23e0 net/atm/lec.c:1008
  do_vcc_ioctl+0x12c/0x930 net/atm/ioctl.c:159
  sock_do_ioctl+0x118/0x280 net/socket.c:1190
  sock_ioctl+0x227/0x6b0 net/socket.c:1311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:907 [inline]
  __se_sys_ioctl fs/ioctl.c:893 [inline]
  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+8b64dec3affaed7b3af5@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6852c6f6.050a0220.216029.0018.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250618140844.1686882-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index ca9952c52fb5c..3f67b84c8f1c9 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -124,6 +124,7 @@ static unsigned char bus_mac[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 /* Device structures */
 static struct net_device *dev_lec[MAX_LEC_ITF];
+static DEFINE_MUTEX(lec_mutex);
 
 #if IS_ENABLED(CONFIG_BRIDGE)
 static void lec_handle_bridge(struct sk_buff *skb, struct net_device *dev)
@@ -687,6 +688,7 @@ static int lec_vcc_attach(struct atm_vcc *vcc, void __user *arg)
 	int bytes_left;
 	struct atmlec_ioc ioc_data;
 
+	lockdep_assert_held(&lec_mutex);
 	/* Lecd must be up in this case */
 	bytes_left = copy_from_user(&ioc_data, arg, sizeof(struct atmlec_ioc));
 	if (bytes_left != 0)
@@ -712,6 +714,7 @@ static int lec_vcc_attach(struct atm_vcc *vcc, void __user *arg)
 
 static int lec_mcast_attach(struct atm_vcc *vcc, int arg)
 {
+	lockdep_assert_held(&lec_mutex);
 	if (arg < 0 || arg >= MAX_LEC_ITF)
 		return -EINVAL;
 	arg = array_index_nospec(arg, MAX_LEC_ITF);
@@ -727,6 +730,7 @@ static int lecd_attach(struct atm_vcc *vcc, int arg)
 	int i;
 	struct lec_priv *priv;
 
+	lockdep_assert_held(&lec_mutex);
 	if (arg < 0)
 		arg = 0;
 	if (arg >= MAX_LEC_ITF)
@@ -744,6 +748,7 @@ static int lecd_attach(struct atm_vcc *vcc, int arg)
 		snprintf(dev_lec[i]->name, IFNAMSIZ, "lec%d", i);
 		if (register_netdev(dev_lec[i])) {
 			free_netdev(dev_lec[i]);
+			dev_lec[i] = NULL;
 			return -EINVAL;
 		}
 
@@ -1005,6 +1010,7 @@ static int lane_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 	}
 
+	mutex_lock(&lec_mutex);
 	switch (cmd) {
 	case ATMLEC_CTRL:
 		err = lecd_attach(vcc, (int)arg);
@@ -1019,6 +1025,7 @@ static int lane_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
+	mutex_unlock(&lec_mutex);
 	return err;
 }
 
-- 
2.39.5



