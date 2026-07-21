Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85E13F825C;
	Tue, 21 Jul 2026 17:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654583; cv=none; b=L9QkT2zoWkktelrbcgTwMTbT5t60hC/DI2YhGSpoQ2tZMxzwzSR83LnohE/5lwCKqnrhJWjw9f5tmGL5PE71w0vpIAanMn7KT2NiH7su4kONLJV0ucgDvQzM3ekrKnhlpp7lhlAEzUMy/r1jfW3zGp0ot68kkEtF6a5YuiiP/4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654583; c=relaxed/simple;
	bh=mfyegmyy17camLG8qkxTTn1qTeprFRLivbJbEh4QiZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=io2D7FKB/sBjyjQaM3rFEYaV4KvBjSlo5auvZBkgTfvWlAqyy05d6soJkCZT1E7PKlbxGX7HwjfojlEYq5OFUC+iVV0VjXTqp6JPfWDPHCrRPC2CUE/gFV1VJ6iyfWV4Gta8XKQMnZdhJT692aZk7jhG5vjvulQJv757MhNFSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/qIVmkg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/qIVmkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470A11F000E9;
	Tue, 21 Jul 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654580;
	bh=yom0AC55cM/vMLxJaw79v0nrnXBSmx3cs6I+uPVcEog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/qIVmkg4U59bFXrLPeqUzZz8v8dwwZGWQ3fMEjzlUWckBSQb0gihQqL85vYKxrqB
	 2b7YZ1iOKNKTzFbihrLoEbi0C/7stLtoPFPh3kKXeRx2RPEziz8UyTA5m2ZZJsWu+U
	 dnjvTtaGMkYHKccm1Gy5Lfvh0+7VhqC63agOc3aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 1752/2077] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Tue, 21 Jul 2026 17:23:45 +0200
Message-ID: <20260721152634.069067751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit a291c77c034b7a81849ce9b71cc9ecda9e587d89 upstream.

During unmount, ocfs2_journal_shutdown() frees the journal and sets
osb->journal to NULL. Later, when VFS evicts remaining cached inodes,
ocfs2_evict_inode() -> ocfs2_clear_inode() -> ocfs2_checkpoint_inode()
-> ocfs2_ci_fully_checkpointed() dereferences osb->journal, causing a
NULL pointer dereference.

Fix this by adding a NULL check for osb->journal in
ocfs2_checkpoint_inode(). If the journal is NULL, it has already been
fully flushed and destroyed during shutdown, so there is nothing to
checkpoint.

Link: https://lore.kernel.org/20260531131645.3650299-1-joseph.qi@linux.alibaba.com
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Fixes: da5e7c87827e ("ocfs2: cleanup journal init and shutdown")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/journal.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -196,6 +196,9 @@ static inline void ocfs2_checkpoint_inod
 	if (ocfs2_mount_local(osb))
 		return;
 
+	if (!osb->journal)
+		return;
+
 	if (!ocfs2_ci_fully_checkpointed(INODE_CACHE(inode))) {
 		/* WARNING: This only kicks off a single
 		 * checkpoint. If someone races you and adds more


