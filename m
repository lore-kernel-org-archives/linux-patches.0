Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9941A76AB;
	Tue, 30 Jul 2024 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360152; cv=none; b=fE+LJBL9RcUvzyaqcNjoeRm65s+TGGNr87Wrs7hp9RxPfQ39W7hemip/rpT/ZFPbFT2zyve/2eM3wWU4mLifQzvnqUBjvsSzr55SNSB0qcOnx/AphUZ93qosDBjQXf6QI8KUnX+GZX/qCLzPyJ1dj7Ep/Q0AWEpUvkAL27AFs80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360152; c=relaxed/simple;
	bh=rFp2Pbme6u/T0c/7W0fmYdC6u4li5F5aP9inOBYFKOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv9hFs8cR9S7y1GaWMqx2215Zu4cxJtH2kxyAvA19SY5sXNBAa6x0a6UVKJfRdXmI6qaj+R/jNsnHSp32JJ5LmuakoVZ8Sfq4++1Idm5ZivzDNlETtf11nlmFvx6pQJJDKn5Jae0RvO2vEtiIA8ST00alXmzdVNSbq4kqLOJhDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2BaIJ+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2BaIJ+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A250C32782;
	Tue, 30 Jul 2024 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360152;
	bh=rFp2Pbme6u/T0c/7W0fmYdC6u4li5F5aP9inOBYFKOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2BaIJ+JNldtJiGWqPaYje/4CMrfrrNLtAb7egPSJZku3Q9J7T3AOeJspd7dD9lmV
	 ToZa9ccKlGJaSH5xuO+cwNEuejRNfSnKyEO/Cs6hPC/0IQVNOP2bYMsBtSJoptEGdc
	 rgcuhUF9xcy3jT+2pN8Ge4vytQDTKDsk6nZ1r084=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.10 612/809] jbd2: make jbd2_journal_get_max_txn_bufs() internal
Date: Tue, 30 Jul 2024 17:48:08 +0200
Message-ID: <20240730151749.010950601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -766,7 +766,7 @@ start_journal_io:
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
@@ -1698,6 +1698,11 @@ journal_t *jbd2_journal_init_inode(struc
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
@@ -1660,11 +1660,6 @@ int jbd2_wait_inode_data(journal_t *jour
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


