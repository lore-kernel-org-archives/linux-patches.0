Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869247F2C8;
	Thu, 20 Aug 2026 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248228; cv=none; b=StlcFosKYCxbe+w3XIw5zEacbqXB/CLTzhzp3JpUVTGwfrBa3Uwmz6ng4Ju651x1AWAj2m3zgOmWHEB91oW9V3umeLrPEZUOyaD6nh6Q+pOj3N2pOg4NOENSG1EX7li64+GmJ5b+cGuZjl2ud8fRxHSnm1jAL4dtkBRi7tYY7PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248228; c=relaxed/simple;
	bh=TImVbdDk1ANj+30lmkXtmCCQiBwUuUd+G9N4FGfyeGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7d09xdTVKT86H2T77aC0kb/+Zfye5V3mQ1mpzUyG6vN4EUNBUlgd/QPCx4aQPA2gO8ORXu2UQvV1OKH5wGKtEoBIfKaEDrpl3oScSOEKURvVCDF6O1BHFOGlQ3ZovRRe9fTPcndhAO4xSQcaxHm5/A2CgSFm8+EvQMZ/NRXvdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0m7WP79; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0m7WP79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB731F000E9;
	Thu, 20 Aug 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248227;
	bh=QhYlhv++JJ/f2Mw84m4grYA9lbz35i9DpPTlBqs7Q/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0m7WP79WDaZtsBNUEhrR0ObKtQDrtBGQ1qG4ha2ygvAKD4pFbsYbG5GHrYSkTQxw
	 KEcbipT8spO3uoHV5i4jfoguwwlrgjkesb3Y6A2t5OPmr2hIQMXz36yKRX1AQ7llo5
	 8uU/iBprn+b/9lcDbQlJtee84TZ8qCZ3KGLQ3qS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/303] octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF
Date: Thu, 20 Aug 2026 16:54:51 +0200
Message-ID: <20260820145257.953701962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 8cdcf3d2caacdee7ddd363705fb4d93b0c1a0915 ]

rvu_mbox_handler_lmtst_tbl_setup() uses req->base_pcifunc as a direct
index into the LMT map table to read another function's LMTLINE
physical base address and copy it into the caller's own LMT map table
entry. The mailbox dispatcher authenticates req->hdr.pcifunc from the
IRQ source, but req->base_pcifunc is a separate payload field and is
not sanitized.

Reject the request with -EPERM when a VF caller's base_pcifunc is not a
valid function under its own PF. is_pf_func_valid() bounds the FUNC field
to the PF's configured VF count, keeping the computed index inside the
caller's own slot block.

Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST regions")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB78811656934E713B77DA6CEDAFE62@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Dropped `rvu->pdev` argument from `rvu_get_pf()` calls and folded in the `is_pf_func_valid()` de-static plus its `rvu.h` declaration from commit 2156a29aecff. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c       |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h       |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c |    9 +++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -440,7 +440,7 @@ struct rvu_pfvf *rvu_get_pfvf(struct rvu
 		return &rvu->pf[rvu_get_pf(pcifunc)];
 }
 
-static bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc)
+bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc)
 {
 	int pf, vf, nvfs;
 	u64 cfg;
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -718,6 +718,7 @@ int rvu_get_pf(u16 pcifunc);
 struct rvu_pfvf *rvu_get_pfvf(struct rvu *rvu, int pcifunc);
 void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf);
 bool is_block_implemented(struct rvu_hwinfo *hw, int blkaddr);
+bool is_pf_func_valid(struct rvu *rvu, u16 pcifunc);
 bool is_pffunc_map_valid(struct rvu *rvu, u16 pcifunc, int blktype);
 int rvu_get_lf(struct rvu *rvu, struct rvu_block *block, u16 pcifunc, u16 slot);
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf);
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
@@ -178,6 +178,15 @@ int rvu_mbox_handler_lmtst_tbl_setup(str
 	 * pcifunc (will be the one who is calling this mailbox).
 	 */
 	if (req->base_pcifunc) {
+		/* A VF is untrusted and must not redirect its LMTLINE to
+		 * another PF's region, so confine VF callers to their own PF.
+		 */
+		if (is_vf(req->hdr.pcifunc) &&
+		    (!is_pf_func_valid(rvu, req->base_pcifunc) ||
+		     rvu_get_pf(req->hdr.pcifunc) !=
+		     rvu_get_pf(req->base_pcifunc)))
+			return -EPERM;
+
 		/* Calculating the LMT table index equivalent to primary
 		 * pcifunc.
 		 */


