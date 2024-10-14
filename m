Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68211A76CE;
	Mon, 14 Oct 2024 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919240; cv=none; b=K/CidSkjSEIQcnKBc/YQq9SE8h+ec2AQFmLBmPH/DtZ0n0FDi16o1mgZZ4/DjFbwvWwEPQq8bj8Zn/kePZITTYYK64NpwWYJDT5VSSQnDmGaV/4nS+2M8wezezukrYGSBYqcERTDarEcOYHrhcJ6cJjb4egFYZDVfybphvwHxAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919240; c=relaxed/simple;
	bh=3hJ3ja/N9bzSmg144mUrwZHh95aMRuyaYBLx3rDrw58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNjDQFwDfXCVBosz3RglbF8HipxgDSoAEYMl9zm6Ic8eFGvcmo2q3AuItwW6ZoVPkQ3Amn+/BUZWHuDwTYtiS4mmqoufIqpK8GHl4oa5SM/mThkOz6S0U79MxYIWDwK69mXWYY8Ld1bTL5YgbPGWMOeB/5iaS6Xrz6LJ9JfdMpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUa0FeP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUa0FeP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3534FC4CEC3;
	Mon, 14 Oct 2024 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919240;
	bh=3hJ3ja/N9bzSmg144mUrwZHh95aMRuyaYBLx3rDrw58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUa0FeP5c/kmo2ryqsKclo+c5w+osYv0oxlcoF8hf+EnRsV3+yH9HItiqPDMapjZ5
	 HbnHeDjqQrwY3CvlYV+8wXM0aBDM29wkl3w3ZEH2C1LmbXqEZJQ/GGjRWMAHl+I+tx
	 9oyX5RlsBVOZxXAbkr2TafiHTNh7a2jksFtUsJaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 552/798] ext4: fix incorrect tid assumption in ext4_wait_for_tail_page_commit()
Date: Mon, 14 Oct 2024 16:18:26 +0200
Message-ID: <20241014141239.684077146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit dd589b0f1445e1ea1085b98edca6e4d5dedb98d0 upstream.

Function ext4_wait_for_tail_page_commit() assumes that '0' is not a valid
value for transaction IDs, which is incorrect.  Don't assume that and invoke
jbd2_log_wait_commit() if the journal had a committing transaction instead.

Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240724161119.13448-2-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5350,8 +5350,9 @@ static void ext4_wait_for_tail_page_comm
 {
 	unsigned offset;
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
-	tid_t commit_tid = 0;
+	tid_t commit_tid;
 	int ret;
+	bool has_transaction;
 
 	offset = inode->i_size & (PAGE_SIZE - 1);
 	/*
@@ -5376,12 +5377,14 @@ static void ext4_wait_for_tail_page_comm
 		folio_put(folio);
 		if (ret != -EBUSY)
 			return;
-		commit_tid = 0;
+		has_transaction = false;
 		read_lock(&journal->j_state_lock);
-		if (journal->j_committing_transaction)
+		if (journal->j_committing_transaction) {
 			commit_tid = journal->j_committing_transaction->t_tid;
+			has_transaction = true;
+		}
 		read_unlock(&journal->j_state_lock);
-		if (commit_tid)
+		if (has_transaction)
 			jbd2_log_wait_commit(journal, commit_tid);
 	}
 }


