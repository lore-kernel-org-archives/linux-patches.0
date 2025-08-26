Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A1F2BAF7;
	Tue, 26 Aug 2025 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213240; cv=none; b=TGkAm69nEdgRro8wsZV+j+hVb6OMo4Er3SQXq/8QJ+j5kGhdWL5wW7NY9s0tA7/mMy5KYXkMJgV46h+A/9A6qMkQZWeigMbjyC1OtVfkzQ2IBjwkXAJfufqhTxIqwM8OzHuHqirzlXqWzWJLvMdgYxXNb+QPNBKYVbo5ijuVUbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213240; c=relaxed/simple;
	bh=9/ph2HvZDyPoEpaOqguj1gUoGUsW6lKS6WONmtP/xZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAeB32Cp+TyH49YkHtE6eZvSuixudR6itlMqKgbMWEHsq5Gsfaj6pbBFGBwilz7j2cw2AGD4g5H0JbdlnP7X/0iIZb2KzsIZNvgWrpzpJR/TId2WMwKJYgKZfN6GTrDbvXhW+puY6++uncrkesKVIZ5v+CaWeD6WzLenZcxlHi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fuw+TilF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fuw+TilF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD812C4CEF1;
	Tue, 26 Aug 2025 13:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213238;
	bh=9/ph2HvZDyPoEpaOqguj1gUoGUsW6lKS6WONmtP/xZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fuw+TilFC5hNDw3V1+QjBtXY8lhtry8zLKbjhLqITyTSPvXMfEe9xUwN5ZljT/uIW
	 Gm52w9NS8LKIlj0GqYX9URJ00davs8NgC0Q1yGVil3PARqzKrFWqJ8WbxpWD+EieO7
	 WOCVWuMlO/q3CXxPA8yM+OkeQCLGP3gvxAhTtCDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/587] f2fs: check the generic conditions first
Date: Tue, 26 Aug 2025 13:07:02 +0200
Message-ID: <20250826110959.872874555@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit e23ab8028de0d92df5921a570f5212c0370db3b5 ]

Let's return errors caught by the generic checks. This fixes generic/494 where
it expects to see EBUSY by setattr_prepare instead of EINVAL by f2fs for active
swapfile.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8f0cb7c7eede..031015823acb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -991,6 +991,18 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
+	err = setattr_prepare(idmap, dentry, attr);
+	if (err)
+		return err;
+
+	err = fscrypt_prepare_setattr(dentry, attr);
+	if (err)
+		return err;
+
+	err = fsverity_prepare_setattr(dentry, attr);
+	if (err)
+		return err;
+
 	if (unlikely(IS_IMMUTABLE(inode)))
 		return -EPERM;
 
@@ -1008,18 +1020,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			return -EINVAL;
 	}
 
-	err = setattr_prepare(idmap, dentry, attr);
-	if (err)
-		return err;
-
-	err = fscrypt_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
-	err = fsverity_prepare_setattr(dentry, attr);
-	if (err)
-		return err;
-
 	if (is_quota_modification(idmap, inode, attr)) {
 		err = f2fs_dquot_initialize(inode);
 		if (err)
-- 
2.39.5



