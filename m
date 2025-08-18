Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2781C258ED7;
	Mon, 18 Aug 2025 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522517; cv=none; b=bUDsF+bZyJWwrbdBRx8sBHHcbZA+pH/pR+WQ800svXWXjd6XzwQPDnrPuSKpdGy65m1PX62S+clCE87dteMXQ3qn7KBWg+DsYh+PTQvq9LoKnuY15SyX9k1Kv/Rg/biqS8Wf9tJDV0JgydYJZQHzJImYuMUUjn/DyFs94cuq1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522517; c=relaxed/simple;
	bh=yBqXhEG/5FNxF+vz+hN9ptUrOmUH4sFvE1oNlf9EanI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITCiaUtCQl/skqN9e3bN3ixHgRunoEWUkQ/H0Bt2VygXMw9kp/loc75OytcQtMs7bXdvk+Qb8EBgbai8QvxCtNbtOOxLRi8+vHM2HvRixO1G9BThX8WI7hrN9Sryj2OWMktUv4L9M66hGf1R5uddDs4b5Oc5XtAdCPjKjNcvKcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMQyxlID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMQyxlID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8944FC4CEEB;
	Mon, 18 Aug 2025 13:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522517;
	bh=yBqXhEG/5FNxF+vz+hN9ptUrOmUH4sFvE1oNlf9EanI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMQyxlID6kAqMGzymZvL8Po/Pu7s/Hki3KVv/KWC/lZ3xP+kSX87TJo753OJIOHEd
	 tsNf5Z3P4Ku0KYzqfbkfRstqvAV2AdPgNn3PEzrINLsPAqMV+8PisADUZGtZc5yCpB
	 xI7gkJeyFeBbuHxFWV6vhAUZFRgyTJ717s4DTfF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/444] f2fs: check the generic conditions first
Date: Mon, 18 Aug 2025 14:46:06 +0200
Message-ID: <20250818124501.677628627@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d9037e74631c..fa77841f3e2c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1003,6 +1003,18 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
 
@@ -1020,18 +1032,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



