Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA6A1DF24B;
	Wed,  6 Nov 2024 12:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895909; cv=none; b=jQqDng84RPCCyeP/5Xge+ItDwCQyJBGV62qI3jp5nKziYiV3/uZvVpByQNj3HklCvBwXpgqeWvq7pvpC7DlbwkK2pwLQbk39aqYvXyX+XUQIm4HxtGG8loSbTJCAFMDqrQ4Zb+1L9Md0uYCx4Sd4iIYUSOTAnmfaP++bMUqL2i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895909; c=relaxed/simple;
	bh=nEW9zqlrAYgYRF/YPpkIBQVYVVGAtL0TAWbxZEn+4Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkKighlOkm5PKJRKi5STOvn7IU9KmOZXUOpNJgzrG/EsSZ0A22aiVnIxtXQ68NfcgvxOBsr8arlD8OwO1+6Sbirz0WYZgrFatgJDkSY6OSZDP8xZXZEWYiHttdeJtoJZRW3PNXdQ1Wl0JTHAZmKazT6riNQHehn8OrjJg6VlEUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1nmDR4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1nmDR4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9D8C4CED3;
	Wed,  6 Nov 2024 12:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895909;
	bh=nEW9zqlrAYgYRF/YPpkIBQVYVVGAtL0TAWbxZEn+4Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1nmDR4FL6wXsDSiUkdbqbLpZAix0vU+k0p1utXr+E2LATOYGT8hsPf/4bYFy82Y9
	 223uuHFk1R9g2mZf21ePtH6vDw5NTPpCBTM+qy4AeS1E1XAvNZ7mkEQVfIGP7FL+XX
	 g//0WnXKon3bRY0XIIwG80tppziRlNMnZbICzV9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Chris Mi <cmi@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/245] macsec: Fix use-after-free while sending the offloading packet
Date: Wed,  6 Nov 2024 13:01:18 +0100
Message-ID: <20241106120319.852168563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit f1e54d11b210b53d418ff1476c6b58a2f434dfc0 ]

KASAN reports the following UAF. The metadata_dst, which is used to
store the SCI value for macsec offload, is already freed by
metadata_dst_free() in macsec_free_netdev(), while driver still use it
for sending the packet.

To fix this issue, dst_release() is used instead to release
metadata_dst. So it is not freed instantly in macsec_free_netdev() if
still referenced by skb.

 BUG: KASAN: slab-use-after-free in mlx5e_xmit+0x1e8f/0x4190 [mlx5_core]
 Read of size 2 at addr ffff88813e42e038 by task kworker/7:2/714
 [...]
 Workqueue: mld mld_ifc_work
 Call Trace:
  <TASK>
  dump_stack_lvl+0x51/0x60
  print_report+0xc1/0x600
  kasan_report+0xab/0xe0
  mlx5e_xmit+0x1e8f/0x4190 [mlx5_core]
  dev_hard_start_xmit+0x120/0x530
  sch_direct_xmit+0x149/0x11e0
  __qdisc_run+0x3ad/0x1730
  __dev_queue_xmit+0x1196/0x2ed0
  vlan_dev_hard_start_xmit+0x32e/0x510 [8021q]
  dev_hard_start_xmit+0x120/0x530
  __dev_queue_xmit+0x14a7/0x2ed0
  macsec_start_xmit+0x13e9/0x2340
  dev_hard_start_xmit+0x120/0x530
  __dev_queue_xmit+0x14a7/0x2ed0
  ip6_finish_output2+0x923/0x1a70
  ip6_finish_output+0x2d7/0x970
  ip6_output+0x1ce/0x3a0
  NF_HOOK.constprop.0+0x15f/0x190
  mld_sendpack+0x59a/0xbd0
  mld_ifc_work+0x48a/0xa80
  process_one_work+0x5aa/0xe50
  worker_thread+0x79c/0x1290
  kthread+0x28f/0x350
  ret_from_fork+0x2d/0x70
  ret_from_fork_asm+0x11/0x20
  </TASK>

 Allocated by task 3922:
  kasan_save_stack+0x20/0x40
  kasan_save_track+0x10/0x30
  __kasan_kmalloc+0x77/0x90
  __kmalloc_noprof+0x188/0x400
  metadata_dst_alloc+0x1f/0x4e0
  macsec_newlink+0x914/0x1410
  __rtnl_newlink+0xe08/0x15b0
  rtnl_newlink+0x5f/0x90
  rtnetlink_rcv_msg+0x667/0xa80
  netlink_rcv_skb+0x12c/0x360
  netlink_unicast+0x551/0x770
  netlink_sendmsg+0x72d/0xbd0
  __sock_sendmsg+0xc5/0x190
  ____sys_sendmsg+0x52e/0x6a0
  ___sys_sendmsg+0xeb/0x170
  __sys_sendmsg+0xb5/0x140
  do_syscall_64+0x4c/0x100
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

 Freed by task 4011:
  kasan_save_stack+0x20/0x40
  kasan_save_track+0x10/0x30
  kasan_save_free_info+0x37/0x50
  poison_slab_object+0x10c/0x190
  __kasan_slab_free+0x11/0x30
  kfree+0xe0/0x290
  macsec_free_netdev+0x3f/0x140
  netdev_run_todo+0x450/0xc70
  rtnetlink_rcv_msg+0x66f/0xa80
  netlink_rcv_skb+0x12c/0x360
  netlink_unicast+0x551/0x770
  netlink_sendmsg+0x72d/0xbd0
  __sock_sendmsg+0xc5/0x190
  ____sys_sendmsg+0x52e/0x6a0
  ___sys_sendmsg+0xeb/0x170
  __sys_sendmsg+0xb5/0x140
  do_syscall_64+0x4c/0x100
  entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path support")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20241021100309.234125-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 2a31d09d43ed4..edee2870f62ab 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3798,8 +3798,7 @@ static void macsec_free_netdev(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 
-	if (macsec->secy.tx_sc.md_dst)
-		metadata_dst_free(macsec->secy.tx_sc.md_dst);
+	dst_release(&macsec->secy.tx_sc.md_dst->dst);
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
-- 
2.43.0



