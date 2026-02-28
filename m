Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A6332AABE;
	Sat, 28 Feb 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301274; cv=none; b=uU2ggVnOyATXt2jPKzObNf4519/tLqwVLiP53z0VMjR4hIAJ1tSla6k0N9ECuM3nCQdZdsspZaVXUm+yz4R9iM+DJszCuuhBEIBeRaKbP3odX78uuujsMp+/TPoi0ETrmB56H4Sf0ObgCxycP0XXSuOeXq6E3KkMXHG4W3O/dwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301274; c=relaxed/simple;
	bh=NB5XY87O7EfO6zDXO0usrFrFzoKKA8vAHWquwHOy5uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkaB8WIY7Tm7AIBmQAcwRoOw6J5PWZjW00ZbpVURd4pG1mgZ8YVBfn9NDw2OQ6gn4DJbBe2HOWvuTVqPwrmzC3VNOxstwZvvKGP0DyJlTphhKyaY08mKsHAV8JUc4mTdu9onhk8uUT9p5eqGLRFcj2A4CmVqPgstrOxLx7aJHQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECmkLmJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECmkLmJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E31C19424;
	Sat, 28 Feb 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301273;
	bh=NB5XY87O7EfO6zDXO0usrFrFzoKKA8vAHWquwHOy5uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECmkLmJVSVHE9rXPZHHyaPuEX+V4DLwfQHPTTr678EDc1tq7LTb8L8f9Uc96S0cpj
	 rqfVx9W46bZ1y0aLhaukpyML+tcC34Jb3HXkL7r5npmtMcIGohOftaK4JLcCzkMd2X
	 8Q/VvfVtPUe4I8inEIH7PEPTE1hc0Mi/ZnLXBdqytOztcsS1fSqOR0/cCw3OGPqPQQ
	 C/REGDkToR62OpCPtReYSh0TnlkuBesBSNMUUl2PDGQpSLKcp4M6awlJU0JYJEHxZZ
	 RUyN7wzXv4zJdcV0iW9r1m6yq6ZbbUnlYIOvQ5qDMCY7BULf3paHMxbyt6VXUA4Cao
	 dNIgCeM4pMnVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>,
	stable@vger.kernel.org,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 458/752] hfsplus: ensure sb->s_fs_info is always cleaned up
Date: Sat, 28 Feb 2026 12:42:49 -0500
Message-ID: <20260228174750.1542406-458-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>

[ Upstream commit 126fb0ce99431126b44a6c360192668c818f641f ]

When hfsplus was converted to the new mount api a bug was introduced by
changing the allocation pattern of sb->s_fs_info. If setup_bdev_super()
fails after a new superblock has been allocated by sget_fc(), but before
hfsplus_fill_super() takes ownership of the filesystem-specific s_fs_info
data it was leaked.

Fix this by freeing sb->s_fs_info in hfsplus_kill_super().

Cc: stable@vger.kernel.org
Fixes: 432f7c78cb00 ("hfsplus: convert hfsplus to use the new mount api")
Reported-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mehdi Ben Hadj Khelifa <mehdi.benhadjkhelifa@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20251201222843.82310-3-mehdi.benhadjkhelifa@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index bb819ae608fd9..5230d368bd4f2 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -350,8 +350,6 @@ static void hfsplus_put_super(struct super_block *sb)
 	hfs_btree_close(sbi->ext_tree);
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
-	call_rcu(&sbi->rcu, delayed_free);
-
 	hfs_dbg("finished\n");
 }
 
@@ -656,7 +654,6 @@ static int hfsplus_fill_super(struct super_block *sb, struct fs_context *fc)
 out_unload_nls:
 	unload_nls(sbi->nls);
 	unload_nls(nls);
-	kfree(sbi);
 	return err;
 }
 
@@ -715,10 +712,18 @@ static int hfsplus_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void hfsplus_kill_super(struct super_block *sb)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+
+	kill_block_super(sb);
+	call_rcu(&sbi->rcu, delayed_free);
+}
+
 static struct file_system_type hfsplus_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "hfsplus",
-	.kill_sb	= kill_block_super,
+	.kill_sb	= hfsplus_kill_super,
 	.fs_flags	= FS_REQUIRES_DEV,
 	.init_fs_context = hfsplus_init_fs_context,
 };
-- 
2.51.0

