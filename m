Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BBB313E34;
	Mon, 13 Oct 2025 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370095; cv=none; b=ZP4dSKAikh9Dbg7TsNcDhsPfLfKa6h1qHstI29XnLOeW56aymFoFM+s/hFEEk6Ctt1AN3qvZtnkZsfMYk3JFjiQrZLhhvt7SQ9LAh/dR0X79TcZizBKjJfzvnZR+c5ZZ9gZGb1LFfopNyiWsLw/itixrb0K3HbM/rg7nqSbqtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370095; c=relaxed/simple;
	bh=azd4Er6J6cb9E1xFVWtcsws5MiAUmKqFVGZjNboSAA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2jlBeQmgly4UMVPa74HgrRi3S1jTPaFZk1iLmB2PFf9LT+4z11NRfsIkYBdgRxSXIwV36+wdXpunxFmDiwHe6cAkQcqdGQ0eHa5KRQZdCKG1MQDAfx471YCmYMU27KruKpbPnBzD0mXslxqkGLvMFvBtZTbGXMz884UGzk4xDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO+OgMVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO+OgMVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE51C4CEE7;
	Mon, 13 Oct 2025 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370095;
	bh=azd4Er6J6cb9E1xFVWtcsws5MiAUmKqFVGZjNboSAA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO+OgMVvWCPGFDzmykOxv1PckwDYmGZQFfxMu5ybuud6ZdPP6pdCdPdaE4Xyeh8+k
	 +HxrGGikdMNZsij0eibgnxhjup04jFPOE4dOnJLfKEChsVbLAECbfA5PK7XYgCne1O
	 OcKwtAvNEbj9NrQ8oj7mRe6IFoLh2YEinHoG1ikI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 476/563] net/mlx5: pagealloc: Fix reclaim race during command interface teardown
Date: Mon, 13 Oct 2025 16:45:37 +0200
Message-ID: <20251013144428.531796802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 79a0e32b32ac4e4f9e4bb22be97f371c8c116c88 ]

The reclaim_pages_cmd() function sends a command to the firmware to
reclaim pages if the command interface is active.

A race condition can occur if the command interface goes down (e.g., due
to a PCI error) while the mlx5_cmd_do() call is in flight. In this
case, mlx5_cmd_do() will return an error. The original code would
propagate this error immediately, bypassing the software-based page
reclamation logic that is supposed to run when the command interface is
down.

Fix this by checking whether mlx5_cmd_do() returns -ENXIO, which mark
that command interface is down. If this is the case, fall through to
the software reclamation path. If the command failed for any another
reason, or finished successfully, return as before.

Fixes: b898ce7bccf1 ("net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 9bc9bd83c2324..cd68c4b2c0bf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -489,9 +489,12 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	u32 func_id;
 	u32 npages;
 	u32 i = 0;
+	int err;
 
-	if (!mlx5_cmd_is_down(dev))
-		return mlx5_cmd_do(dev, in, in_size, out, out_size);
+	err = mlx5_cmd_do(dev, in, in_size, out, out_size);
+	/* If FW is gone (-ENXIO), proceed to forceful reclaim */
+	if (err != -ENXIO)
+		return err;
 
 	/* No hard feelings, we want our pages back! */
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
-- 
2.51.0



