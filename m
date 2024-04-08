Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5BD7C6C5;
	Mon,  8 Apr 2024 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583981; cv=none; b=HLWfoStR6RJA7gIbSmSCBOx/88G/0s6Oh84gEM1aE203hpUcOe9lbM6nqypVXTSfzrhmx6jlq1t5HzGCztqVzkznt/InV2yTTFdzzdGRYXQUfYDvV02+CoBA08fNUJ4K1uOtbWAuoo1MzCG+pA0VYaH7xoNbkHjLwejZAoshayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583981; c=relaxed/simple;
	bh=ToATflDgHrTJHE1YZuViVgzeD+a9JuhRgQ03zQEIbfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZiaLHUo/SuUvVJjKvGqY+iYtRSAELvP9a4TF/JyGndRH2Zl/IoJ9+f/UY+H4eF8xQTdnUnpGRsgqgxwvbvRA0n90cUM/XIWNC5uKrPo2RQZUeiqeY8zh5RxoPSInX+tTJyj/FcLT4vL9e3SJW2La/hKJtcshk+sJlIdXQAJPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH54EwZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH54EwZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6475C433F1;
	Mon,  8 Apr 2024 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583981;
	bh=ToATflDgHrTJHE1YZuViVgzeD+a9JuhRgQ03zQEIbfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mH54EwZh4I8Vbx6uqY2j49VaHLNpAK88CEPO9wRYn/FDLtOhcHPqjByZH4zYreqzx
	 FgVRTrLPO+qmA1/pY6fqSQuyT12YJ0LWUf6eGbnLDNOwsvaowV0Gx1yMiKE9g76Twq
	 cx11ntmAPYB/Y1mQzZSzN0pBl3+2cwvRNl1TW8us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 310/690] fs/lock: add helper locks_owner_has_blockers to check for blockers
Date: Mon,  8 Apr 2024 14:52:56 +0200
Message-ID: <20240408125410.821039427@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 591502c5cb325b1c6ec59ab161927d606b918aa0 ]

Add helper locks_owner_has_blockers to check if there is any blockers
for a given lockowner.

Reviewed-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/locks.c         | 28 ++++++++++++++++++++++++++++
 include/linux/fs.h |  7 +++++++
 2 files changed, 35 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 4899a4666f24d..f8c4844ebcce4 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -376,6 +376,34 @@ void locks_release_private(struct file_lock *fl)
 }
 EXPORT_SYMBOL_GPL(locks_release_private);
 
+/**
+ * locks_owner_has_blockers - Check for blocking lock requests
+ * @flctx: file lock context
+ * @owner: lock owner
+ *
+ * Return values:
+ *   %true: @owner has at least one blocker
+ *   %false: @owner has no blockers
+ */
+bool locks_owner_has_blockers(struct file_lock_context *flctx,
+		fl_owner_t owner)
+{
+	struct file_lock *fl;
+
+	spin_lock(&flctx->flc_lock);
+	list_for_each_entry(fl, &flctx->flc_posix, fl_list) {
+		if (fl->fl_owner != owner)
+			continue;
+		if (!list_empty(&fl->fl_blocked_requests)) {
+			spin_unlock(&flctx->flc_lock);
+			return true;
+		}
+	}
+	spin_unlock(&flctx->flc_lock);
+	return false;
+}
+EXPORT_SYMBOL_GPL(locks_owner_has_blockers);
+
 /* Free a lock which is not in use. */
 void locks_free_lock(struct file_lock *fl)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f32723d937fb5..9b7ce642d4f08 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1212,6 +1212,8 @@ extern void lease_unregister_notifier(struct notifier_block *);
 struct files_struct;
 extern void show_fd_locks(struct seq_file *f,
 			 struct file *filp, struct files_struct *files);
+extern bool locks_owner_has_blockers(struct file_lock_context *flctx,
+			fl_owner_t owner);
 #else /* !CONFIG_FILE_LOCKING */
 static inline int fcntl_getlk(struct file *file, unsigned int cmd,
 			      struct flock __user *user)
@@ -1352,6 +1354,11 @@ static inline int lease_modify(struct file_lock *fl, int arg,
 struct files_struct;
 static inline void show_fd_locks(struct seq_file *f,
 			struct file *filp, struct files_struct *files) {}
+static inline bool locks_owner_has_blockers(struct file_lock_context *flctx,
+			fl_owner_t owner)
+{
+	return false;
+}
 #endif /* !CONFIG_FILE_LOCKING */
 
 static inline struct inode *file_inode(const struct file *f)
-- 
2.43.0



