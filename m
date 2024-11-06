Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD7E1DE8A2;
	Wed,  6 Nov 2024 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895356; cv=none; b=KSUfRsRJ2GE0IZTUzC8NU042IPl1ZMPs6pJz+OIX4zsnHQ6fQep5bXKlxlzb5C9h2vlRwnC8cEc/0Lyj6Ewx4OYIFkHxs7O9SvX6ODz+6NbA4Hm5snzq38+epEaVHX5dDQggVIILgJhcHE7PjUZjuzosCLCsTN4r4lMflVlUoMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895356; c=relaxed/simple;
	bh=bnT53fWHMePPCObq0fblbrWeWZT/xwn3ObNIDSqlLQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlcYgDegyDr/XmuqiUbbQlJl2yVd+L/eIphresrmlYS4csXoW1I93re+eLtxFdc3DU7G+hxd4u1fPz8F5OM4g3layCnU3q2J+ctefwvDK+jQKansfsQ0n0sMts25EYsUg70UVkkefRb5jmmNfaPKUUgiPtE+vTUvVc2Yl3e2EVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CycgUPIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CycgUPIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D5DC4CECD;
	Wed,  6 Nov 2024 12:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895356;
	bh=bnT53fWHMePPCObq0fblbrWeWZT/xwn3ObNIDSqlLQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CycgUPIg4V16JmiaSDWTXyoSqgPz3ieD78aD7B1W+Tgjw8ZgA5qlyiDUqdBdzwx4Q
	 F5lLo7Jam7B0nI2+RjagbVzYDVXjkFp45HGHgpokgY6bJxALufleVoRDxTYyUY5p5B
	 G7/U/Mopu1A3agV3PrCm7EiRMWLjVRRRZJ43BPWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.19 190/350] ext4: fix incorrect tid assumption in __jbd2_log_wait_for_space()
Date: Wed,  6 Nov 2024 13:01:58 +0100
Message-ID: <20241106120325.652763841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 972090651ee15e51abfb2160e986fa050cfc7a40 upstream.

Function __jbd2_log_wait_for_space() assumes that '0' is not a valid value
for transaction IDs, which is incorrect.  Don't assume that and invoke
jbd2_log_wait_commit() if the journal had a committing transaction instead.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -137,9 +137,12 @@ void __jbd2_log_wait_for_space(journal_t
 		if (space_left < nblocks) {
 			int chkpt = journal->j_checkpoint_transactions != NULL;
 			tid_t tid = 0;
+			bool has_transaction = false;
 
-			if (journal->j_committing_transaction)
+			if (journal->j_committing_transaction) {
 				tid = journal->j_committing_transaction->t_tid;
+				has_transaction = true;
+			}
 			spin_unlock(&journal->j_list_lock);
 			write_unlock(&journal->j_state_lock);
 			if (chkpt) {
@@ -147,7 +150,7 @@ void __jbd2_log_wait_for_space(journal_t
 			} else if (jbd2_cleanup_journal_tail(journal) == 0) {
 				/* We were able to recover space; yay! */
 				;
-			} else if (tid) {
+			} else if (has_transaction) {
 				/*
 				 * jbd2_journal_commit_transaction() may want
 				 * to take the checkpoint_mutex if JBD2_FLUSHED


