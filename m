Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3241FAF18;
	Tue, 15 Oct 2024 13:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998145; cv=none; b=e0x4j9gxKZ4IQVwKDTnQP1IDxm8OTSkgyJD4luEnCmjuJij2PL1oTY/OAfMcNozUe/9ZBlEkaYq/2XAxK/OM2Zp56XDlSQ64yK4Idgeh7iJ9X+8SBIgyXns/apk5fwpRLF0lss4fGKf11VmXbB992duu0x5L9VEpiB9PMbmSXa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998145; c=relaxed/simple;
	bh=EcuVr9e8DTL5JYaxDBXxbA+zj3NAxu9dtYEF9prNS/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0fC8uORuJm8t0SJBnRYinpiu76vbkt8H/+fDjRMsTtLxol8jyaFtYuCYFBYDqAHkGYE5kcmMEcYHjxUQAPhVQ24UBTr5o0UXfY6Lr//XNE3Rk9noGcM2Nq5QJoLseOlfpdPv+rypYkvMDpbSzdp0nevvCkFN9YNDo5Qk6bI3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUtQoYt4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUtQoYt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6577CC4CECE;
	Tue, 15 Oct 2024 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998144;
	bh=EcuVr9e8DTL5JYaxDBXxbA+zj3NAxu9dtYEF9prNS/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUtQoYt4/DaeB7wsKpqgkmOEpbgApK3c1tUNjv5ptXEEzSBevLhSznXyp334M+84v
	 okQQePSIMRb+SU6kF3ucS3Q0FFrEZBhNPFoLdHnJdpdHa0TMfR5g5ibwq10WJI7b5P
	 JUGfACLo4+USrENCkPYWJ0lH9suqAc/rCXyBKiSo=
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
Subject: [PATCH 5.10 391/518] ocfs2: fix null-ptr-deref when journal load failed.
Date: Tue, 15 Oct 2024 14:44:55 +0200
Message-ID: <20241015123932.063803203@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -996,7 +996,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -1015,9 +1015,10 @@ void ocfs2_journal_shutdown(struct ocfs2
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


