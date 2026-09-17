Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538AB4B44C4;
	Thu, 17 Sep 2026 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671236; cv=none; b=UgPW+Qt/4wpLL8725904sSYKUeEwReH0RuvA940oa5jowOYLogevENoPsnCYO99oXtaZwPmpyykqyLqCdljWuOa8TlFAE59QFYyk1Se6gxdUiVK4U6EQC4p7oqmbqzSVq8ukGPXdQOb0iySkx/B1sXSc5NnPAfieo0K6QkhxwKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671236; c=relaxed/simple;
	bh=uOuHYLQRwus7J2Eke1MDjGeIveca346GVY24ljZ5uk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufM7CswOWkczMBGEaDnNPnTknIRzdRyxUsg27VOI1i3nRLsUjyJhxIn253Wf0vECTmQl7mFrGi72sbkFX3izdY23W/gVVSA4ieSk/oYZFv53UBKP9eYdrKrEsNUdah04dbv4BodSGChAFbSwAFzaOYELbO81TMXM7Qh4WzafWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCD4pSC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCD4pSC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91BA1F000FF;
	Thu, 17 Sep 2026 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671235;
	bh=xeWWPYWEO+Hjzd5DC5N0uLyHR1GJC2NLCBTIEao4xaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCD4pSC1mn9NeaZTnjJoYYR7buHUOdu0zlTNHYQfQ364g9gEhksKYVNGY6wemnoMd
	 0B1Y/GodpZhDrfnv5zygj6RVi7UZMau1A/a17kSsLu/qv+6WC5FL1DnhNednMXuFZP
	 iP8RTGpFgpm7tI2mLnzIJHVJn8C/a+lgKn7j8mbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0909/1102] xfs: fix bnobt repair space reservation disposal failure
Date: Thu, 17 Sep 2026 16:14:12 +0100
Message-ID: <20260917151603.431351455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


