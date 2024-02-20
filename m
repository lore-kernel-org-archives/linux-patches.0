Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B1214F9C8;
	Tue, 20 Feb 2024 21:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464266; cv=none; b=FrbeTBb08thcp9+zuV1OUJ/ovWPLSGlBVdLCXDrSzlDcAPlDE2PH7v5ClFbTNCDhldTNAzfZDwfsWpTokaTY9zdgyfY9j8WOhlFELJSVC5RGYQ4WFj8aWj59EKtGeJoFDrkF2g/6/DHmEJnzijdZVGGHKsnc5lPLKo+NRYe4fT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464266; c=relaxed/simple;
	bh=981T6jj1yGjg5CqwJlSuXCUNICKFm+DfQ4QhigZBGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C13p7AB7x3tlKdCY6jbcvkvuYLoQ7QrB0Wb6ysPUnZKpJUrM3jkZvvYzjW0dQcAyUcOWF/cpkqBvnp0EUPuThvsfUuMedrwjk5Pr0eOKLGCFDY/IWZ8ytJkuCPaXFZQ3b29rRDwke1puXOt5E1iZfjn3noWc+TcsT1AvdcnLwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyD95KFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyD95KFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F132C433F1;
	Tue, 20 Feb 2024 21:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464266;
	bh=981T6jj1yGjg5CqwJlSuXCUNICKFm+DfQ4QhigZBGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyD95KFZiGO6R+S6GEi7Lr4KO/rzOn2hb/9Im4GTm+NP6LkU5USPsoLINyil2Fg2C
	 w4M9F27bCG4rD9ZEumEpnoq2TcFEqOiTkRLPFIZRjhU6XbNCHvZ1H/qhXNOUYJuyji
	 uzOs+drYnMi/IEkbjF5tB1g53XdRBnWFzconKINA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <akaher@vmware.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 275/331] eventfs: Test for ei->is_freed when accessing ei->dentry
Date: Tue, 20 Feb 2024 21:56:31 +0100
Message-ID: <20240220205646.534925958@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 77a06c33a22d13f3a6e31f06f6ee6bca666e6898 upstream.

The eventfs_inode (ei) is protected by SRCU, but the ei->dentry is not. It
is protected by the eventfs_mutex. Anytime the eventfs_mutex is released,
and access to the ei->dentry needs to be done, it should first check if
ei->is_freed is set under the eventfs_mutex. If it is, then the ei->dentry
is invalid and must not be used. The ei->dentry must only be accessed
under the eventfs_mutex and after checking if ei->is_freed is set.

When the ei is being freed, it will (under the eventfs_mutex) set is_freed
and at the same time move the dentry to a free list to be cleared after
the eventfs_mutex is released. This means that any access to the
ei->dentry must check first if ei->is_freed is set, because if it is, then
the dentry is on its way to be freed.

Also add comments to describe this better.

Link: https://lore.kernel.org/all/CA+G9fYt6pY+tMZEOg=SoEywQOe19fGP3uR15SGowkdK+_X85Cg@mail.gmail.com/
Link: https://lore.kernel.org/all/CA+G9fYuDP3hVQ3t7FfrBAjd_WFVSurMgCepTxunSJf=MTe=6aA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20231101172649.477608228@goodmis.org

Cc: Ajay Kaher <akaher@vmware.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 5790b1fb3d672 ("eventfs: Remove eventfs_file and just use eventfs_inode")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Beau Belgrave <beaub@linux.microsoft.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   45 +++++++++++++++++++++++++++++++++++++++------
 fs/tracefs/internal.h    |    3 ++-
 2 files changed, 41 insertions(+), 7 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -24,7 +24,20 @@
 #include <linux/delay.h>
 #include "internal.h"
 
+/*
+ * eventfs_mutex protects the eventfs_inode (ei) dentry. Any access
+ * to the ei->dentry must be done under this mutex and after checking
+ * if ei->is_freed is not set. The ei->dentry is released under the
+ * mutex at the same time ei->is_freed is set. If ei->is_freed is set
+ * then the ei->dentry is invalid.
+ */
 static DEFINE_MUTEX(eventfs_mutex);
