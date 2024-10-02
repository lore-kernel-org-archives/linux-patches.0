Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4E21D0946;
	Wed,  2 Oct 2024 13:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876512; cv=none; b=fQ5LI1QGzJFxM440S5imgaeWWiHLSSjCYo1GwaXnz87Rfj0g5mLFNltUj8eJN729FsOqLc6hDu/1Ybl5e0T63Y4dLPX4xNoM19XxYVkI4+WyqUn5OXZaW9PMYG+Y/ggLdQg5vT6fsS/4+mE2+LEwnHnLBvTGMJSSvlYvBwM82ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876512; c=relaxed/simple;
	bh=O2ZpCM3bYPlOiboYMyMJpqrocah2nBjOpkcJJV0E/t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayTxhVF5vwq4lwL+F20an8BBREjw7jATp446OdspQKnit0YjDjBq8mYNS538oJSHHk0AAqOYwaNkIZHIdxi8HmVnxlHWt4RegcUSNL05Lxt5SsnHqXLFFYw5RZjlKIt0uksC54qK+qJ2Pw7oaE6E/uoCTKgPBdUb6sv/hLzL1ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJvpkNo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJvpkNo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE91C4CECD;
	Wed,  2 Oct 2024 13:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876512;
	bh=O2ZpCM3bYPlOiboYMyMJpqrocah2nBjOpkcJJV0E/t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJvpkNo6UOXcbaPDak4A/E1dlunkQ9v194qgEzfVEngsx+VLB1uEX7Q2vzbL4kFQB
	 ayQWw5s5EWJzZLXE1f1EeJNgG1sv1k8IpC5w9E7mU0cAqPOeGrBbaQrWQDT9xubcQa
	 jP8Vw9pmpkDDX3c0O8+vtKMS3rBr3z0rtuHgCBic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 470/695] vdpa/mlx5: Fix invalid mr resource destroy
Date: Wed,  2 Oct 2024 14:57:48 +0200
Message-ID: <20241002125841.235748081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit dc12502905b7a3de9097ea6b98870470c2921e09 ]

Certain error paths from mlx5_vdpa_dev_add() can end up releasing mr
resources which never got initialized in the first place.

This patch adds the missing check in mlx5_vdpa_destroy_mr_resources()
to block releasing non-initialized mr resources.

Reference trace:

  mlx5_core 0000:08:00.2: mlx5_vdpa_dev_add:3274:(pid 2700) warning: No mac address provisioned?
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 140216067 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 8 PID: 2700 Comm: vdpa Kdump: loaded Not tainted 5.14.0-496.el9.x86_64 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  RIP: 0010:vhost_iotlb_del_range+0xf/0xe0 [vhost_iotlb]
  Code: [...]
  RSP: 0018:ff1c823ac23077f0 EFLAGS: 00010246
  RAX: ffffffffc1a21a60 RBX: ffffffff899567a0 RCX: 0000000000000000
  RDX: ffffffffffffffff RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ff1bda1f7c21e800 R08: 0000000000000000 R09: ff1c823ac2307670
  R10: ff1c823ac2307668 R11: ffffffff8a9e7b68 R12: 0000000000000000
  R13: 0000000000000000 R14: ff1bda1f43e341a0 R15: 00000000ffffffea
  FS:  00007f56eba7c740(0000) GS:ff1bda269f800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000104d90001 CR4: 0000000000771ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:

   ? show_trace_log_lvl+0x1c4/0x2df
   ? show_trace_log_lvl+0x1c4/0x2df
   ? mlx5_vdpa_free+0x3d/0x150 [mlx5_vdpa]
   ? __die_body.cold+0x8/0xd
   ? page_fault_oops+0x134/0x170
   ? __irq_work_queue_local+0x2b/0xc0
   ? irq_work_queue+0x2c/0x50
   ? exc_page_fault+0x62/0x150
   ? asm_exc_page_fault+0x22/0x30
   ? __pfx_mlx5_vdpa_free+0x10/0x10 [mlx5_vdpa]
   ? vhost_iotlb_del_range+0xf/0xe0 [vhost_iotlb]
   mlx5_vdpa_free+0x3d/0x150 [mlx5_vdpa]
   vdpa_release_dev+0x1e/0x50 [vdpa]
   device_release+0x31/0x90
   kobject_cleanup+0x37/0x130
   mlx5_vdpa_dev_add+0x2d2/0x7a0 [mlx5_vdpa]
   vdpa_nl_cmd_dev_add_set_doit+0x277/0x4c0 [vdpa]
   genl_family_rcv_msg_doit+0xd9/0x130
   genl_family_rcv_msg+0x14d/0x220
   ? __pfx_vdpa_nl_cmd_dev_add_set_doit+0x10/0x10 [vdpa]
   ? _copy_to_user+0x1a/0x30
   ? move_addr_to_user+0x4b/0xe0
   genl_rcv_msg+0x47/0xa0
   ? __import_iovec+0x46/0x150
   ? __pfx_genl_rcv_msg+0x10/0x10
   netlink_rcv_skb+0x54/0x100
   genl_rcv+0x24/0x40
   netlink_unicast+0x245/0x370
   netlink_sendmsg+0x206/0x440
   __sys_sendto+0x1dc/0x1f0
   ? do_read_fault+0x10c/0x1d0
   ? do_pte_missing+0x10d/0x190
   __x64_sys_sendto+0x20/0x30
   do_syscall_64+0x5c/0xf0
   ? __count_memcg_events+0x4f/0xb0
   ? mm_account_fault+0x6c/0x100
   ? handle_mm_fault+0x116/0x270
   ? do_user_addr_fault+0x1d6/0x6a0
   ? do_syscall_64+0x6b/0xf0
   ? clear_bhb_loop+0x25/0x80
   ? clear_bhb_loop+0x25/0x80
   ? clear_bhb_loop+0x25/0x80
   ? clear_bhb_loop+0x25/0x80
   ? clear_bhb_loop+0x25/0x80
   entry_SYSCALL_64_after_hwframe+0x78/0x80

Fixes: 512c0cdd80c1 ("vdpa/mlx5: Decouple cvq iotlb handling from hw mapping code")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Message-Id: <20240827160808.2448017-2-dtatulea@nvidia.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/core/mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 4758914ccf860..bf56f3d696253 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -581,6 +581,9 @@ static void mlx5_vdpa_show_mr_leaks(struct mlx5_vdpa_dev *mvdev)
 
 void mlx5_vdpa_destroy_mr_resources(struct mlx5_vdpa_dev *mvdev)
 {
+	if (!mvdev->res.valid)
+		return;
+
 	for (int i = 0; i < MLX5_VDPA_NUM_AS; i++)
 		mlx5_vdpa_update_mr(mvdev, NULL, i);
 
-- 
2.43.0



