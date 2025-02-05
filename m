Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADA817C79;
	Wed,  5 Feb 2025 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768195; cv=none; b=iO3kfrIB/0juOdgl6yWatfhdNr84kxfpux+1FkFSVIbTp2WMKOer02UgF7ffk4vTJwlTCd9NXR6DdVIOpA74vpdwECnDK9W5Z6eNBGMvNwf/+tqExt6uZO/7mOdbI3UphWwtgrmBYIOzq8CgQK7n+z3towsY8Bsr/RahahCukjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768195; c=relaxed/simple;
	bh=YUuKCDLhxLP5Pbci10U+hwsWofp6p5WSv5LexlVmkBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2uIHWKvVK4HrduZTsXfeKpWnFebkGLbSZNFap178kkYbWGqU2YUvy6nRWTeiBtJulhgwxJPF8G15n/IpSvlc2jK7Xl4mheGn/LKculIkX06ERIUkJ63ea3vIq4Uk3S/OiHm10FLrvpw+J0KRxSsUwxYt6NFHpLC/zRYQJhrqBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6p/g6pE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6p/g6pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C669C4CEDD;
	Wed,  5 Feb 2025 15:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768195;
	bh=YUuKCDLhxLP5Pbci10U+hwsWofp6p5WSv5LexlVmkBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6p/g6pEUpxFeglQhkCzypF/Pvl3tkvvuyxmamkh4GZbSSpnTfMe1GmcnhKDjvxsb
	 odY9ScuktHfx50br2fAf9PPJUuRaoOvkCSs2torhEIWUAS2w8iy5/QHiFzA0KpxKsz
	 bOijPCXiOfpiF9hh+JwJjoGQBPBCucWlL+tinIDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 566/590] RDMA/mlx5: Fix implicit ODP use after free
Date: Wed,  5 Feb 2025 14:45:21 +0100
Message-ID: <20250205134516.920691324@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Patrisious Haddad <phaddad@nvidia.com>

commit d3d930411ce390e532470194296658a960887773 upstream.

Prevent double queueing of implicit ODP mr destroy work by using
__xa_cmpxchg() to make sure this is the only time we are destroying this
specific mr.

Without this change, we could try to invalidate this mr twice, which in
turn could result in queuing a MR work destroy twice, and eventually the
second work could execute after the MR was freed due to the first work,
causing a user after free and trace below.

   refcount_t: underflow; use-after-free.
   WARNING: CPU: 2 PID: 12178 at lib/refcount.c:28 refcount_warn_saturate+0x12b/0x130
   Modules linked in: bonding ib_ipoib vfio_pci ip_gre geneve nf_tables ip6_gre gre ip6_tunnel tunnel6 ipip tunnel4 ib_umad rdma_ucm mlx5_vfio_pci vfio_pci_core vfio_iommu_type1 mlx5_ib vfio ib_uverbs mlx5_core iptable_raw openvswitch nsh rpcrdma ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay zram zsmalloc fuse [last unloaded: ib_uverbs]
   CPU: 2 PID: 12178 Comm: kworker/u20:5 Not tainted 6.5.0-rc1_net_next_mlx5_58c644e #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
   Workqueue: events_unbound free_implicit_child_mr_work [mlx5_ib]
   RIP: 0010:refcount_warn_saturate+0x12b/0x130
   Code: 48 c7 c7 38 95 2a 82 c6 05 bc c6 fe 00 01 e8 0c 66 aa ff 0f 0b 5b c3 48 c7 c7 e0 94 2a 82 c6 05 a7 c6 fe 00 01 e8 f5 65 aa ff <0f> 0b 5b c3 90 8b 07 3d 00 00 00 c0 74 12 83 f8 01 74 13 8d 50 ff
   RSP: 0018:ffff8881008e3e40 EFLAGS: 00010286
   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000027
   RDX: ffff88852c91b5c8 RSI: 0000000000000001 RDI: ffff88852c91b5c0
   RBP: ffff8881dacd4e00 R08: 00000000ffffffff R09: 0000000000000019
   R10: 000000000000072e R11: 0000000063666572 R12: ffff88812bfd9e00
   R13: ffff8881c792d200 R14: ffff88810011c005 R15: ffff8881002099c0
   FS:  0000000000000000(0000) GS:ffff88852c900000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00007f5694b5e000 CR3: 00000001153f6003 CR4: 0000000000370ea0
   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
   Call Trace:
    <TASK>
    ? refcount_warn_saturate+0x12b/0x130
    free_implicit_child_mr_work+0x180/0x1b0 [mlx5_ib]
    process_one_work+0x1cc/0x3c0
    worker_thread+0x218/0x3c0
    kthread+0xc6/0xf0
    ret_from_fork+0x1f/0x30
    </TASK>

Fixes: 5256edcb98a1 ("RDMA/mlx5: Rework implicit ODP destroy")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/r/c96b8645a81085abff739e6b06e286a350d1283d.1737274283.git.leon@kernel.org
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/odp.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -228,13 +228,27 @@ static void destroy_unused_implicit_chil
 	unsigned long idx = ib_umem_start(odp) >> MLX5_IMR_MTT_SHIFT;
 	struct mlx5_ib_mr *imr = mr->parent;
 
+	/*
+	 * If userspace is racing freeing the parent implicit ODP MR then we can
+	 * loose the race with parent destruction. In this case
+	 * mlx5_ib_free_odp_mr() will free everything in the implicit_children
+	 * xarray so NOP is fine. This child MR cannot be destroyed here because
+	 * we are under its umem_mutex.
+	 */
 	if (!refcount_inc_not_zero(&imr->mmkey.usecount))
 		return;
 
-	xa_erase(&imr->implicit_children, idx);
+	xa_lock(&imr->implicit_children);
+	if (__xa_cmpxchg(&imr->implicit_children, idx, mr, NULL, GFP_KERNEL) !=
+	    mr) {
+		xa_unlock(&imr->implicit_children);
+		return;
+	}
+
 	if (MLX5_CAP_ODP(mr_to_mdev(mr)->mdev, mem_page_fault))
-		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
-			 mlx5_base_mkey(mr->mmkey.key));
+		__xa_erase(&mr_to_mdev(mr)->odp_mkeys,
+			   mlx5_base_mkey(mr->mmkey.key));
+	xa_unlock(&imr->implicit_children);
 
 	/* Freeing a MR is a sleeping operation, so bounce to a work queue */
 	INIT_WORK(&mr->odp_destroy.work, free_implicit_child_mr_work);
@@ -500,18 +514,18 @@ static struct mlx5_ib_mr *implicit_get_c
 		refcount_inc(&ret->mmkey.usecount);
 		goto out_lock;
 	}
-	xa_unlock(&imr->implicit_children);
 
 	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
-		ret = xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
-			       &mr->mmkey, GFP_KERNEL);
+		ret = __xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
+				 &mr->mmkey, GFP_KERNEL);
 		if (xa_is_err(ret)) {
 			ret = ERR_PTR(xa_err(ret));
-			xa_erase(&imr->implicit_children, idx);
-			goto out_mr;
+			__xa_erase(&imr->implicit_children, idx);
+			goto out_lock;
 		}
 		mr->mmkey.type = MLX5_MKEY_IMPLICIT_CHILD;
 	}
+	xa_unlock(&imr->implicit_children);
 	mlx5_ib_dbg(mr_to_mdev(imr), "key %x mr %p\n", mr->mmkey.key, mr);
 	return mr;
 


