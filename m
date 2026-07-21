Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D832470109;
	Tue, 21 Jul 2026 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658779; cv=none; b=DMiMk2qzCA5Suly7o9Czoxz8aA0DHkRNqFNQQRIJ9X667k70veJYGNcex5/2McmufasEvhXbam37pyMnbDhxNN7/yrC7fHlM2BaqMy2Rreyj9ZxfUukiI+73ZCpSFn1DBC/Utp3715tydqio2Bw7v7xnTL6DjJHatgiDAcYhD+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658779; c=relaxed/simple;
	bh=qh1VMF7wwknHFvk7SHFpAxj++7s1vVNKlvZjgkKBIIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjA9UpBqMz2OiJWip2T8Ea/XbZpDTOMxT84Kx+KpTnlYeiN5V06Xoyk51le24Py8uKStlBMrCfSJ0BDzlvgn3RliMr61ybizNJWSz/HEY3dt4pMFLZAQIlBSliGV8ZV+2Ew+OACp6VCtmf1MIDWhmhKNqE+neSTmYdkbGSLO4wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNp9oWMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNp9oWMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7224B1F00A3A;
	Tue, 21 Jul 2026 18:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658777;
	bh=gOvOi5VY892hFqforsRS2+Xv/qENPLvvQnVe70tSQIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNp9oWMCXs7OMEXZDKgSIrJwJmEqufjHM1/z9gVUgLaNcDa1UmcHy/tqrdRaCnxu3
	 FB/+OWAbeuN0v97bg9xKFq/R035qoOoiHCAhgWIW0yhEyp2rDfAglHjef0fCi6nSQo
	 zvmwmAcvolPmz5B3NuqTiyiTTeYt8TrCHwDoy8PI=
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
Subject: [PATCH 6.18 1272/1611] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152544.057386635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


