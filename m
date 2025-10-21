Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF75526F292;
	Tue, 21 Oct 2025 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076520; cv=none; b=q7oN9aDseNer2cRo1qpX+KPi+jFl2IHnbtI4RrYejLIyIJaLkSYx3Hf4/ERYTDk/EkrdBb6NKGqeg1Wz0V2Xh1zELa53u0oOUlkCgBqqPK20e6hhviV1HDAK4+c/uRoBdOhaJWbb2iJ2UkqywyZ4jnf3qRmCb3rqeshon3y4L9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076520; c=relaxed/simple;
	bh=MGjgbC/jFgk9C0CytzjcP/3fSHkPcCb8AjITugdUEUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNEOfmwzBQoqlEwCLsj7y/ZAZvdiD0a4VeJSuElz8YGDeAnRiPyWw/bsSE6RPa7MpC6Pl7L1GSJDk8do1ko6cWxYY6m2mlqFYV+JY3EM/mi314+3t9Jo8B+vCn8LyzJ8nSwSX9AouJ+/Ok1Kf9xfYXLRmfdkyTmQ4RZIwjy1x3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kzf2NVVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kzf2NVVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC46C4CEF1;
	Tue, 21 Oct 2025 19:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076520;
	bh=MGjgbC/jFgk9C0CytzjcP/3fSHkPcCb8AjITugdUEUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kzf2NVVUC0GSe4rFH6KWgX2puuqIQMuz9Kijixf/U3qDjiaIpxY4uCRqzyRwE+DG6
	 QF7H/0T0b3eHI/0fNpN2PvSBJjtrxBeZmxPh2426fxo75lqKy7cbwqgaleApIa4f8U
	 UE/DMP7L6cgzjAed0+B6u3v+yD06LUFK9eEgaRRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 005/105] jbd2: ensure that all ongoing I/O complete before freeing blocks
Date: Tue, 21 Oct 2025 21:50:14 +0200
Message-ID: <20251021195021.621764081@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 3c652c3a71de1d30d72dc82c3bead8deb48eb749 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1649,6 +1649,7 @@ int jbd2_journal_forget(handle_t *handle
 	int drop_reserve = 0;
 	int err = 0;
 	int was_modified = 0;
+	int wait_for_writeback = 0;
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
@@ -1772,18 +1773,22 @@ int jbd2_journal_forget(handle_t *handle
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
 drop:
 	__brelse(bh);
 	spin_unlock(&jh->b_state_lock);
+	if (wait_for_writeback)
+		wait_on_buffer(bh);
 	jbd2_journal_put_journal_head(jh);
 	if (drop_reserve) {
 		/* no need to reserve log space for this block -bzzz */


