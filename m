Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E775C1DFDA2;
	Tue,  8 Oct 2024 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393924; cv=none; b=n5XRLQYL9YTydHCrFzuTDCyZ+nOoUoE0eaFlJ/XVgaa5pzXtEnc41hhJ+cI0uMria1VcuirLHBOacK1XHqizHQHeB9WLNKqIQBrNx8kvuBvm91Gg2XjOnuBsPmLajwJuq6AFDa0SGhzGb2oSN533Az+s+M6z9zvlW2a4qxTD/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393924; c=relaxed/simple;
	bh=7NFXa7rFOvOiQRP6GD88GCQSybzixquX6iOesbMbpA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ+WfoGGYzbkG1bUuIOgmwGstGqTEbjM/MM/DrikRjkjhjs1m4Z5NWwb6Rr7tzUyWvgZHaGRjCm6/LZqVDQM4pPfQIdzy+aTsDJBCQw795ZILqgjlgz7TRR6m5S0TplRxd4NuVFa/Betf1E15V3FhN8eWaIu70F/EA0anBS0tEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnnWa6wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnnWa6wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37686C4CEC7;
	Tue,  8 Oct 2024 13:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393923;
	bh=7NFXa7rFOvOiQRP6GD88GCQSybzixquX6iOesbMbpA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnnWa6wipvHretQIX8swhtqD0CotsrgqgKofu+OPSlCSmuOWf8Izl54c62IJsSEi+
	 M9P5wMFxZhXwKTMREUSdZMjqX4hBbb68zdTaQqoV8XDJD+UzIeH6gjm6uZATHwqZ/l
	 uYZdxMfofpP73nDaC3h+tNdexlfeD5CpKip9QAXM=
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
Subject: [PATCH 6.6 264/386] ocfs2: fix null-ptr-deref when journal load failed.
Date: Tue,  8 Oct 2024 14:08:29 +0200
Message-ID: <20241008115639.780383555@linuxfoundation.org>
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
@@ -1055,7 +1055,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -1074,9 +1074,10 @@ void ocfs2_journal_shutdown(struct ocfs2
 		osb->commit_task = NULL;
 	}
 
-	BUG_ON(atomic_read(&(osb->journal->j_num_trans)) != 0);
+	BUG_ON(atomic_read(&(journal->j_num_trans)) != 0);
 
-	if (ocfs2_mount_local(osb)) {
+	if (ocfs2_mount_local(osb) &&
+	    (journal->j_journal->j_flags & JBD2_LOADED)) {
 		jbd2_journal_lock_updates(journal->j_journal);
 		status = jbd2_journal_flush(journal->j_journal, 0);
 		jbd2_journal_unlock_updates(journal->j_journal);


