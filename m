Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4E3BF2E4;
	Thu, 15 Jan 2026 17:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498471; cv=none; b=cqEtRDK+ZEY8EJ4NRlOATG2fQdIORxIhMduxHrbqbjNA9SvI59/8dsUVwBiawVOvxq27n326eSo6qfWwn5er7XzU8yJCa+wqKw1NkHCBpL5FQVe/u0+U0ein9gnavSOeZ0r+oEXk88+dT0t8Qc+7+lduGeyqBUG/4iSVA2ts0Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498471; c=relaxed/simple;
	bh=8sW4sw/8fruqTbvGg4j/Jyg8hqKZFWRWdGR2BAmIYRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAM59BdTy8nV8sHuRfI35dfS+6nvH7GQ7cGYJG1kNRKGGSs8M5qQLuD+VKClKCXON4efbpUrC+OxFdKnp+Wz27DfBHO2e4LguvCJFVWCPfpIx6RPpcrTIt3Gfwr/srH4rsu+etSMd+4Etey6dyGet+NNmEv2pprPRysoGYpCwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz7bTElg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz7bTElg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBEBC116D0;
	Thu, 15 Jan 2026 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498471;
	bh=8sW4sw/8fruqTbvGg4j/Jyg8hqKZFWRWdGR2BAmIYRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz7bTElgaJJoyCoe0WymFlPWNwpWFVp3xUMGJ/c/0jhxn43Ib2guA6TrWwdL5tMij
	 OMg/YSkD1bm4LX1JPAIw5aCwI7tI2H5XxFBY5Vqybny6RZ7bxlMbep/n1haokz/oc4
	 rOK8JqR+oIstlpkGdJKHXp+SmqfgV0lUg5bh10hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/554] f2fs: fix to propagate error from f2fs_enable_checkpoint()
Date: Thu, 15 Jan 2026 17:48:29 +0100
Message-ID: <20260115164302.302550031@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit be112e7449a6e1b54aa9feac618825d154b3a5c7 ]

In order to let userspace detect such error rather than suffering
silent failure.

Fixes: 4354994f097d ("f2fs: checkpoint disabling")
Cc: stable@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Adjust context, no rollback ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2177,9 +2177,10 @@ restore_flag:
 	return err;
 }
 
-static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
+static int f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
 	int retry = DEFAULT_RETRY_IO_COUNT;
+	int ret;
 
 	/* we should flush all the data to keep data consistency */
 	do {
@@ -2197,10 +2198,14 @@ static void f2fs_enable_checkpoint(struc
 	set_sbi_flag(sbi, SBI_IS_DIRTY);
 	up_write(&sbi->gc_lock);
 
-	f2fs_sync_fs(sbi->sb, 1);
+	ret = f2fs_sync_fs(sbi->sb, 1);
+	if (ret)
+		f2fs_err(sbi, "%s sync_fs failed, ret: %d", __func__, ret);
 
 	/* Let's ensure there's no pending checkpoint anymore */
 	f2fs_flush_ckpt_thread(sbi);
+
+	return ret;
 }
 
 static int f2fs_remount(struct super_block *sb, int *flags, char *data)
@@ -2416,7 +2421,9 @@ static int f2fs_remount(struct super_blo
 			if (err)
 				goto restore_discard;
 		} else {
-			f2fs_enable_checkpoint(sbi);
+			err = f2fs_enable_checkpoint(sbi);
+			if (err)
+				goto restore_discard;
 		}
 	}
 
@@ -4397,13 +4404,12 @@ reset_checkpoint:
 	/* f2fs_recover_fsync_data() cleared this already */
 	clear_sbi_flag(sbi, SBI_POR_DOING);
 
-	if (test_opt(sbi, DISABLE_CHECKPOINT)) {
+	if (test_opt(sbi, DISABLE_CHECKPOINT))
 		err = f2fs_disable_checkpoint(sbi);
-		if (err)
-			goto sync_free_meta;
-	} else if (is_set_ckpt_flags(sbi, CP_DISABLED_FLAG)) {
-		f2fs_enable_checkpoint(sbi);
-	}
+	else if (is_set_ckpt_flags(sbi, CP_DISABLED_FLAG))
+		err = f2fs_enable_checkpoint(sbi);
+	if (err)
+		goto sync_free_meta;
 
 	/*
 	 * If filesystem is not mounted as read-only then


