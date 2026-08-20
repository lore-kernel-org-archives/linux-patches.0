Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EAE37FF61;
	Thu, 20 Aug 2026 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238993; cv=none; b=jUXwrlzWVwOkFhKrJjUUHSB06qgwciyHRVk7Euh82il3sPGZdn6lb/HrGMPwyVYUehZHM+6Tz8XywD9LGS940UmcyX7/dypSpGZbiSfgFWBisyBWNuKWGtyIvsRnLF8iHmpYLGWOQxXNMXs7S2M5ygZL/zUnZPiTcdttGNcNM2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238993; c=relaxed/simple;
	bh=mbMAlfrFh6iQq3r85tXLFuZFfrlYUbHjj78ruuyzWyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu4FGzRY7ehnjV09KTIFVsROUFSt2dTLgKdVWePzTRU3StYA2Aj6O9UqoiVXTBYXDag5RJlFyQTRhOs4VnoJ4VJA4o6MFQJlaDPcaeRGy1xfcOPeLPqhdwT+fMvYGMfImVUZuA2jQNpM3Uissvey3Lbh30OtVyKVkKQuVLf4468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dB8EiJzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dB8EiJzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5062A1F000E9;
	Thu, 20 Aug 2026 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238991;
	bh=SLzh47TV+rAfLbykxCr2RFWepC8fuaFEIEoRvNbbosk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dB8EiJzlD3ImovljJhNbWxP/GIRJq1Xm0uLLfd/F/5EFhrVjmE+2Cr0q3BbrDj8mp
	 GBgB1evDsq139IpLfWgHXO7wy0WpDCzJYH6ON9QXduLg+KksCymmJVwvcjIDfFqCZi
	 PnJOXz0tSTj3AQ/zrUctyVwwZ1pGLT/SI7iiSVOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 111/217] xfs: only check mergeability of bnobt records
Date: Thu, 20 Aug 2026 16:54:39 +0200
Message-ID: <20260820145241.081215446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

commit 97efed1091a50e4dbf31307015138b43a972d2e4 upstream.

In the cntbt (free space by block count) btree, records are not supposed
to be in startblock order.  Hence the mergeability check is pointless.
Remove it, since it does nothing, as LOLLM points out.

Cc: stable@vger.kernel.org # v6.4
Fixes: d5784ae82778d9 ("xfs: flag free space btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -136,7 +136,7 @@ xchk_allocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_alloc_rec_incore	irec;
-	struct xchk_alloc	*ca = bs->private;
+	struct xchk_alloc		*ca = bs->private;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
 	if (xfs_alloc_check_irec(to_perag(bs->cur->bc_group), &irec) != NULL) {
@@ -144,7 +144,8 @@ xchk_allocbt_rec(
 		return 0;
 	}
 
-	xchk_allocbt_mergeable(bs, ca, &irec);
+	if (bs->sc->sm->sm_type == XFS_SCRUB_TYPE_BNOBT)
+		xchk_allocbt_mergeable(bs, ca, &irec);
 	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;


