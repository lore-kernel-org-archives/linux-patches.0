Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83259DDA9;
	Mon, 27 May 2024 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836457; cv=none; b=DQ0wCElTGLmTEghiWbFH9vJeFOB3ibCPFSV0ewbSGaLyuXp+WVJp3MpJdWEn383RqcwkHwMEtBTu48Z7MPq2daLMmpPx2RUUFzDe8kpiRu5UfBVoSc/XaBneQLAKDc+YtxsM0MXVCSnKag3A7uKZ20Ob0wsTdySMzWD2/yaXnL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836457; c=relaxed/simple;
	bh=JtYSCfuxvkFQxsDMJSGTKqlZu24BJOrYAWa53dgtvts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkU1s6D6PbI+QrfdVdl6S7vRVQcNPsb/J5n8bgoGJlZFzQni/xYvVOjTaN1aUXSedq2kP73f7E8tvCgfAfjLH26OoXnqbuMStblIiWe6sjTZrUo77vNiV7J3V+bp0b7QzEjffln6V2/+JMZ9S+aO1HR6E7QHg3rw2L9Y4ib5TFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+zQGNUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+zQGNUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171E3C32781;
	Mon, 27 May 2024 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836457;
	bh=JtYSCfuxvkFQxsDMJSGTKqlZu24BJOrYAWa53dgtvts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+zQGNUOmzdpyJJGT19HIs9BSWZcenIjNWvF7frQJpuvU0yEt+TVjuz7s8F2dtf6p
	 CgOzR7Fmf+l7uRdDmmWd296G5vB6vKUZu3xvYWn8HTym7KrZD0E0GtU99koDYqVFLy
	 12dNgAwtS0vuPDR8yO4ol4OjonDYL8OJghqGGR7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/427] libfs: Add simple_offset_rename() API
Date: Mon, 27 May 2024 20:51:49 +0200
Message-ID: <20240527185607.737078378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 5a1a25be995e1014abd01600479915683e356f5c ]

I'm about to fix a tmpfs rename bug that requires the use of
internal simple_offset helpers that are not available in mm/shmem.c

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20240415152057.4605-3-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: ad191eb6d694 ("shmem: Fix shmem_rename2()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/libfs.c         | 21 +++++++++++++++++++++
 include/linux/fs.h |  2 ++
 mm/shmem.c         |  3 +--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ab61fae92cde8..c392a6edd3930 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -357,6 +357,27 @@ int simple_offset_empty(struct dentry *dentry)
 	return ret;
 }
 
+/**
+ * simple_offset_rename - handle directory offsets for rename
+ * @old_dir: parent directory of source entry
+ * @old_dentry: dentry of source entry
+ * @new_dir: parent_directory of destination entry
+ * @new_dentry: dentry of destination
+ *
+ * Caller provides appropriate serialization.
+ *
+ * Returns zero on success, a negative errno value on failure.
+ */
+int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry)
+{
+	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
+	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
+
+	simple_offset_remove(old_ctx, old_dentry);
+	return simple_offset_add(new_ctx, old_dentry);
+}
+
 /**
  * simple_offset_rename_exchange - exchange rename with directory offsets
  * @old_dir: parent of dentry being moved
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8dfd53b52744a..b09f141321105 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3340,6 +3340,8 @@ void simple_offset_init(struct offset_ctx *octx);
 int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
 void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
 int simple_offset_empty(struct dentry *dentry);
+int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
+			 struct inode *new_dir, struct dentry *new_dentry);
 int simple_offset_rename_exchange(struct inode *old_dir,
 				  struct dentry *old_dentry,
 				  struct inode *new_dir,
diff --git a/mm/shmem.c b/mm/shmem.c
index 94ab99b6b574a..1f84a41aeb850 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3467,8 +3467,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
 			return error;
 	}
 
-	simple_offset_remove(shmem_get_offset_ctx(old_dir), old_dentry);
-	error = simple_offset_add(shmem_get_offset_ctx(new_dir), old_dentry);
+	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
 	if (error)
 		return error;
 
-- 
2.43.0



