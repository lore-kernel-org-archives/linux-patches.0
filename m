Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E98D453A21;
	Thu, 30 Jul 2026 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428326; cv=none; b=emQmCDptfvLxC+swXTmlsIAV/ejIPMs9wbPd3X6d/lU7rHXF9uKaHJCpUM9U46ZdvCp1U0/3owq+TflarINZrdVcN0ibXj3dM3dYTYU/i/KPEBvaRglohyWc/ukkwt9Zp+ggmnkHX0YWzIJVnDH3Plf+6z8Mi/2ow08EaRTl1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428326; c=relaxed/simple;
	bh=wdKVZDP4ivoaeRs0GuGt/Pfa0iebXGD/E3x84EaN/RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3Onf4RIhu1ojjh8jX/fRHcnIqsd0flIDiqKIoS3bb2q+tKs4CzP2nw+PglCLX2cGm0WPpPgMcjOzadLdDggAzFMToic0BY12PaWs9rMtJcm6pxF/Az6ETuZ5cS5ZzbW0Kd/JSfsub+GRJaxsHZZl4Wn579B3OxgjR2vDm8jStw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+2Ic80C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+2Ic80C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2671F000E9;
	Thu, 30 Jul 2026 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428325;
	bh=z5oAm0k5e61Uce4Xn560iJjzUMKb7YUOK3F0HafPkrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+2Ic80CJkRERUg2bNjxjeUcvZGh/2211zxz7chmV1w/BiOytJ+1PqcQ/kJ10BglF
	 viZMe1pbNIOeHekyiqB636ywRjuDguLc8t1aW9GLR3DDcDa09JH59lhwTQrtOtGYUi
	 zcInBzhObp/dCTmoWB7bg2qOYjOSKYhddtZwb/5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 465/484] octeontx2-af: cn10k: restrict VF LMTLINE sharing to its own PF
Date: Thu, 30 Jul 2026 16:16:02 +0200
Message-ID: <20260730141433.587631218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -751,6 +751,7 @@ int rvu_get_pf(u16 pcifunc);
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


