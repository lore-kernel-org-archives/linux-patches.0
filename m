Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02ED35C1A6;
	Thu, 20 Aug 2026 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239004; cv=none; b=l9K0wLEV5iYYPt3MXpPniYkconVT0BAR6UZC4xLcaS5R7AdMmQLx4/SsxBnmT+eB2qWmNCX7bqqIr49EZ463MbF5571YbbBdrC+09ZTNoXCO+HsgvSPhncrreaPu7jQhzodSz857DgSv2zQXbCytHSHeQC+56SKJR25CX/OZo6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239004; c=relaxed/simple;
	bh=k586xYjkg8KiKpl8ryCdeUE3Uuyt6g2Dg9kUxzQDNDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1YW7xovSbPFietch2/aqzQx0mlk/rztdtRSFqW5+SiDI396O6efzMs7WC9ZDtZuN00QMxCo2rjEBsgP5UAtYz4DQw01vhhtHsKDs7Ah+pnNSIIaQbugCTurCi3sfFj/Ix5uA8rDz329qfX5LMZe2IfNYBqwHRqOfXV69twrhlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdqBE+Tk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdqBE+Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF9B1F000E9;
	Thu, 20 Aug 2026 15:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239003;
	bh=JmaBhPZ1/qSrXRcgy2HuyRoro6clHUPJR3sW9RpRJRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdqBE+TkCuH6sCuTE9ojd7ehurcfYEBRPEqYFJM28Q/R3liOI6pJaRFDrnxgDkA3n
	 JyZ0QTFJUBQgx3pPVQ2tO35pdLdgULcKrUOba1V2qElNlca54ZXtG+iYTGYZ80r+4+
	 vNwZo+6Yvqdof+Opx8EXJA1ZIXqcvOqli9WYGSLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 115/217] xfs: nlink scrub must take IOLOCK before determining ILOCK state
Date: Thu, 20 Aug 2026 16:54:43 +0200
Message-ID: <20260820145241.200267738@linuxfoundation.org>
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

commit b1a296fc2241f724ef8f14da6a4efa800d444dac upstream.

In xchk_nlinks_ilock_dir, take the IOLOCK before accessing internal
inode state to figure out if we need to take ILOCK shared or exclusive.
That way we can't race with directory updates.  LOLLM pointed out that
the code was initially correct w.r.t. the IOLOCK, but then I broke it.

Cc: stable@vger.kernel.org # v6.18
Fixes: f477af0cfa0487 ("xfs: fix locking in xchk_nlinks_collect_dir")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/nlinks.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -383,6 +383,12 @@ xchk_nlinks_ilock_dir(
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
 	/*
+	 * Take the IOLOCK so that other threads cannot start a directory
+	 * update while we're scanning.
+	 */
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+
+	/*
 	 * We're going to scan the directory entries, so we must be ready to
 	 * pull the data fork mappings into memory if they aren't already.
 	 */
@@ -397,13 +403,8 @@ xchk_nlinks_ilock_dir(
 	    xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 
-	/*
-	 * Take the IOLOCK so that other threads cannot start a directory
-	 * update while we're scanning.
-	 */
-	lock_mode |= XFS_IOLOCK_SHARED;
 	xfs_ilock(ip, lock_mode);
-	return lock_mode;
+	return lock_mode | XFS_IOLOCK_SHARED;
 }
 
 /* Walk a directory to bump the observed link counts of the children. */


