Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C7B80C02;
	Mon, 23 Dec 2024 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969690; cv=none; b=D+A/aktIb7BK3kn0y9fc5TP3K5oiCHicbl1RVAzGgccNsxv6TZs/LVdauNw5b9xCMU4dfs/xoVP5w2HygB3bHAz3Ddj56LcEHZyeeNgRfgY4GlNGZBZupqDHXFXyXz9tqJV7zf64vD9Y+RSen95/F2dMWoESGCAAyWoBA2fDcS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969690; c=relaxed/simple;
	bh=HIkuIRdZ7TXRUc0c0JOPzh7720bi4wyknqSvcoAPCI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEOVtRHbytnnBEG77bOGbspMRcT12jbp+U7k4eN6mphqtbewgSmvD3qWPpmFQSMva0sVZliTP7IJNrVI6DmFR2ZixEe1TYKvoej3TaMKfhRfuWgXtPZf3tU8P52WtDGJGx+zAkEvg72Cv1ZWMvIF4eM+vC9cUuqjUVzRKun19lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uik0YlUd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uik0YlUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5B9C4CED4;
	Mon, 23 Dec 2024 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969689;
	bh=HIkuIRdZ7TXRUc0c0JOPzh7720bi4wyknqSvcoAPCI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uik0YlUdv6WOqpk7FjzYLYW6DxeFstkhHr6ovnGWFVvHUPgbGpQDNtMSh/FxhljX6
	 cYBGqG6A3EX1tgT0dktIeEX/E5U/kI158fRIV7PQzB/jwIE5BejoD9RtIf6uUfMw7z
	 mC3bVlLQDI7l/ASiulGG6pO1jT4rXd76v1V3Pldg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/160] xfs: fix zero byte checking in the superblock scrubber
Date: Mon, 23 Dec 2024 16:57:18 +0100
Message-ID: <20241223155409.707896072@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit c004a793e0ec34047c3bd423bcd8966f5fac88dc upstream.

The logic to check that the region past the end of the superblock is all
zeroes is wrong -- we don't want to check only the bytes past the end of
the maximally sized ondisk superblock structure as currently defined in
xfs_format.h; we want to check the bytes beyond the end of the ondisk as
defined by the feature bits.

Port the superblock size logic from xfs_repair and then put it to use in
xfs_scrub.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 21fb4cb1981ef7 ("xfs: scrub the secondary superblocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/agheader.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index da30f926cbe6..0f2f1852d58f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -59,6 +59,30 @@ xchk_superblock_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/*
+ * Calculate the ondisk superblock size in bytes given the feature set of the
+ * mounted filesystem (aka the primary sb).  This is subtlely different from
+ * the logic in xfs_repair, which computes the size of a secondary sb given the
+ * featureset listed in the secondary sb.
+ */
+STATIC size_t
+xchk_superblock_ondisk_size(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_metauuid(mp))
+		return offsetofend(struct xfs_dsb, sb_meta_uuid);
+	if (xfs_has_crc(mp))
+		return offsetofend(struct xfs_dsb, sb_lsn);
+	if (xfs_sb_version_hasmorebits(&mp->m_sb))
+		return offsetofend(struct xfs_dsb, sb_bad_features2);
+	if (xfs_has_logv2(mp))
+		return offsetofend(struct xfs_dsb, sb_logsunit);
+	if (xfs_has_sector(mp))
+		return offsetofend(struct xfs_dsb, sb_logsectsize);
+	/* only support dirv2 or more recent */
+	return offsetofend(struct xfs_dsb, sb_dirblklog);
+}
+
 /*
  * Scrub the filesystem superblock.
  *
@@ -75,6 +99,7 @@ xchk_superblock(
 	struct xfs_buf		*bp;
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
+	size_t			sblen;
 	xfs_agnumber_t		agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
@@ -350,8 +375,8 @@ xchk_superblock(
 	}
 
 	/* Everything else must be zero. */
-	if (memchr_inv(sb + 1, 0,
-			BBTOB(bp->b_length) - sizeof(struct xfs_dsb)))
+	sblen = xchk_superblock_ondisk_size(mp);
+	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
 	xchk_superblock_xref(sc, bp);
-- 
2.39.5



