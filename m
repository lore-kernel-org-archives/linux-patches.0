Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6176264FA0;
	Tue,  8 Apr 2025 11:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110873; cv=none; b=PD01ogtGvfAhE8xBfJ/aZEO4C9WlGUCAwFUfyZzqi3VmHoird669xCe7tY2uJb+EwltkA7Tg3Ao7gY0iX9hD5JcHBViNCl+HzvkOEIzZDcfSqCEJ4kf2mugcI1DL4YLWf8SMMpeQ5DZyGciK4fsdyJnO8ZpZusJbZZRYCwkvPbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110873; c=relaxed/simple;
	bh=vZDZB1i/D5sJ48tCJnkr8eGNLNN6BRd8x34pTo0gzuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zhbzj5aeJI+1xMIZgNZs99zZb5LJqVWlFXt5PMOv3WJPllgiUWe7Bufd15bUbB2+BSk/Lc6Wd0REO6o2cOxq9FwwbRzLtJyBBP4rLYsvfX/oUgTN8mG7zE3CuThG7xe7b3tPp3vQksZZ+waToNJZfLGFCObIFD6ojkRzsCZZo74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2EUQxLZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2EUQxLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C43C4CEE5;
	Tue,  8 Apr 2025 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110873;
	bh=vZDZB1i/D5sJ48tCJnkr8eGNLNN6BRd8x34pTo0gzuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2EUQxLZQgWwaAjMDgSgy5UP+TQ7MZ+fBCw8/IwNn5tHvF0hdU62W5hTd6NLzUELz
	 kbz54iXVi54a1vEKxUXUr+jppblILsbQ6GoaqJ65xc90tc0fmJ43yKbQgmuTdpokuR
	 p4stDbTcKq+F+Rk7/9+oXXvGjTx4PUwYesEqgQxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 227/731] ext4: define ext4_journal_destroy wrapper
Date: Tue,  8 Apr 2025 12:42:04 +0200
Message-ID: <20250408104919.561294012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0d1c3eefe438a..f658c017055f3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1309,8 +1309,7 @@ static void ext4_put_super(struct super_block *sb)
 
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
-		err = jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		err = ext4_journal_destroy(sbi, sbi->s_journal);
 		if ((err < 0) && !aborted) {
 			ext4_abort(sb, -err, "Couldn't clean up the journal");
 		}
@@ -4975,8 +4974,7 @@ static int ext4_load_and_init_journal(struct super_block *sb,
 out:
 	/* flush s_sb_upd_work before destroying the journal. */
 	flush_work(&sbi->s_sb_upd_work);
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	ext4_journal_destroy(sbi, sbi->s_journal);
 	return -EINVAL;
 }
 
@@ -5667,8 +5665,7 @@ failed_mount8: __maybe_unused
 	if (sbi->s_journal) {
 		/* flush s_sb_upd_work before journal destroy. */
 		flush_work(&sbi->s_sb_upd_work);
-		jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
@@ -5973,7 +5970,7 @@ static journal_t *ext4_open_dev_journal(struct super_block *sb,
 	return journal;
 
 out_journal:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
 	bdev_fput(bdev_file);
 	return ERR_PTR(errno);
@@ -6090,8 +6087,7 @@ static int ext4_load_journal(struct super_block *sb,
 	EXT4_SB(sb)->s_journal = journal;
 	err = ext4_clear_journal_err(sb, es);
 	if (err) {
-		EXT4_SB(sb)->s_journal = NULL;
-		jbd2_journal_destroy(journal);
+		ext4_journal_destroy(EXT4_SB(sb), journal);
 		return err;
 	}
 
@@ -6109,7 +6105,7 @@ static int ext4_load_journal(struct super_block *sb,
 	return 0;
 
 err_out:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 	return err;
 }
 
-- 
2.39.5



