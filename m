Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3F147D94F;
	Thu, 20 Aug 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244163; cv=none; b=CdoT8PlBzrR/4BlNjg9ZGtCFUKCP853BXw+8xD3VaLuBYnqVKAxfa9U4ElQDmIFGoeddBwSOKe+oK67S5xnM34w/aTlkoNRTtL/2ZxQtXmhLTJwCzSkkeVnXWyvaH9RXUkGXzKNs9po+mzMpS7IcmzJJmXIhzDRKV0lMI7CcwXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244163; c=relaxed/simple;
	bh=UTIEIQngMVqwcAEXVARzBvIt8qalMJVKlCfFgDfja0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzXxGbsl4seXBQa8bzgayON4ZNKCyG9juKnsG3d0ewb8Yotu89mmIdVXvHaG5hHJ0Xd/x4/DtmctnssKHs9h68MUNc7vaWfRZIuq2odOqhx/lKM/g9RDAl3m5p2k4dtuWM5gA2fQoDUax5u5U7OsrnvLAJIUKD43n04M4lQdpeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmGSBblO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmGSBblO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEF61F000E9;
	Thu, 20 Aug 2026 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244162;
	bh=3YhOv4uBVwTl+do4Rq6pRftTy+b4+8hjjBY/Bs+DM6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmGSBblOBY37Z+qnsEIVds2LsC17+DKu5UmoBMj1Jrx3kIt5Gu+2YVV7tRA6XdJrv
	 qkvBno1eFI+/gvDVAasOyLsuudP8a+KD0O5PjS11m97QQxEGX5bbcZQaznSD5RZpou
	 QYuVJJjYq9XV/wOlddnrtCKVzH0O7fHw8SauymKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/235] jbd2: add a helper to find out number of fast commit blocks
Date: Thu, 20 Aug 2026 16:55:09 +0200
Message-ID: <20260820145218.659449675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

[ Upstream commit 9bd23c31f392bda88618008f27fd52ee9e0fac38 ]

Add a helper to read number of fast commit blocks from jbd2 superblock
and also rename the JBD2_MIN_FC_BLKS to
JBD2_DEFAULT_FAST_COMMIT_BLOCKS since this constant is just the
default number of fast commit blocks to use in case number of fast
commit blocks isn't set in jbd2 superblock.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20201120202232.2240293-2-harshadshirwadkar@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 289a2ca0c9b7 ("jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/journal.c    |    8 ++------
 include/linux/jbd2.h |    9 ++++++++-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1884,9 +1884,7 @@ static int load_superblock(journal_t *jo
 
 	if (jbd2_has_feature_fast_commit(journal)) {
 		journal->j_fc_last = be32_to_cpu(sb->s_maxlen);
-		num_fc_blocks = be32_to_cpu(sb->s_num_fc_blks);
-		if (!num_fc_blocks)
-			num_fc_blocks = JBD2_MIN_FC_BLOCKS;
+		num_fc_blocks = jbd2_journal_get_num_fc_blks(sb);
 		if (journal->j_last - num_fc_blocks >= JBD2_MIN_JOURNAL_BLOCKS)
 			journal->j_last = journal->j_fc_last - num_fc_blocks;
 		journal->j_fc_first = journal->j_last + 1;
@@ -2117,9 +2115,7 @@ jbd2_journal_initialize_fast_commit(jour
 	journal_superblock_t *sb = journal->j_superblock;
 	unsigned long long num_fc_blks;
 
-	num_fc_blks = be32_to_cpu(sb->s_num_fc_blks);
-	if (num_fc_blks == 0)
-		num_fc_blks = JBD2_MIN_FC_BLOCKS;
+	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
 	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -68,7 +68,7 @@ extern void *jbd2_alloc(size_t size, gfp
 extern void jbd2_free(void *ptr, size_t size);
 
 #define JBD2_MIN_JOURNAL_BLOCKS 1024
-#define JBD2_MIN_FC_BLOCKS	256
+#define JBD2_DEFAULT_FAST_COMMIT_BLOCKS 256
 
 #ifdef __KERNEL__
 
@@ -1686,6 +1686,13 @@ static inline int jbd2_journal_has_csum_
 	return journal->j_chksum_driver != NULL;
 }
 
+static inline int jbd2_journal_get_num_fc_blks(journal_superblock_t *jsb)
+{
+	int num_fc_blocks = be32_to_cpu(jsb->s_num_fc_blks);
+
+	return num_fc_blocks ? num_fc_blocks : JBD2_DEFAULT_FAST_COMMIT_BLOCKS;
+}
+
 /*
  * Return number of free blocks in the log. Must be called under j_state_lock.
  */


