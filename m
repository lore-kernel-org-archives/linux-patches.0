Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969F44AB91;
	Tue, 21 Jul 2026 21:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670109; cv=none; b=FXsjRwm1oJpKb3Hu0/zXPYNDdxUGAkuuKSyDoxD6lsgbvHL01Qbw5H3yEbkE34GytL2pt377ikGY+o0hiSoPPwlMSKld+3LXAM65KCz5gV57GJ/84+ktBzpKRSzRwfQ/MK50kzPCe/YQXax8WIXssqXdGfljNqKA/gt9dGAYx0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670109; c=relaxed/simple;
	bh=jdT97ddpZyGxN/Y3L3hW2WqPoFiV34ahKzWbTDtgQvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJNBBI4rdKDAx4gFBf43LDC0phsQEsiuhOqj6Fdb4OGKTmr2cRSgO6tEsFKwnl2r3NngB3uc99ZkF1IMEF65ZMKLC5UtHcSSVnNvwCVlbr7OXWk3BCMl+Mj9onqrvo1pgdE8S6BIHmpcmhWr9py9zqbfbRs3HnsGMcmJP1BwAho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc0+FHqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc0+FHqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545471F000E9;
	Tue, 21 Jul 2026 21:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670107;
	bh=H6fZLgTG8+5qlUg1Gbj/SKtTn6J9z66V70OF4wjiEXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc0+FHqLb4acbksxDI3z42u9dOGGpkle39j0cLZIyTR7ymTuBVqHDKOjH1dVFC72P
	 OpKJg7b82jGUHRrGv5ESDhYH97gtFP4cU4b700KHy/Z6EV/SXRxBp8LNuG35l+88XV
	 NYWS29NQi+y8dK2TXKoDHjAIzIYy28Ocwi2wR7CE=
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
Subject: [PATCH 6.1 0809/1067] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Tue, 21 Jul 2026 17:23:30 +0200
Message-ID: <20260721152442.654201374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


