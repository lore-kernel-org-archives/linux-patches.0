Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7917406A;
	Mon, 29 Jan 2024 17:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548571; cv=none; b=OXYbKJdoEUisltGpfwOu6KmymdbW6xViNQq8xRatCLLTlxFe+qi5L4sFDT3umvks1nFgUeCjgYowkfmjVbI1T9i6yOWeaUB9tfW2EY+Nw+lhkE3EiVh1aGuwD6Je2MSdJNQAc4W+yUOfqC5Ww3SbBS1eskDfeYCjELfzagkWmtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548571; c=relaxed/simple;
	bh=DAl0qj9U05bf7LSd3/qBf9AMoTCO/zQon/phXFdXylE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7SC/rtnHtlkh9ZkH662956jxJXXN3Exj7xNG+FRgCrqLCzR44o/2i175dPrqlSeF4VIQCe+4HciHoRTuk5WlR9KZwh6fTNFT/p4KWB3q9W6hu54040Z4QMKw5nFqJ2FtQJ5DSKPT4rQhYObW0LomlZd3DjZIdFvZowWH5T1kt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulF8TjGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulF8TjGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC6FC43390;
	Mon, 29 Jan 2024 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548569;
	bh=DAl0qj9U05bf7LSd3/qBf9AMoTCO/zQon/phXFdXylE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulF8TjGF1n41ODjk8eTf+Z7Y1nb81sIQURceqI4QhQ8kZ0deEpNoDcrf070EMAe4A
	 WTVISnolGP8FFWkz3imHqUCTx9Qu+sTaKiXtPx9+fkOSu3O2vREwu9N2KiEdjwEdnR
	 20m3LucyvHpaOpvj0qfWQ7HCtZjVHwOgdDcZB4jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/331] net/mlx5: Fix a WARN upon a callback command failure
Date: Mon, 29 Jan 2024 09:04:18 -0800
Message-ID: <20240129170020.559933821@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit cc8091587779cfaddb6b29c9e9edb9079a282cad ]

The below WARN [1] is reported once a callback command failed.

As a callback runs under an interrupt context, needs to use the IRQ
save/restore variant.

[1]
DEBUG_LOCKS_WARN_ON(lockdep_hardirq_context())
WARNING: CPU: 15 PID: 0 at kernel/locking/lockdep.c:4353
              lockdep_hardirqs_on_prepare+0x11b/0x180
Modules linked in: vhost_net vhost tap mlx5_vfio_pci
vfio_pci vfio_pci_core vfio_iommu_type1 vfio mlx5_vdpa vringh
vhost_iotlb vdpa nfnetlink_cttimeout openvswitch nsh ip6table_mangle
ip6table_nat ip6table_filter ip6_tables iptable_mangle
xt_conntrackxt_MASQUERADE nf_conntrack_netlink nfnetlink
xt_addrtype iptable_nat nf_nat br_netfilter rpcsec_gss_krb5
auth_rpcgss oid_registry overlay rpcrdma rdma_ucm ib_iser libiscsi
scsi_transport_iscsi rdma_cm iw_cm ib_umad ib_ipoib ib_cm
mlx5_ib ib_uverbs ib_core fuse mlx5_core
CPU: 15 PID: 0 Comm: swapper/15 Tainted: G        W 6.7.0-rc4+ #1587
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:lockdep_hardirqs_on_prepare+0x11b/0x180
Code: 00 5b c3 c3 e8 e6 0d 58 00 85 c0 74 d6 8b 15 f0 c3
      76 01 85 d2 75 cc 48 c7 c6 04 a5 3b 82 48 c7 c7 f1
      e9 39 82 e8 95 12 f9 ff <0f> 0b 5b c3 e8 bc 0d 58 00
      85 c0 74 ac 8b 3d c6 c3 76 01 85 ff 75
