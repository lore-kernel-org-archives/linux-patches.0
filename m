Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0342834BA22;
	Tue,  6 Jan 2026 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719975; cv=none; b=SjHEcyD0ZN/4gsNDYAIUpeO2xl+EVG5vOHBkg2b5ZkVkpDS3gGNHlJMHbzzNIR7ZRr49nsh66WlHJSv2L9Ye8XyKuGJEttkfgvmv9RAIuxFkbL68/+uCrDEHh35rdlZQzKTu7JiUmazJ4FwoiItTzqDf5ClRnW32FAkb/nc9NkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719975; c=relaxed/simple;
	bh=44kAaZgbAsY8huVv8W9qCtUCmOul0L2QtVmno65vlr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COCx5IafZw0UfbxcUnz+HcBt8Zz8mmb6i0Y22ceH3svG9t/xRfaiSiRs9e3tL+ou35zknvJjk1e6TtXacG+4HLN+h8eDVx/LVkK08nlDcBTEph1V+gdlHf4l8c9C6P4euUZtg+Rv0PR4N7KUTS+0/PoO5I2Lfy8Ca3uQ3dP3FoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQbsa6P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQbsa6P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C48C116C6;
	Tue,  6 Jan 2026 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719974;
	bh=44kAaZgbAsY8huVv8W9qCtUCmOul0L2QtVmno65vlr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQbsa6P1osYLSHMko3QPjw1DGCIqE1Ju1CCYFU17zmdGlHaCdroi97CXCLBHxFDgK
	 fy3tOhsdjtk2r1IfoYRrt3OShyD9RuUVg3vRw02rtMJcJboqfTQ+o617teaK3jhpui
	 +QKT2Drt0Bab2U0O6J+oJ2eSFyBOrMyZGOBpYnmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/567] net/mlx5: Drain firmware reset in shutdown callback
Date: Tue,  6 Jan 2026 17:57:31 +0100
Message-ID: <20260106170453.888424230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 5846a365fc6476b02d6766963cf0985520f0385f ]

Invoke drain_fw_reset() in the shutdown callback to ensure all
firmware reset handling is completed before shutdown proceeds.

Fixes: 16d42d313350 ("net/mlx5: Drain fw_reset when removing device")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1765284977-1363052-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 11d8739b9497a..e97b3494b9161 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2196,6 +2196,7 @@ static void shutdown(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "Shutdown was called\n");
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-- 
2.51.0



