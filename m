Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF54C1DE8B4;
	Wed,  6 Nov 2024 12:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895394; cv=none; b=JzcyrKkYmSjspzWzgLs5uwd0VKr7kHL4R32UjuOGN+9EYlxoY0jxUHGuqzDp0e0pP6RkXlal9WytjpsWgRd4hjxDuvFPbozjwpr7Dncla2YVmAR7M6zQ/TkQomwvfCSheepe7WXQ4dVWo/omRY5Mw912b9LQ7jMx3HqIMCQGrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895394; c=relaxed/simple;
	bh=IsZtY2uP4SbZGxtvd9dFGXskmdg0j8Kj0BO9R2Xk15w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6+yI0HUuoSgv1fBeMQ+ymJCCHVLzvQiq3R86wPx80GVLLZG0CHAo1bUjVj8vy//WlmDy4CDwOTuQ7Fura4s39AK0vIvlNfJXYE7fzeFeLsimKrarCqBamAbKXtfAnpxY60tLIphPS7LiELMePV6m4dmT2R+gF4YvxHEn1xHldQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQ8O9dKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQ8O9dKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C658C4CECD;
	Wed,  6 Nov 2024 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895394;
	bh=IsZtY2uP4SbZGxtvd9dFGXskmdg0j8Kj0BO9R2Xk15w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQ8O9dKBAEyO0WqSEL+fmVeDaXrpLcorwXDtYoiXWvadpJBpyokpyaawki3BYdh8Q
	 1pl+46+vBWWYR0s8Er93k1vp2HypxPKi/bRFWABtRQcA6paE3Es5PJsxkYVJUaLKOf
	 nsxkWWkxL0DQTx+2Q/RRb6BszZblqRILAkZehL6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>,
	syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 202/350] ocfs2: fix null-ptr-deref when journal load failed.
Date: Wed,  6 Nov 2024 13:02:10 +0100
Message-ID: <20241106120325.967448699@linuxfoundation.org>
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

From: Julian Sun <sunjunchao2870@gmail.com>

commit 5784d9fcfd43bd853654bb80c87ef293b9e8e80a upstream.

During the mounting process, if journal_reset() fails because of too short
journal, then lead to jbd2_journal_load() fails with NULL j_sb_buffer.
Subsequently, ocfs2_journal_shutdown() calls
jbd2_journal_flush()->jbd2_cleanup_journal_tail()->
__jbd2_update_log_tail()->jbd2_journal_update_sb_log_tail()
->lock_buffer(journal->j_sb_buffer), resulting in a null-pointer
dereference error.

To resolve this issue, we should check the JBD2_LOADED flag to ensure the
journal was properly loaded.  Additionally, use journal instead of
osb->journal directly to simplify the code.

Link: https://syzkaller.appspot.com/bug?extid=05b9b39d8bdfe1a0861f
Link: https://lkml.kernel.org/r/20240902030844.422725-1-sunjunchao2870@gmail.com
Fixes: f6f50e28f0cb ("jbd2: Fail to load a journal if it is too short")
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reported-by: syzbot+05b9b39d8bdfe1a0861f@syzkaller.appspotmail.com
Suggested-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/journal.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -989,7 +989,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -1008,9 +1008,10 @@ void ocfs2_journal_shutdown(struct ocfs2
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) &&
+	    (journal->j_journal->j_flags & JBD2_LOADED)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal);
 		jbd2_journal_unlock_updates(journal->j_journal);


