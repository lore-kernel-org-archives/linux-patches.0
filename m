Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3974F3B05BC;
	Sat, 17 Oct 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257169; cv=none; b=sojPXoWw9iMLNIfJlnUUNx9ANKKn4yp+pEwysubbxTb972YuWQfYGo9mppZFTt2HsZksqp17FLjnldyJfqNjTbSC8C28KQBaiQqDP8i9Z7iApps3d5lPfSebVqfGvIPZ6oX4grf/+R9lgu3Gy+4vxbWh4pVhKy0l9Pu2hhzswew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257169; c=relaxed/simple;
	bh=QYmRMES0aNPKEWJWpghetE29EXsY0hhFuMRF3LtytYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm+7ro+dh0b8ezph+tF1Nc8o2cdSr1QlcCS409EHE1DMcuISSPOPzAZop244J3YAkm+7CizI4HrO55bLON7pds/tIBp4oI7RKAPNfNuZ8VXs89sDCUYK4Ij4DpNDLi1bdp0Tj0K7l4oETdhctm1OF6hzZorF5ABiGQawStM5BB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+o3EeGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+o3EeGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C941F000C4;
	Sat, 17 Oct 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257167;
	bh=8eiSlkvCvNtF6jxotKM90lGMfKg/Jh1Vx1aWleesOXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+o3EeGv4LBPFS02SCm5xW1ZDSJQ6RO1bZVg0/GUfdl3nOwlPbxj4sLCbCsknHUD9
	 zrbBVez0HdyP/oo13ZQMyYdprS/VqUg0v5ObyYxIoarg5OhVQl6jnDTYkDhOHcKsPb
	 uBlK+9NYhdZk9+fR92LYPgHD4bAOrfsGU20JM2lE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0436/1674] net: mana: check xdp_rxq registration before unreg in mana_destroy_rxq()
Date: Sat, 17 Oct 2026 17:45:08 +0200
Message-ID: <20261017160442.314289932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit e9e334f8063a991b4f648b8dbb8dac44cf810540 ]

When mana_create_rxq() fails at mana_create_wq_obj() or any step before
xdp_rxq_info_reg() is called, the error path jumps to `out:` which calls
mana_destroy_rxq(). mana_destroy_rxq() unconditionally calls
xdp_rxq_info_unreg() on xilinx xdp_rxq that was never registered,
triggering a WARN_ON in net/core/xdp.c:

mana 7870:00:00.0: HWC: Failed hw_channel req: 0xc000009a
mana 7870:00:00.0 eth7: Failed to create RXQ: err = -71
Driver BUG
WARNING: CPU: 442 PID: 491615 at ../net/core/xdp.c:150 xdp_rxq_info_unreg+0x44/0x70
Modules linked in: tcp_bbr xsk_diag udp_diag raw_diag unix_diag af_packet_diag netlink_diag nf_tables nfnetlink tcp_diag inet_diag binfmt_misc rpcsec_gss_krb5 nfsv3 nfs_acl auth_rpcgss nfsv4 dns_resolver nfs lockd ext4 grace crc16 iscsi_tcp mbcache fscache libiscsi_tcp jbd2 netfs rpcrdma af_packet sunrpc rdma_ucm ib_iser rdma_cm iw_cm iscsi_ibft ib_cm iscsi_boot_sysfs libiscsi rfkill scsi_transport_iscsi mana_ib ib_uverbs ib_core mana hyperv_drm(X) drm_shmem_helper intel_rapl_msr drm_kms_helper intel_rapl_common syscopyarea nls_iso8859_1 sysfillrect intel_uncore_frequency_common nls_cp437 vfat fat nfit sysimgblt libnvdimm hv_netvsc(X) hv_utils(X) fb_sys_fops hv_balloon(X) joydev fuse drm dm_mod configfs ip_tables x_tables xfs libcrc32c sd_mod nvme nvme_core nvme_common t10_pi crc64_rocksoft_generic crc64_rocksoft crc64 hid_generic serio_raw pci_hyperv(X) hv_storvsc(X) scsi_transport_fc hyperv_keyboard(X) hid_hyperv(X) pci_hyperv_intf(X) crc32_pclmul
 crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd cryptd hv_vmbus(X) softdog sg scsi_mod efivarfs
