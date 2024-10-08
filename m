Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333431DFDBF;
	Tue,  8 Oct 2024 13:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393795; cv=none; b=lX07mQYhY5YVa6TR/manhZZRTbeNdpIMhi+DazoQ7j8Ti3lQRRsQZPKWxeDRfal3g4E0y3T+lB1Y6WY8tdEDVcKv9jmSpYByL8MwDh22PY1m/+e2WB63v2jzJrA9yvtyM8POLpBIAD8auvF1X0mh9Tni7nphyty8pg0TuolPFHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393795; c=relaxed/simple;
	bh=mijUXsVd5v++8Xh2DqmAW4xnTPKgkjC8/CIEfvJYqYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8SKq+cEIFLeTfin71o42ZZV6lahbrlq635xKYbbfs82ntOg85OcHK4x3K9FrUF9wIEwcsyZxcIkmu5wYmZPRo6jAGlYx0nYSSJANqlMxj8rQESaEbs1UIr714k0XDjA334TBsZd/T4ASQCeVYBXIRs2oD/yaFyxt5DqowM13yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpctSvFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpctSvFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A439BC4CEC7;
	Tue,  8 Oct 2024 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393795;
	bh=mijUXsVd5v++8Xh2DqmAW4xnTPKgkjC8/CIEfvJYqYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpctSvFVBbTkpEWc3oUAaMscHD26KrmTZ8M3Gruq56cepAlDjVpmGk6nxOKi6KUv+
	 bejmM7SfhUcRUHe/BaojPubHXlhMVDhaEzsNVYfaIQ/rQGyi6aGdsUKz8/PsSgbcyE
	 Yu+amF7Fd5hF6V196KFeq2aAV9Wj/9Jca5f1zl9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 256/386] jbd2: stop waiting for space when jbd2_cleanup_journal_tail() returns error
Date: Tue,  8 Oct 2024 14:08:21 +0200
Message-ID: <20241008115639.468802159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit f5cacdc6f2bb2a9bf214469dd7112b43dd2dd68a upstream.

In __jbd2_log_wait_for_space(), we might call jbd2_cleanup_journal_tail()
to recover some journal space. But if an error occurs while executing
jbd2_cleanup_journal_tail() (e.g., an EIO), we don't stop waiting for free
space right away, we try other branches, and if j_committing_transaction
is NULL (i.e., the tid is 0), we will get the following complain:

============================================
JBD2: I/O error when updating journal superblock for sdd-8.
__jbd2_log_wait_for_space: needed 256 blocks and only had 217 space available
__jbd2_log_wait_for_space: no way to get more journal space in sdd-8
------------[ cut here ]------------
WARNING: CPU: 2 PID: 139804 at fs/jbd2/checkpoint.c:109 __jbd2_log_wait_for_space+0x251/0x2e0
Modules linked in:
CPU: 2 PID: 139804 Comm: kworker/u8:3 Not tainted 6.6.0+ #1
RIP: 0010:__jbd2_log_wait_for_space+0x251/0x2e0
Call Trace:
 <TASK>
 add_transaction_credits+0x5d1/0x5e0
 start_this_handle+0x1ef/0x6a0
 jbd2__journal_start+0x18b/0x340
 ext4_dirty_inode+0x5d/0xb0
 __mark_inode_dirty+0xe4/0x5d0
 generic_update_time+0x60/0x70
[...]
============================================

So only if jbd2_cleanup_journal_tail() returns 1, i.e., there is nothing to
clean up at the moment, continue to try to reclaim free space in other ways.

Note that this fix relies on commit 6f6a6fda2945 ("jbd2: fix ocfs2 corrupt
when updating journal superblock fails") to make jbd2_cleanup_journal_tail
return the correct error code.

Fixes: 8c3f25d8950c ("jbd2: don't give up looking for space so easily in __jbd2_log_wait_for_space")
Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240718115336.2554501-1-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -89,8 +89,11 @@ __releases(&journal->j_state_lock)
 			write_unlock(&journal->j_state_lock);
 			if (chkpt) {
 				jbd2_log_do_checkpoint(journal);
-			} else if (jbd2_cleanup_journal_tail(journal) == 0) {
-				/* We were able to recover space; yay! */
+			} else if (jbd2_cleanup_journal_tail(journal) <= 0) {
+				/*
+				 * We were able to recover space or the
+				 * journal was aborted due to an error.
+				 */
 				;
 			} else if (has_transaction) {
 				/*


