Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F52324B09;
	Mon, 27 Oct 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593427; cv=none; b=YLj8lAUuCCyOY6cZH7XSabqsq9oM4tbZJR+L8AqQ3a0rcub7dRtMYN4kKNA62RwYaCQ7hH8WX2LsyS3IGmYwELEI/YvhS4JYVnp8lOLPrpvw/fUstQfwwQsF0nFa+YB+1p0Cz7d3ykYKMPbsyoK1vm8/uEOk1/E9IkYaToWrhck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593427; c=relaxed/simple;
	bh=3f41haB/1/7Ri6moilzTWDdciubzvYpo8AIDVNrxJ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW4YntgSBplT1LyRlAYpJWB9+Jfyrn5efPtu116cSt4g36wyG/Nac3JEFogzWvPypy3fK/RDkmJjFrxxpabiRYGUoi42ugGLJd942/g5Fo0no+Dy2DHYm6DG/B2qoc3K/3l+q8eDG2X5MSfgmOK43kxvoyy1x5U/kfFDkOGwgPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X3o82luQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X3o82luQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CC0C4CEF1;
	Mon, 27 Oct 2025 19:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593426;
	bh=3f41haB/1/7Ri6moilzTWDdciubzvYpo8AIDVNrxJ5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3o82luQdm0sT5/7vAuUwTq2zzqe1G4uOImcsH+98vT91huqfCnhqoMIDdjHFsbpR
	 o7KZCSAAH01pyvhYcBtofDU2wJN/mL0KFddaXg2/LW6sPl981wG5Kiwq/RFaG8WJWM
	 4I/rL46ELIQMxbbGPNPUishcnEHdHeqAnstppACY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cynthia <cynthia@kosmx.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/184] sysfs: check visibility before changing group attribute ownership
Date: Mon, 27 Oct 2025 19:36:52 +0100
Message-ID: <20251027183518.445598273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c7fbb8218b4ad35fec0bd2256d2b9c8d60331f33 ]

Since commit 0c17270f9b92 ("net: sysfs: Implement is_visible for
phys_(port_id, port_name, switch_id)"), __dev_change_net_namespace() can
hit WARN_ON() when trying to change owner of a file that isn't visible.
See the trace below:

 WARNING: CPU: 6 PID: 2938 at net/core/dev.c:12410 __dev_change_net_namespace+0xb89/0xc30
 CPU: 6 UID: 0 PID: 2938 Comm: incusd Not tainted 6.17.1-1-mainline #1 PREEMPT(full)  4b783b4a638669fb644857f484487d17cb45ed1f
 Hardware name: Framework Laptop 13 (AMD Ryzen 7040Series)/FRANMDCP07, BIOS 03.07 02/19/2025
 RIP: 0010:__dev_change_net_namespace+0xb89/0xc30
 [...]
 Call Trace:
  <TASK>
  ? if6_seq_show+0x30/0x50
  do_setlink.isra.0+0xc7/0x1270
  ? __nla_validate_parse+0x5c/0xcc0
  ? security_capable+0x94/0x1a0
  rtnl_newlink+0x858/0xc20
  ? update_curr+0x8e/0x1c0
  ? update_entity_lag+0x71/0x80
  ? sched_balance_newidle+0x358/0x450
  ? psi_task_switch+0x113/0x2a0
  ? __pfx_rtnl_newlink+0x10/0x10
  rtnetlink_rcv_msg+0x346/0x3e0
  ? sched_clock+0x10/0x30
  ? __pfx_rtnetlink_rcv_msg+0x10/0x10
  netlink_rcv_skb+0x59/0x110
  netlink_unicast+0x285/0x3c0
  ? __alloc_skb+0xdb/0x1a0
  netlink_sendmsg+0x20d/0x430
  ____sys_sendmsg+0x39f/0x3d0
  ? import_iovec+0x2f/0x40
  ___sys_sendmsg+0x99/0xe0
  __sys_sendmsg+0x8a/0xf0
  do_syscall_64+0x81/0x970
  ? __sys_bind+0xe3/0x110
  ? syscall_exit_work+0x143/0x1b0
  ? do_syscall_64+0x244/0x970
  ? sock_alloc_file+0x63/0xc0
  ? syscall_exit_work+0x143/0x1b0
  ? do_syscall_64+0x244/0x970
  ? alloc_fd+0x12e/0x190
  ? put_unused_fd+0x2a/0x70
  ? do_sys_openat2+0xa2/0xe0
  ? syscall_exit_work+0x143/0x1b0
  ? do_syscall_64+0x244/0x970
  ? exc_page_fault+0x7e/0x1a0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 [...]
  </TASK>

Fix this by checking is_visible() before trying to touch the attribute.

Fixes: 303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")
Fixes: 0c17270f9b92 ("net: sysfs: Implement is_visible for phys_(port_id, port_name, switch_id)")
Reported-by: Cynthia <cynthia@kosmx.dev>
Closes: https://lore.kernel.org/netdev/01070199e22de7f8-28f711ab-d3f1-46d9-b9a0-048ab05eb09b-000000@eu-central-1.amazonses.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20251016101456.4087-1-fmancera@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysfs/group.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 2d78e94072a0d..e142bac4f9f80 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -498,17 +498,26 @@ int compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(compat_only_sysfs_link_entry_to_kobj);
 
-static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
+static int sysfs_group_attrs_change_owner(struct kobject *kobj,
+					  struct kernfs_node *grp_kn,
 					  const struct attribute_group *grp,
 					  struct iattr *newattrs)
 {
 	struct kernfs_node *kn;
-	int error;
+	int error, i;
+	umode_t mode;
 
 	if (grp->attrs) {
 		struct attribute *const *attr;
 
-		for (attr = grp->attrs; *attr; attr++) {
+		for (i = 0, attr = grp->attrs; *attr; i++, attr++) {
+			if (grp->is_visible) {
+				mode = grp->is_visible(kobj, *attr, i);
+				if (mode & SYSFS_GROUP_INVISIBLE)
+					break;
+				if (!mode)
+					continue;
+			}
 			kn = kernfs_find_and_get(grp_kn, (*attr)->name);
 			if (!kn)
 				return -ENOENT;
@@ -523,7 +532,14 @@ static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
 	if (grp->bin_attrs) {
 		const struct bin_attribute *const *bin_attr;
 
-		for (bin_attr = grp->bin_attrs; *bin_attr; bin_attr++) {
+		for (i = 0, bin_attr = grp->bin_attrs; *bin_attr; i++, bin_attr++) {
+			if (grp->is_bin_visible) {
+				mode = grp->is_bin_visible(kobj, *bin_attr, i);
+				if (mode & SYSFS_GROUP_INVISIBLE)
+					break;
+				if (!mode)
+					continue;
+			}
 			kn = kernfs_find_and_get(grp_kn, (*bin_attr)->attr.name);
 			if (!kn)
 				return -ENOENT;
@@ -573,7 +589,7 @@ int sysfs_group_change_owner(struct kobject *kobj,
 
 	error = kernfs_setattr(grp_kn, &newattrs);
 	if (!error)
-		error = sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
+		error = sysfs_group_attrs_change_owner(kobj, grp_kn, grp, &newattrs);
 
 	kernfs_put(grp_kn);
 
-- 
2.51.0



