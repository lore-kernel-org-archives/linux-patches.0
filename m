Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDE53BB12A;
	Thu, 17 Sep 2026 17:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666664; cv=none; b=AFiXmhawmZEJOcmL8Blxk6mFd1kKsDBx+7RBtkXMieYkLZcVIRfEdHDcvJmu+tYY3E0XOnAzs7m5mVLMhLB77XwyRXiD8O57XCMq8g9SIbbTl0K4c5I6C5RNMZ9J7ZV0c7PFsRE0qbWljaDKRAAFAYu1hefd4fuIFopztKKh2O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666664; c=relaxed/simple;
	bh=ahm45Zok1SQ6DZ2ZXHlHPD8UjaKhf/EqdOQwNjzy4Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYu69kIgzmJYYEaVpGXJalM8hXoIPfxAJiXg0p6BlJvzlnInzALTXsAQ3iLuyfjzpUxp1IgeHbxeeuFXeYhgnI8RqCYhI9fHV6b6eboy9g8YMKGPErHeo3n1x+e8TS9bWjk4xE71lmr4m0gfnGTolBKSpgaLxZnaTM+NMclF1KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/R1/v+S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/R1/v+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7682D1F000FF;
	Thu, 17 Sep 2026 17:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666663;
	bh=pJaFHKJsjASV3gx65C8safCam6NRyWaV9GRcfteVCwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/R1/v+S6tU5/PYWJcPTSsHdA8f27pqVHsYhhioa9U4PCOJyNOsJsrJghodslYo0E
	 rHBqDUC+NYdIuo6Hk7UnVJASR+UVlt8UoedTWGMlAm9He2FJCxv4P7VR2H3Zs6FWfE
	 SrvJHKue33PPnpYrcv/4wraripShtBheLtSGMhjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1113/1250] xfs: fix bnobt repair space reservation disposal failure
Date: Thu, 17 Sep 2026 16:15:08 +0100
Message-ID: <20260917151622.390985369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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


