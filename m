Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33046EF88;
	Tue, 21 Jul 2026 19:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661228; cv=none; b=JPZRZ9/OqcMBfazGzi7eCo7zwKSyHDZvvdAcvdonjX4f3yOCvITmIPaGWpTCLGvLrjvBCDQfOOww1h1h2j9NgFBrM0ScI3eVBVVz/UinjIQaWOKafZ4vr08CvrZJtKuDEe9PgdTxWuED7diFxtEsVHwsl2W6VQaxNG2ULwKmnj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661228; c=relaxed/simple;
	bh=wZSX3P/gQruGdgnTXolhQGj3lmjRRlRX/srFnGXI89w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ6XoNMv2AOrD3XnayGuadR0QuN9iXS2DdElu61mdAzHQi5OVAInhgnswpUZbCxxFESHgPOPN73TwF9t2IO9YG6MO85x6YP9WcybbQWihWhRx+ebqYbnU4XtPxIXg2qzy0il43n79YZADgurNHLTsP8T03sRg67qAsNhNcW63d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/EbK+yq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/EbK+yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F181F00A3A;
	Tue, 21 Jul 2026 19:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661227;
	bh=Pz1A72/DJMsG/0RvU/eo+NfW9+TQeBIuXazgvhXYt30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/EbK+yq2hI/nApgKKlwBX0rOrTp9CfkuhbhICEBKxP12hUaCLCZqqLxPMIbcLlzQ
	 AHjuwOoB6jDo7DPevQVs1bny13ZWg12Rt1nQYNzTEtvXWMZeYSn7+Z/gwTu5r105YS
	 XPgd4tLaO6hBuniG+W05UAIg18yKh7QYoIM9loqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1278/2077] octeontx2-af: Validate NIX maximum LFs correctly
Date: Tue, 21 Jul 2026 17:15:51 +0200
Message-ID: <20260721152622.960063828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 1576d12a39860418d6a68b402fda71a48f04a57c ]

NIX maximum number of LFs can be set via devlink command
but that can be done before assigning any LFs to a PF/VF.
The condition used to check whether any LFs are assigned is
incorrect. This patch fixes that condition.

Fixes: dd7842878633 ("octeontx2-af: Add new devlink param to configure maximum usable NIX block LFs")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1782082853-6941-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 6494a9ee2f0dde..3b47ecb44d51ba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1510,7 +1510,9 @@ static int rvu_af_dl_nix_maxlf_validate(struct devlink *devlink, u32 id,
 	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
 	struct rvu *rvu = rvu_dl->rvu;
 	u16 max_nix0_lf, max_nix1_lf;
-	struct npc_mcam *mcam;
+	struct rvu_block *block;
+	int blkaddr = 0;
+	int free_lfs;
 	u64 cfg;
 
 	cfg = rvu_read64(rvu, BLKADDR_NIX0, NIX_AF_CONST2);
@@ -1518,14 +1520,23 @@ static int rvu_af_dl_nix_maxlf_validate(struct devlink *devlink, u32 id,
 	cfg = rvu_read64(rvu, BLKADDR_NIX1, NIX_AF_CONST2);
 	max_nix1_lf = cfg & 0xFFF;
 
-	/* Do not allow user to modify maximum NIX LFs while mcam entries
-	 * have already been assigned.
+	/* Do not allow user to modify maximum NIX LFs while NIX LFs
+	 * have already been assigned. Note that modifying NIX LFs count
+	 * can be done only before any LF attach requests from PFs and VFs
+	 * and not later or concurrently.
 	 */
-	mcam = &rvu->hw->mcam;
-	if (mcam->bmap_fcnt < mcam->bmap_entries) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "mcam entries have already been assigned, can't resize");
-		return -EPERM;
+	blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
+	while (blkaddr) {
+		block = &rvu->hw->block[blkaddr];
+
+		free_lfs = rvu_rsrc_free_count(&block->lf);
+		if (free_lfs != block->lf.max) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "NIX LFs already assigned, can't resize");
+			return -EPERM;
+		}
+
+		blkaddr = rvu_get_next_nix_blkaddr(rvu, blkaddr);
 	}
 
 	if (max_nix0_lf && val.vu16 > max_nix0_lf) {
-- 
2.53.0



