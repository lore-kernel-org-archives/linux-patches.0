Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB80762C1;
	Wed, 21 Feb 2024 13:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522124; cv=none; b=R1eV/SU2/i3G9QMaYIUgWiJxRG5tbATzGUJRO5mPWrjlB+aXzCGGzv52m1CeeCNwuAvIxp8KMnmvKeapwyDXpP0osq1dxPoWTk10GNCm8x2rsu5kHjCBnDkYwFp8+qN5X2b1oMfjgCOe+RvKBkfCajckzNMgRMgN7cdaiu3vQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522124; c=relaxed/simple;
	bh=121/nwdQpK6uKZBqHGw/mC0aC4mmkBmz6MfWgRdwoGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuVfio4cJy5RA9U8gNBavA3qPkcSlQqrVZp5PTBpkSOV86XfqZ3tQRTcQhL7Fkoz3wYsiGIwgNEr/GXiB8foFq5UHdK328L8r5AHwbH2bWnkyBzHQsI71Jga6MGASn0IffLdha9okKeyCuW/iG6bBiIN4HYF+osPcojugLvChfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wptUXPFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wptUXPFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E87CC43399;
	Wed, 21 Feb 2024 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522123;
	bh=121/nwdQpK6uKZBqHGw/mC0aC4mmkBmz6MfWgRdwoGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wptUXPFUwqhpX45xqfV5rXdEzuY/J79HYM9C02UI1QjFMmueX21od5qKKNVMCX9E4
	 OYtqfpXMwSNuURAtO/MtDUWAjfcOVQQFkcMaZ4UiVxBXlvyA3+OIV3U2typVIpwKS1
	 ZP5zUdn/pgzKF3aRSZJUO6NnJBAGM2BAUwBk+22U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/476] net/mlx5: DR, Use the right GVMI number for drop action
Date: Wed, 21 Feb 2024 14:01:48 +0100
Message-ID: <20240221130010.038840626@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 897c7f852123..380e3294df43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -579,6 +579,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		switch (action_type) {
 		case DR_ACTION_TYP_DROP:
 			attr.final_icm_addr = nic_dmn->drop_icm_addr;
+			attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
 			break;
 		case DR_ACTION_TYP_FT:
 			dest_action = action;
-- 
2.43.0



