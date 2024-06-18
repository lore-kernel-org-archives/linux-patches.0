Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391441BF38;
	Tue, 18 Jun 2024 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715621; cv=none; b=U3b4jfj+z5ZZ5+SsbeoCksZzdCAqgRkkFuHqSu0j2qo7fknZxCxqzylG1cgd23HpCY11Bj2JOKW9daPiOwskM2E3E5lwLfKi621GpKCIncxRLm8z+cePJHQUPUTBq06qLsW16dTQH4G8C0VF7iGFe7ZXZgFN6Qfq8DOMO2+C3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715621; c=relaxed/simple;
	bh=POfCseqqSBahYblox4z81NH438Q7Jv/0cIRRH1dZgzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdTZOCXTH5R4Gbwt7m2SYBWx+Tfrhde5T4YrsnVP15XM2Cy3xihTL7bgIZnb2GPAxnMNaEfMr/eoddiGbGBC4yFjCS+6s4DbLXl9H8IBev53yb2kdCyeHPkaIIHMLZKypARahVX7s5QQnBSkDO9WGUOohCGdQPC88vFK1S22KwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uw8GoDPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uw8GoDPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3333C3277B;
	Tue, 18 Jun 2024 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715621;
	bh=POfCseqqSBahYblox4z81NH438Q7Jv/0cIRRH1dZgzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw8GoDPE0HhTAzWeF1ULEE5L/GA1zTkaLGGqk8VGYoiqY/jhvEXVoa+8mFENi8XAD
	 ZSGB9nUWFqJ13u9icNQusX1so7F15z86qWCqqQqbWQm13zwMdRnQUYDld2PzIP9WeO
	 E/msDswBZFCnRUN3vdKjpTrLTKbpqTi1e5Z4wCok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 370/770] fsnotify: Retrieve super block from the data field
Date: Tue, 18 Jun 2024 14:33:43 +0200
Message-ID: <20240618123421.549261678@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 29335033c574a15334015d8c4e36862cff3d3384 ]

Some file system events (i.e. FS_ERROR) might not be associated with an
inode or directory.  For these, we can retrieve the super block from the
data field.  But, since the super_block is available in the data field
on every event type, simplify the code to always retrieve it from there,
through a new helper.

Link: https://lore.kernel.org/r/20211025192746.66445-11-krisman@collabora.com
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fsnotify.c             |  7 +++----
 include/linux/fsnotify_backend.h | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 963e6ce75b961..fde3a1115a170 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -455,16 +455,16 @@ static void fsnotify_iter_next(struct fsnotify_iter_info *iter_info)
  *		@file_name is relative to
  * @file_name:	optional file name associated with event
  * @inode:	optional inode associated with event -
- *		either @dir or @inode must be non-NULL.
- *		if both are non-NULL event may be reported to both.
+ *		If @dir and @inode are both non-NULL, event may be
+ *		reported to both.
  * @cookie:	inotify rename cookie
  */
 int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 	     const struct qstr *file_name, struct inode *inode, u32 cookie)
 {
 	const struct path *path = fsnotify_data_path(data, data_type);
+	struct super_block *sb = fsnotify_data_sb(data, data_type);
 	struct fsnotify_iter_info iter_info = {};
-	struct super_block *sb;
 	struct mount *mnt = NULL;
 	struct inode *parent = NULL;
 	int ret = 0;
@@ -483,7 +483,6 @@ int fsnotify(__u32 mask, const void *data, int data_type, struct inode *dir,
 		 */
 		parent = dir;
 	}
-	sb = inode->i_sb;
 
 	/*
 	 * Optimization: srcu_read_lock() has a memory barrier which can
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index b323d0c4b9671..035438fe4a435 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -289,6 +289,21 @@ static inline const struct path *fsnotify_data_path(const void *data,
 	}
 }
 
+static inline struct super_block *fsnotify_data_sb(const void *data,
+						   int data_type)
+{
+	switch (data_type) {
+	case FSNOTIFY_EVENT_INODE:
+		return ((struct inode *)data)->i_sb;
+	case FSNOTIFY_EVENT_DENTRY:
+		return ((struct dentry *)data)->d_sb;
+	case FSNOTIFY_EVENT_PATH:
+		return ((const struct path *)data)->dentry->d_sb;
+	default:
+		return NULL;
+	}
+}
+
 enum fsnotify_obj_type {
 	FSNOTIFY_OBJ_TYPE_INODE,
 	FSNOTIFY_OBJ_TYPE_PARENT,
-- 
2.43.0



