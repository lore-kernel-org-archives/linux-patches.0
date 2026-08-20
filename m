Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662BF37C902;
	Thu, 20 Aug 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238408; cv=none; b=qwz0oRNVyZGbJTl8hkCNbA5NLsGV1Byf/6HrtSXdRADbcaNbzjPqRFsoHLFrN10FbP2kt4AqIjpHG6lsce/EXlZuMUuduD17tFJtvs7oqy2s3Jwp7NYAetISstFnmsrFQRX/X52wJHQ7y9zfFCxWKl1rfCu4IhPmDd4lOJpYMuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238408; c=relaxed/simple;
	bh=zMl4bJmzN4GjXShwPXmHIdZ/vl2naWIXvANY0oP1q/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUgYnz6VTIA3ceDFVJw2Ah7BwmfsCU4CyR2m0Rslo7vskAzxFpUGoHs9Xe2VsBhCzbe1CnSg8UxTdtdpCgwdGRMAp5nYFM5o9tZn5oJ0X1JZP4pYvlGxJP3yjZ58hT5H80mfa5UHgafGnfE16kAyHgJ0rhIRDgeIw4hUF/UimTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsdWj0HI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsdWj0HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EED1F000E9;
	Thu, 20 Aug 2026 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238407;
	bh=RKvdBMIOsfrGeAnXKeM2Kaaxnv2BH0SagXX26n5H2VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsdWj0HI+dGUAim1cTSRIDtIaGCYVWWkzLSrRpshI1TcRLxqomaSGpR/JU5d5e3kJ
	 BOIUsl+F7ymoKR34uTWeckp7j+CxxsAVHcoDf4c7OgPs6nNIjqhXYSrpBLaF4NsRyk
	 ggVAeFrn1vP+nZYluUFSGZ7J8VgVPhjsxlRWHjug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 136/228] xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
Date: Thu, 20 Aug 2026 16:54:38 +0200
Message-ID: <20260820145248.741426713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 5644fab990fc72406dddc91cbb8304659d77f3f1 upstream.

LOLLM points out that the only error that xrep_iunlink_mark_ondisk_rec
returns is ENOMEM, but we ignore that, and can end up writing a garbage
AGI based on incomplete information.  We shouldn't do that, though here
we must be screen out EFSCORRUPTED/EFSBASDCRC because we haven't
checked the inobt yet.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1302,7 +1302,7 @@ xrep_iunlink_mark_ondisk_rec(
  * iunlink_bmp.   We haven't checked the inobt yet, so we don't error out if
  * the btree is corrupt.
  */
-STATIC void
+STATIC int
 xrep_iunlink_mark_ondisk(
 	struct xrep_agi		*ragi)
 {
@@ -1314,6 +1314,14 @@ xrep_iunlink_mark_ondisk(
 	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 	error = xfs_btree_query_all(cur, xrep_iunlink_mark_ondisk_rec, ragi);
 	xfs_btree_del_cursor(cur, error);
+
+	/*
+	 * Don't proceed if we couldn't set a bit in the bitmap.  All other
+	 * errors we ignore because we haven't actually checked the inobt yet.
+	 */
+	if (error == -ENOMEM)
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -1505,7 +1513,9 @@ xrep_iunlink_rebuild_buckets(
 	 * If there are ondisk inodes that are unlinked and are not been loaded
 	 * into cache, record them in iunlink_bmp.
 	 */
-	xrep_iunlink_mark_ondisk(ragi);
+	error = xrep_iunlink_mark_ondisk(ragi);
+	if (error)
+		return error;
 
 	/*
 	 * Walk each iunlink bucket to (re)construct as much of the incore list


