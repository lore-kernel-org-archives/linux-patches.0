Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF48200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUX68Fci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E6CC433C7;
	Mon,  6 Nov 2023 13:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276136;
	bh=xt6mevd+3YddSgYc/REYs86p3Rj04KEXmsrgbOPMwQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUX68FciEddARRX6aPKNb9qYz4Fh3At/l6MRvSuwJi0I+o3NiurKmVj/oZ5nzHqzD
	 c0yVUBj70g6C4sZHoEkqaMvBj1Z24KX4JOFxhvS/IIGnEtIRh2dkrpRysNvyPrVVyZ
	 EXx/njBzpl/HWg0HwdJinl5S/tojZA9y8ShJf0sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <akaher@vmware.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 06/30] eventfs: Save ownership and mode
Date: Mon,  6 Nov 2023 14:03:24 +0100
Message-ID: <20231106130258.145607498@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
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

commit 28e12c09f5aa081b2d13d1340e3610070b6c624d upstream

Now that inodes and dentries are created on the fly, they are also
reclaimed on memory pressure. Since the ownership and file mode are saved
in the inode, if they are freed, any changes to the ownership and mode
will be lost.

To counter this, if the user changes the permissions or ownership, save
them, and when creating the inodes again, restore those changes.

Link: https://lkml.kernel.org/r/20231101172649.691841445@goodmis.org