RSP: 0018:ffffc900003ecd18 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000027
RDX: 0000000000000000 RSI: ffff88885fbdb880 RDI: ffff88885fbdb888
RBP: 00000000ffffff87 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 284e4f5f4e524157 R12: 00000000002c9aa1
R13: ffff88810aace980 R14: ffff88810aace9b8 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff88885fbc0000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f731436f4c8 CR3: 000000010aae6001 CR4: 0000000000372eb0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
? __warn+0x81/0x170
? lockdep_hardirqs_on_prepare+0x11b/0x180
? report_bug+0xf8/0x1c0
? handle_bug+0x3f/0x70
? exc_invalid_op+0x13/0x60
? asm_exc_invalid_op+0x16/0x20
? lockdep_hardirqs_on_prepare+0x11b/0x180
? lockdep_hardirqs_on_prepare+0x11b/0x180
trace_hardirqs_on+0x4a/0xa0
raw_spin_unlock_irq+0x24/0x30
cmd_status_err+0xc0/0x1a0 [mlx5_core]
cmd_status_err+0x1a0/0x1a0 [mlx5_core]
mlx5_cmd_exec_cb_handler+0x24/0x40 [mlx5_core]
mlx5_cmd_comp_handler+0x129/0x4b0 [mlx5_core]
cmd_comp_notifier+0x1a/0x20 [mlx5_core]
notifier_call_chain+0x3e/0xe0
atomic_notifier_call_chain+0x5f/0x130
mlx5_eq_async_int+0xe7/0x200 [mlx5_core]
notifier_call_chain+0x3e/0xe0
atomic_notifier_call_chain+0x5f/0x130
irq_int_handler+0x11/0x20 [mlx5_core]
__handle_irq_event_percpu+0x99/0x220
? tick_irq_enter+0x5d/0x80
handle_irq_event_percpu+0xf/0x40
handle_irq_event+0x3a/0x60
handle_edge_irq+0xa2/0x1c0
__common_interrupt+0x55/0x140
common_interrupt+0x7d/0xa0
</IRQ>
<TASK>
asm_common_interrupt+0x22/0x40
RIP: 0010:default_idle+0x13/0x20
Code: c0 08 00 00 00 4d 29 c8 4c 01 c7 4c 29 c2 e9 72 ff
ff ff cc cc cc cc 8b 05 ea 08 25 01 85 c0 7e 07 0f 00 2d 7f b0 26 00 fb
f4 <fa> c3 90 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 80 d0 02 00
RSP: 0018:ffffc9000010fec8 EFLAGS: 00000242
RAX: 0000000000000001 RBX: 000000000000000f RCX: 4000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff811c410c
RBP: ffffffff829478c0 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
? do_idle+0x1ec/0x210
default_idle_call+0x6c/0x90
do_idle+0x1ec/0x210
cpu_startup_entry+0x26/0x30
start_secondary+0x11b/0x150
secondary_startup_64_no_verify+0x165/0x16b
</TASK>
irq event stamp: 833284
hardirqs last  enabled at (833283): [<ffffffff811c410c>]
do_idle+0x1ec/0x210
hardirqs last disabled at (833284): [<ffffffff81daf9ef>]
common_interrupt+0xf/0xa0
softirqs last  enabled at (833224): [<ffffffff81dc199f>]
__do_softirq+0x2bf/0x40e
softirqs last disabled at (833177): [<ffffffff81178ddf>]
irq_exit_rcu+0x7f/0xa0

Fixes: 34f46ae0d4b3 ("net/mlx5: Add command failures data to debugfs")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 7013e1c8741a..55efb932ab2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1921,6 +1921,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 {
 	const char *namep = mlx5_command_str(opcode);
 	struct mlx5_cmd_stats *stats;
+	unsigned long flags;
 
 	if (!err || !(strcmp(namep, "unknown command opcode")))
 		return;
@@ -1928,7 +1929,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 	stats = xa_load(&dev->cmd.stats, opcode);
 	if (!stats)
 		return;
-	spin_lock_irq(&stats->lock);
+	spin_lock_irqsave(&stats->lock, flags);
 	stats->failed++;
 	if (err < 0)
 		stats->last_failed_errno = -err;
@@ -1937,7 +1938,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 		stats->last_failed_mbox_status = status;
 		stats->last_failed_syndrome = syndrome;
 	}
-	spin_unlock_irq(&stats->lock);
+	spin_unlock_irqrestore(&stats->lock, flags);
 }
 
 /* preserve -EREMOTEIO for outbox.status != OK, otherwise return err as is */
-- 
2.43.0



