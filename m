Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07422222A0;
	Mon, 18 Aug 2025 13:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524321; cv=none; b=SjsHg3g+9Od+J8vfMBzY6HEFkNLBsKDGpTItvk76hFoxWv9YNKcJ+xguwcYBW6fet9kAbnNChQjG2So3P4+dP9rkMgY1ANqOswWu9SNMbLxplMKnuIEtcKDMQ/achYJv31Fw4WljFn+GIMmz3ajgwpUy9BBl5LOFN4tVB6/OWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524321; c=relaxed/simple;
	bh=mu4K7T2lAQKt8y2AvksqKpEs5B1TK53NVLiFXFlbHgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8qUmpUpKYG7we39fTTwdoKi+HnDMorbPGjtwv/+ZAbC04vkknt/Q9ER3HYBVBMYyUmYyDjHtIgnAOFvVUSNpjwbDsnx5TxuqQCO3h7MAvwVn18vnCfKpfksWdGudLVbRZjl+HrUejklvTuhdyohiamQBFYVG7xVxn7r0wXVNDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxZINmiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxZINmiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E79C4CEF1;
	Mon, 18 Aug 2025 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524321;
	bh=mu4K7T2lAQKt8y2AvksqKpEs5B1TK53NVLiFXFlbHgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxZINmiqTPSau3o7yKrsK/PUNub8dG2HFKyZ12HzhwqHxuUUl8PFGLFoSezE484SM
	 bwyYyCY5eKNmHXoSShq+ln0pFmK6RVl3Kt/Q+wk1VKO1xLj0EJpQxGrux27EMc3l60
	 Og4ACzOqpZrFetYkAi2efhId/Au89k+oel2kem/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 403/515] f2fs: check the generic conditions first
Date: Mon, 18 Aug 2025 14:46:29 +0200
Message-ID: <20250818124513.928594472@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2de3c886c08..72c8d8cb6fe8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1044,6 +1044,18 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
 
@@ -1062,18 +1074,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



