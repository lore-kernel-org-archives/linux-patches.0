Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038973;
	b=l1PxsaL4OBb8xbsshUKqCoH+qKvhS5pOc1/uxxbv3OzBxPf+eGiPOofAvq66MK0GA1kL
	 RmDpabT/JnRYlRpTfRVdEbMcUpjmL32P/oEHxyyJZI8CsuSouhdtB8KxaO/DBUIQtyc9A
	 eXogo6yytYIO+yByctHL++MigbHg9lQfjbv3LYdfE1nQE/psVIerIbNPWbj89mAmqSxqX
	 Vc+drPKOI5IepNBv+9+qnxTWL9t5KqGPl8GBReOnOwis4ZueeUcJbyhJ0r6goj3WqMON7
	 w3WcKmQcPYAUVLkRuLs1LHg9RnA546FME/dRMpdSMULZijtGO8/BoQxuWoptJgHbjRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ZBjiX4B736VlK2j+bPDVUgjZwiaTpc2v5u5dDwBxsY=;
	b=emsZ1PMF26+P9Gw0G+3rvxHZzDu8IHR1YTRKlwFiyAgh4H470KEJtNugo1j/fEQ9leuT
	 mUQ6Joyz/tzE2W+Y22Y1ZE96pjDksAjH7jIo+lk2hb3V7EA3HBnGaDOQ0UONDkcGWSonm
	 5Uaglv0W9Fdq7HB9HR5/mcaP2v9YFavKNgBAFe0XdpOPFb1LlLZK0uRB+vB1u8QruTE1c
	 Y0pDjqln6kmXRZePNUcHDPOyWS4JphnUOM5C0Smi8ZG5uBfAf846VYg/Bf36fuo+4mY64
	 lyenGWK+ODeujsR97HWOCPKsHz1W3WYIfYbd0gFVIJ5BwVv++fH34Gg+LJJLCd6Cvhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umDFFAJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6D3606A31C;
	Wed, 18 Nov 2026 21:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umDFFAJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6A01F000C4;
	Wed, 18 Nov 2026 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038973;
	bh=8ZBjiX4B736VlK2j+bPDVUgjZwiaTpc2v5u5dDwBxsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umDFFAJFI+pT74iytL0rn9HrYasW7cG80ukBcyyUHb6FFtpt5/wO7jSRyLyLdGHOt
	 NFY90WjKN/21Djl7ezgOwfIwY7MhYm1iV6tVN6F+MxVci37uAelg4c22O81tnaTOP5
	 kSTjJxsNP0aRrJb0Lus8+FiEIKzwkEaRo6HgP6Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Zhang <yuz08559@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1917/3318] scsi: target: Fix demo-mode dynamic ACL dev-entry UAF vs LUN teardown
Date: Wed, 18 Nov 2026 15:42:19 +0100
Message-ID: <20261118150419.512286506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Zhang <yuz08559@gmail.com>

[ Upstream commit 6a6e7d7230cd4e0a6c003bae5b85bf37a1e77b94 ]

A demo-mode (generate_node_acls=1) login that allocates a dynamic NodeACL
populates that ACL's per-LUN dev entries in core_tpg_add_node_to_devs()
*before* the ACL is linked onto tpg->acl_node_list by
target_add_node_acl():

	core_tpg_check_initiator_node_acl():
		...
		core_tpg_add_node_to_devs(acl, tpg, NULL); /* builds deves */
		target_add_node_acl(acl);                  /* only now listed */

The LUN teardown sweep, core_clear_lun_from_tpg(), enumerates only
tpg->acl_node_list, so a dev entry whose ACL is still in the window above
is invisible to the sweep and is never disabled.  It is left on the
se_lun->lun_deve_list after core_tpg_remove_lun() frees the se_lun; when
the same unpacked_lun is later re-added and the se_lun is reallocated at
the same address, the stale dev entry is rediscovered by
target_nacl_find_deve() and core_enable_device_list_for_node() corrupts
lun_deve_list:

  BUG: KASAN: slab-use-after-free ...
   core_enable_device_list_for_node+0x5ce/0x880
   core_tpg_add_node_to_devs+0x169/0x190
   core_dev_add_lun+0x146/0x190
   target_fabric_port_link+0xe9/0x1b0
   configfs_symlink+0x381/0xae0
   __x64_sys_symlink+0x55/0x80

The demo-mode login path that drives the ACL/dev-entry creation is
reachable by an unauthenticated initiator; the colliding LUN add/remove is
a local configfs operation.

