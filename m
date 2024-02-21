Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6187869317;
	Wed, 21 Feb 2024 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525019; cv=none; b=rGZZ7oTiYHcDYBbrZDYB7PU7oJsjG6PAe+3TJr723Vu/cvEi7cn/KT1u9LFtGx6O1Xm1gf0tWykbxQrdDL2NVuThR+WXpR3OnzhloRo71d9rd0N/pKQZgeaO63av+b4bYuqhvdVsYx2Sfx1ONUk5Bd7VVkEX0d9EFJmCkxz3A2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525019; c=relaxed/simple;
	bh=C/hmfvdl5q/J+GWuPKZtgrwxW1JMryDbWcr67gYnegQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxzNcy85YUJBbMbLk+HA7Qe0x7+zARJsXB+RM3cy28XgXNSwSPiTKUHnwI+imbaoKzZA2rxzW4IN/yAlBdGfJtoQHrQY04+egkdNBqZQcuaVYUs0PzFXtcanN/RFKgr9ih/WIyVCTNCKBVCaB/bnfmpySqkZnuks9KLV9XQXtrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7lI+BLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7lI+BLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCF3C433C7;
	Wed, 21 Feb 2024 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525019;
	bh=C/hmfvdl5q/J+GWuPKZtgrwxW1JMryDbWcr67gYnegQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7lI+BLb+R+rNiOImRecDYWMf0bufAMfWmnlD4/T0uaqHqF3BtbK9jF/lYqz1SG/W
	 BqxaP7DarHO9maGYAEzekzmHLGCrxm27hgR2qVRhW6UfdYp3OE0bBWIDBlJqKQ5Zkb
	 azgp7RnmaBZosyqTXreey9QbJxZrp6E4IEEl3b9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/267] net/mlx5: DR, Use the right GVMI number for drop action
Date: Wed, 21 Feb 2024 14:06:16 +0100
Message-ID: <20240221125941.131978898@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b2dfa2b5366f..dccb4f6c14e7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -667,6 +667,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		switch (action_type) {
 		case DR_ACTION_TYP_DROP:
 			attr.final_icm_addr = nic_dmn->drop_icm_addr;
+			attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-- 
2.43.0



