Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94E11A585
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4s83nZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DF3C433C8;
	Mon, 16 Oct 2023 08:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445894;
	bh=ncavapu+B+96TIPb0W7wa4g+w5DygAIUKvaj/Pgxvzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4s83nZsA1VLLzKlokd3eRnHtEiU8bw2cqM7K4pvbrTqDz3mcg0qDIQzY5zqyxHIx
	 hOjZGMtWZc6Ckt9E0091zo0QQ5boKXOYTFydcUs67S0CSpmQrmwvBVLSF1lCjC1w15
	 94KGTNxbWAphE9jsOaRmz9qGerkYa5jdTcTG3yFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/102] net: phy: mscc: macsec: reject PN update requests
Date: Mon, 16 Oct 2023 10:40:32 +0200
Message-ID: <20231016083954.583685341@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

[ Upstream commit e0a8c918daa58700609ebd45e3fcd49965be8bbc ]

Updating the PN is not supported.
Return -EINVAL if update_pn is true.

The following command succeeded, but it should fail because the driver
does not update the PN:
ip macsec set macsec0 tx sa 0 pn 232 on

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index c00eef457b850..bec270785c594 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -880,6 +880,9 @@ static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
+	if (ctx->sa.update_pn)
+		return -EINVAL;
+
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
@@ -929,6 +932,9 @@ static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
 {
 	struct macsec_flow *flow;
 
+	if (ctx->sa.update_pn)
+		return -EINVAL;
+
 	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
 	if (IS_ERR(flow))
 		return PTR_ERR(flow);
-- 
2.40.1