Commit 49cb77e297dc ("target: Avoid mappedlun symlink creation during lun
shutdown") introduced se_lun->lun_shutdown and guarded the *explicit* ACL
MappedLUN path (target_fabric_mappedlun_link()), but the demo-mode
automatic path, core_tpg_add_node_to_devs() ->
core_enable_device_list_for_node(), was never given the equivalent guard,
and the publish-after-populate ordering in
core_tpg_check_initiator_node_acl() was left unchanged.

Fix it in three cooperating parts:

 1) Publish the dynamic NodeACL onto acl_node_list *before* creating its
    dev entries, so the teardown sweep can observe them.

 2) Refuse to attach a dev entry to an se_lun that is shutting down,
    checked under nacl->lun_entry_mutex -- the same lock the sweep takes --
    so once the sweep has passed an ACL any later enable for that LUN
    observes lun_shutdown and skips it.

 3) In core_enable_device_list_for_node(), insert the new dev entry onto
    lun->lun_deve_list while still holding nacl->lun_entry_mutex, in both
    the replace and the new-entry branch.  Previously the entry was added
    to nacl->lun_entry_hlist under the mutex but to lun->lun_deve_list only
    after dropping it; with the ACL now published early, the sweep could
    take the mutex in that gap, find the entry on the hlist,
    core_disable_device_list_for_node() it (list_del() on the not-yet-
    linked lun_link succeeds and the entry is freed), and then the enable
    would list_add_tail() the freed entry back onto lun_deve_list.  Linking
    both lists under the mutex makes enable and the sweep mutually
    exclusive, closing that window.

core_tpg_add_node_to_devs() already ignores the return value of
core_enable_device_list_for_node(), so a shutting-down LUN is simply
skipped.

Cc: stable@vger.kernel.org
Fixes: 49cb77e297dc ("target: Avoid mappedlun symlink creation during lun shutdown")
Signed-off-by: Yu Zhang <yuz08559@gmail.com>
Tested-by: Yu Zhang <yuz08559@gmail.com>
Link: https://patch.msgid.link/20261014013746.46705-1-yuz08559@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 18 +++++++++++++++---
 drivers/target/target_core_tpg.c    | 10 +++++++++-
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 60ea1a317065a..c7fb180c19b18 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -350,6 +350,19 @@ int core_enable_device_list_for_node(
 	new->attach_count++;
 
 	mutex_lock(&nacl->lun_entry_mutex);
+	/*
+	 * Do not attach a new dev entry to an se_lun that is being torn down.
+	 * lun_shutdown is set by core_tpg_remove_lun() before its
+	 * core_clear_lun_from_tpg() sweep; checking it here under the same
+	 * nacl->lun_entry_mutex the sweep takes guarantees that once the sweep
+	 * has passed this ACL no dev entry can be left dangling on the
+	 * se_lun->lun_deve_list that is about to be freed.
+	 */
+	if (lun->lun_shutdown) {
+		mutex_unlock(&nacl->lun_entry_mutex);
+		ret = -ENODEV;
+		goto free_stats;
+	}
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->se_lun) {
 		struct se_lun *orig_lun = orig->se_lun;
@@ -376,12 +389,12 @@ int core_enable_device_list_for_node(
 		new->se_lun_acl = lun_acl;
 		hlist_del_rcu(&orig->link);
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-		mutex_unlock(&nacl->lun_entry_mutex);
 
 		spin_lock(&lun->lun_deve_lock);
 		list_del(&orig->lun_link);
 		list_add_tail(&new->lun_link, &lun->lun_deve_list);
 		spin_unlock(&lun->lun_deve_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 
 		kref_put(&orig->pr_kref, target_pr_kref_release);
 		wait_for_completion(&orig->pr_comp);
@@ -394,11 +407,10 @@ int core_enable_device_list_for_node(
 	new->se_lun = lun;
 	new->se_lun_acl = lun_acl;
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-	mutex_unlock(&nacl->lun_entry_mutex);
-
 	spin_lock(&lun->lun_deve_lock);
 	list_add_tail(&new->lun_link, &lun->lun_deve_list);
 	spin_unlock(&lun->lun_deve_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	target_luns_data_has_changed(nacl, new, true);
 	return 0;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0e429e5ef310..d8f4538e48dc7 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -266,6 +266,15 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	kref_get(&acl->acl_kref);
 	acl->dynamic_node_acl = 1;
 
+	/*
+	 * Publish the dynamic NodeACL on tpg->acl_node_list before creating
+	 * its demo-mode MappedLUN dev entries below, so that a concurrent LUN
+	 * teardown sweep (core_clear_lun_from_tpg(), which walks acl_node_list)
+	 * can observe and disable those dev entries.  Otherwise a dev entry can
+	 * be left on an se_lun->lun_deve_list that is about to be freed.
+	 */
+	target_add_node_acl(acl);
+
 	/*
 	 * Here we only create demo-mode MappedLUNs from the active
 	 * TPG LUNs if the fabric is not explicitly asking for
@@ -275,7 +284,6 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) != 1))
 		core_tpg_add_node_to_devs(acl, tpg, NULL);
 
-	target_add_node_acl(acl);
 	return acl;
 }
 EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
-- 
2.53.0



