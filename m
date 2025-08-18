Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05A2322525;
	Mon, 18 Aug 2025 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526024; cv=none; b=NaDR9PjnlP+IXa11zcEYA1leP2rDHmPODBsBPzczfMV4SY+c5IJtGedtHvMwCWYVmmPxuOPcz0wJR05rK4cT5ZLYAgafn1SjjRhQdzQPQT0XLdBsUlQWIMJAvDo+gpdfSWHUNzSdKyD0p9givbticDiq1j9vEK4610HHOY9uAII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526024; c=relaxed/simple;
	bh=Qci8KyMFoBi49LhGFgQApFOaIeppruZnvPD8Y6TMk2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieq9MEWxMWcOrWp0Hs9my0wkl830bImtkefkqOiMoslrEpE7VWpPyazI48iUo3beymvm4GxACjB3c5izEMoBndTHXJPdWCsNWkyVzC2b9TzmAosc3hlr8T364OJGTnkeNDeDtayr2+SdgZ9pF3gKUhlH9RgLMikFWmoN94enV5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzoJ1oZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzoJ1oZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB37C113D0;
	Mon, 18 Aug 2025 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526024;
	bh=Qci8KyMFoBi49LhGFgQApFOaIeppruZnvPD8Y6TMk2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzoJ1oZ4yTxRFzJCEfXSOTDcibPQWvImcekZybb2OoF5S7AG8EHLKIYD8gufutr4S
	 +xGAdKa7aww6yaM6pV0cBn9OUmROX59WZMa+ewxkf/LQCGvGa3+XAaF9r/B+68T0me
	 vChGuToLN+WBIPPo0NU871M8YSsotJYx4oJ6jia0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 436/570] f2fs: check the generic conditions first
Date: Mon, 18 Aug 2025 14:47:03 +0200
Message-ID: <20250818124522.621560492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 696131e655ed..bb3fd6a8416f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1047,6 +1047,18 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
 
@@ -1065,18 +1077,6 @@ int f2fs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



