Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6123AD26
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FD1C433C0;
	Mon, 19 Jun 2023 11:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172461;
	bh=dEVVEPlgqo1KsANVwCPpfvIBb6+luo1QKibp34e95AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8r00SciQiuMh6ep64dmlpMmWPAVFJLBrDx6THs8fPv3Vmj5NlCrum+OGs8MC3BzL
	 MEAd4PWaDN7y5DAU6lztQG+RwKl0q6I7joUmPnER8eSK+uiknxDG/Sx8p9+eJM8P4V
	 9Hq93eNuJj+K8HmOPQTSne4NjkyqKGdUpR5NuncE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/107] octeontx2-af: fix lbk link credits on cn10k
Date: Mon, 19 Jun 2023 12:31:00 +0200
Message-ID: <20230619102145.069605154@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

[ Upstream commit 87e12a17eef476bbf768dc3a74419ad461f36fbc ]

Fix LBK link credits on CN10K to be same as CN9K i.e
16 * MAX_LBK_DATA_RATE instead of current scheme of
calculation based on LBK buf length / FIFO size.

Fixes: 6e54e1c5399a ("octeontx2-af: cn10K: Add MTU configuration")
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6ea14c8bd59b8..dee2f2086bb5d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4067,10 +4067,6 @@ int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
 
 static u64 rvu_get_lbk_link_credits(struct rvu *rvu, u16 lbk_max_frs)
 {
-	/* CN10k supports 72KB FIFO size and max packet size of 64k */
-	if (rvu->hw->lbk_bufsize == 0x12000)
-		return (rvu->hw->lbk_bufsize - lbk_max_frs) / 16;
-
 	return 1600; /* 16 * max LBK datarate = 16 * 100Gbps */
 }
 
-- 
2.39.2



