Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94959158DB2;
	Tue, 18 Jun 2024 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716540; cv=none; b=uuIVtodSwdwUMzYvA1TXCMoKdpXgZZj3L/RoAoFi4Z+6dhw/PkZfREURaCTXUgJ/4rKMwKrCmeJzqr4Yt5Ik/B4HtK9W66EkL0ZOO8AgphMbeAPs5elxaNhzNpERkVXBCiqV+GuKeHk/lDKSvbc0/BtXJ2knEChtzMrrDe0CrCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716540; c=relaxed/simple;
	bh=5TYvuVcQzbmq7MjVN2MBMzSZe3b0XhZYCRG/QVhhZUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hd4xQoJL2W2Sly8jMszuYQLw/pZRsUakxe50copmwGweA6k2Ql39eZk1xjjJUgk0RNn9quc4PPokZmZkPpcV5ai1JLim/xuS5bk3KVhtVho6T7QSM6SbFAUCPrQkpVikvNL4wbh4chJJUedqPAKKP7gOY2bKoO0FxW/ryGw3STk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipQjvuJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipQjvuJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4EFC3277B;
	Tue, 18 Jun 2024 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716540;
	bh=5TYvuVcQzbmq7MjVN2MBMzSZe3b0XhZYCRG/QVhhZUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipQjvuJ+QUz6BVTckzfmJJ16A5NsNgnv9CWa+5gS5TUai0TG5MaZkMa1lsh3abCqP
	 8S5osinD7RiovQ2k4phZrS5+FDQPeXNsA24ktrcy2zzVLSwKW6q5Q0q51a8lTvt/TM
	 0I9KXM0hYiTVrJ/B3Qg0jy2aJQmIiu2IH0iBWyb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@control.lth.se>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 678/770] NFSD: Fix reads with a non-zero offset that dont end on a page boundary
Date: Tue, 18 Jun 2024 14:38:51 +0200
Message-ID: <20240618123433.448393415@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ac8db824ead0de2e9111337c401409d010fba2f0 ]

This was found when virtual machines with nfs-mounted qcow2 disks
failed to boot properly.

Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142132
Fixes: bfbfb6182ad1 ("nfsd_splice_actor(): handle compound pages")
[ cel: "‘for’ loop initial declarations are only allowed in C99 or C11 mode" ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index e29034b1e6128..4ff626c912cc3 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -888,11 +888,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct svc_rqst *rqstp = sd->u.data;
 	struct page *page = buf->page;	// may be a compound one
 	unsigned offset = buf->offset;
-	int i;
+	struct page *last_page;
 
-	page += offset / PAGE_SIZE;
-	for (i = sd->len; i > 0; i -= PAGE_SIZE)
-		svc_rqst_replace_page(rqstp, page++);
+	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
+	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+		svc_rqst_replace_page(rqstp, page);
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.43.0



