Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AAC5674D;
	Tue, 10 Sep 2024 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964709; cv=none; b=heuDwUiY2WOzWC15gPJL+xHn3Ciwq3J0do6lzCXq8QSJFt/L2PmvPHKqpTmObq2xvjOqM16Qh0Z067BJGIAzNmKcFgHJQYZJrc2fi80ZFkn85CWGMsAAAePvCgdEj44XTNQClCkhZlVftEDyTnLnI6uMavmTCjyHbIDAVYs5Ev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964709; c=relaxed/simple;
	bh=w9AEbesQOaCnL9F76GoMzc4yBmDwbOVDvm8QOv+B7yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u405oHaoJepJFurYEsUXq4/9aQzYRsr6DegolCO1SJ60Jt+0AtMqv2rP9FRM3MUG6uFUha3j2ymMug8m8zO/1PBKzzpbGI1WipEqihIThs/rSUAlxRfGU8RqTI6YD1QFOs3CVW2hEYHDhb/pumTGNXJY4PkBPKrxC2ayxOwwYhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOkL7FzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOkL7FzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F4AC4CEC3;
	Tue, 10 Sep 2024 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964709;
	bh=w9AEbesQOaCnL9F76GoMzc4yBmDwbOVDvm8QOv+B7yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOkL7FzOQd0mWpAi2SzwVizrLohiuVRBnKuqsKSxRTIi4SRLDEWTL1pcnCVeVMh3j
	 u3G76XfGQWnYSJ6QWN0dm6P8w51jiohQ6zyhDkNfzempi/ZhBkL9N8MuzBn6GPrZRA
	 v4/Ol5wa4ZdpclPld5rCLdQE6P9H79oTLjUZD0xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 267/269] Bluetooth: hci_sync: Fix UAF in hci_acl_create_conn_sync
Date: Tue, 10 Sep 2024 11:34:14 +0200
Message-ID: <20240910092617.251247560@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 3d1c16e920c88eb5e583e1b4a10b95a5dc97ec22 upstream.

This fixes the following error caused by hci_conn being freed while
hcy_acl_create_conn_sync is pending:

==================================================================
BUG: KASAN: slab-use-after-free in hci_acl_create_conn_sync+0xa7/0x2e0
Write of size 2 at addr ffff888002ae0036 by task kworker/u3:0/848

CPU: 0 PID: 848 Comm: kworker/u3:0 Not tainted 6.8.0-rc6-g2ab3e8d67fc1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-1.fc38
04/01/2014
Workqueue: hci0 hci_cmd_sync_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x21/0x70
 print_report+0xce/0x620
 ? preempt_count_sub+0x13/0xc0
 ? __virt_addr_valid+0x15f/0x310
 ? hci_acl_create_conn_sync+0xa7/0x2e0
 kasan_report+0xdf/0x110
 ? hci_acl_create_conn_sync+0xa7/0x2e0
 hci_acl_create_conn_sync+0xa7/0x2e0
 ? __pfx_hci_acl_create_conn_sync+0x10/0x10
 ? __pfx_lock_release+0x10/0x10
 ? __pfx_hci_acl_create_conn_sync+0x10/0x10
 hci_cmd_sync_work+0x138/0x1c0
 process_one_work+0x405/0x800
 ? __pfx_lock_acquire+0x10/0x10
 ? __pfx_process_one_work+0x10/0x10
 worker_thread+0x37b/0x670
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x19b/0x1e0
 ? kthread+0xfe/0x1e0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2f/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 847:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x8f/0xa0
 hci_conn_add+0xc6/0x970
 hci_connect_acl+0x309/0x410
 pair_device+0x4fb/0x710
 hci_sock_sendmsg+0x933/0xef0
 sock_write_iter+0x2c3/0x2d0
 do_iter_readv_writev+0x21a/0x2e0
 vfs_writev+0x21c/0x7b0
 do_writev+0x14a/0x180
 do_syscall_64+0x77/0x150
 entry_SYSCALL_64_after_hwframe+0x6c/0x74

Freed by task 847:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0xfa/0x150
 kfree+0xcb/0x250
 device_release+0x58/0xf0
 kobject_put+0xbb/0x160
 hci_conn_del+0x281/0x570
 hci_conn_hash_flush+0xfc/0x130
 hci_dev_close_sync+0x336/0x960
 hci_dev_close+0x10e/0x140
 hci_sock_ioctl+0x14a/0x5c0
 sock_ioctl+0x58a/0x5d0
 __x64_sys_ioctl+0x480/0xf60
 do_syscall_64+0x77/0x150
 entry_SYSCALL_64_after_hwframe+0x6c/0x74

Fixes: 45340097ce6e ("Bluetooth: hci_conn: Only do ACL connections sequentially")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6748,6 +6748,9 @@ static int hci_acl_create_conn_sync(stru
 	struct hci_cp_create_conn cp;
 	int err;
 
+	if (!hci_conn_valid(hdev, conn))
+		return -ECANCELED;
+
 	/* Many controllers disallow HCI Create Connection while it is doing
 	 * HCI Inquiry. So we cancel the Inquiry first before issuing HCI Create
 	 * Connection. This may cause the MGMT discovering state to become false


