Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C673AEF3F;
	Sat, 17 Oct 2026 17:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257877; cv=none; b=HgOjmMiVnmEXm0gQkWcsjlqjC0cG/n1GZDCJMhyEsUZmL8Qqnq12PlT4B8F9yIF7wY6EKRzN6CotnyfUnXb5x21HlBFU7zyIb3f+Ul1sJ23xVCHo/HmBOb2uZc4j+5HevZ4kqRE08smWcYPdNawhyYgcOP6LIRJkheGCgdIuBmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257877; c=relaxed/simple;
	bh=8RhFjRSn8eFea6a0Uu9P5rqLdx2PErxPhHLcZj61Cfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtgTraHuNCZNyfYn+VxlCU6fRpjLvdMMdf8ZDHKesp+3dYZnwrFJRVREAvX6Nj2hGay1M4f2T5RMI3AJpeKvZl1QyxYJbFISBs0v0qlkmhsthz4DE/7dImfa7kqc6rqGUA+AkoHGif/5WaGHjksglcNW0FR9bw641hCdjKo4xJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9wSS7f0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9wSS7f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1451F000C4;
	Sat, 17 Oct 2026 17:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257876;
	bh=K2H5qUTbVt/FwCgsGeztsdIjGUDYGY1yBVByb9CjO38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9wSS7f0FkiuD/3X2JbTGTtNbGaw8jEm8SaO9kd1Ei4/725RnvbCTVt4koeNwSKHK
	 NdCybafCIINE/3ayNv9gBw+nPNBpyAjuhrvPdRO9CauWxxfXg4SXMwHDlBz44u/h/4
	 1DWr4jmZA3y2N7DNNb3iEZGJOpO08idlCTJtHD2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0697/1674] ext4: define ext4_journal_destroy wrapper
Date: Sat, 17 Oct 2026 17:49:29 +0200
Message-ID: <20261017160448.994336905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit 5a02a6204ca37e7c22fbb55a789c503f05e8e89a ]

Define an ext4 wrapper over jbd2_journal_destroy to make sure we
have consistent behavior during journal destruction. This will also
come useful in the next patch where we add some ext4 specific logic
in the destroy path.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/c3ba78c5c419757e6d5f2d8ebb4a8ce9d21da86a.1742279837.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: ce2f26e73783 ("ext4: avoid journaling sb update on error if journal is destroying")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4_jbd2.h | 14 ++++++++++++++
 fs/ext4/super.c     | 16 ++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 0c77697d5e90d..930778e507cc4 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -513,4 +513,18 @@ static inline int ext4_should_dioread_nolock(struct inode *inode)
 	return 1;
 }
 
+/*
+ * Pass journal explicitly as it may not be cached in the sbi->s_journal in some
+ * cases
+ */
+static inline int ext4_journal_destroy(struct ext4_sb_info *sbi, journal_t *journal)
+{
+	int err = 0;
+
+	err = jbd2_journal_destroy(journal);
+	sbi->s_journal = NULL;
+
+	return err;
+}
+
 #endif	/* _EXT4_JBD2_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 045c1cf3c5963..32ee4c317583a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1317,8 +1317,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
-		err = jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		err = ext4_journal_destroy(sbi, sbi->s_journal);
 		if ((err < 0) && !aborted) {
 			ext4_abort(sb, -err, "Couldn't clean up the journal");
 		}
@@ -4995,8 +4994,7 @@ static int ext4_load_and_init_journal(struct super_block *sb,
 out:
 	/* flush s_sb_upd_work before destroying the journal. */
 	flush_work(&sbi->s_sb_upd_work);
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	ext4_journal_destroy(sbi, sbi->s_journal);
 	return -EINVAL;
 }
 
@@ -5686,8 +5684,7 @@ failed_mount8: __maybe_unused
 	if (sbi->s_journal) {
 		/* flush s_sb_upd_work before journal destroy. */
 		flush_work(&sbi->s_sb_upd_work);
-		jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
@@ -5995,7 +5992,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
 	return journal;
 
 out_journal:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
 	blkdev_put(journal_bdev, sb);
 	return ERR_PTR(errno);
@@ -6112,8 +6109,7 @@ static int ext4_load_journal(struct super_block *sb,
 	EXT4_SB(sb)->s_journal = journal;
 	err = ext4_clear_journal_err(sb, es);
 	if (err) {
-		EXT4_SB(sb)->s_journal = NULL;
-		jbd2_journal_destroy(journal);
+		ext4_journal_destroy(EXT4_SB(sb), journal);
 		return err;
 	}
 
@@ -6131,7 +6127,7 @@ static int ext4_load_journal(struct super_block *sb,
 	return 0;
 
 err_out:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 	return err;
 }
 
-- 
2.53.0



