Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4B27ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvKrYFIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B884C433C7;
	Mon, 16 Oct 2023 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467689;
	bh=MhKO85ljGZNyFH57705miLzNWqvFo5Vs05NCQcdPVGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvKrYFIndBXCiye2KZyqmqUWO/8u2F5m6ZVlAqBT803mBATwkeYO/0p6Aji2aYNRc
	 54ScMHwW11spR5bj8WXnwJ8NXxsX4bWKUE3g+vnTbt4tDRrsRnTVnut84KQR5vP3sO
	 KL5sLmrlCnK7tUvjPGHuI8ODH2QbYk7IGhhUz3dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 071/191] octeontx2-pf: mcs: update PN only when update_pn is true
Date: Mon, 16 Oct 2023 10:40:56 +0200
Message-ID: <20231016084017.066067048@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

[ Upstream commit 4dcf38ae3ca16b8872f151d46ba5ac28dd580b60 ]

When updating SA, update the PN only when the update_pn flag is true.
Otherwise, the PN will be reset to its previous value using the
following command and this should not happen:
$ ip macsec set macsec0 tx sa 0 on

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c   | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 59b138214af2f..6cc7a78968fc1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -1357,10 +1357,12 @@ static int cn10k_mdo_upd_txsa(struct macsec_context *ctx)
 
 	if (netif_running(secy->netdev)) {
 		/* Keys cannot be changed after creation */
-		err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
-					   sw_tx_sa->next_pn);
-		if (err)
-			return err;
+		if (ctx->sa.update_pn) {
+			err = cn10k_write_tx_sa_pn(pfvf, txsc, sa_num,
+						   sw_tx_sa->next_pn);
+			if (err)
+				return err;
+		}
 
 		err = cn10k_mcs_link_tx_sa2sc(pfvf, secy, txsc,
 					      sa_num, sw_tx_sa->active);
@@ -1529,6 +1531,9 @@ static int cn10k_mdo_upd_rxsa(struct macsec_context *ctx)
 		if (err)
 			return err;
 
+		if (!ctx->sa.update_pn)
+			return 0;
+
 		err = cn10k_mcs_write_rx_sa_pn(pfvf, rxsc, sa_num,
 					       rx_sa->next_pn);
 		if (err)
-- 
2.40.1



