Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD4514F9C8;
	Tue, 20 Feb 2024 21:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464289; cv=none; b=hHJsg2zjj4vCMGisWt15oTx5VmDshau1sGC/HV524poyd6OcVvyqneR+uzYd3K6jQ3t5x/uwJGxkIwMM1O7lnlzp/sp6WQv8RjZytFRiNVcPFhy4sg2XgZyo386SUe86QZg6rEtNnJUftSXOOElyMi6PMcDCCHGYXLTq9TExJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464289; c=relaxed/simple;
	bh=EVvcKmQ5uq/VUW8Qo+aS6VpmnPfRwzOaH0PXSXNvSYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuFghYLGW4r1+rr8n98bKFn2Lo9S/f6fwiD0QBgWMNgu4TyMW8+NveMj4AZD/4EpNlxL5E2E0KW/A2AFzE7230PdILYD7M5xUGOz8fbfkRPvqYjne+ECkH44BRnTmXGFf3sbG6sSG4PjH5o8bw0/N+MlzZpRQhQ5Q8/klZe0WW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bpx9dKdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bpx9dKdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E200C433F1;
	Tue, 20 Feb 2024 21:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464289;
	bh=EVvcKmQ5uq/VUW8Qo+aS6VpmnPfRwzOaH0PXSXNvSYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bpx9dKdU7BMaSuZLNM+lEWwwGTF8QRjJnONPzx4p7euUV8S2ky5JiSbjhSUgtX6TM
	 /OkUhCTMRlQUzGwe8qJi7FU4dVJgpcpgKEhIaw/GxPTXXLtjpo2vFWtkfSPHgMLdyN
	 zFL8CYyIb8wYpxrevPMqYYRxy73T5w9+49UCI2+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 303/331] tracefs: remove stale update_gid code
Date: Tue, 20 Feb 2024 21:56:59 +0100
Message-ID: <20240220205647.636434942@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 29142dc92c37d3259a33aef15b03e6ee25b0d188 upstream.

The 'eventfs_update_gid()' function is no longer called, so remove it
(and the helper function it uses).

Link: https://lore.kernel.org/all/CAHk-=wj+DsZZ=2iTUkJ-Nojs9fjYMvPs1NuoM3yK7aTDtJfPYQ@mail.gmail.com/

Fixes: 8186fff7ab64 ("tracefs/eventfs: Use root and instance inodes as default ownership")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   38 --------------------------------------
 fs/tracefs/internal.h    |    1 -
 2 files changed, 39 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -281,44 +281,6 @@ static void update_inode_attr(struct den
 		inode->i_gid = attr->gid;
 }
 
-static void update_gid(struct eventfs_inode *ei, kgid_t gid, int level)
-{
-	struct eventfs_inode *ei_child;
-
-	/* at most we have events/system/event */
-	if (WARN_ON_ONCE(level > 3))
-		return;
-
-	ei->attr.gid = gid;
-
-	if (ei->entry_attrs) {
-		for (int i = 0; i < ei->nr_entries; i++) {
-			ei->entry_attrs[i].gid = gid;
-		}
-	}
-
-	/*
-	 * Only eventfs_inode with dentries are updated, make sure
-	 * all eventfs_inodes are updated. If one of the children
-	 * do not have a dentry, this function must traverse it.
-	 */
-	list_for_each_entry_srcu(ei_child, &ei->children, list,
-				 srcu_read_lock_held(&eventfs_srcu)) {
-		if (!ei_child->dentry)
-			update_gid(ei_child, gid, level + 1);
-	}
-}
-
-void eventfs_update_gid(struct dentry *dentry, kgid_t gid)
-{
-	struct eventfs_inode *ei = dentry->d_fsdata;
-	int idx;
-
-	idx = srcu_read_lock(&eventfs_srcu);
-	update_gid(ei, gid, 0);
-	srcu_read_unlock(&eventfs_srcu, idx);
-}
-
 /**
  * create_file - create a file in the tracefs filesystem
  * @name: the name of the file to create.
--- a/fs/tracefs/internal.h
+++ b/fs/tracefs/internal.h
@@ -82,7 +82,6 @@ struct inode *tracefs_get_inode(struct s
 struct dentry *eventfs_start_creating(const char *name, struct dentry *parent);
 struct dentry *eventfs_failed_creating(struct dentry *dentry);
 struct dentry *eventfs_end_creating(struct dentry *dentry);
-void eventfs_update_gid(struct dentry *dentry, kgid_t gid);
 void eventfs_set_ei_status_free(struct tracefs_inode *ti, struct dentry *dentry);
 
 #endif /* _TRACEFS_INTERNAL_H */