Supported: Yes, External
CPU: 442 PID: 491615 Comm: ethtool Kdump: loaded Tainted: G               X    5.14.21-150500.55.136-default #1 SLE15-SP5 a627be1b53abbfd64ad16b2685e4308c52847f42
Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 07/25/2025
RIP: 0010:xdp_rxq_info_unreg+0x44/0x70
Code: e8 91 fe ff ff c7 43 0c 02 00 00 00 48 c7 03 00 00 00 00 5b c3 cc cc cc cc e9 58 3a 1c 00 48 c7 c7 f6 5f 19 97 e8 5c a4 7e ff <0f> 0b 83 7b 0c 01 74 ca 48 c7 c7 d9 5f 19 97 e8 48 a4 7e ff 0f 0b
RSP: 0018:ff3df6c8f7207818 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ff30d89f94808a80 RCX: 0000000000000027
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ff30d94bdcca2908
RBP: 0000000000080000 R08: ffffffff98ed11a0 R09: ff3df6c8f72077a0
R10: dead000000000100 R11: 000000000000000a R12: 0000000000000000
R13: 0000000000002000 R14: 0000000000040000 R15: ff30d89f94800000
FS:  00007fe6d8432b80(0000) GS:ff30d94bdcc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe6d81a89b1 CR3: 00000b3b6d578001 CR4: 0000000000371ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mana_destroy_rxq+0x5b/0x2f0 [mana 267acf7006bcb696095bba4d810643d1db3b9e94]
 mana_create_rxq.isra.55+0x3db/0x720 [mana 267acf7006bcb696095bba4d810643d1db3b9e94]
 ? simple_lookup+0x36/0x50
 ? current_time+0x42/0x80
 ? __d_free_external+0x30/0x30
 mana_alloc_queues+0x32a/0x470 [mana 267acf7006bcb696095bba4d810643d1db3b9e94]
 ? _raw_spin_unlock+0xa/0x30
 ? d_instantiate.part.29+0x2e/0x40
 ? _raw_spin_unlock+0xa/0x30
 ? debugfs_create_dir+0xe4/0x140
 mana_attach+0x5c/0xf0 [mana 267acf7006bcb696095bba4d810643d1db3b9e94]
 mana_set_ringparam+0xd5/0x1a0 [mana 267acf7006bcb696095bba4d810643d1db3b9e94]
 ethnl_set_rings+0x292/0x320
 genl_family_rcv_msg_doit.isra.15+0x11b/0x150
 genl_rcv_msg+0xe3/0x1e0
 ? rings_prepare_data+0x80/0x80
 ? genl_family_rcv_msg_doit.isra.15+0x150/0x150
 netlink_rcv_skb+0x50/0x100
 genl_rcv+0x24/0x40
 netlink_unicast+0x1b6/0x280
 netlink_sendmsg+0x365/0x4d0
 sock_sendmsg+0x5f/0x70
 __sys_sendto+0x112/0x140
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0x5b/0x80
 ? handle_mm_fault+0xd7/0x290
 ? do_user_addr_fault+0x2d8/0x740
 ? exc_page_fault+0x67/0x150
 entry_SYSCALL_64_after_hwframe+0x6b/0xd5
RIP: 0033:0x7fe6d8122f06
Code: 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 72 f3 c3 41 57 41 56 4d 89 c7 41 55 41 54 41
RSP: 002b:00007fff2b66b068 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055771123d2a0 RCX: 00007fe6d8122f06
RDX: 0000000000000034 RSI: 000055771123d3b0 RDI: 0000000000000003
RBP: 00007fff2b66b100 R08: 00007fe6d8203360 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 000055771123d350
R13: 000055771123d340 R14: 0000000000000000 R15: 00007fff2b66b2b0
 </TASK>

Guard the xdp_rxq_info_unreg() call with xdp_rxq_info_is_reg() so that
mana_destroy_rxq() is safe to call regardless of how far initialization
progressed.

Fixes: ed5356b53f07 ("net: mana: Add XDP support")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20260430035935.1859220-2-dipayanroy@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 5c96e9a5f14e6..1477f05b897d5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2050,7 +2050,9 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 
 		netif_napi_del(napi);
 	}
-	xdp_rxq_info_unreg(&rxq->xdp_rxq);
+
+	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
+		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
 	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
-- 
2.53.0



