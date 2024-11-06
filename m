Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19BF1922EF;
	Wed,  6 Nov 2024 13:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898494; cv=none; b=n8CQLwLdf+lio6xVMjUpgHIyy7PY/axse29Dj0+v6B2btwoevYuA7ZMKcrGp3AR/kS4p8IDWuERu1m9l8wWJPi+uHcXjfi94ylQBjv8kDHh2Y53GMcFssBUZqMfp3ZUCCe5jHHx+7+Obb712O8X0oWLwtMvzcgSjNnx8IaPiuxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898494; c=relaxed/simple;
	bh=H6hg6b6SivqltR4X5YkW+puXMeEj1SudnpRrkcIOPPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMKcJM5rozftnyPTgBS138Wt3mYcbXsVnsPLuFUUwfds2MG1RXxzNmwT8zmqHrXnAv+oAaW8QYVt7Lj7iAziQHBARUpjw6piBX+f3UjGlfX5+4mlu1Emjv1FO+wQjEgmPz8AWriD5guBt5aNcrI+ebWAQIOhKwECPaLiday5Nf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoZUulp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoZUulp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565DCC4CECD;
	Wed,  6 Nov 2024 13:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898494;
	bh=H6hg6b6SivqltR4X5YkW+puXMeEj1SudnpRrkcIOPPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoZUulp2HYtODpFYmkXr5+n7OmBSBvfpxjhrWDtOy3tSfkTLoWpNxQtXk6KkkwdVU
	 q6Kx97H83/v/KGEWWGRiMUkcTurgkh9vOLO+leswnXMnhSAUzs1mv3ZhHJd9xMTb8e
	 O72BbKX/79euhOH0upvCI5oxEaH2ITzRNbDs+8UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 256/462] jbd2: stop waiting for space when jbd2_cleanup_journal_tail() returns error
Date: Wed,  6 Nov 2024 13:02:29 +0100
Message-ID: <20241106120337.848968347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -125,8 +125,11 @@ __releases(&journal->j_state_lock)
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


