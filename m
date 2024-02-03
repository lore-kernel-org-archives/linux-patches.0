Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE7D13AC0;
	Sat,  3 Feb 2024 04:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933745; cv=none; b=lWj5bLEYEja57rHnR3FbVqZ2nzR42pbDEE3bThSLjXARzMB9x1KBib80i2uvz+IKdABZ5ff1sZRG2eO8kVDVpjtE1ZAAzncLqSmORYnSDAho/aRuDuXMbr1w9z0GMVUvcvT0Y6YP3k6dZ8adJrlQuUNgsZtkNAPXqlWdqB28mqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933745; c=relaxed/simple;
	bh=pJDETNuqL+ortci7qKsDr0LYnqMKXgHRJZ5T5Y/NPko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWBwx2uuEIN1Dr+ipIldt35j+E6RrX1KhbN0szx53COfPPQFlO0WPxEQp6Xn4PSpUbxbGJxQwWJz6AvVz08jK+KVEGnRYrZow84/ybiKaokPFi76T3JqgtXMkjFmNIh2CYUgAk8N4QJxUlu+tIIyVcDbWkS5Ln7erhptCA1KxKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEOxvp4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEOxvp4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0154EC43394;
	Sat,  3 Feb 2024 04:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933745;
	bh=pJDETNuqL+ortci7qKsDr0LYnqMKXgHRJZ5T5Y/NPko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEOxvp4tuVnoKNELzjjW81e7FhSrneYfUlktsUjZTprtQ5ZkeScNK51eGO69HWL5O
	 NEoal4X/py6Rc4a0AyC4UX3YnwQTLzSwvg44WZzk2EpEYdAfPD/b/2Bxp1z6mzrFfx
	 /YqIpvelbYDCjN3vwn1mruZuMQrEsBytGjv4G030=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 038/353] erofs: fix up compacted indexes for block size < 4096
Date: Fri,  2 Feb 2024 20:02:36 -0800
Message-ID: <20240203035405.004432423@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 8d2517aaeea3ab8651bb517bca8f3c8664d318ea ]

Previously, the block size always equaled to PAGE_SIZE, therefore
`lclusterbits` couldn't be less than 12.

Since sub-page compressed blocks are now considered, `lobits` for
a lcluster in each pack cannot always be `lclusterbits` as before.
Otherwise, there is no enough room for the special value
`Z_EROFS_LI_D0_CBLKCNT`.

To support smaller block sizes, `lobits` for each compacted lcluster is
now calculated as:
   lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1)

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231206091057.87027-4-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 7a1a24ae4a2d..e313c936351d 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -82,29 +82,26 @@ static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
 }
 
 static unsigned int decode_compactedbits(unsigned int lobits,
-					 unsigned int lomask,
 					 u8 *in, unsigned int pos, u8 *type)
 {
 	const unsigned int v = get_unaligned_le32(in + pos / 8) >> (pos & 7);
-	const unsigned int lo = v & lomask;
+	const unsigned int lo = v & ((1 << lobits) - 1);
 
 	*type = (v >> lobits) & 3;
 	return lo;
 }
 
-static int get_compacted_la_distance(unsigned int lclusterbits,
+static int get_compacted_la_distance(unsigned int lobits,
 				     unsigned int encodebits,
 				     unsigned int vcnt, u8 *in, int i)
 {
-	const unsigned int lomask = (1 << lclusterbits) - 1;
 	unsigned int lo, d1 = 0;
 	u8 type;
 
 	DBG_BUGON(i >= vcnt);
 
 	do {
-		lo = decode_compactedbits(lclusterbits, lomask,
-					  in, encodebits * i, &type);
+		lo = decode_compactedbits(lobits, in, encodebits * i, &type);
 
 		if (type != Z_EROFS_LCLUSTER_TYPE_NONHEAD)
 			return d1;
@@ -123,15 +120,14 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 {
 	struct erofs_inode *const vi = EROFS_I(m->inode);
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	const unsigned int lomask = (1 << lclusterbits) - 1;
-	unsigned int vcnt, base, lo, encodebits, nblk, eofs;
+	unsigned int vcnt, base, lo, lobits, encodebits, nblk, eofs;
 	int i;
 	u8 *in, type;
 	bool big_pcluster;
 
 	if (1 << amortizedshift == 4 && lclusterbits <= 14)
 		vcnt = 2;
-	else if (1 << amortizedshift == 2 && lclusterbits == 12)
+	else if (1 << amortizedshift == 2 && lclusterbits <= 12)
 		vcnt = 16;
 	else
 		return -EOPNOTSUPP;
@@ -140,6 +136,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 	m->nextpackoff = round_down(pos, vcnt << amortizedshift) +
 			 (vcnt << amortizedshift);
 	big_pcluster = vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1;
+	lobits = max(lclusterbits, ilog2(Z_EROFS_LI_D0_CBLKCNT) + 1U);
 	encodebits = ((vcnt << amortizedshift) - sizeof(__le32)) * 8 / vcnt;
 	eofs = erofs_blkoff(m->inode->i_sb, pos);
 	base = round_down(eofs, vcnt << amortizedshift);
@@ -147,15 +144,14 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 
 	i = (eofs - base) >> amortizedshift;
 
-	lo = decode_compactedbits(lclusterbits, lomask,
-				  in, encodebits * i, &type);
+	lo = decode_compactedbits(lobits, in, encodebits * i, &type);
 	m->type = type;
 	if (type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
 		m->clusterofs = 1 << lclusterbits;
 
 		/* figure out lookahead_distance: delta[1] if needed */
 		if (lookahead)
-			m->delta[1] = get_compacted_la_distance(lclusterbits,
+			m->delta[1] = get_compacted_la_distance(lobits,
 						encodebits, vcnt, in, i);
 		if (lo & Z_EROFS_LI_D0_CBLKCNT) {
 			if (!big_pcluster) {
@@ -174,8 +170,8 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 		 * of which lo saves delta[1] rather than delta[0].
 		 * Hence, get delta[0] by the previous lcluster indirectly.
 		 */
-		lo = decode_compactedbits(lclusterbits, lomask,
-					  in, encodebits * (i - 1), &type);
+		lo = decode_compactedbits(lobits, in,
+					  encodebits * (i - 1), &type);
 		if (type != Z_EROFS_LCLUSTER_TYPE_NONHEAD)
 			lo = 0;
 		else if (lo & Z_EROFS_LI_D0_CBLKCNT)
@@ -190,8 +186,8 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 		nblk = 1;
 		while (i > 0) {
 			--i;
-			lo = decode_compactedbits(lclusterbits, lomask,
-						  in, encodebits * i, &type);
+			lo = decode_compactedbits(lobits, in,
+						  encodebits * i, &type);
 			if (type == Z_EROFS_LCLUSTER_TYPE_NONHEAD)
 				i -= lo;
 
@@ -202,8 +198,8 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 		nblk = 0;
 		while (i > 0) {
 			--i;
-			lo = decode_compactedbits(lclusterbits, lomask,
-						  in, encodebits * i, &type);
+			lo = decode_compactedbits(lobits, in,
+						  encodebits * i, &type);
 			if (type == Z_EROFS_LCLUSTER_TYPE_NONHEAD) {
 				if (lo & Z_EROFS_LI_D0_CBLKCNT) {
 					--i;
-- 
2.43.0



