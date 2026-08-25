Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85863483BF8;
	Tue, 25 Aug 2026 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664870; cv=none; b=iS3EOpEcIcCAxlZ7C2AZ/+0++BF5oIL7B/pI1TN8xDC+bSXvLv9EAzvAL2wZa4Nf4WznroRy99PZ8SAPxLtDrxwIZzggsu1hjIgX5ZvRey+tv3VLV3FsTVT7oox1smVinIFEb2FM8n7rmcX8JQGd9+w8Uh5Z406C+VcSUZ/IXLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664870; c=relaxed/simple;
	bh=uT+WVb6Ojol4eO3G22CJ7p5ej9cfBClltOu6Q9DKJOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f143Gbpw3sQZPCxWBpFW8iuFn079rd+XakctfNgTvaMpoIji8wjAtg02fmkp1JvgdconFm9FEYeY9UAsANUkYQOO4bbldvOr9yXqSr3CA6fbgI1uE0IKUqhPeXNcZL0ztGbJN2NGTRBSjmgCyaGUTI3vvcoIQitKnuSC0W5NVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta6HZObi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta6HZObi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930A11F00A3D;
	Tue, 25 Aug 2026 13:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664869;
	bh=Of/WtvrxkTnDdr+wGdRwo2SnUAvTej92jx1gqCgonj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ta6HZObibaRAD9tuyu/bZof/rNkDASSW/zqt8HS70NdtRr8G/xYw37zofRj/nbSIj
	 LViqqXayjWXTKnHzAR0xj3WPqGQqWVzc2Me6QAwvSHqpi7UetAXB3x0TdzyNmpd5N8
	 l7HUtqhYDUzaznbd4KnvQ4esatvYKufHh/6DE/zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Yun Zhou <yun.zhou@windriver.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 032/101] xfs: restore nofs context unconditionally in xfs_trans_roll
Date: Tue, 25 Aug 2026 15:25:10 +0200
Message-ID: <20260825132543.270399342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

commit 0241ea5fb0fe86d2a673163b2f5815111aadc7f7 upstream.

When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
is cleared but only restored in the success path.  This leaves the
error path without nofs protection, causing a circular lock dependency
between xfs_nondir_ilock_class and fs_reclaim:

       CPU0                    CPU1
       ----                    ----
  lock(&xfs_nondir_ilock_class);
                               lock(fs_reclaim);
                               lock(&xfs_nondir_ilock_class);
  lock(fs_reclaim);

Fix this by moving xfs_trans_set_context() before the error check so
that nofs context is always restored on the new transaction.

Reported-by: syzbot+59178abfeb0ea3f0ab20@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=59178abfeb0ea3f0ab20
Fixes: a1ca658d649a ("xfs: fix incorrect context handling in xfs_trans_roll")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bfbd9f6f0df..1b36cf12d4e3 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1029,6 +1029,15 @@ xfs_trans_roll(
 	 * duplicate transaction that gets returned.
 	 */
 	error = __xfs_trans_commit(tp, true);
+
+	tp = *tpp;
+	/*
+	 * __xfs_trans_commit cleared the NOFS flag by calling into
+	 * xfs_trans_free.  Set it again here before doing memory
+	 * allocations.
+	 */
+	xfs_trans_set_context(tp);
+
 	if (error)
 		return error;
 
@@ -1040,13 +1049,6 @@ xfs_trans_roll(
 	 * either nothing be locked across this call, or that anything that is
 	 * locked be logged in the prior and the next transactions.
 	 */
-	tp = *tpp;
-	/*
-	 * __xfs_trans_commit cleared the NOFS flag by calling into
-	 * xfs_trans_free.  Set it again here before doing memory
-	 * allocations.
-	 */
-	xfs_trans_set_context(tp);
 	error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
 	if (error)
 		return error;
-- 
2.55.0



