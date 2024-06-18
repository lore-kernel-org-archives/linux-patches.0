Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE88B156972;
	Tue, 18 Jun 2024 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715598; cv=none; b=j9HD71yv7Ek6XQxxBmIuS00zj/stqqMfHAQm3VcIQWzkjxWUUlPQSS67R8cBE7ISfHvnR8j/h4v6HaVqHFOR3tZJWspucPRRE+iKfKynF1aSqmJUmqxegNMrY7uNAPJZSSHnhKGCNVhu8molsf76orXDiis+RTzSAP3ovc731fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715598; c=relaxed/simple;
	bh=cWNCCeBsQc1dFbAfJI2yf8CpyOiuy7tOVZFeznRhnFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqPNTeGkM8pLagGFCu0zQZqTUNTYmm8ZUXl7klEW1/HWJLi+mw8h5cpr4UGz4Y+a3l6WSCib4uy0oLqN0nJ1FRmH/qWaSzADGHvKGdHhgaKZ3KJfnEX3IIfLrCnXmy6fDdzn1jBlV5UMfug8u+2OL6/ld6kdOji6F+hmmo2uOSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZLnJXpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZLnJXpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C34EC32786;
	Tue, 18 Jun 2024 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715597;
	bh=cWNCCeBsQc1dFbAfJI2yf8CpyOiuy7tOVZFeznRhnFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZLnJXptCSpI6BZCfezTvPrOfbA/DxgfeYTQBXhukclS5xOHcDFNWHpBk5SR9nDda
	 OnYZnjFa/b3Ci129tFN66Zn3vIRCjG1CULZmDpoLrT2Eg2suNRt5HqIRdFvP7B93CT
	 IwO2knuny6vMwMG+eU/nIu4A4EX6Jp3jdWAQ3sfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/770] fsnotify: pass dentry instead of inode data
Date: Tue, 18 Jun 2024 14:33:35 +0200
Message-ID: <20240618123421.241484927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fsnotify.h         |  5 ++---
 include/linux/fsnotify_backend.h | 16 ++++++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 211463715e29d..e969a23f70631 100644
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