+
+/*
+ * The eventfs_inode (ei) itself is protected by SRCU. It is released from
+ * its parent's list and will have is_freed set (under eventfs_mutex).
+ * After the SRCU grace period is over, the ei may be freed.
+ */
 DEFINE_STATIC_SRCU(eventfs_srcu);
 
 static struct dentry *eventfs_root_lookup(struct inode *dir,
@@ -239,6 +252,10 @@ create_file_dentry(struct eventfs_inode
 	bool invalidate = false;
 
 	mutex_lock(&eventfs_mutex);
+	if (ei->is_freed) {
+		mutex_unlock(&eventfs_mutex);
+		return NULL;
+	}
 	/* If the e_dentry already has a dentry, use it */
 	if (*e_dentry) {
 		/* lookup does not need to up the ref count */
@@ -312,6 +329,8 @@ static void eventfs_post_create_dir(stru
 	struct eventfs_inode *ei_child;
 	struct tracefs_inode *ti;
 
+	lockdep_assert_held(&eventfs_mutex);
+
 	/* srcu lock already held */
 	/* fill parent-child relation */
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
@@ -325,6 +344,7 @@ static void eventfs_post_create_dir(stru
 
 /**
  * create_dir_dentry - Create a directory dentry for the eventfs_inode
+ * @pei: The eventfs_inode parent of ei.
  * @ei: The eventfs_inode to create the directory for
  * @parent: The dentry of the parent of this directory
  * @lookup: True if this is called by the lookup code
@@ -332,12 +352,17 @@ static void eventfs_post_create_dir(stru
  * This creates and attaches a directory dentry to the eventfs_inode @ei.
  */
 static struct dentry *
-create_dir_dentry(struct eventfs_inode *ei, struct dentry *parent, bool lookup)
+create_dir_dentry(struct eventfs_inode *pei, struct eventfs_inode *ei,
+		  struct dentry *parent, bool lookup)
 {
 	bool invalidate = false;
 	struct dentry *dentry = NULL;
 
 	mutex_lock(&eventfs_mutex);
+	if (pei->is_freed || ei->is_freed) {
+		mutex_unlock(&eventfs_mutex);
+		return NULL;
+	}
 	if (ei->dentry) {
 		/* If the dentry already has a dentry, use it */
 		dentry = ei->dentry;
@@ -440,7 +465,7 @@ static struct dentry *eventfs_root_looku
 	 */
 	mutex_lock(&eventfs_mutex);
 	ei = READ_ONCE(ti->private);
-	if (ei)
+	if (ei && !ei->is_freed)
 		ei_dentry = READ_ONCE(ei->dentry);
 	mutex_unlock(&eventfs_mutex);
 
@@ -454,7 +479,7 @@ static struct dentry *eventfs_root_looku
 		if (strcmp(ei_child->name, name) != 0)
 			continue;
 		ret = simple_lookup(dir, dentry, flags);
-		create_dir_dentry(ei_child, ei_dentry, true);
+		create_dir_dentry(ei, ei_child, ei_dentry, true);
 		created = true;
 		break;
 	}
@@ -588,7 +613,7 @@ static int dcache_dir_open_wrapper(struc
 
 	list_for_each_entry_srcu(ei_child, &ei->children, list,
 				 srcu_read_lock_held(&eventfs_srcu)) {
-		d = create_dir_dentry(ei_child, parent, false);
+		d = create_dir_dentry(ei, ei_child, parent, false);
 		if (d) {
 			ret = add_dentries(&dentries, d, cnt);
 			if (ret < 0)
@@ -705,12 +730,20 @@ struct eventfs_inode *eventfs_create_dir
 	ei->nr_entries = size;
 	ei->data = data;
 	INIT_LIST_HEAD(&ei->children);
+	INIT_LIST_HEAD(&ei->list);
 
 	mutex_lock(&eventfs_mutex);
-	list_add_tail(&ei->list, &parent->children);
-	ei->d_parent = parent->dentry;
+	if (!parent->is_freed) {
+		list_add_tail(&ei->list, &parent->children);
+		ei->d_parent = parent->dentry;
+	}
 	mutex_unlock(&eventfs_mutex);
 
+	/* Was the parent freed? */
+	if (list_empty(&ei->list)) {
+		free_ei(ei);
+		ei = NULL;
+	}
 	return ei;
 }
 
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -24,6 +24,7 @@ struct tracefs_inode {
  * @d_children: The array of dentries to represent the files when created
  * @data:	The private data to pass to the callbacks
  * @is_freed:	Flag set if the eventfs is on its way to be freed
+ *                Note if is_freed is set, then dentry is corrupted.
  * @nr_entries: The number of items in @entries
  */
 struct eventfs_inode {
@@ -31,7 +32,7 @@ struct eventfs_inode {
 	const struct eventfs_entry	*entries;
 	const char			*name;
 	struct list_head		children;
-	struct dentry			*dentry;
+	struct dentry			*dentry; /* Check is_freed to access */
 	struct dentry			*d_parent;
 	struct dentry			**d_children;
 	void				*data;


