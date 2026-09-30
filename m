Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D7515961;
	Wed, 30 Sep 2026 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787982; cv=none; b=ku1jWWznrDSTCK3m2anUv9GEuVQclIjYyRbfLipdfsb3kA3bpghydH978BcU9VMojUdN3su5wbaMAMG8cuABKePacgGZnZiaLtOJ5pbrAUL659dpuWOJNfqHBxQgzpotNIitcsaNbBf/2TFEz54MQBu3iRstUzDXakA2aEZRJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787982; c=relaxed/simple;
	bh=vpbd9bCcSi0ciq45eXduvcIL5OYf7LnYds1+dw2rZ3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdU2bjajrDTzRAq9XUvuGSeFVxkNCrFjWYUZZ3q0qBf8vxVYnY+p39CxbsxdK0ob+hX2VHyWrmMWJDRNJPRmTYGRyoIqTu39t9AusSdCggPp1EpRN9PoC6HDSXE1AHesqkq/aQnUHFckNe1loi6R+afk+KihLVaKOMBeiwhQtdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjB4nOZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjB4nOZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40CE1F000FF;
	Wed, 30 Sep 2026 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787981;
	bh=s0Xmc/ZZXRQr3S9nW4PDOJ2UAYtL+8HejKfYPRMGrPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NjB4nOZthO8VNnbIEwFBFUIdMHj/T6gvt8BYXX2sFB4zsUBAjUnZ1qWsW7Rz+ONJA
	 OXFspbzCzVKH1f6x049id2QRDq+4H1aS9bPxCes/xXg77jD1RMK839c3/y9P0cgxik
	 Uqw/KyA0C8gTQA7ff2BBbNeAmlievCQ8XKcycXQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 422/457] xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
Date: Wed, 30 Sep 2026 17:28:47 +0200
Message-ID: <20260930152355.094180547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c54110d814c3e8ed6bbbb5e02874994ed9f668ac upstream.

LOLLM complains that xchk_directory_data_bestfree can be passed a
directory block that is either in "block" or "data" format, but the
check here unconditionally treats the dir3_block and dir3_data blocks as
if they have the same header format (they don't).  Consequently, we can
incorrectly set the preen state on dir3_block blocks, which of course
we can't preen away because dir3_block blocks do not have a padding
field.  Fix this.

Cc: stable@vger.kernel.org # v7.1-rc4
Fixes: 939919ccddfcc3 ("xfs: check directory data block header padding in scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2a037aae904d..19d974c7e2b7 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -492,7 +492,7 @@ xchk_directory_data_bestfree(
 		goto out;
 	xchk_buffer_recheck(sc, bp);
 
-	if (xfs_has_crc(sc->mp)) {
+	if (!is_block && xfs_has_crc(sc->mp)) {
 		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
 
 		if (hdr3->pad)
-- 
2.55.0



