Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155AD396B6F;
	Sat, 12 Sep 2026 07:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196684; cv=none; b=XkMStcLDPzzwkIf6lsBKe2ru/rqa/gbSXVNvIJs8KZ5exIc0wFWwQrxufptxGGUALEEXxCPtECjeMN9KuixycL+Fdt3oSB/JopZj5TMFv9z5IZTVBp4JWTXwV3y6ZNNbijB5QMqgnzkZ7Zrh2t/U+njCbAex0NRY+fpQvhrrZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196684; c=relaxed/simple;
	bh=L9yROu3Zja8ue0mtPYfk64cq3qQdnoMfLrVh42LmDy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBg1y8LuFMW+HggrtAwqGQVgwgR8ZA1XMBrjhD+hoU59KNpn7LW0/oOOfFaDSFq7Lp1wV0TLF5YZcyAJD/4tH9c4IMn3ZpToJViIOwFQ2MzTZl2uTPH423DhX8e2qDGiZKfBYsGQYffS4Pc84laXs6DHaggSySlDeENY9oRMHDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9LEUsj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9LEUsj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54D21F000FF;
	Sat, 12 Sep 2026 07:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196679;
	bh=lLx3ok5lqf0KqaNWUpdt+qpROuj9v5e7jnwOYoL58Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9LEUsj55+kVw1q54DMbFdbTBrRGZUONmZLPXSn0GV+7LFynOuaAoVsf9+OznrDOJ
	 YSk/3TOfgkJT8DvMo7/W/3jjCD7dWwMi+cNcWPlNPxSwIhoyqNM7nuJmzgyqUlaKu/
	 bTKzW4aj80rS4RtlnIKeqX++PjtCfEu+SNOpz+mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	"jlayton@meta.com" <jlayton@meta.com>,
	Leo Martins <loemra.dev@gmail.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0016/1815] btrfs: abort transaction before releasing tree_log_mutex on commit failure
Date: Sat, 12 Sep 2026 08:29:26 +0200
Message-ID: <20260912065649.390463439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Martins <loemra.dev@gmail.com>

[ Upstream commit 529c01c3dc0d322c103611c35b01d71ea04562b2 ]

When transaction metadata writeout fails in btrfs_commit_transaction(),
the current code only logs the error, drops tree_log_mutex and then goes
through cleanup_transaction(), which aborts the transaction and records
the fs error.

That is too late for the tree log side. A log sync can already be
waiting on tree_log_mutex, because the committing transaction is moved
to TRANS_STATE_UNBLOCKED while that mutex is held, which lets fsyncs
join the next transaction and queue up in btrfs_sync_log(). Once the
failed commit drops tree_log_mutex, such a log sync acquires it, sees
BTRFS_FS_ERROR() still clear, and writes super_for_commit. That
superblock holds the roots prepared for the transaction that has just
failed to write out its metadata, so it can point at tree blocks that
never reached the disk, and the next mount fails with a parent transid
mismatch.

Commit 165ea85f1483 ("btrfs: do not write supers if we have an fs
error") fixed this class of problem by making btrfs_sync_log() check for
an fs error right after taking tree_log_mutex. That check only works if
the commit path publishes the fs error before it releases the same
mutex, and commit 68d4ece9c30e ("btrfs: don't call
btrfs_handle_fs_error() in btrfs_commit_transaction()") removed the only
thing that did so.

Restore the ordering by aborting the transaction while tree_log_mutex is
still held. We have a transaction handle here, so this does not need to
bring back the btrfs_handle_fs_error() call: __btrfs_abort_transaction()
records the fs error itself, which is all btrfs_sync_log() looks at, and
the error message put in its place is kept.

This is what commit 3810ab40afa5 ("btrfs: abort transaction on error in
write_all_supers()") already does for the next call in this function.

This is reproducible on an unmodified kernel by failing the first
couple of bios of a transaction commit with fail_make_request while a
concurrent fsync workload keeps log syncs queued on tree_log_mutex.

Fixes: 68d4ece9c30e ("btrfs: don't call btrfs_handle_fs_error() in btrfs_commit_transaction()")
CC: stable@vger.kernel.org # 7.0+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: jlayton@meta.com <jlayton@meta.com>
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[ adjusted error-message context to retain `%d` with `ret` instead of `%pe` with `ERR_PTR(ret)`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/transaction.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2589,6 +2589,12 @@ int btrfs_commit_transaction(struct btrf
 	ret = btrfs_write_and_wait_transaction(trans);
 	if (unlikely(ret)) {
 		btrfs_err(fs_info, "error while writing out transaction: %d", ret);
+		/*
+		 * Abort before releasing tree_log_mutex, so a log sync waiting
+		 * on it sees the fs error and skips writing super_for_commit
+		 * for this failed transaction. See btrfs_sync_log().
+		 */
+		btrfs_abort_transaction(trans, ret);
 		mutex_unlock(&fs_info->tree_log_mutex);
 		goto scrub_continue;
 	}


