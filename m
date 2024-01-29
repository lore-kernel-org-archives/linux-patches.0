Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C59159560;
	Mon, 29 Jan 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548154; cv=none; b=QpZD4xNdfPxBpdfyh4SG9SFfzFX5fx4bkJ3NYvKOjNRzX8UTFYWhhGPgLKBC13UT8v/Bf9YzKz6aNT8AhKqgAMCCdnoPj5E563WfqHegQhP/7L9RxBYMM0drBSvbd/KOgDn/PeNGI5UAk92BqqewV6HIsqejkWoPb3eTMwwPWXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548154; c=relaxed/simple;
	bh=GdQPhP4gXf70go/x2fTITEDndicuddtXGgVAFmXBuMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5h0mfeC/V5IA1VhnVLsYqE2alD0snx3kxij9txJGIV6ANVnKgOarl/jLgwwXty1WtiRHGtNTMTvBUq8xJVHtZrVXkfxQw6HmQNq+CPJW5kbchee+g638BQeaB3A981eUtq2xZctTJvO1aB1atUu2TkPEK4p7VLfJHkW3h1OudM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xeWoXcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xeWoXcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD7C433C7;
	Mon, 29 Jan 2024 17:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548153;
	bh=GdQPhP4gXf70go/x2fTITEDndicuddtXGgVAFmXBuMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xeWoXcxtAb3s1UwDxwLOAeioHAZKg+vSJvfNlajwDdt6ej2/GqYZOs5F9e6A2GYu
	 VyyygSQN/Np0NxVLoixSRBxEaxjuyPwpcX7JCvBAJNHnjkEPJ4+/PUEw4M3+Xrz/h1
	 tBQdynqRUP4skaPP1zrkReq2U9XI6IoNFx1AnyNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 191/346] net/mlx5: DR, Use the right GVMI number for drop action
Date: Mon, 29 Jan 2024 09:03:42 -0800
Message-ID: <20240129170022.019844979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e3ec559369fa..74fc318b5027 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -788,6 +788,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		switch (action_type) {
 		case DR_ACTION_TYP_DROP:
 			attr.final_icm_addr = nic_dmn->drop_icm_addr;
+			attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-- 
2.43.0



