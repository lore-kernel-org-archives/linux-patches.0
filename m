Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE81494C5;
	Thu, 15 Aug 2024 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729813; cv=none; b=p2O45566wqdw3btrnfoEjfHm6N9sjVYbySRmLja9rnfbi8pUxtLwBQTurH30oV29BPPpSRkMDaM52o4JIADCfXaWlulEz5qBNsuVf7nKOGIJwLiwKlzNIvZS0P7PkUO3wgx0gONrhuugSbNZor1dXgaNRMmusQA2zetbANAOfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729813; c=relaxed/simple;
	bh=vGSA5OKVCGBIsbysymT7m4aBNxB3C+3/FOfNpI6Ejfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcdSbIA8hCnktcXKUOkWEoBDV5tOpOhMs/OzHISkrVGpr2q0auvl2gysbPUui4UiTc7LnuHqmNHzikQwHxYb6pWGJ72ppJIf3BfwNJtXTEebAM5hGTfY2bmFKRwUPqDEo7qU2Qt6Xn2pUPdzcdCWiznqywg7aP7H8tV1rWNX3Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYLEuZZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYLEuZZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE33C4AF0A;
	Thu, 15 Aug 2024 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729813;
	bh=vGSA5OKVCGBIsbysymT7m4aBNxB3C+3/FOfNpI6Ejfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYLEuZZZXk6E0dToL0cnRifLyf14W822IU1oDcJLAjkykKUVElAF+O0mvPUBj6U3l
	 jAH9zyH1b7FEwsCkvp8DmrZQ4RvX9jW0jVG3LWnTvkb03Zcdqvap1qX9g/HS5bH9za
	 faq76nZiZrAfify5ttGkLZFX22nuhPU9zICi/3nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 198/484] jbd2: make jbd2_journal_get_max_txn_bufs() internal
Date: Thu, 15 Aug 2024 15:20:56 +0200
Message-ID: <20240815131949.059773224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -800,7 +800,7 @@ start_journal_io:
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
@@ -1529,6 +1529,11 @@ static void journal_fail_superblock(jour
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
@@ -1669,11 +1669,6 @@ int jbd2_wait_inode_data(journal_t *jour
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


