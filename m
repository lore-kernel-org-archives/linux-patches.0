Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ACE1EE000;
	Wed,  6 Nov 2024 13:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898515; cv=none; b=LryIs0fjUZlasmNu/jYKi5zVa2Z67gpmgEbazugHdSDerZARwiuYQdRZq7v2uNUwUjaRRiJ3/mEqNjBIitccPDGeEh3maOrDB9puQ+TNiquNfb3zyU1r9Abu4n/vRcRZDkWjLxxQswsk9pXKpGz84hhvd0pEQeeScv4wRG7/bWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898515; c=relaxed/simple;
	bh=MKSFNfGJi9NCUGLW+KEb8AgCHE9cJ9TobzFg1Oao7Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+U1M1+RHUdxhVLXxT3V2IqgOBWxQvx+rlvZJSlE0/vH7ENj053Ncef8LGC+k8d9aCqFMLF32JtcGbTzGNQEv8h3SReDJCNiOuX0XbS8Lapz3nFjTEU4Wuo5fkmXXDVihpVP1nz+a0/eXOnBeJsC1oJw8xTphwW3xJ3ehJRO3gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHg5ctcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHg5ctcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CF0C4CED3;
	Wed,  6 Nov 2024 13:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898515;
	bh=MKSFNfGJi9NCUGLW+KEb8AgCHE9cJ9TobzFg1Oao7Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHg5ctcUAV7wXeRsT+RfxyAF6n6D6KOnNKAzN+sjDHwJlY7Ew/86Sjg0fpeBEmsjB
	 41vJ42boA2945UQqV7262A5AxXangm4Y2+y/wyGhlQkTLiqrE3UcABeeXDLw2tguJ3
	 dCMkoYt2cneNm4sgDQdwAenT0RcBmj9npV0MloEE=
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
Subject: [PATCH 5.4 263/462] ocfs2: fix null-ptr-deref when journal load failed.
Date: Wed,  6 Nov 2024 13:02:36 +0100
Message-ID: <20241106120338.024091809@linuxfoundation.org>
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
@@ -975,7 +975,7 @@ void ocfs2_journal_shutdown(struct ocfs2
 	if (!igrab(inode))
 		BUG();
 
-	num_running_trans = atomic_read(&(osb->journal->j_num_trans));
+	num_running_trans = atomic_read(&(journal->j_num_trans));
 	trace_ocfs2_journal_shutdown(num_running_trans);
 
 	/* Do a commit_cache here. It will flush our journal, *and*
@@ -994,9 +994,10 @@ void ocfs2_journal_shutdown(struct ocfs2
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


