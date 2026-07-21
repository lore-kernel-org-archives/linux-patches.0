Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0644071F5;
	Tue, 21 Jul 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654902; cv=none; b=EIjjloWc4jpPCXMawXmTU+1EVzuV1dg3A53GalH7FxK9s1u09khKM9RA8/u8ksYCZ2a741nSHR1czN7VCLBNcNx1+2mu8gvMUYL58Oc0G9adSkce3ESsDr2GBo6x/7Y2hmuo6KKvaghweh5dnk2ztl5rr9NwZdf1ha33iwOGnnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654902; c=relaxed/simple;
	bh=t5uNYElaBNJyf8py/oV0qH5xo5UL1/3oPRn2hqn2tdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uG2JoaEbVN4nH+K+ymUoTO9Z+pGxqZQV+b30ET7HPXU88q537CvjF3CDsPgRK8QFFkaYrZdYDgRHwizkP2Ji5RGzQTqK3XvEi04XUvoXoGYiy4Q3EnNP+pYcPxXYA3js9PNXeHVfVUw7u4JdzNxJt8pYUeteKM8ySCOHYmSjQsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3qG1pAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3qG1pAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB511F000E9;
	Tue, 21 Jul 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654899;
	bh=5Z60MNBEZ+pbhlUOpOCAWwn5wamDlJtW16VBqzynctE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3qG1pAcRBncfUsPUKG2QwC15G42cUdjFvfPGXCTkhgK76r4brA5jT3QDufWD9lxM
	 48QBcLRLTeUW8lwAfsvgfQ2sTxM0B1weXE7ZlFkEoYiJSDcyiIYFeNjkkJ64bi92J/
	 dkfjWzzuyGzShHLXm8rj4AZ99/VY8zfLNGa3U+bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Chen Yu <yu.c.chen@intel.com>,
	stable@kernel.org
Subject: [PATCH 7.1 1879/2077] fs/resctrl: Fix use-after-free during unmount
Date: Tue, 21 Jul 2026 17:25:52 +0200
Message-ID: <20260721152637.046953393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 52fce648607e0d6a76eeb443d78708c49df1c554 upstream.

During unmount or failure teardown all mon_data structures that contain
monitoring event file private data are freed after which kernfs nodes are
removed. However, the RDT_DELETED flag is never set for the statically
allocated default resource group.

A concurrent reader of an event file associated with the default resource
group may, after dropping kernfs active protection, block on rdtgroup_mutex
while unmount proceeds to free the file private data and destroy the kernfs
node without waiting for the reader.

When the mutex is released, the reader wakes up, observes that RDT_DELETED
is not set for the default group, and dereferences the already-freed
file private data.

The scenario can be depicted as follows:
  CPU0                                      CPU1
   /*
    * Default resource group's
    * monitoring data accessible via
    * kernfs file with kernfs_node::priv
    * pointing to a struct mon_data.
    * User opens the file for reading.
    */
   rdtgroup_mondata_show()                 /* arch encounters fatal error */
    rdtgroup_kn_lock_live()                 resctrl_exit()
     atomic_inc(&rdtgroup_default.waitcount) cpus_read_lock()
     kernfs_break_active_protection(kn)      mutex_lock(&rdtgroup_mutex)
     cpus_read_lock()                        resctrl_fs_teardown()
     mutex_lock(&rdtgroup_mutex)              rmdir_all_sub()
                                              mon_put_kn_priv()
                                               /* Delete all mon_data structures */
                                              rdtgroup_destroy_root()
                                               kernfs_destroy_root()
                                               rdtgroup_default.kn = NULL
                                             mutex_unlock(&rdtgroup_mutex)
     /*
      * rdtgroup_default.flags is empty so
      * rdtgroup_kn_lock_live() returns
      * &rdtgroup_default
      */
     md = of->kn->priv;

     /* md points to freed mon_data */

Set RDT_DELETED for the default group unconditionally since the flag does
not lead to the freeing of this statically allocated group.

Do not allow a new resctrl mount if there are any waiters on default group
of previous mount. A new mount will re-initialize the default group that
would appear to waiters from previous mount as though the default group is
accessible causing them to access the mon_data structures from the previous
mount that have been removed.

Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
Closes: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Cc: <stable@kernel.org>
Link: https://patch.msgid.link/49a2ca3ca688f27e1a646cf90e1dc69287021127.1783377598.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/resctrl/rdtgroup.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -585,14 +585,20 @@ unlock:
  *
  * On resource group creation via a mkdir, an extra kernfs_node reference is
  * taken to ensure that the rdtgroup structure remains accessible for the
- * rdtgroup_kn_unlock() calls where it is removed.
+ * rdtgroup_kn_unlock() calls where it is removed. The default group is
+ * statically allocated: it does not have an extra reference but will have
+ * RDT_DELETED set on unmount to support safe access to its associated files
+ * via rdtgroup_kn_lock_live/rdtgroup_kn_unlock().
  *
- * Drop the extra reference here, then free the rdtgroup structure.
+ * For all but the default group: drop the extra reference, then free the
+ * rdtgroup structure.
  *
  * Return: void
  */
 static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
+	if (rdtgrp == &rdtgroup_default)
+		return;
 	kernfs_put(rdtgrp->kn);
 	kfree(rdtgrp);
 }
@@ -2802,6 +2808,12 @@ static int rdt_get_tree(struct fs_contex
 		goto out;
 	}
 
+	/* Avoid races from pending operations from a previous mount */
+	if (atomic_read(&rdtgroup_default.waitcount) != 0) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = setup_rmid_lru_list();
 	if (ret)
 		goto out;
@@ -3164,6 +3176,7 @@ static void resctrl_fs_teardown(void)
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	rdtgroup_default.flags = RDT_DELETED;
 	closid_exit();
 	schemata_list_destroy();
 	rdtgroup_destroy_root();
@@ -4264,6 +4277,7 @@ static int rdtgroup_setup_root(struct rd
 
 	ctx->kfc.root = rdt_root;
 	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
+	rdtgroup_default.flags = 0;
 
 	return 0;
 }


