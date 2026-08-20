Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460202874E6;
	Thu, 20 Aug 2026 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238411; cv=none; b=bcxg+OwWS+IAPPfq5fXjSEtq5KsozPRGwOrklYk4A0lWqO0jyGoUlVE2L21IJR0H6A2Jal3TrVuVh+1ZjjFQXoNjkFm8AD8LFdLtxHbwvONK12vcP/gkza7JWdXaATqXSfPbtT6zBfUyaISGsTT3ujcxW7yWrNiocVEFPJjpYl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238411; c=relaxed/simple;
	bh=rzp9VORbUg7VGZetgxfwB8VMJK8Z2x+JQEnhMboLIac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY4Qe6K8DnAcG48i0as26BafPI7hQ7oZkYo5bLH6M5UHS8kVR4h4lrMBRFIealUsNXgRQKLC7P3RCPUgLqFKut3zZY7KEtjTwWRN8G5ztINywMDuIq//t2kCfAAChknTaVRNcAj65a1T48Tb2Sp4xiI+rhRMh54LgDUaY7XiuP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZdZXjt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZdZXjt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC9C1F000E9;
	Thu, 20 Aug 2026 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238410;
	bh=Umu6wi/CB898+goxx9Hd3npjJgOkxbj7EWbF0LIiPtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZdZXjt2GbFCPw1JkR0FDnGFIp9VRIX8a95kNnwa+YCdOLNbNgy44XH7/b67iVUT1
	 a2pI/cpZkUfGsqqnRjNMW6dxp86+JQFe18jqyNohEYYJaVe2VHdEXT2WB96Fh/eOhZ
	 LAXLBQuYWRS3j3s0GRPwjbki3EMORRPvTBTu14w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 137/228] xfs: nlink scrub must take IOLOCK before determining ILOCK state
Date: Thu, 20 Aug 2026 16:54:39 +0200
Message-ID: <20260820145248.770690257@linuxfoundation.org>
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


