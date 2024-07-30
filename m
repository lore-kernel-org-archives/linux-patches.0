Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D862E1A6192;
	Tue, 30 Jul 2024 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358935; cv=none; b=Ag+zVswvAx+yil9CxpEBJmY3nB8ZVhmAF14DuVwrjKwdO8lMO12zuA8r6I8h58oQS1Eb1bCgcocU02ELBFitzS2gVVB60cSswGlo9aAQ0ERzCQEqXstXSt3zMy3A0uSf+wGR4+gwL0D5kS1cvLCgxw4pBvo4W9vOJSEu/Wv+Ej8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358935; c=relaxed/simple;
	bh=gapk2KAPDzsiL9GLSsaTiL/qRTYMVLVWur4R4sXyI3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLIe9pqexIm7eIQpD5EaNhjNlJc1Dyqv9k7YHdtgQ2Tq8XAG1VlKbaffpyeDE/hjXoWuBq1TAz0hXU07pnSvY7ooZwdEK61OffTQWiUkITjp4OLSFiZGjO/fydQhqoPkQ1TXkaTJzypd63nQTL5rMKJY4AGg+Dn/8rq3I22RkWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpUQBfmm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpUQBfmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59923C4AF0A;
	Tue, 30 Jul 2024 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358934;
	bh=gapk2KAPDzsiL9GLSsaTiL/qRTYMVLVWur4R4sXyI3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpUQBfmm38qx2Ad/V3J7Fsp2KMnxxKjdYmfhIY8+vPlGTdA2jRCcmCfxu3wHGkj+D
	 L7UxT4tfnsKT5t/5ULKHBsSv7UYkb9jvzW8IEohRiagFdnlL9hs3YfzYC//gRVeF3R
	 TIHTMjFlzzl5Q2OqowlghnRPmFuH7vTkSlZNzBGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 410/568] jbd2: make jbd2_journal_get_max_txn_bufs() internal
Date: Tue, 30 Jul 2024 17:48:37 +0200
Message-ID: <20240730151655.894086398@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4aa99c71e42ad60178c1154ec24e3df9c684fb67 upstream.

There's no reason to have jbd2_journal_get_max_txn_bufs() public
function. Currently all users are internal and can use
journal->j_max_transaction_buffers instead. This saves some unnecessary
recomputations of the limit as a bonus which becomes important as this
function gets more complex in the following patch.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20240624170127.3253-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/commit.c     |    2 +-
 fs/jbd2/journal.c    |    5 +++++
 include/linux/jbd2.h |    5 -----
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -767,7 +767,7 @@ start_journal_io:
 		if (first_block < journal->j_tail)
 			freed += journal->j_last - journal->j_first;
 		/* Update tail only if we free significant amount of space */
-		if (freed < jbd2_journal_get_max_txn_bufs(journal))
+		if (freed < journal->j_max_transaction_buffers)
 			update_tail = 0;
 	}
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1690,6 +1690,11 @@ journal_t *jbd2_journal_init_inode(struc
 	return journal;
 }
 
+static int jbd2_journal_get_max_txn_bufs(journal_t *journal)
+{
+	return (journal->j_total_len - journal->j_fc_wbufsize) / 4;
+}
+
 /*
  * Given a journal_t structure, initialise the various fields for
  * startup of a new journaling session.  We use this both when creating
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1666,11 +1666,6 @@ int jbd2_wait_inode_data(journal_t *jour
 int jbd2_fc_wait_bufs(journal_t *journal, int num_blks);
 int jbd2_fc_release_bufs(journal_t *journal);
 
-static inline int jbd2_journal_get_max_txn_bufs(journal_t *journal)
-{
-	return (journal->j_total_len - journal->j_fc_wbufsize) / 4;
-}
-
 /*
  * is_journal_abort
  *


