Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91552DF73;
	Mon,  8 Apr 2024 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582799; cv=none; b=gAWsg85YmFP9tvt0FrrioBVFNn9vG2N71B2v9QaLNP9WOL4edwgXh9ylQ1KcNrI0zBfjbRdSl8xG6InZD5Vvx0nlO+MALbHsbreqAwYLqVQczyX37a3FAd1VOvEm2AnWehU5Qae/3M9TJauNdPHVe6uR7g9Fe631EbJz7EwMTB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582799; c=relaxed/simple;
	bh=Xk1aHvoxZBFwL8zjS6cjQ0kN3SOd5GCWppfSuVtM/gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZUdCHHto5TmqZ8AxZRAMECoPU4u7W65x1gqsgUjL6/tt0Fa75+kT/oMtu/pn2I14fHW8wl2wbUgxrtzZN45XROPJZJIzah9aNOobxd63N697/AUzggY/GmhogiDoYJVQwYNXeib8CdrRNKdbOhNFE4H5QkMe+HdtslwMVRLQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7DO280q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7DO280q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7455FC433F1;
	Mon,  8 Apr 2024 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582798;
	bh=Xk1aHvoxZBFwL8zjS6cjQ0kN3SOd5GCWppfSuVtM/gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7DO280qyCh/lBNmGMbY/mYFeCOysAwWi9xN6tpFwKdHfD3eK4VDutS0y+c9f6VFq
	 m+lAh3nig0GmyqsBsmOlZ1VnvWAtLZKvSeN6wdC4dOEx/lnlPZuyUSlhjcg/VANp7l
	 xepCNYW7cw8AmQFiJQzWVbUSoE+ANR/watcAGX+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 167/690] fsnotify: pass dentry instead of inode data
Date: Mon,  8 Apr 2024 14:50:33 +0200
Message-ID: <20240408125405.603520393@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit fd5a3ff49a19aa69e2bc1e26e98037c2d778e61a ]

Define a new data type to pass for event - FSNOTIFY_EVENT_DENTRY.
Use it to pass the dentry instead of it's ->d_inode where available.

This is needed in preparation to the refactor to retrieve the super
block from the data field.  In some cases (i.e. mkdir in kernfs), the
data inode comes from a negative dentry, such that no super block
information would be available. By receiving the dentry itself, instead
of the inode, fsnotify can derive the super block even on these cases.

Link: https://lore.kernel.org/r/20211025192746.66445-3-krisman@collabora.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[Expand explanation in commit message]
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/fsnotify.h         |  5 ++---
 include/linux/fsnotify_backend.h | 16 ++++++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 298fd2bc29e49..70e6b147a76ad 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -39,8 +39,7 @@ static inline int fsnotify_name(__u32 mask, const void *data, int data_type,
 static inline void fsnotify_dirent(struct inode *dir, struct dentry *dentry,
 				   __u32 mask)
 {
-	fsnotify_name(mask, d_inode(dentry), FSNOTIFY_EVENT_INODE,
-		      dir, &dentry->d_name, 0);
+	fsnotify_name(mask, dentry, FSNOTIFY_EVENT_DENTRY, dir, &dentry->d_name, 0);
 }
 
 static inline void fsnotify_inode(struct inode *inode, __u32 mask)
@@ -87,7 +86,7 @@ static inline int fsnotify_parent(struct dentry *dentry, __u32 mask,
  */
 static inline void fsnotify_dentry(struct dentry *dentry, __u32 mask)
 {
-	fsnotify_parent(dentry, mask, d_inode(dentry), FSNOTIFY_EVENT_INODE);
+	fsnotify_parent(dentry, mask, dentry, FSNOTIFY_EVENT_DENTRY);
 }
 
 static inline int fsnotify_file(struct file *file, __u32 mask)
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 1ce66748a2d29..a2db821e8a8f2 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -248,6 +248,7 @@ enum fsnotify_data_type {
 	FSNOTIFY_EVENT_NONE,
 	FSNOTIFY_EVENT_PATH,
 	FSNOTIFY_EVENT_INODE,
+	FSNOTIFY_EVENT_DENTRY,
 };
 
 static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
@@ -255,6 +256,8 @@ static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
 	switch (data_type) {
 	case FSNOTIFY_EVENT_INODE:
 		return (struct inode *)data;
+	case FSNOTIFY_EVENT_DENTRY:
+		return d_inode(data);
 	case FSNOTIFY_EVENT_PATH:
 		return d_inode(((const struct path *)data)->dentry);
 	default:
@@ -262,6 +265,19 @@ static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
 	}
 }
 
+static inline struct dentry *fsnotify_data_dentry(const void *data, int data_type)
+{
+	switch (data_type) {
+	case FSNOTIFY_EVENT_DENTRY:
+		/* Non const is needed for dget() */
+		return (struct dentry *)data;
+	case FSNOTIFY_EVENT_PATH:
+		return ((const struct path *)data)->dentry;
+	default:
+		return NULL;
+	}
+}
+
 static inline const struct path *fsnotify_data_path(const void *data,
 						    int data_type)
 {
-- 
2.43.0



