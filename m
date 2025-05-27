Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D631FB3;
	Tue, 27 May 2025 17:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367984; cv=none; b=fM05A4qqOU1fEzAF73369o2T44BZmQEmlNJ+9eWUmUvCsvgRnWrc+caupF6fSzUXhGWv6Z+rcpE6S6GWdI3CMDnRPsbPpEWoIvicQIVyMD42DQMV75h3+S5iDte/sak1Jx6jCd8ZH9RL/c0egc5BymV3hzkl2d9M5cP8wO2oyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367984; c=relaxed/simple;
	bh=MDc42TrWAovL9NxNoMPLypxZB2GBUMMjtp91hhJlRoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sh3TNkfj2vQQCHmwamALFOiDv/OA9G+nzRgH6nBCOm9B5sFeUJPq5crhj09Vqj8c2d6yxAh8MrEElJWkr53f1BmwHODmLvSnR8SR/yOeiwxkpI9rxwFIv4xu0lNbN6rwwgaDfbouE3tc3+EESc7+OP3zJx0+A85VEE19Hb46OYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=caW2sKxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="caW2sKxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1817C4CEE9;
	Tue, 27 May 2025 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367984;
	bh=MDc42TrWAovL9NxNoMPLypxZB2GBUMMjtp91hhJlRoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=caW2sKxQyTSff/Jfp+51PFbrIs+yd2aHJVN1ELUjqB4snR+KaJzmeOz3PI+8jW1tC
	 Q+yBVVIwM6Yuhl9Y3D85ADW1XHLFjP9VQggv+vrQhNoVJUyl4EqrvIaqDu1plAsxCG
	 LkOv4mCNO/zBPxrEy2OvzkQc4b5/u07Y6gSvtNak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 561/783] net/mlx5e: Avoid WARN_ON when configuring MQPRIO with HTB offload enabled
Date: Tue, 27 May 2025 18:25:58 +0200
Message-ID: <20250527162535.992828865@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 689805dcc474c2accb5cffbbcea1c06ee4a54570 ]

When attempting to enable MQPRIO while HTB offload is already
configured, the driver currently returns `-EINVAL` and triggers a
`WARN_ON`, leading to an unnecessary call trace.

Update the code to handle this case more gracefully by returning
`-EOPNOTSUPP` instead, while also providing a helpful user message.

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b0748e46b1ac4..ca56740f6d2f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3787,8 +3787,11 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 	/* MQPRIO is another toplevel qdisc that can't be attached
 	 * simultaneously with the offloaded HTB.
 	 */
-	if (WARN_ON(mlx5e_selq_is_htb_enabled(&priv->selq)))
-		return -EINVAL;
+	if (mlx5e_selq_is_htb_enabled(&priv->selq)) {
+		NL_SET_ERR_MSG_MOD(mqprio->extack,
+				   "MQPRIO cannot be configured when HTB offload is enabled.");
+		return -EOPNOTSUPP;
+	}
 
 	switch (mqprio->mode) {
 	case TC_MQPRIO_MODE_DCB:
-- 
2.39.5



