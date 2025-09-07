Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D31DF246;
	Sun,  7 Sep 2025 20:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277268; cv=none; b=F94STQMnQoRH4E2e0/SMhnVMah2QBQrarCwfiyDISzfdtNVV7xDJLxuUFDSI7Ds2AU3etC76uzJym9MNNw3MiuGvFErAawqhFH0bCH7MuV20E979U+2thYkSPmrLyXGOiSB19SAcirZSN24Ki62idVURpMP2T7aCJRn1uhdKwc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277268; c=relaxed/simple;
	bh=S/Tw3cD5+OdjWsFvhwUnjIJaWuY+X2JkHaF4r2vQOPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNGKDycsZ+0a2cIsrkKxe5vpgdeUCggs5JitiulKAC9rGG4KYYVO+XKUQWGyC9ZffTjWqvUZO0JmIztOj6II2CfhKSHCrMl5nhqR2dZVr7gv+CzPcbMW2d9SxqB0vh+U+jn4mIfsr+gr9LAGATQpQeyvPjwi5lJ3tnfEodbfTko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySjwwS0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySjwwS0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C170DC4CEF0;
	Sun,  7 Sep 2025 20:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277268;
	bh=S/Tw3cD5+OdjWsFvhwUnjIJaWuY+X2JkHaF4r2vQOPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySjwwS0JmPnu+/s6jNMj4T26FUs34G+8bdjrqgvy768r9DHnTJh4u4GqcKN5gPY9q
	 Y7AgB+k+E4E4mjYbRDdLwJ4DbSFbVAIHKjtSgsWyqTJSFFXdxHn9l9eaZwUWFPRSrm
	 YBhGVVCMyUShVkJjAnwfBNPgBfsha164JtQN3a50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 131/175] ext4: define ext4_journal_destroy wrapper
Date: Sun,  7 Sep 2025 21:58:46 +0200
Message-ID: <20250907195617.955445603@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

commit 5a02a6204ca37e7c22fbb55a789c503f05e8e89a upstream.

Define an ext4 wrapper over jbd2_journal_destroy to make sure we
have consistent behavior during journal destruction. This will also
come useful in the next patch where we add some ext4 specific logic
in the destroy path.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/c3ba78c5c419757e6d5f2d8ebb4a8ce9d21da86a.1742279837.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4_jbd2.h |   14 ++++++++++++++
 fs/ext4/super.c     |   16 ++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -513,4 +513,18 @@ static inline int ext4_should_dioread_no
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
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1312,8 +1312,7 @@ static void ext4_put_super(struct super_
 
 	if (sbi->s_journal) {
 		aborted = is_journal_aborted(sbi->s_journal);
-		err = jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		err = ext4_journal_destroy(sbi, sbi->s_journal);
 		if ((err < 0) && !aborted) {
 			ext4_abort(sb, -err, "Couldn't clean up the journal");
 		}
@@ -4957,8 +4956,7 @@ static int ext4_load_and_init_journal(st
 out:
 	/* flush s_sb_upd_work before destroying the journal. */
 	flush_work(&sbi->s_sb_upd_work);
-	jbd2_journal_destroy(sbi->s_journal);
-	sbi->s_journal = NULL;
+	ext4_journal_destroy(sbi, sbi->s_journal);
 	return -EINVAL;
 }
 
@@ -5649,8 +5647,7 @@ failed_mount_wq:
 	if (sbi->s_journal) {
 		/* flush s_sb_upd_work before journal destroy. */
 		flush_work(&sbi->s_sb_upd_work);
-		jbd2_journal_destroy(sbi->s_journal);
-		sbi->s_journal = NULL;
+		ext4_journal_destroy(sbi, sbi->s_journal);
 	}
 failed_mount3a:
 	ext4_es_unregister_shrinker(sbi);
@@ -5958,7 +5955,7 @@ static journal_t *ext4_open_dev_journal(
 	return journal;
 
 out_journal:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 out_bdev:
 	bdev_fput(bdev_file);
 	return ERR_PTR(errno);
@@ -6075,8 +6072,7 @@ static int ext4_load_journal(struct supe
 	EXT4_SB(sb)->s_journal = journal;
 	err = ext4_clear_journal_err(sb, es);
 	if (err) {
-		EXT4_SB(sb)->s_journal = NULL;
-		jbd2_journal_destroy(journal);
+		ext4_journal_destroy(EXT4_SB(sb), journal);
 		return err;
 	}
 
@@ -6094,7 +6090,7 @@ static int ext4_load_journal(struct supe
 	return 0;
 
 err_out:
-	jbd2_journal_destroy(journal);
+	ext4_journal_destroy(EXT4_SB(sb), journal);
 	return err;
 }
 


