Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB312D3225;
	Sat, 17 Oct 2026 17:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258227; cv=none; b=UGbgAOWhi60xjlw3PabgN7hgnGZoPHsTUC1+kt4gN0nP1yLhxK2Lud4z30pSIfxrtcqUAbWIFmo/SEBd/qbfBvEABtn7GcWfFKUkQNXpyPUkZUVGYbUCaVtdw66eMqLual7uWQ/5+kD70j2idOX3YeG8EFNEpHvKO3oOQdIbGRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258227; c=relaxed/simple;
	bh=N3K7yGXOD65kphwth+HnJl1D8lU4cz0h5N9qS5uy0v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOOM5VZ6XzbNyJHsXqXrHvR6/KnlkJD+aNSiUuNo0fUVkE94hArAIlvHj9rKRHFL4FIVM+C+sAmA1fwIAwVd0dqIEpB5TAU5MCMDQYFdIS0bXxtTGYkee1/1itjRprd/DvfeFQcYIn03RTk37QSO/5GjDZlT2RpfHmo9M6/oOKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7SnKgkC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7SnKgkC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9765E1F000C4;
	Sat, 17 Oct 2026 17:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258226;
	bh=D0rpkb4pNkgeCRiWCiaAFMFAVKHdU66HLWe0ZFyMpXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7SnKgkCAVfIqHAxjSZ7RRgSEs7qDPO4XhvqlEsXloXopyePLou45+9AHId0OkC61
	 RZrK/GTfRttn5LFNVzWbDAwI7Joks9CKqmSxTQ6T4EgVDnkqTsLYRz1xjD8KBRvbqP
	 A1ChbFA7UsgxroOL8vmHpDHBbACRLv2Tw4lVEPBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cynthia <cynthia@kosmx.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0815/1674] sysfs: check visibility before changing group attribute ownership
Date: Sat, 17 Oct 2026 17:51:27 +0200
Message-ID: <20261017160452.042218983@linuxfoundation.org>
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
index 7e8ee83351554..1b2a8dd1bcda5 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -495,17 +495,26 @@ int compat_only_sysfs_link_entry_to_kobj(struct kobject *kobj,
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
@@ -520,7 +529,14 @@ static int sysfs_group_attrs_change_owner(struct kernfs_node *grp_kn,
 	if (grp->bin_attrs) {
 		struct bin_attribute *const *bin_attr;
 
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
@@ -570,7 +586,7 @@ int sysfs_group_change_owner(struct kobject *kobj,
 
 	error = kernfs_setattr(grp_kn, &newattrs);
 	if (!error)
-		error = sysfs_group_attrs_change_owner(grp_kn, grp, &newattrs);
+		error = sysfs_group_attrs_change_owner(kobj, grp_kn, grp, &newattrs);
 
 	kernfs_put(grp_kn);
 
-- 
2.53.0



