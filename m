Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DAA210FB;
	Thu, 15 Aug 2024 14:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732359; cv=none; b=BdvtievmSXFO0uZ/M23HPxnMGUN0xm+ijAaiZvef8KSfU29w6M/SCHBSLLEjFPkyeLe4dwXCdcRhYxbbxvFXOtkrt+IRf0461eh1/HBoSd5SgfT6penq6XrRdT2TRNYFlY8RwQuWRnf+ZX+/f/EFWm+6ikPIXnscrruX2y4lg20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732359; c=relaxed/simple;
	bh=qBHMJyN+ljPvU4jLU4Qq+hxpFn5SRIlJdISJAx3/sPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MSMu4aXcNMBebW2YV6TG7PBOdvOS0AsgolgJ/hCjIaZBZYo8Wyw9qJKr6frPaVkddkJuUabRBXejkWhfEHohvSLNO0md/0aCigQG8KS20y7IvkVTyOdQhOpVSvD3n35dJTWFjtgJqG1jk4x4fYmm/tm3ReweUzy2TiktRT4TPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlvF1v1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlvF1v1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E19C32786;
	Thu, 15 Aug 2024 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732359;
	bh=qBHMJyN+ljPvU4jLU4Qq+hxpFn5SRIlJdISJAx3/sPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlvF1v1lRlCAB6AuxDYNGcJ0VdX4iJBWUJDZ7A8T8rBCSikuQUsnOo9sLNLNt8AIa
	 2grBKmlaU2kek5tXug0TeWiJTgxfWGGjprd3GfCSvO7SF/WK9BmAthWTeQuVgB+Nu/
	 xWPd+SZMP14oM3A3KjXjde/KD3UDozn+vKG4+A3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 148/352] jbd2: make jbd2_journal_get_max_txn_bufs() internal
Date: Thu, 15 Aug 2024 15:23:34 +0200
Message-ID: <20240815131924.982050320@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -813,7 +813,7 @@ start_journal_io:
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
@@ -1481,6 +1481,11 @@ static void journal_fail_superblock(jour
 	journal->j_sb_buffer = NULL;
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
@@ -1626,11 +1626,6 @@ int jbd2_wait_inode_data(journal_t *jour
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


