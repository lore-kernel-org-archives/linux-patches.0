Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19AC266EFC;
	Tue, 11 Nov 2025 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823645; cv=none; b=YGi//Z6cOxBXD5qbMLh2VHnjfNEIIX8iJpKuzuBp82FvaWl+7ZH4WvsYymdbLLyrd5XgvRUhyI1iCZxK/netQPf+h18xF2usrBXYk7Jb9nMdrzHUCSxVeE5OVMp7Bi4hF55DhRad2mHjLVE7Lqza90e6kHd9XuQwOtVMfHcrR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823645; c=relaxed/simple;
	bh=t50wLiN740HMfUa0/lWiDILSdWIumY8MzSOJAViLtrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZYT6TvSzbx4yLMQBg53NnOXIyEOLbbMvLfvJsImw29T+AEFasb4VwKcTIdQbVtX9xOx5ZPS8/oaPTWJkB+df6xhfLQa1OmsypJBb3wudXVSmAedu+KD7RVjjZQiGhGxF3qUv2ISopyVWE6uBt5nDeP1TYmTQ8T3Q874O29F0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+D2nVP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+D2nVP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6742AC19424;
	Tue, 11 Nov 2025 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823645;
	bh=t50wLiN740HMfUa0/lWiDILSdWIumY8MzSOJAViLtrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+D2nVP0b4LsBUnK1lUmmZ3jExcZPjXkXNRyBRB9n98dYLv7tWDICo/K0ekJsqXoo
	 w7gHJxtzX/jcT56jyFu/HeNHSb9NVCZRJSQu+JK5ZuDcMc9i0or6zySPXN9soClfFt
	 woWp6Fzf0v497/bdyW/W8to/odLsv3giyFmHPg+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 342/849] Octeontx2-af: Broadcast XON on all channels
Date: Tue, 11 Nov 2025 09:38:32 +0900
Message-ID: <20251111004544.689130728@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit a7bd72158063740212344fad5d99dcef45bc70d6 ]

The NIX block receives traffic from multiple channels, including:

MAC block (RPM)
Loopback module (LBK)
CPT block

                     RPM
                      |
                -----------------
       LBK   --|     NIX         |
                -----------------
                     |
                    CPT

Due to a hardware errata,  CN10k and earlier Octeon silicon series,
the hardware may incorrectly assert XOFF on certain channels during
reset. As a workaround, a write operation to the NIX_AF_RX_CHANX_CFG
register can be performed to broadcast XON signals on the affected
channels

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250820064625.1464361-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c  |  3 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h  |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c  | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c6bb3aaa8e0d0..2d78e08f985f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1164,6 +1164,9 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 	rvu_program_channels(rvu);
 	cgx_start_linkup(rvu);
 
+	rvu_block_bcast_xon(rvu, BLKADDR_NIX0);
+	rvu_block_bcast_xon(rvu, BLKADDR_NIX1);
+
 	err = rvu_mcs_init(rvu);
 	if (err) {
 		dev_err(rvu->dev, "%s: Failed to initialize mcs\n", __func__);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 18c7bb39dbc73..b582833419232 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -1031,6 +1031,7 @@ int rvu_nix_mcast_update_mcam_entry(struct rvu *rvu, u16 pcifunc,
 void rvu_nix_flr_free_bpids(struct rvu *rvu, u16 pcifunc);
 int rvu_alloc_cint_qint_mem(struct rvu *rvu, struct rvu_pfvf *pfvf,
 			    int blkaddr, int nixlf);
+void rvu_block_bcast_xon(struct rvu *rvu, int blkaddr);
 /* NPC APIs */
 void rvu_npc_freemem(struct rvu *rvu);
 int rvu_npc_get_pkind(struct rvu *rvu, u16 pf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 60db1f616cc82..828316211b245 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -6616,3 +6616,19 @@ int rvu_mbox_handler_nix_mcast_grp_update(struct rvu *rvu,
 
 	return ret;
 }
+
+/* On CN10k and older series of silicons, hardware may incorrectly
+ * assert XOFF on certain channels. Issue a write on NIX_AF_RX_CHANX_CFG
+ * to broadcacst XON on the same.
+ */
+void rvu_block_bcast_xon(struct rvu *rvu, int blkaddr)
+{
+	struct rvu_block *block = &rvu->hw->block[blkaddr];
+	u64 cfg;
+
+	if (!block->implemented || is_cn20k(rvu->pdev))
+		return;
+
+	cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0));
+	rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0), cfg);
+}
-- 
2.51.0



