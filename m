Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C6E1C6F51;
	Tue, 27 Aug 2024 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771925; cv=none; b=hLPenuhdq7B4v2L2pbyAT+jEn5/gDxk6qGzcdujbASmUqrE4X9OLdA9BEMnEAQ4m2sj7/xbqOoNvIKEKAwSgb3TyLOQfw802D+RH0toyq51E3V/bxibVyb3AaOPLH52TEFCvVLo0DG21A0LQqS17O8wmaOGIM9ijhfUxpEb2pNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771925; c=relaxed/simple;
	bh=7ZxAi5laNapiRP5TadWYFOXDV/BVAozD3WWJLQLnPdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9qTzTTmETR9j1IvoHGF6aqs9AZ36dNzfk7kdNljSA3vvmu5myCRJstfCT97FEQPB96LI3sJwxFXSgHKkdM0uslwAUhRELshYNc23+Jvxm+3wjPQhgE2TzCSYIfRI62VDTeWDschrw07Rijxjzuxro6uBRxZy8sMC2aqJNI8D6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtqQEIvw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtqQEIvw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692CFC4AF1B;
	Tue, 27 Aug 2024 15:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771924;
	bh=7ZxAi5laNapiRP5TadWYFOXDV/BVAozD3WWJLQLnPdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtqQEIvwehkPPmM8sqBeKIHUfwLoFaIsCDBc34w5/qbaxngsehdJRqyl4uI1lTOoI
	 4yH+Nk1wsHdcINZnE99W6SF4mWPfhuTRjY7s6kF6qypH2b2iaxACzArQvOx/UJ5nqr
	 i08Tf3g6Fw4KMU7QQa0uQpjpuAm71SqjEx/gq7I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9543479984ae9e576000@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/321] ext4, jbd2: add an optimized bmap for the journal inode
Date: Tue, 27 Aug 2024 16:35:42 +0200
Message-ID: <20240827143839.520063227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 62913ae96de747091c4dacd06d158e7729c1a76d ]

The generic bmap() function exported by the VFS takes locks and does
checks that are not necessary for the journal inode.  So allow the
file system to set a journal-optimized bmap function in
journal->j_bmap.

Reported-by: syzbot+9543479984ae9e576000@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=e4aaa78795e490421c79f76ec3679006c8ff4cf0
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c      | 23 +++++++++++++++++++++++
 fs/jbd2/journal.c    |  9 ++++++---
 include/linux/jbd2.h |  8 ++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 274542d869d0c..3db39758486e9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5752,6 +5752,28 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 	return journal_inode;
 }
 
+static int ext4_journal_bmap(journal_t *journal, sector_t *block)
+{
+	struct ext4_map_blocks map;
+	int ret;
+
+	if (journal->j_inode == NULL)
+		return 0;
+
+	map.m_lblk = *block;
+	map.m_len = 1;
+	ret = ext4_map_blocks(NULL, journal->j_inode, &map, 0);
+	if (ret <= 0) {
+		ext4_msg(journal->j_inode->i_sb, KERN_CRIT,
+			 "journal bmap failed: block %llu ret %d\n",
+			 *block, ret);
+		jbd2_journal_abort(journal, ret ? ret : -EIO);
+		return ret;
+	}
+	*block = map.m_pblk;
+	return 0;
+}
+
 static journal_t *ext4_get_journal(struct super_block *sb,
 				   unsigned int journal_inum)
 {
@@ -5772,6 +5794,7 @@ static journal_t *ext4_get_journal(struct super_block *sb,
 		return NULL;
 	}
 	journal->j_private = sb;
+	journal->j_bmap = ext4_journal_bmap;
 	ext4_init_journal_params(sb, journal);
 	return journal;
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c8d59f7c47453..d3d3ea439d29b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -971,10 +971,13 @@ int jbd2_journal_bmap(journal_t *journal, unsigned long blocknr,
 {
 	int err = 0;
 	unsigned long long ret;
-	sector_t block = 0;
+	sector_t block = blocknr;
 
-	if (journal->j_inode) {
-		block = blocknr;
+	if (journal->j_bmap) {
+		err = journal->j_bmap(journal, &block);
+		if (err == 0)
+			*retp = block;
+	} else if (journal->j_inode) {
 		ret = bmap(journal->j_inode, &block);
 
 		if (ret || !block) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index e301d323108d1..5bf7ada754d79 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1302,6 +1302,14 @@ struct journal_s
 				    struct buffer_head *bh,
 				    enum passtype pass, int off,
 				    tid_t expected_commit_id);
+
+	/**
+	 * @j_bmap:
+	 *
+	 * Bmap function that should be used instead of the generic
+	 * VFS bmap function.
+	 */
+	int (*j_bmap)(struct journal_s *journal, sector_t *block);
 };
 
 #define jbd2_might_wait_for_commit(j) \
-- 
2.43.0



