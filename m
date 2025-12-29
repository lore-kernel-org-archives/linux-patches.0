Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAC531ED83;
	Mon, 29 Dec 2025 16:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025537; cv=none; b=W4J/mGgkkMNqqxTz0gLczEhC1Njv63kxjUHzqC+2XRlewPM+b8tHT8KLA5dAMTrVU7GLl7JLmv7NPr/nMOad/CVenftxxd77TCk4w8JYdqM8HQN5YKymAyS4+EE0h36bwUBKKOsnYTQrlXUXLucwI+hmSS3SHcG0chYz29wA770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025537; c=relaxed/simple;
	bh=rDxpeRfq1RYUHBdTXKtFGwa/Is3svCOe1eAUz3LSets=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnmYCQuhkrF/UUsTeh7/IhmzkASp4rBJQP43IuQEeCEBcEFo3MRwNoeNvsJwPc3VB3Mu8VqkFnpzULe0eCEoUtiUMS1dtX9iS9w3Rf1E+MDMkfo+uXyJlLzv4ZDSNHrAoyROXZG1xTMz0nzzw84I7B5CQWT+P5jk0M9daa7mLuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccf14r7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccf14r7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07869C4CEF7;
	Mon, 29 Dec 2025 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025537;
	bh=rDxpeRfq1RYUHBdTXKtFGwa/Is3svCOe1eAUz3LSets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ccf14r7kaNSEO9bJOyUfN+vlsSbAoKm/+GpXmsjoqQXSyzBdIO13qOXctKXEC7nJ7
	 0VlaK9dsw0caolhb5j4wvAFd96csyOAU4dpCQwdBAtRdcIyqLV9Aj3Yg2OUi5S5LY7
	 SzMJ02zPKOa18yFu7+Vg4niaSLFpN8+K+7X5pUFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 249/430] jbd2: fix the inconsistency between checksum and data in memory for journal sb
Date: Mon, 29 Dec 2025 17:10:51 +0100
Message-ID: <20251229160733.519474858@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 6abfe107894af7e8ce3a2e120c619d81ee764ad5 upstream.

Copying the file system while it is mounted as read-only results in
a mount failure:
[~]# mkfs.ext4 -F /dev/sdc
[~]# mount /dev/sdc -o ro /mnt/test
[~]# dd if=/dev/sdc of=/dev/sda bs=1M
[~]# mount /dev/sda /mnt/test1
[ 1094.849826] JBD2: journal checksum error
[ 1094.850927] EXT4-fs (sda): Could not load journal inode
mount: mount /dev/sda on /mnt/test1 failed: Bad message

The process described above is just an abstracted way I came up with to
reproduce the issue. In the actual scenario, the file system was mounted
read-only and then copied while it was still mounted. It was found that
the mount operation failed. The user intended to verify the data or use
it as a backup, and this action was performed during a version upgrade.
Above issue may happen as follows:
ext4_fill_super
 set_journal_csum_feature_set(sb)
  if (ext4_has_metadata_csum(sb))
   incompat = JBD2_FEATURE_INCOMPAT_CSUM_V3;
  if (test_opt(sb, JOURNAL_CHECKSUM)
   jbd2_journal_set_features(sbi->s_journal, compat, 0, incompat);
    lock_buffer(journal->j_sb_buffer);
    sb->s_feature_incompat  |= cpu_to_be32(incompat);
    //The data in the journal sb was modified, but the checksum was not
      updated, so the data remaining in memory has a mismatch between the
      data and the checksum.
    unlock_buffer(journal->j_sb_buffer);

In this case, the journal sb copied over is in a state where the checksum
and data are inconsistent, so mounting fails.
To solve the above issue, update the checksum in memory after modifying
the journal sb.

Fixes: 4fd5ea43bc11 ("jbd2: checksum journal superblock")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251103010123.3753631-1-yebin@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2349,6 +2349,12 @@ int jbd2_journal_set_features(journal_t
 	sb->s_feature_compat    |= cpu_to_be32(compat);
 	sb->s_feature_ro_compat |= cpu_to_be32(ro);
 	sb->s_feature_incompat  |= cpu_to_be32(incompat);
+	/*
+	 * Update the checksum now so that it is valid even for read-only
+	 * filesystems where jbd2_write_superblock() doesn't get called.
+	 */
+	if (jbd2_journal_has_csum_v2or3(journal))
+		sb->s_checksum = jbd2_superblock_csum(sb);
 	unlock_buffer(journal->j_sb_buffer);
 	jbd2_journal_init_transaction_limits(journal);
 
@@ -2378,9 +2384,17 @@ void jbd2_journal_clear_features(journal
 
 	sb = journal->j_superblock;
 
+	lock_buffer(journal->j_sb_buffer);
 	sb->s_feature_compat    &= ~cpu_to_be32(compat);
 	sb->s_feature_ro_compat &= ~cpu_to_be32(ro);
 	sb->s_feature_incompat  &= ~cpu_to_be32(incompat);
+	/*
+	 * Update the checksum now so that it is valid even for read-only
+	 * filesystems where jbd2_write_superblock() doesn't get called.
+	 */
+	if (jbd2_journal_has_csum_v2or3(journal))
+		sb->s_checksum = jbd2_superblock_csum(sb);
+	unlock_buffer(journal->j_sb_buffer);
 	jbd2_journal_init_transaction_limits(journal);
 }
 EXPORT_SYMBOL(jbd2_journal_clear_features);


