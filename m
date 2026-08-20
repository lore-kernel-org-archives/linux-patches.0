Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58AF47CA74;
	Thu, 20 Aug 2026 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247095; cv=none; b=lFDEZqthHDURxT9poHCaSRGbOvoZiUQY4ZVfao3SByD99jJXz442u5peXdfTys0sPJnCkWl4fEPBn0weBkAJB0P4Odps3+ZpYbSyDunsQKxilpjM19c7yOFS1S2SYqtKzJNWh+se50G+e0o4OfKHC5x5SA1GI809pc9OvHwl49o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247095; c=relaxed/simple;
	bh=hj7z/Skgep7GVNY78fajEO5VIBP26M9MTy7is2djtQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0018gVHdPFHks/o4FlxSFldpoB5gtbPfziZOoPQB+AxCS9Q1zirgBsfdqr699MQ/ToRx7Oj2ajrLH8fcy7pfKDAxpTKZLhNjUdXG4JgOgYOWsYuc+VczXKwf7TZsoIjmqlHehbALhG2k8Fxc30P74AmHD3wRN0iFPG9aaIs8uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfvDOj/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfvDOj/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0261F000E9;
	Thu, 20 Aug 2026 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247094;
	bh=sbNDqDgX87eru8zS2rD8Ek7iTI0+qRElLIwPIhVHt28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfvDOj/lX9p7qRlUBaoqEbHHYVcWGQW/BXheb/r1GHOGaGaKVTRGl26WsrA6f3KhB
	 W31l6JdpmRAysNL+0IaEY585q2B3dCqhU7zhU/1jrHyJnL1PHsKXErzByFN0UlA4Bi
	 5rLMY6yt45VdTbDmiXFB0s4J8nKo0MSKpRoF5Jtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 098/220] xfs: nlink scrub must take IOLOCK before determining ILOCK state
Date: Thu, 20 Aug 2026 16:54:48 +0200
Message-ID: <20260820145226.424050830@linuxfoundation.org>
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
 fs/xfs/scrub/nlinks.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 355ab6de23ea..bcedb8c3e4e6 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -382,6 +382,12 @@ xchk_nlinks_ilock_dir(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
+	/*
+	 * Take the IOLOCK so that other threads cannot start a directory
+	 * update while we're scanning.
+	 */
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+
 	/*
 	 * We're going to scan the directory entries, so we must be ready to
 	 * pull the data fork mappings into memory if they aren't already.
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
-- 
2.55.0



