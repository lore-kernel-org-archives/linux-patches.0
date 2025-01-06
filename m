Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E351086332;
	Mon,  6 Jan 2025 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177850; cv=none; b=MBD80sqMpk9ynShWvE5rL6rSe5p46IqVrheNZiXBTGvcMTaYs8EygiNq/2ABBQhM2DH98tWA8460+b1Blp8GANW3yekXVxSfLbmKEQG9k6rGg2bZAopDtyRRv52mLWKO27t+io7n9ze/lDRb7mVkmer8+l/exRHFmjZjLw3ucps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177850; c=relaxed/simple;
	bh=rQbmZ7VXEhmVil3ZdxFcrTeWNZtGXT7rllsJtCrGaGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGqeWc6WMobuZfcwnA6QRAUg6Y/tj8GXEBslg8C4OCiRK79sksbSbz2/ZPBR5MeZKZuMsZJOe8AUAN6OPWQ1r4pHsN5xbdUAzsFwp+LR6E5yHOgqWVLTfkb9aBXUQEfWXWjcXdx1trbUFFhaKM/JjS0trfkcDhtkC3ySOAmAR+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IR0qvtyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IR0qvtyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ECFC4CED2;
	Mon,  6 Jan 2025 15:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177849;
	bh=rQbmZ7VXEhmVil3ZdxFcrTeWNZtGXT7rllsJtCrGaGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IR0qvtyvzLiDgJbaf1TicSNJ/hJcVlSADUgJb6lEHedYv0z4+rtyYktqPOz1IzIkC
	 MSihSc7dVVLdfN3eEVfLVZfVBiD0xbAr0pZ9H4GwIhEEbHX0DFGHR01jNFAlFhfh0w
	 tPdTUq65uGPb+Zz6lH62EEhMNB0NdrolUG56Mp+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Lior Nahmanson <liorna@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/156] net/mlx5e: macsec: Maintain TX SA from encoding_sa
Date: Mon,  6 Jan 2025 16:15:36 +0100
Message-ID: <20250106151143.618749843@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 8c6254479b3d5bd788d2b5fefaa48fb194331ed0 ]

In MACsec, it is possible to create multiple active TX SAs on a SC,
but only one such SA can be used at a time for transmission. This SA
is selected through the encoding_sa link parameter.

When there are 2 or more active TX SAs configured (encoding_sa=0):
  ip macsec add macsec0 tx sa 0 pn 1 on key 00 <KEY1>
  ip macsec add macsec0 tx sa 1 pn 1 on key 00 <KEY2>

... the traffic should be still sent via TX SA 0 as the encoding_sa was
not changed. However, the driver ignores the encoding_sa and overrides
it to SA 1 by installing the flow steering id of the newly created TX SA
into the SCI -> flow steering id hash map. The future packet tx
descriptors will point to the incorrect flow steering rule (SA 1).

This patch fixes the issue by avoiding the creation of the flow steering
rule for an active TX SA that is not the encoding_sa. The driver side
tx_sa object and the FW side macsec object are still created. When the
encoding_sa link parameter is changed to another active TX SA, only the
new flow steering rule will be created in the mlx5e_macsec_upd_txsa()
handler.

Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241220081505.1286093-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index cc9bcc420032..6ab02f3fc291 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -339,9 +339,13 @@ static int mlx5e_macsec_init_sa_fs(struct macsec_context *ctx,
 {
 	struct mlx5e_priv *priv = macsec_netdev_priv(ctx->netdev);
 	struct mlx5_macsec_fs *macsec_fs = priv->mdev->macsec_fs;
+	const struct macsec_tx_sc *tx_sc = &ctx->secy->tx_sc;
 	struct mlx5_macsec_rule_attrs rule_attrs;
 	union mlx5_macsec_rule *macsec_rule;
 
+	if (is_tx && tx_sc->encoding_sa != sa->assoc_num)
+		return 0;
+
 	rule_attrs.macsec_obj_id = sa->macsec_obj_id;
 	rule_attrs.sci = sa->sci;
 	rule_attrs.assoc_num = sa->assoc_num;
-- 
2.39.5



