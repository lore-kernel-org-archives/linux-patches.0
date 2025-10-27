Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A744D1DED64;
	Mon, 27 Oct 2025 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590898; cv=none; b=XRRQfdS7/bSe75fjIsCRQqPBLjzJpxxJ31sF0j0r1v587o+RDrJ0A2xYLM0Gb5Q1TXPRM77qHNwngvjU779Giel+3p4AaMi/xG27qj7H8aehEm2C4JQkKoX2kibBcGHbTy2rynnE26pVTHcjV5OdU5JswByGhjnsL/1zLWNVgoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590898; c=relaxed/simple;
	bh=Jm3zQ7dI/gnVsVwU78PeR0rduI0l7NbvSU5zsPfHpTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxMpKSByAcsnOuxR4F0irDVclWX2sBjPzqMS2M45ax7WI4ToGUPskSsphTZVQ952ilJZH7mBDYQ7M2wgFo3L7lSmpCP24uebgeRwZ4/tVgiuOG7qFegxug6FtEZA4TAGLf3FCVCtBu+iWq0L489lyrzIn/p7MvgsGH1KxA4ceEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhQD9bqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhQD9bqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB54C4CEF1;
	Mon, 27 Oct 2025 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590898;
	bh=Jm3zQ7dI/gnVsVwU78PeR0rduI0l7NbvSU5zsPfHpTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhQD9bqyEBUszIsIw6MJO9WYK6nInTrzWTY1e8G4t10GLZosZb3gdMc43tFlwoGRY
	 lI2ARCMOROKucNHL2fxK1Rv0U7G4c/m3sfPAf3slhTeSiHZFxoXTQ8UdMYQHTnS0RZ
	 k3jTReBjx2h+ntxSC/QcKPuj/KYR0Vgd+LW91fE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/224] jbd2: ensure that all ongoing I/O complete before freeing blocks
Date: Mon, 27 Oct 2025 19:36:02 +0100
Message-ID: <20251027183514.526016146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 3c652c3a71de1d30d72dc82c3bead8deb48eb749 ]

When releasing file system metadata blocks in jbd2_journal_forget(), if
this buffer has not yet been checkpointed, it may have already been
written back, currently be in the process of being written back, or has
not yet written back.  jbd2_journal_forget() calls
jbd2_journal_try_remove_checkpoint() to check the buffer's status and
add it to the current transaction if it has not been written back. This
buffer can only be reallocated after the transaction is committed.

jbd2_journal_try_remove_checkpoint() attempts to lock the buffer and
check its dirty status while holding the buffer lock. If the buffer has
already been written back, everything proceeds normally. However, there
are two issues. First, the function returns immediately if the buffer is
locked by the write-back process. It does not wait for the write-back to
complete. Consequently, until the current transaction is committed and
the block is reallocated, there is no guarantee that the I/O will
complete. This means that ongoing I/O could write stale metadata to the
newly allocated block, potentially corrupting data. Second, the function
unlocks the buffer as soon as it detects that the buffer is still dirty.
If a concurrent write-back occurs immediately after this unlocking and
before clear_buffer_dirty() is called in jbd2_journal_forget(), data
corruption can theoretically still occur.

Although these two issues are unlikely to occur in practice since the
undergoing metadata writeback I/O does not take this long to complete,
it's better to explicitly ensure that all ongoing I/O operations are
completed.

Fixes: 597599268e3b ("jbd2: discard dirty data when forgetting an un-journalled buffer")
Cc: stable@kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20250916093337.3161016-2-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1550,6 +1550,7 @@ int jbd2_journal_forget (handle_t *handl
 	int drop_reserve = 0;
 	int err = 0;
 	int was_modified = 0;
+	int wait_for_writeback = 0;
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
@@ -1675,18 +1676,22 @@ int jbd2_journal_forget (handle_t *handl
 		}
 
 		/*
-		 * The buffer is still not written to disk, we should
-		 * attach this buffer to current transaction so that the
-		 * buffer can be checkpointed only after the current
-		 * transaction commits.
+		 * The buffer has not yet been written to disk. We should
+		 * either clear the buffer or ensure that the ongoing I/O
+		 * is completed, and attach this buffer to current
+		 * transaction so that the buffer can be checkpointed only
+		 * after the current transaction commits.
 		 */
 		clear_buffer_dirty(bh);
+		wait_for_writeback = 1;
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
 		spin_unlock(&journal->j_list_lock);
 	}
 
 	jbd_unlock_bh_state(bh);
 	__brelse(bh);
+	if (wait_for_writeback)
+		wait_on_buffer(bh);
 drop:
 	if (drop_reserve) {
 		/* no need to reserve log space for this block -bzzz */


