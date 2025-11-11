Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B03F1D86FF;
	Tue, 11 Nov 2025 01:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825478; cv=none; b=EHvYcHz7JURm0wtRU62gBTlaF+a1w9DcZnlFCwDR6WMLXl012zYOw1Skwv15AA5MeiBZMzmGGOg8WrEHr0peXc8PrQbpSdyJ1w/tZDfkqFZStm+LldD6H4d6zkaCwGjZQEIK1Ueb/gS5n++NwR3g58WRfRwNkeEKmK4BhzBwBEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825478; c=relaxed/simple;
	bh=atZlN0nBYw60VEBdK/U7BeDPTajCJSvMoRluLKegocQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oS1a6aC0ZHQrFrLLf89hocSitMqweDyLdrQrljnfZ6aJpSIWD1fRTRoKt+TP2EWkM67YVQNV4wez50Np4VDUNLE3CIaM1WIaRkC+V0uNUsWZpWRP/cMyfT6H3ZhLTU8rwGg2okvQi+Q/0BEqnq27FjCzjy2ff/azR9YMK9qPTIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQKVnUvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQKVnUvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE66C4CEF5;
	Tue, 11 Nov 2025 01:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825478;
	bh=atZlN0nBYw60VEBdK/U7BeDPTajCJSvMoRluLKegocQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQKVnUvgCXL3eo77VUWbAJLDP0a2bjifsiQFcNjY6ou92zi1WjVUFJdsBa4bc8pKa
	 VsojUQzT45Lr7824YOBCsthFqGork28kibO9utMD8tGw3Y5rmza70I7r/DGUibX+0B
	 +HkV7e1D/e1d8+yDeSfJRVYgutAS1t8eQ0vYFPaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.17 820/849] xfs: fix delalloc write failures in software-provided atomic writes
Date: Tue, 11 Nov 2025 09:46:30 +0900
Message-ID: <20251111004556.249808619@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 8d54eacd82a0623a963e0c150ad3b02970638b0d upstream.

With the 20 Oct 2025 release of fstests, generic/521 fails for me on
regular (aka non-block-atomic-writes) storage:

QA output created by 521
dowrite: write: Input/output error
LOG DUMP (8553 total operations):
1(  1 mod 256): SKIPPED (no operation)
2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)

with a warning in dmesg from iomap about XFS trying to give it a
delalloc mapping for a directio write.  Fix the software atomic write
iomap_begin code to convert the reservation into a written mapping.
This doesn't fix the data corruption problems reported by generic/760,
but it's a start.

Cc: stable@vger.kernel.org # v6.16
Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_iomap.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1121,7 +1121,7 @@ xfs_atomic_write_cow_iomap_begin(
 		return -EAGAIN;
 
 	trace_xfs_iomap_atomic_write_cow(ip, offset, length);
-
+retry:
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	if (!ip->i_cowfp) {
@@ -1132,6 +1132,8 @@ xfs_atomic_write_cow_iomap_begin(
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
 		cmap.br_startoff = end_fsb;
 	if (cmap.br_startoff <= offset_fsb) {
+		if (isnullstartblock(cmap.br_startblock))
+			goto convert_delay;
 		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
@@ -1160,8 +1162,10 @@ xfs_atomic_write_cow_iomap_begin(
 	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap))
 		cmap.br_startoff = end_fsb;
 	if (cmap.br_startoff <= offset_fsb) {
-		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		xfs_trans_cancel(tp);
+		if (isnullstartblock(cmap.br_startblock))
+			goto convert_delay;
+		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
 
@@ -1201,6 +1205,19 @@ found:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
 
+convert_delay:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmapi_convert_delalloc(ip, XFS_COW_FORK, offset, iomap,
+			NULL);
+	if (error)
+		return error;
+
+	/*
+	 * Try the lookup again, because the delalloc conversion might have
+	 * turned the COW mapping into unwritten, but we need it to be in
+	 * written state.
+	 */
+	goto retry;
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;