Cc: stable@vger.kernel.org
Cc: Ajay Kaher <akaher@vmware.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 63940449555e7 ("eventfs: Implement eventfs lookup, read, open functions")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |  107 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 91 insertions(+), 16 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -40,6 +40,8 @@ struct eventfs_inode {
  * @data:	something that the caller will want to get to later on
  * @is_freed:	Flag set if the eventfs is on its way to be freed
  * @mode:	the permission that the file or directory should have
+ * @uid:	saved uid if changed
+ * @gid:	saved gid if changed
  */
 struct eventfs_file {
 	const char			*name;
@@ -61,11 +63,22 @@ struct eventfs_file {
 	void				*data;
 	unsigned int			is_freed:1;
 	unsigned int			mode:31;
+	kuid_t				uid;
+	kgid_t				gid;
 };
 
 static DEFINE_MUTEX(eventfs_mutex);
 DEFINE_STATIC_SRCU(eventfs_srcu);
 
+/* Mode is unsigned short, use the upper bits for flags */
+enum {
+	EVENTFS_SAVE_MODE	= BIT(16),
+	EVENTFS_SAVE_UID	= BIT(17),
+	EVENTFS_SAVE_GID	= BIT(18),
+};
+
+#define EVENTFS_MODE_MASK	(EVENTFS_SAVE_MODE - 1)
+
 static struct dentry *eventfs_root_lookup(struct inode *dir,
 					  struct dentry *dentry,
 					  unsigned int flags);
@@ -73,8 +86,54 @@ static int dcache_dir_open_wrapper(struc
 static int dcache_readdir_wrapper(struct file *file, struct dir_context *ctx);
 static int eventfs_release(struct inode *inode, struct file *file);
 
+static void update_attr(struct eventfs_file *ef, struct iattr *iattr)
+{
+	unsigned int ia_valid = iattr->ia_valid;
+
+	if (ia_valid & ATTR_MODE) {
+		ef->mode = (ef->mode & ~EVENTFS_MODE_MASK) |
+			(iattr->ia_mode & EVENTFS_MODE_MASK) |
+			EVENTFS_SAVE_MODE;
+	}
+	if (ia_valid & ATTR_UID) {
+		ef->mode |= EVENTFS_SAVE_UID;
+		ef->uid = iattr->ia_uid;
+	}
+	if (ia_valid & ATTR_GID) {
+		ef->mode |= EVENTFS_SAVE_GID;
+		ef->gid = iattr->ia_gid;
+	}
+}
+
+static int eventfs_set_attr(struct mnt_idmap *idmap, struct dentry *dentry,
+			     struct iattr *iattr)
+{
+	struct eventfs_file *ef;
+	int ret;
+
+	mutex_lock(&eventfs_mutex);
+	ef = dentry->d_fsdata;
+	/* The LSB is set when the eventfs_inode is being freed */
+	if (((unsigned long)ef & 1UL) || ef->is_freed) {
+		/* Do not allow changes if the event is about to be removed. */
+		mutex_unlock(&eventfs_mutex);
+		return -ENODEV;
+	}
+
+	ret = simple_setattr(idmap, dentry, iattr);
+	if (!ret)
+		update_attr(ef, iattr);
+	mutex_unlock(&eventfs_mutex);
+	return ret;
+}
+
 static const struct inode_operations eventfs_root_dir_inode_operations = {
 	.lookup		= eventfs_root_lookup,
+	.setattr	= eventfs_set_attr,
+};
+
+static const struct inode_operations eventfs_file_inode_operations = {
+	.setattr	= eventfs_set_attr,
 };
 
 static const struct file_operations eventfs_file_operations = {
@@ -85,10 +144,20 @@ static const struct file_operations even
 	.release	= eventfs_release,
 };
 
+static void update_inode_attr(struct inode *inode, struct eventfs_file *ef)
+{
+	inode->i_mode = ef->mode & EVENTFS_MODE_MASK;
+
+	if (ef->mode & EVENTFS_SAVE_UID)
+		inode->i_uid = ef->uid;
+
+	if (ef->mode & EVENTFS_SAVE_GID)
+		inode->i_gid = ef->gid;
+}
+
 /**
  * create_file - create a file in the tracefs filesystem
- * @name: the name of the file to create.
- * @mode: the permission that the file should have.
+ * @ef: the eventfs_file
  * @parent: parent dentry for this file.
  * @data: something that the caller will want to get to later on.
  * @fop: struct file_operations that should be used for this file.
@@ -104,7 +173,7 @@ static const struct file_operations even
  * If tracefs is not enabled in the kernel, the value -%ENODEV will be
  * returned.
  */
-static struct dentry *create_file(const char *name, umode_t mode,
+static struct dentry *create_file(struct eventfs_file *ef,
 				  struct dentry *parent, void *data,
 				  const struct file_operations *fop)
 {
@@ -112,13 +181,13 @@ static struct dentry *create_file(const
 	struct dentry *dentry;
 	struct inode *inode;
 
-	if (!(mode & S_IFMT))
-		mode |= S_IFREG;
+	if (!(ef->mode & S_IFMT))
+		ef->mode |= S_IFREG;
 
-	if (WARN_ON_ONCE(!S_ISREG(mode)))
+	if (WARN_ON_ONCE(!S_ISREG(ef->mode)))
 		return NULL;
 
-	dentry = eventfs_start_creating(name, parent);
+	dentry = eventfs_start_creating(ef->name, parent);
 
 	if (IS_ERR(dentry))
 		return dentry;
@@ -127,7 +196,10 @@ static struct dentry *create_file(const
 	if (unlikely(!inode))
 		return eventfs_failed_creating(dentry);
 
-	inode->i_mode = mode;
+	/* If the user updated the directory's attributes, use them */
+	update_inode_attr(inode, ef);
+
+	inode->i_op = &eventfs_file_inode_operations;
 	inode->i_fop = fop;
 	inode->i_private = data;
 
@@ -140,7 +212,7 @@ static struct dentry *create_file(const
 
 /**
  * create_dir - create a dir in the tracefs filesystem
- * @name: the name of the file to create.
+ * @ei: the eventfs_inode that represents the directory to create
  * @parent: parent dentry for this file.
  * @data: something that the caller will want to get to later on.
  *
@@ -155,13 +227,14 @@ static struct dentry *create_file(const
  * If tracefs is not enabled in the kernel, the value -%ENODEV will be
  * returned.
  */
-static struct dentry *create_dir(const char *name, struct dentry *parent, void *data)
+static struct dentry *create_dir(struct eventfs_file *ef,
+				 struct dentry *parent, void *data)
 {
 	struct tracefs_inode *ti;
 	struct dentry *dentry;
 	struct inode *inode;
 
-	dentry = eventfs_start_creating(name, parent);
+	dentry = eventfs_start_creating(ef->name, parent);
 	if (IS_ERR(dentry))
 		return dentry;
 
@@ -169,7 +242,8 @@ static struct dentry *create_dir(const c
 	if (unlikely(!inode))
 		return eventfs_failed_creating(dentry);
 
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	update_inode_attr(inode, ef);
+
 	inode->i_op = &eventfs_root_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 	inode->i_private = data;
@@ -306,10 +380,9 @@ create_dentry(struct eventfs_file *ef, s
 		inode_lock(parent->d_inode);
 
 	if (ef->ei)
-		dentry = create_dir(ef->name, parent, ef->data);
+		dentry = create_dir(ef, parent, ef->data);
 	else
-		dentry = create_file(ef->name, ef->mode, parent,
-				     ef->data, ef->fop);
+		dentry = create_file(ef, parent, ef->data, ef->fop);
 
 	if (!lookup)
 		inode_unlock(parent->d_inode);
@@ -475,6 +548,7 @@ static int dcache_dir_open_wrapper(struc
 		if (d) {
 			struct dentry **tmp;
 
+
 			tmp = krealloc(dentries, sizeof(d) * (cnt + 2), GFP_KERNEL);
 			if (!tmp)
 				break;
@@ -549,13 +623,14 @@ static struct eventfs_file *eventfs_prep
 			return ERR_PTR(-ENOMEM);
 		}
 		INIT_LIST_HEAD(&ef->ei->e_top_files);
+		ef->mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
 	} else {
 		ef->ei = NULL;
+		ef->mode = mode;
 	}
 
 	ef->iop = iop;
 	ef->fop = fop;
-	ef->mode = mode;
 	ef->data = data;
 	return ef;
 }


