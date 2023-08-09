Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC38D17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1DFC433C7;
	Wed,  9 Aug 2023 11:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579243;
	bh=+4F+jbmnDb7dGt24n8kG/y50S1oILj5eCJueOyqEqKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuWDCiceY9sOgPQXoEwwakpRms8PujfFrGWhYIMYaXO0vgC8MBO/w1ZF9fC12piZz
	 y62CwqogQBy1dHp2y67+uAhvYE9BXlakkR6kESh8XJ41jMj/ufLp665/c7l2hLClS9
	 +n51vXEYGdoU9OGNlyvzmwe++YXQf9xMcv3JoUao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 126/204] can: bcm: Fix UAF in bcm_proc_show()
Date: Wed,  9 Aug 2023 12:41:04 +0200
Message-ID: <20230809103646.820800527@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

commit 55c3b96074f3f9b0aee19bf93cd71af7516582bb upstream.

BUG: KASAN: slab-use-after-free in bcm_proc_show+0x969/0xa80
Read of size 8 at addr ffff888155846230 by task cat/7862

CPU: 1 PID: 7862 Comm: cat Not tainted 6.5.0-rc1-00153-gc8746099c197 #230
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xd5/0x150
 print_report+0xc1/0x5e0
 kasan_report+0xba/0xf0
 bcm_proc_show+0x969/0xa80
 seq_read_iter+0x4f6/0x1260
 seq_read+0x165/0x210
 proc_reg_read+0x227/0x300
 vfs_read+0x1d5/0x8d0
 ksys_read+0x11e/0x240
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Allocated by task 7846:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x9e/0xa0
 bcm_sendmsg+0x264b/0x44e0
 sock_sendmsg+0xda/0x180
 ____sys_sendmsg+0x735/0x920
 ___sys_sendmsg+0x11d/0x1b0
 __sys_sendmsg+0xfa/0x1d0
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 7846:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x27/0x40
 ____kasan_slab_free+0x161/0x1c0
 slab_free_freelist_hook+0x119/0x220
 __kmem_cache_free+0xb4/0x2e0
 rcu_core+0x809/0x1bd0

bcm_op is freed before procfs entry be removed in bcm_release(),
this lead to bcm_proc_show() may read the freed bcm_op.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230715092543.15548-1-yuehaibing@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1572,6 +1572,12 @@ static int bcm_release(struct socket *so
 
 	lock_sock(sk);
 
+#if IS_ENABLED(CONFIG_PROC_FS)
+	/* remove procfs entry */
+	if (net->can.bcmproc_dir && bo->bcm_proc_read)
+		remove_proc_entry(bo->procname, net->can.bcmproc_dir);
+#endif /* CONFIG_PROC_FS */
+
 	list_for_each_entry_safe(op, next, &bo->tx_ops, list)
 		bcm_remove_op(op);
 
@@ -1607,12 +1613,6 @@ static int bcm_release(struct socket *so
 	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
 		bcm_remove_op(op);
 
-#if IS_ENABLED(CONFIG_PROC_FS)
-	/* remove procfs entry */
-	if (net->can.bcmproc_dir && bo->bcm_proc_read)
-		remove_proc_entry(bo->procname, net->can.bcmproc_dir);
-#endif /* CONFIG_PROC_FS */
-
 	/* remove device reference */
 	if (bo->bound) {
 		bo->bound   = 0;


