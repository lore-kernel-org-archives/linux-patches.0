Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F345205501;
	Thu, 12 Dec 2024 17:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024008; cv=none; b=lYVJkuxQCEWl5QTVgp5UfUhjqRGghauNB54Eg5yD3kApPlgnAgF23m9qx0lxFm6f+B0aX36cO34vEgf7EdXiiXeVQgRLJGOq4DO1JAsNl+3J0TNRHSW7FsNR+XeVjsiOQStzp+mBKwkldJI9tmeNjmlEQA2gdb8iKr3FOuFYFio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024008; c=relaxed/simple;
	bh=0cLwS4e38qJWV++nYig8hwHFsLZtzRvIgO1n983SORM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNb0GfXYD+FFE764//sZ0J3kzLNbfS6UmLefOcZqdiixhXSZw5xCgFv2BYheI1yfbDxKAJ2Z4nfspo+MN1Af7nB56r7ezRRxyODrf6IQNV3NuA6wblNs5PmJ/dvQcmBk0v2ZfH3fXkXeaCR7GQdJO5BcnRrWvdXPLTQiv8VmHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJe44nXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJe44nXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8432C4CECE;
	Thu, 12 Dec 2024 17:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024008;
	bh=0cLwS4e38qJWV++nYig8hwHFsLZtzRvIgO1n983SORM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJe44nXqPMxSm159QSr0NW/Qnfu799hqWQhnPghSyAjYM44VkBFgOWbZ/jPcPJagx
	 EXmW/gyUEwXUT2xCs8RdWyQUgCXjrKV/Z3SYDqtiBcFlzKGkAMx+7yGQaAnLrngZMq
	 q80y/TLBe2KbbLbRAzX6aZ/ml+ovUGLNCNYpbzgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Rakesh Babu <rsaladi2@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/459] octeontx2-pf: Calculate LBK link instead of hardcoding
Date: Thu, 12 Dec 2024 15:57:44 +0100
Message-ID: <20241212144258.485868899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 8bcf5ced6526e1c4c8a2703f9ca9135fef7409d6 ]

CGX links are followed by LBK links but number of
CGX and LBK links varies between platforms. Hence
get the number of links present in hardware from
AF and use it to calculate LBK link number.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e26f8eac6bb2 ("octeontx2-pf: handle otx2_mbox_get_rsp errors in otx2_ethtool.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 8 ++++++--
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index b062ed06235d2..3b4530bc30378 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -532,8 +532,10 @@ static int otx2_get_link(struct otx2_nic *pfvf)
 		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
 	}
 	/* LBK channel */
-	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE)
-		link = 12;
+	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE) {
+		map = pfvf->hw.tx_chan_base & 0x7FF;
+		link = pfvf->hw.cgx_links | ((map >> 8) & 0xF);
+	}
 
 	return link;
 }
@@ -1519,6 +1521,8 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 	pfvf->hw.tx_chan_base = rsp->tx_chan_base;
 	pfvf->hw.lso_tsov4_idx = rsp->lso_tsov4_idx;
 	pfvf->hw.lso_tsov6_idx = rsp->lso_tsov6_idx;
+	pfvf->hw.cgx_links = rsp->cgx_links;
+	pfvf->hw.lbk_links = rsp->lbk_links;
 }
 EXPORT_SYMBOL(mbox_handler_nix_lf_alloc);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index d6253f2a414d3..386cb08497e48 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -197,6 +197,8 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
 	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
+	u8			cgx_links;  /* No. of CGX links present in HW */
+	u8			lbk_links;  /* No. of LBK links present in HW */
 };
 
 struct otx2_vf_config {
-- 
2.43.0



