Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9433B7B79;
	Tue, 21 Jul 2026 20:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667290; cv=none; b=ITYElmGgRXNQzn2++d2xxpL1psDT0Lwm7Pk+JaT3pJJgdNc9Qkvw0EODgh4TC5q1s4N2LvY10zr7iCNWzG38aA7zIQnrbAEqLQ6f6PyiB4i550lQZ5UaUnGM8U7W8pCqDbifiiEYeStl7orZ9Z6mJtRL5bhgMBCXz2P6OHf7hvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667290; c=relaxed/simple;
	bh=vJU+eTGU5gNByNBZIDjL8ATuDUmi4eEaxBhTQWuqjss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q42oM55FDr3uReTeL1cx82LGCaRPS6Kj7FuJMas98mBaxFPJXnvW1WIUdtBwToMB5u3bbgp5uPQFroafkM5impbjhYWSuKTiOHOhvnxsp6e+A6Ff4YfJZvY3bEZfyIl9EfluLjCTfI4UfKyI9ZJfVe/xcaiN4Fbjz8u8ZRXWQ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKvEk7Kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKvEk7Kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A72D1F000E9;
	Tue, 21 Jul 2026 20:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667288;
	bh=LcKoi8fdChUALIHXdeuTM6k73eEsfSHj2pKlXkmEhj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKvEk7KjoYY4QshWJ5581aalAjmOdnPWOOEP5gwLg7IJ19ImPP5LOCi4og7EN06XM
	 HWBHN1kJVhoa6SDKwMvjYLTi3XpPni7Q6tKbKplcCkqjHvDundI7TifsM7vsxi+YNN
	 jE1Lg+RVl8gmW3w6Y8RJKK2h/vnW3Ji8fHfCoIqc=
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
Subject: [PATCH 6.6 1004/1266] ocfs2: add journal NULL check in ocfs2_checkpoint_inode()
Date: Tue, 21 Jul 2026 17:24:01 +0200
Message-ID: <20260721152504.294614832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


