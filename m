Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585512;
	b=iUfmEAvGaj6iL7rpOmPRM/ssiZEy0vH+ZY+Px+J8kXQeE8chy51fD1joyYxtLK6GNM6u
	 JkgLztcA5b8Cr9N3LexnKCDjmwDvqmWrZsK/1r54fAzYSlL9huXKheUS3NLKLqaYCyowC
	 8GUVMMCFIqp8hLlCU0yna+D8xl/WspP7C5R/aeO2QcESH9PBnjBtLP0uP0pouM5r8pgxF
	 w/+Ia1VNtGcUt3cNNrjD1xDPgphAY6MTZn+W1aosW5GjZ/qkyGiL0e1ylxS8ChEML2O3m
	 VmpIBjVsnS/398szFtHihQaRwcXJQuNhPVZuD7XyGWaM1aZHA+eYDWqYm/Z1dh8RRvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3OoqsdNFn3/ogMznsCzS3d/W+ayRjCKvxqO21unJHU=;
	b=HbhfqLF+DSG0JFP8cZ0ZBdwOmtiVwGmEkXTx1kPfiMH2qaCFTIqHz3G/esZU3xNKSaTK
	 tnCmDddHbrOkNS3jMeov/kLt+Yo6lEpRRWPOX6s7grrE60OTKh/I/qmGn6/2QEtsrAEFK
	 fq/5GHIx6qvqnJTzN5WGneQobObQh4BzepFPo7mY0uCdUe6kKznAA/9a+NjIrurP56tYW
	 /vMSguXta4blc5+YGxoE78f2NPZ+hdFMdWcjOQ7zr0r5HB7M9j3uO5AAazO1h4940zGOZ
	 FXKr8FLHTe5zK0LvunEQ2x9Ovj6vna8+xAHzW96ZArGBhcCZ4UkXnP+6vzH0JSI4TMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qvlh+iJX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E4B606AE32;
	Fri, 13 Nov 2026 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qvlh+iJX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49F51F000C4;
	Fri, 13 Nov 2026 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585512;
	bh=Z3OoqsdNFn3/ogMznsCzS3d/W+ayRjCKvxqO21unJHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qvlh+iJXuea27clYaZbF+RN8MGQIDDirCtWixGSzlOzMJ7oaihTPZRuKQ2+/GRaFi
	 kYHEOIU726uAPemuG2HNVQxk1bySyKvCIFdeBOVebktRZkOLocd0hs49XqvS4e7ojv
	 pgsBQIfKOO4klIDW04aICkoxzIGwJT3ekAz6uEOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 158/507] xfs: dont skip free extents in later batches of a whole-AG FITRIM
Date: Fri, 13 Nov 2026 10:47:42 -0500
Message-ID: <20261113153759.858664477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 595e67d7261673d03c96950ffbb2e545c00376ed ]

A whole-device FITRIM walks every AG but the last by length, in
batches. xfs_trim_gather_extents() saves the record to restart from in
tcur->start. But tcur->start is also the start of the range to trim.
Later batches therefore never discard the free extents below that
block.

Save the restart record in a new restart_bno field.

Cc: stable@vger.kernel.org # v6.10
Fixes: b0ffe661fab4 ("xfs: fix performance problems when fstrimming a subset of a fragmented AG")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_discard.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 906221ffe9ba8..8120f136af931 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -155,6 +155,8 @@ struct xfs_trim_cur {
 	xfs_agblock_t	end;
 	xfs_extlen_t	minlen;
 	bool		by_bno;
+	/* restart point (with count) for the by-length walk */
+	xfs_agblock_t	restart_bno;
 };
 
 static int
@@ -198,14 +200,15 @@ xfs_trim_gather_extents(
 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
 		if (!error && !i)
 			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
-	} else if (tcur->start == 0) {
+	} else if (tcur->restart_bno == NULLAGBLOCK) {
 		/* first time through a by-len starts with max length */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
 	} else {
 		/* nth time through a by-len starts where we left off */
 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+		error = xfs_alloc_lookup_le(cur, tcur->restart_bno,
+					    tcur->count, &i);
 	}
 	if (error)
 		goto out_del_cursor;
@@ -235,9 +238,15 @@ xfs_trim_gather_extents(
 		if (--batch <= 0) {
 			/*
 			 * Update the cursor to point at this extent so we
-			 * restart the next batch from this extent.
+			 * restart the next batch from this extent. The
+			 * by-length walk does not visit extents in block
+			 * order, so it must keep the start of the range and
+			 * restart from restart_bno instead.
 			 */
-			tcur->start = fbno;
+			if (tcur->by_bno)
+				tcur->start = fbno;
+			else
+				tcur->restart_bno = fbno;
 			tcur->count = flen;
 			break;
 		}
@@ -340,6 +349,7 @@ xfs_trim_perag_extents(
 		.start		= start,
 		.end		= end,
 		.minlen		= minlen,
+		.restart_bno	= NULLAGBLOCK,
 	};
 	int			error = 0;
 
-- 
2.53.0



