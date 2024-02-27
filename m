Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB513A26F;
	Tue, 27 Feb 2024 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042951; cv=none; b=ccn6e1dR67SMeaLFhTU8EK62L7y7mP3He8TqhKJwLZNR1wmstIJ8r6R3XSrZasUEkCal0aaMkXZ6qBzFZgax1NT4d4hJf80YH64ZeRhocJAz4RyM0i3QRQBthNPYiLMZB4v9Dm3EYdbyuxs7E71Gdyuh4qZXhIW1lv8gCESA8xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042951; c=relaxed/simple;
	bh=gTBmbKgV6ZOiU7weCMK0MKBvV7m7CWqH+nDTQvc16vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1Uh9AfnoA340e0uD94Pr3jS60/nPGXvp4h6vyN+5dhU7mWRhf3Ai+aF/C988+m5iTwANGGNpjhZ+Y1+sBjk02IZoq0TMjWB24zwcvG4wVGe2m6wDY9AyazDlSkSv7SWxV/BJ4wDl40TOyweJWvzUasd9nJJSC3XBlc3ho8To5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdX8qWcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdX8qWcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683E2C433F1;
	Tue, 27 Feb 2024 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042950;
	bh=gTBmbKgV6ZOiU7weCMK0MKBvV7m7CWqH+nDTQvc16vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdX8qWcd6R0nWb6bMSG3CHQmqe9sr1DW3QnUBIaH34ByEMb20ZFGsnUPi2XcN/VO8
	 /8t2RyI8dq3kfV7MS6yvrOKeUQXvfrZOKZfq5paPE1iEmypq4B1jdbwnzVY4drK/Hu
	 M0ZNcyi6VsJWARkgbVr9eY2/CRIp8SSKJ7Bu3h44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/245] devlink: report devlink_port_type_warn source device
Date: Tue, 27 Feb 2024 14:26:07 +0100
Message-ID: <20240227131621.027787255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit a52305a81d6bb74b90b400dfa56455d37872fe4b ]

devlink_port_type_warn is scheduled for port devlink and warning
when the port type is not set. But from this warning it is not easy
found out which device (driver) has no devlink port set.

[ 3709.975552] Type was not set for devlink port.
[ 3709.975579] WARNING: CPU: 1 PID: 13092 at net/devlink/leftover.c:6775 devlink_port_type_warn+0x11/0x20
[ 3709.993967] Modules linked in: openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfnetlink bluetooth rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs vhost_net vhost vhost_iotlb tap tun bridge stp llc qrtr intel_rapl_msr intel_rapl_common i10nm_edac nfit libnvdimm x86_pkg_temp_thermal mlx5_ib intel_powerclamp coretemp dell_wmi ledtrig_audio sparse_keymap ipmi_ssif kvm_intel ib_uverbs rfkill ib_core video kvm iTCO_wdt acpi_ipmi intel_vsec irqbypass ipmi_si iTCO_vendor_support dcdbas ipmi_devintf mei_me ipmi_msghandler rapl mei intel_cstate isst_if_mmio isst_if_mbox_pci dell_smbios intel_uncore isst_if_common i2c_i801 dell_wmi_descriptor wmi_bmof i2c_smbus intel_pch_thermal pcspkr acpi_power_meter xfs libcrc32c sd_mod sg nvme_tcp mgag200 i2c_algo_bit nvme_fabrics drm_shmem_helper drm_kms_helper nvme syscopyarea ahci sysfillrect sysimgblt nvme_core fb_sys_fops crct10dif_pclmul libahci mlx5_core sfc crc32_pclmul nvme_common drm
[ 3709.994030]  crc32c_intel mtd t10_pi mlxfw libata tg3 mdio megaraid_sas psample ghash_clmulni_intel pci_hyperv_intf wmi dm_multipath sunrpc dm_mirror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio cxgb4i cxgb4 tls libcxgbi libcxgb qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse
[ 3710.108431] CPU: 1 PID: 13092 Comm: kworker/1:1 Kdump: loaded Not tainted 5.14.0-319.el9.x86_64 #1
[ 3710.108435] Hardware name: Dell Inc. PowerEdge R750/0PJ80M, BIOS 1.8.2 09/14/2022
[ 3710.108437] Workqueue: events devlink_port_type_warn
[ 3710.108440] RIP: 0010:devlink_port_type_warn+0x11/0x20
[ 3710.108443] Code: 84 76 fe ff ff 48 c7 03 20 0e 1a ad 31 c0 e9 96 fd ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 48 c7 c7 18 24 4e ad e8 ef 71 62 ff <0f> 0b c3 cc cc cc cc 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f6 87
[ 3710.108445] RSP: 0018:ff3b6d2e8b3c7e90 EFLAGS: 00010282
[ 3710.108447] RAX: 0000000000000000 RBX: ff366d6580127080 RCX: 0000000000000027
[ 3710.108448] RDX: 0000000000000027 RSI: 00000000ffff86de RDI: ff366d753f41f8c8
[ 3710.108449] RBP: ff366d658ff5a0c0 R08: ff366d753f41f8c0 R09: ff3b6d2e8b3c7e18
[ 3710.108450] R10: 0000000000000001 R11: 0000000000000023 R12: ff366d753f430600
[ 3710.108451] R13: ff366d753f436900 R14: 0000000000000000 R15: ff366d753f436905
[ 3710.108452] FS:  0000000000000000(0000) GS:ff366d753f400000(0000) knlGS:0000000000000000
[ 3710.108453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3710.108454] CR2: 00007f1c57bc74e0 CR3: 000000111d26a001 CR4: 0000000000773ee0
[ 3710.108456] PKRU: 55555554
[ 3710.108457] Call Trace:
[ 3710.108458]  <TASK>
[ 3710.108459]  process_one_work+0x1e2/0x3b0
[ 3710.108466]  ? rescuer_thread+0x390/0x390
[ 3710.108468]  worker_thread+0x50/0x3a0
[ 3710.108471]  ? rescuer_thread+0x390/0x390
[ 3710.108473]  kthread+0xdd/0x100
[ 3710.108477]  ? kthread_complete_and_exit+0x20/0x20
[ 3710.108479]  ret_from_fork+0x1f/0x30
[ 3710.108485]  </TASK>
[ 3710.108486] ---[ end trace 1b4b23cd0c65d6a0 ]---

After patch:
[  402.473064] ice 0000:41:00.0: Type was not set for devlink port.
[  402.473064] ice 0000:41:00.1: Type was not set for devlink port.

Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230615095447.8259-1-poros@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index db76c55e1a6d7..7113ae79f5228 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9055,7 +9055,10 @@ EXPORT_SYMBOL_GPL(devlink_free);
 
 static void devlink_port_type_warn(struct work_struct *work)
 {
-	WARN(true, "Type was not set for devlink port.");
+	struct devlink_port *port = container_of(to_delayed_work(work),
+						 struct devlink_port,
+						 type_warn_dw);
+	dev_warn(port->devlink->dev, "Type was not set for devlink port.");
 }
 
 static bool devlink_port_type_should_warn(struct devlink_port *devlink_port)
-- 
2.43.0



