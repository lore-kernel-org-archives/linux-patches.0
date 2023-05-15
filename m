Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5055FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292C9C433EF;
	Mon, 15 May 2023 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170161;
	bh=qTsrLSqGAkEBd9UiyRLMI7cQ0VBHbsj8urXUfkpEl78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bjo9SRR15nqSfO3cXVih4VJyDJ1HgSEio+RFaNijjsQaITXoYN0cbCwJOStbUObPg
	 pmczngVbv9F/XjZnKIwifza+tseiv3QwGenzX7JR5CqEIjGWTCpCJ0+9zWuQc6M9P3
	 OJvcSgSzR1k7KRfUdxECty7tataq2i5OFNghK5/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/239] octeontx2-pf: mcs: Do not reset PN while updating secy
Date: Mon, 15 May 2023 18:25:06 +0200
Message-Id: <20230515161723.002673573@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 3c99bace4ad08ad0264285ba8ad73117560992c2 ]

After creating SecYs, SCs and SAs a SecY can be modified
to change attributes like validation mode, protect frames
mode etc. During this SecY update, packet number is reset to
initial user given value by mistake. Hence do not reset
PN when updating SecY parameters.

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 3ad8d7ef20be6..a487a98eac88c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1134,6 +1134,7 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	struct macsec_secy *secy = ctx->secy;
 	struct macsec_tx_sa *sw_tx_sa;
 	struct cn10k_mcs_txsc *txsc;
+	bool active;
 	u8 sa_num;
 	int err;
 
@@ -1141,15 +1142,19 @@ static int cn10k_mdo_upd_secy(struct macsec_context *ctx)
 	if (!txsc)
 		return -ENOENT;
 
-	txsc->encoding_sa = secy->tx_sc.encoding_sa;
-
-	sa_num = txsc->encoding_sa;
-	sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+	/* Encoding SA got changed */
+	if (txsc->encoding_sa != secy->tx_sc.encoding_sa) {
+		txsc->encoding_sa = secy->tx_sc.encoding_sa;
+		sa_num = txsc->encoding_sa;
+		sw_tx_sa = rcu_dereference_bh(secy->tx_sc.sa[sa_num]);
+		active = sw_tx_sa ? sw_tx_sa->active : false;
+		cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc, sa_num, active);
+	}
 
 	if (netif_running(secy->netdev)) {
 		cn10k_mcs_sync_stats(pfvf, secy, txsc);
 
-		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, sw_tx_sa, sa_num);
+		err = cn10k_mcs_secy_tx_cfg(pfvf, secy, txsc, NULL, 0);
 		if (err)
 			return err;
 	}
-- 
2.39.2



