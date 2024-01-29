Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB5B7405B;
	Mon, 29 Jan 2024 17:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548571; cv=none; b=E+p5mt6EtbOT97ipkhBvVdFfSTmSnOEPqKpH3CvwsSpQDPMLOGTorLfZG6a9QfqkDEZgxDT6CZ+D11mjIQPA8wnnCiJ2L1aKyU13QQzwWeJb/v2ehCbQxBLXYt7nIYWVHBqMS2fJ9ZKjEMeejjq8vCTbNXHhJ+gJY/s7eKSbiz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548571; c=relaxed/simple;
	bh=QRKeo1VQc6OEZ79D+xRWLocc3GD6Yp1vK53uocWsSGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUFtvVBC9kwtJpcllhjCbKeprB2tqW7g41Q5WkRWAefYnwAhyOyJGYsSHq1n/x5xncAB0QYj3tUSkaR8Y3qyWtMet2U9TQXYYVu/Xgj2n50w8TOPQmGlYcrQUjEg0Yl4JGCpllIECdGPwPK5doISs/ppRdxtUQBHaWpakMrxzIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSenVJTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSenVJTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69574C43394;
	Mon, 29 Jan 2024 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548571;
	bh=QRKeo1VQc6OEZ79D+xRWLocc3GD6Yp1vK53uocWsSGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSenVJTV3QhzjS2mRwzgZwYZ5l37ajC7IJ9YhAAa53D0D8vpGlt9YCMgC64EkNGSZ
	 m/WZfldz3PU9iAdSlJyeUwBOMT8Vew4DmNIKEnat0j4lUu2auN4gxIkVonVSv2Hvh9
	 l/DgoAR0dkDUD1wWlZOdTu1cYrGV+OtJNAdCaXCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 197/331] net/mlx5: DR, Use the right GVMI number for drop action
Date: Mon, 29 Jan 2024 09:04:21 -0800
Message-ID: <20240129170020.639990980@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5b83da08692d..1a5aee8a7f13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -781,6 +781,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		switch (action_type) {
 		case DR_ACTION_TYP_DROP:
 			attr.final_icm_addr = nic_dmn->drop_icm_addr;
+			attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-- 
2.43.0



