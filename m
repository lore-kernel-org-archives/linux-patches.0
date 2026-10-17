Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329363B7767;
	Sat, 17 Oct 2026 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257005; cv=none; b=uRpcvbGF1yFwU946S9u6JrJBnF6ekaQaRsKL3qAOmC1jZ17Qg32evwnHJaypSWtfI6KoSItHhLgAM6RJ+J/LqUwM+bY/HYNn3yCIL+CmwMko6saocb1hAhOHGeOfNYFrWr1dEw4hh23p+QXDVkk3T62fmJi+ts1gVHS43WsV8Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257005; c=relaxed/simple;
	bh=FzX1gNzj+YAoz3G3ukXXDUTwe5wogwjlOrel2VcIxyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBZEkOLLVcpZ20RHIpCYXhe+RX4ZxGeS2Ba8G0LCZ/M2/ySU6HAPzdKIRhB3m1kVXlHJIhz7RDmzN27NwY+yx4ELyEHZO1FLUlhPGS1PAFI6bI6Mplqxz0uLelIrMApzn5cUg8896kIWU6BOfDJU9SPLtTJsl9t4wdyzr9r+fvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3b4pFE8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3b4pFE8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D11F1F000C4;
	Sat, 17 Oct 2026 17:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257004;
	bh=JKEbvG8HuL97Vs5jaKUrz0x2I7tNOcmE7Ak0wOGOwkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3b4pFE8/fz+Mu/Xb0w7k6Oc0wTwn3m53QRmjLYBWRoxeFLDXKQE/K4KH2N02Q8sz
	 sNHywJjj5I52IIjU88/Xr7qzEpmZxxx/6xxAlOc76f4Csrm2MYUsJpAk7LHqiqCQ6i
	 JT4DwOl6uI+ZhJpMT11NTBYyzXTyMQntGjjSRbjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0420/1674] erofs: unify lcn as u64 for 32-bit platforms
Date: Sat, 17 Oct 2026 17:44:52 +0200
Message-ID: <20261017160441.913162000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2d8c7edcb661812249469f4a5b62e9339118846f ]

As sashiko reported [1], `lcn` was typed as `unsigned long` (or
`unsigned int` sometimes), which is only 32 bits wide on 32-bit
platforms, which causes `(lcn << lclusterbits)` to be truncated
at 4 GiB.

In order to consolidate the logic, just use `u64` consistently
around the codebase.

[1] https://sashiko.dev/r/20260420034612.1899973-1-hsiangkao%40linux.alibaba.com

[ Backport to 6.6.y: rebase after the CVE-2025-68251 compact-index
  validation change. Widen its new lcn diagnostic along with the
  recorder, full and compact loader data flow, lookback and compressed-
  length locals to u64. ]

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e53d5239f04d6..990322b228cb3 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -12,7 +12,7 @@ struct z_erofs_maprecorder {
 	struct erofs_map_blocks *map;
 	void *kaddr;
 
-	unsigned long lcn;
+	u64 lcn;
 	/* compression extent information gathered */
 	u8  type, headtype;
 	u16 clusterofs;
@@ -22,8 +22,7 @@ struct z_erofs_maprecorder {
 	bool partialref;
 };
 
-static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m,
-				      unsigned long lcn)
+static int z_erofs_load_full_lcluster(struct z_erofs_maprecorder *m, u64 lcn)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -219,7 +218,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
-					 unsigned long lcn, bool lookahead)
+					 u64 lcn, bool lookahead)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -270,7 +269,7 @@ static int z_erofs_load_compact_lcluster(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
-					   unsigned int lcn, bool lookahead)
+					   u64 lcn, bool lookahead)
 {
 	struct erofs_inode *vi = EROFS_I(m->inode);
 	int err;
@@ -289,7 +288,7 @@ static int z_erofs_load_lcluster_from_disk(struct z_erofs_maprecorder *m,
 		return err;
 
 	if (m->type >= Z_EROFS_LCLUSTER_TYPE_MAX) {
-		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %u of nid %llu",
+		erofs_err(m->inode->i_sb, "unknown type %u @ lcn %llu of nid %llu",
 			  m->type, lcn, vi->nid);
 		DBG_BUGON(1);
 		return -EOPNOTSUPP;
@@ -310,7 +309,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
 
 	while (m->lcn >= lookback_distance) {
-		unsigned long lcn = m->lcn - lookback_distance;
+		u64 lcn = m->lcn - lookback_distance;
 		int err;
 
 		err = z_erofs_load_lcluster_from_disk(m, lcn, false);
@@ -330,14 +329,14 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 			m->map->m_la = (lcn << lclusterbits) | m->clusterofs;
 			return 0;
 		default:
-			erofs_err(sb, "unknown type %u @ lcn %lu of nid %llu",
+			erofs_err(sb, "unknown type %u @ lcn %llu of nid %llu",
 				  m->type, lcn, vi->nid);
 			DBG_BUGON(1);
 			return -EOPNOTSUPP;
 		}
 	}
 err_bogus:
-	erofs_err(sb, "bogus lookback distance %u @ lcn %lu of nid %llu",
+	erofs_err(sb, "bogus lookback distance %u @ lcn %llu of nid %llu",
 		  lookback_distance, m->lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
@@ -350,7 +349,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	struct erofs_inode *const vi = EROFS_I(m->inode);
 	struct erofs_map_blocks *const map = m->map;
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	unsigned long lcn;
+	u64 lcn;
 	int err;
 
 	DBG_BUGON(m->type != Z_EROFS_LCLUSTER_TYPE_PLAIN &&
@@ -402,7 +401,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 			break;
 		fallthrough;
 	default:
-		erofs_err(sb, "cannot found CBLKCNT @ lcn %lu of nid %llu", lcn,
+		erofs_err(sb, "cannot found CBLKCNT @ lcn %llu of nid %llu", lcn,
 			  vi->nid);
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
@@ -411,7 +410,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	map->m_plen = erofs_pos(sb, m->compressedblks);
 	return 0;
 err_bonus_cblkcnt:
-	erofs_err(sb, "bogus CBLKCNT @ lcn %lu of nid %llu", lcn, vi->nid);
+	erofs_err(sb, "bogus CBLKCNT @ lcn %llu of nid %llu", lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
 }
-- 
2.53.0



