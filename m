Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5C147887F;
	Thu, 20 Aug 2026 17:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247093; cv=none; b=ejgvPEBz1i8HcHLjFeApzk5xky73GAQeFKC5Ynqh6MShdkDZce1lKc8xsl7nssbUX6bM1nYBGrOdLV3Yec+iOHv44q5mgbQ8OPWH9vEhS/tUpFiXuqf7aGF6vZw0to4im5Iw1kg3ILd+kM0q72WJEfhjNOJK/Bp4FR6yC9R2OmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247093; c=relaxed/simple;
	bh=GTEB8v+1VrGPr0t401nM1UzuE/NbUbiioWtQnTUueI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+eez/iZvESYfmsIAliY2+3PFD95xAg8eswafplU/Tz+s8T1Uu3PhX0RsiKZuCcTAxUdWAtq1jpEiK7rIzx0fttEjfJYJ5tt70dkJLjTGGLgqTTskkfooLK7hcjTXhNXsFFh/y92kovQwmk7VGxL/DrXBYJj3X3OK946sreqr5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMCeJIj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMCeJIj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB61F000E9;
	Thu, 20 Aug 2026 17:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247091;
	bh=eyNx4djvI2Kyz5zsFO2RZasJ23GcZq2L5o6cohLGb8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMCeJIj9HnYkZls3g0OOMAmSOF0BNGxFUysdgzA4zTiiaal30ylKSOurrRKG/awnH
	 HQglCHu2224GeuVOTdn3DMPxMyrQNYNPUP23j+7lcUDCUpHHdRkXloeLWp+Puoobbb
	 mCDoPGgp0dv1tiwFFsudPHk7otjWKfldFI8Z3IDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin Jiapeng (TencentOS Red Team)" <jiapenglin@tencent.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 107/220] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
Date: Thu, 20 Aug 2026 16:54:57 +0200
Message-ID: <20260820145226.695527254@linuxfoundation.org>
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

From: Lin Jiapeng <ljp1205831794@gmail.com>

commit b2d5a81dae385333f9734910277fbf94c78bd17f upstream.

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng (TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Cc: stable@vger.kernel.org # v6.10
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -957,6 +957,16 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	if (hweight32(reflink_state) != 1)
 		return false;
 	if (req->startoff1 != 0 || req->startoff2 != 0)


