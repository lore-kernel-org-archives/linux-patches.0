Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2806015A4B8;
	Mon, 29 Jan 2024 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548324; cv=none; b=ZPGeB8pUNuKqwrtg3rAqiD/Cb9IREUO8azsTWxV7ddyS5nx9MwM1ZXCUAr5dyDRZnrH3OTY1emxkCQS0hqCy5RihYnT/GKs5BuV4Vqnz+7MAKPuJ9b01UGn8tUQNZN6LfBN094KY6JeLMOwpYuna931J/eWbhRblW6tV07H68/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548324; c=relaxed/simple;
	bh=j61RwMz6vhjSUft18ss6smUAtOXV3whT1cB5EYPIsSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv6pQVA+5MrnFp7zkEczKA54aTvl/aLPjaAANQzHnx8B+zRMqa+2L31VgqOH2OmN1cHgYTM3nB1YELavkqf4dA5Ls4jAfpOpZEjjrc/65mANWcqTApk22Xl7GtYMazkEocy84/HqWJlyRc90mkEpm5isFHnpEkp5fFjcSceG+7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdYz1rgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdYz1rgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F6CC43390;
	Mon, 29 Jan 2024 17:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548324;
	bh=j61RwMz6vhjSUft18ss6smUAtOXV3whT1cB5EYPIsSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdYz1rgpwFKkKk86MQM3NNT0ppaqgXtUNrXJCaugwqkVxxdrJD34Neui21CdSGbv/
	 U/5rDlVTbCu9l5QUMckJWHCOJpVeFYdx4btfgILhRYDXlL4MEUBwPzibABwBdwR0+G
	 l5TS68lTaAj9rzR3ut3e6G32VK4WLTnBlIBbshHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/185] net/mlx5: DR, Use the right GVMI number for drop action
Date: Mon, 29 Jan 2024 09:04:55 -0800
Message-ID: <20240129170001.642148318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 5665954293f13642f9c052ead83c1e9d8cff186f ]

When FW provides ICM addresses for drop RX/TX, the provided capability
is 64 bits that contain its GVMI as well as the ICM address itself.
In case of TX DROP this GVMI is different from the GVMI that the
domain is operating on.

This patch fixes the action to use these GVMI IDs, as provided by FW.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a3e7602b044e..8c265250bbaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -673,6 +673,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		switch (action_type) {
 		case DR_ACTION_TYP_DROP:
 			attr.final_icm_addr = nic_dmn->drop_icm_addr;
+			attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-- 
2.43.0



