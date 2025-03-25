Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC3F25745F;
	Tue, 25 Mar 2025 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905675; cv=none; b=mcjDjmbNSbwUYGzfcNCRC9afQoIyzGEd877PKFqq7NPGoc/jPHVWUyR+yQoY47raNOTKEUPbUKfFuvk30yJJjq1YdxIrtFyZ531JvBdK0GwDSi9b+6ea0if6Lo0sf0YN74bnIchRqirPiLz36wuOzsrPzMAmoUf7+7gdCd+o2Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905675; c=relaxed/simple;
	bh=q7eumBUECBbIu7ZS4PckQJvITqNyBrHzAZXCqswef+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjTTXioQXpiXZL5kjfX90ApD3sQhkx6qiOPmz1uknT4NKn/pEKXJg76A67hSuqPtEHKLRYth1OJXjjDjHSoRLpv5t3pAccCl87itXgNiOsD9UNkic9IpK3zfL59L5SbkTDH6HkYFyWnNmb3CcIE7b0r2GVjna9s+Bt0OngqeNOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7Ha5TkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7Ha5TkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96E9C4CEE4;
	Tue, 25 Mar 2025 12:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905674;
	bh=q7eumBUECBbIu7ZS4PckQJvITqNyBrHzAZXCqswef+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7Ha5TkH16hgcAYR6iulKxyeePDIn9BPm03BqG8fSlkBsCHLEQ/irI6UVWwfwnIlC
	 qFlHO/sqt/vZmuspXayDm456A3p50einHb/njl/hCkU4w8eaXpKWxwQU+utcwe3eQp
	 qqymuM3sEPeSy08ouvXfh4un/MToECRgEXKo8J30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 101/198] xfs: update dir3 leaf block metadata after swap
Date: Tue, 25 Mar 2025 08:21:03 -0400
Message-ID: <20250325122159.299746672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

[ Upstream commit 5759aa4f956034b289b0ae2c99daddfc775442e1 ]

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

  XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
  XFS (dm-0): Unmount and run xfs_repair
  XFS (dm-0): First 128 bytes of corrupted metadata buffer:
  00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
  000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
  000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
  00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
  00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
  000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
  00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
  0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
  XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
  XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
  XFS (dm-0): Please umount the filesystem and rectify the problem(s)

>>From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_da_btree.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2316,10 +2316,17 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */


