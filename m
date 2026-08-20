Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FCC480326;
	Thu, 20 Aug 2026 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787246957; cv=none; b=O+HzrJyvJzGeBila1I/IccTUJ9cOAsqnJ77V07n5tV3tV2eJzu+Xzt/msC/LDaLUM7SqA8p2FonfpMdhBEd+m5zFcXJ/WDZ3mftBrMVn9fEKTHEsLvt7mmAMewgNSbYUiMTGK56GDFMn6fG5rYfH2BGt6F1TXAUWigPbKF3aY5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787246957; c=relaxed/simple;
	bh=Q3mhvWMgpQRtPPlKArpCz6eFtI33PFiHLl7zOSN7csY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUWFrlpf9lPGRKMqsAgQU9l4O+8397VpcOT9xr2XA6WUK1kmleLq2jXIe1s/YSdmQIzaTRlZE1/vYiLPjE4BqQNK8Zr1VnVXPp/tglA5st+CVVB9YzGeHmGcB/ND35E3ZH9kjxbqKP2U5Ea+JD/3ow+lMC7ieDTPIylMni42oaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7gG0niQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7gG0niQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F8C1F000E9;
	Thu, 20 Aug 2026 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787246955;
	bh=b228AqHFcxP820mhJQbrhFNxDjvYedcGuaKQWWHuHZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7gG0niQGBD9uQTLSbRFaAo/EyLven4Q5l3nG/vLvBNOuThzBryYDWmdMZbCbOE2n
	 So1dciIOVPqsxfwMMuSFdKYHaNg+ztEb+X7uHor313RGanvCHvpHqkTbW/F4pJqJ3R
	 ygf/EngzzyB6+X3ule59PKkcLMRoqjho4rgXVxL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 097/220] xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
Date: Thu, 20 Aug 2026 16:54:47 +0200
Message-ID: <20260820145226.393762214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
@@ -1306,7 +1306,7 @@ xrep_iunlink_mark_ondisk_rec(
  * iunlink_bmp.   We haven't checked the inobt yet, so we don't error out if
  * the btree is corrupt.
  */
-STATIC void
+STATIC int
 xrep_iunlink_mark_ondisk(
 	struct xrep_agi		*ragi)
 {
@@ -1318,6 +1318,14 @@ xrep_iunlink_mark_ondisk(
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
@@ -1509,7 +1517,9 @@ xrep_iunlink_rebuild_buckets(
 	 * If there are ondisk inodes that are unlinked and are not been loaded
 	 * into cache, record them in iunlink_bmp.
 	 */
-	xrep_iunlink_mark_ondisk(ragi);
+	error = xrep_iunlink_mark_ondisk(ragi);
+	if (error)
+		return error;
 
 	/*
 	 * Walk each iunlink bucket to (re)construct as much of the incore list


