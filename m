Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262652BD02A;
	Wed,  4 Feb 2026 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218958; cv=none; b=tuTXaZwwXcCA7qoT4LDJz28mPwGUOnPjhmqqDdZpBFTMHM86Hy34xCMd7FviHAQp6DJIoAS26krbyeoRiiMNw3sIqU7QnG/g3Y2CQ2CwsPwXtU3bf4xO3oiq6UJG1tev4QeECiikEIo4D2SRQt0I/d9JrL5ZixYw+NGRuxNHg+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218958; c=relaxed/simple;
	bh=eyp1pEctYUKnMU7gJNTGNbjLx6U5Q5QlLC4lNbm8x4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsWdAe7+BTXghCsuMxGJkqnTT8/AOucfkXTzxIorSHxF3KLL+uj/dUQwwGz8cTPbkwPWs6/62L1OH9e/9XD8HW9k1ydPFKI0ZkZ0rmWB/DrwjvalShIJ04DXN44GCW8tInoAPF7PoxeCcswnHuYez8+XWWx1kAbH8tHrlmDGTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6J4PQT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6J4PQT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF8CC4CEF7;
	Wed,  4 Feb 2026 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218958;
	bh=eyp1pEctYUKnMU7gJNTGNbjLx6U5Q5QlLC4lNbm8x4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6J4PQT1zCHoEk+bZjSJtwwcclD7mt6J744XtJEYbnWx+O5JS1cSFzRpJU6UVX8+z
	 dxbVITz8FpSySmDoBssLQ1bVOlf1QRLz263dVLDe9D56W8OEdhSfbBo3ekoaYht3I4
	 t8Hs7fmfR3iJNr6vft4erBsDP6q2dlHD60VT6OoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/122] net/mlx5: Fix memory leak in esw_acl_ingress_lgcy_setup()
Date: Wed,  4 Feb 2026 15:39:48 +0100
Message-ID: <20260204143852.092831869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 108948f723b13874b7ebf6b3f1cc598a7de38622 ]

In esw_acl_ingress_lgcy_setup(), if esw_acl_table_create() fails,
the function returns directly without releasing the previously
created counter, leading to a memory leak.

Fix this by jumping to the out label instead of returning directly,
which aligns with the error handling logic of other paths in this
function.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 07bab9502641 ("net/mlx5: E-Switch, Refactor eswitch ingress acl codes")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260120134640.2717808-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 1c37098e09ea5..49a637829c594 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -188,7 +188,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		if (IS_ERR(vport->ingress.acl)) {
 			err = PTR_ERR(vport->ingress.acl);
 			vport->ingress.acl = NULL;
-			return err;
+			goto out;
 		}
 
 		err = esw_acl_ingress_lgcy_groups_create(esw, vport);
-- 
2.51.0



