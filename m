Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880994B7A20;
	Thu, 17 Sep 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660669; cv=none; b=SVAz/ADb0T77x837bAK32MjKv20knxLuTgLBdODcDjvQwysNZ6AvbiPP1N4ruNoy23Wn3RB7J9K4I4yFJM63wYdq/iXsiacaW4Tai9A8uZHc0Pj0tqs7YneAgJMGVMnqgwyR6nFm6JYa4xzJ/bTFwCrfZacVNdSSgnpy8HjCEKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660669; c=relaxed/simple;
	bh=Hf8iZ1Oi5L1jrjpxa3XIA9uvoYqcywmP3wai6d9oq4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qompcUbWBYiZg9dna+NHlfs/Wz36tzgTe+cR9ewSQ0phCI7r+kHDAAxs4TGgl+Psz5RaLYYxNMvg0cdTX9Q1C/ryi18UUErvnxQPoseiOc5jZYovM0rGYKgWMGssNTxx8zUUnCKAZNhd6iE+z0d7+HphLf6vpa76xbMYhXek1V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ARfWbSq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ARfWbSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B8D1F000FF;
	Thu, 17 Sep 2026 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660668;
	bh=cVYiEIIO8k5VDdjtz37AU6Gvu9F5mX+is+iE8NnGGfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ARfWbSqcH1zJB5W2XhmzJbBg2ItrwW+uEWlM7nOOmMkS5HucCz/gEd8yVnJu2Yox
	 3OlZ5Sxu1+kR5e15yg2k7UFz6PlUA9S3b3sImQZiukjBiIrW66GXAqb5KYHSRIQ2VQ
	 qVZlxLuTRubw7Xe2uB+kegXhwZ3xFTyoWkFpKgN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 670/733] xfs: fix bnobt repair space reservation disposal failure
Date: Thu, 17 Sep 2026 16:16:18 +0100
Message-ID: <20260917151409.412167028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c83d1ef97ee3b0b92797d4b4932a3a813ba05b86 upstream.

LOLLM complains that we don't bubble failures from xrep_abt_dispose_one
upwards in the callstack.  A failure to clean up the space used (or
reserved but not used) by the new bnobt/cntbt should be reported.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -571,7 +571,7 @@ xrep_abt_dispose_one(
  * allocation, and blocks that didn't get used can be freed via the usual
  * (deferred) means.
  */
-STATIC void
+STATIC int
 xrep_abt_dispose_reservations(
 	struct xrep_abt		*ra,
 	int			error)
@@ -582,9 +582,13 @@ xrep_abt_dispose_reservations(
 		goto junkit;
 
 	list_for_each_entry_safe(resv, n, &ra->new_bnobt.resv_list, list) {
-		error = xrep_abt_dispose_one(ra, resv);
-		if (error)
+		int		error2 = xrep_abt_dispose_one(ra, resv);
+
+		if (error2) {
+			if (!error)
+				error = error2;
 			goto junkit;
+		}
 	}
 
 junkit:
@@ -596,6 +600,7 @@ junkit:
 
 	xrep_newbt_cancel(&ra->new_bnobt);
 	xrep_newbt_cancel(&ra->new_cntbt);
+	return error;
 }
 
 /* Retrieve free space data for bulk load. */
@@ -801,7 +806,9 @@ xrep_abt_build_new_trees(
 		goto err_newbt;
 
 	/* Dispose of any unused blocks and the accounting information. */
-	xrep_abt_dispose_reservations(ra, error);
+	error = xrep_abt_dispose_reservations(ra, error);
+	if (error)
+		return error;
 
 	return xrep_roll_ag_trans(sc);
 
@@ -812,8 +819,7 @@ err_cur:
 	xfs_btree_del_cursor(cnt_cur, error);
 	xfs_btree_del_cursor(bno_cur, error);
 err_newbt:
-	xrep_abt_dispose_reservations(ra, error);
-	return error;
+	return xrep_abt_dispose_reservations(ra, error);
 }
 
 /*


