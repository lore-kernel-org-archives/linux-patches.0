Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09548139579;
	Tue, 27 May 2025 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365750; cv=none; b=ApPdB8wNfvSUhj7XOf4JEtN6gc7xVdXzsGRgJ46tTuGHo7Vto3VSsgBbBg0+SrlwMjypeiAuhyTqBvI3bxq2h8C2grI/ynvxcmFKryrtC3TFMfIipaP1tEC3wc8QAV88P9igycv11GeZDR4QO287esvteyzofNWWYdMnsUpJ5cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365750; c=relaxed/simple;
	bh=uChY627mp2HaoGjvTlNiUopRQWWuV9endS+9JeEMVK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUCu66ZMCQuY3ZBaGL1x34xKWQ6HH85LcEbuvrfz5XQtftbTtOdT422M3E26YTpjH28nrQLCpFTEI56JzLDwmoKs6sGQayKsfmQsnJEEt5RfgVRs9FQ+TJrJ/1ZnYAXslUjbUBuA46Q1PKzj4/h+NsRqh8jHvLfhSl23mMvyW7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scKF09Gw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scKF09Gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B267C4CEE9;
	Tue, 27 May 2025 17:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365749;
	bh=uChY627mp2HaoGjvTlNiUopRQWWuV9endS+9JeEMVK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scKF09GwMFBHmv82ynGgvh58Dq8D4+4sMjkBYEvoPiPjp70MMqU1JuL9H/hk1jtrD
	 CMtDVjUpO005dSZNdPgW7CupUtsjv4ib6GD89jUBpvPMJGFBxlsZhZVLE1G8c9kcOj
	 5M0L5UNRAV83hizDxcFsi7C/DJF55yC4QZBKfsz8=
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
Subject: [PATCH 6.12 446/626] net/mlx5e: Avoid WARN_ON when configuring MQPRIO with HTB offload enabled
Date: Tue, 27 May 2025 18:25:39 +0200
Message-ID: <20250527162503.120637283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 38055537b12ac..4a2f58a9d7066 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3759,8 +3759,11 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
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



