Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1C630506B;
	Mon, 27 Oct 2025 19:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591845; cv=none; b=W0XNzeLyGwNtyzGf++AOrqmnmm5UjEaoa38ity6oXcuvEqXHA95p1Ivv9QDiWPufInBgbe0fuMkL7alxh2h1PocK5qkgoBypU1QHdgau8OXFIHwseHPRyx/pKIZBfyGizbGOdHEMwvbvZbRZEqoFq8dAM3XgZTIvUuX6/xpROSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591845; c=relaxed/simple;
	bh=QUNV8RJuVnLPa5ckDSKCCTAwBKYIVbMFZ72fsoOacDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF5T+rtjqMM3QNhQp7451vsbs8uw2QS2woavlMmzxienE1J6olON59sQswUCFHH8fSQkFA4VUif/152vKlsp2PPJJwL4mknQyNhdPDWGMvi7Fr9KlI5l7aKN5QUeJAH3jka+ze8KOAiZV1RcQh9ENoJDauzyxF74amsVjcUZ0/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjMPF8Py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjMPF8Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1095AC4CEF1;
	Mon, 27 Oct 2025 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591844;
	bh=QUNV8RJuVnLPa5ckDSKCCTAwBKYIVbMFZ72fsoOacDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjMPF8Py9PemqOuz0QkfCXESGz3DK04RBLu+MvNduc0yNNOtFBokmVeDlN19uS9DC
	 xzpt8iH243VEwID0srfqnqK8Fa/XJfyL3XhDGmH1tBXXxiXk8xBzsHsxASd3JCml4J
	 sZv/IpE8HDfzFy1QrRFHUlQA2JPSsd2LXZ+9JNQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 002/123] jbd2: ensure that all ongoing I/O complete before freeing blocks
Date: Mon, 27 Oct 2025 19:34:42 +0100
Message-ID: <20251027183446.453499317@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1669,6 +1669,7 @@ int jbd2_journal_forget(handle_t *handle
 	int drop_reserve = 0;
 	int err = 0;
 	int was_modified = 0;
+	int wait_for_writeback = 0;
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
@@ -1792,18 +1793,22 @@ int jbd2_journal_forget(handle_t *handle
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


