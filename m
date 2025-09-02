Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9852A30F536;
	Tue,  2 Sep 2025 13:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820663; cv=none; b=sT8k5V1+eFd87DpjUq+k7wCe0Er/j6VmQuaEf4i0UbphowBKVYflWOfK6TETuiu92CZwLyQVKUe+hyCa6eGr0jszEP7rpAm2Z1ANZk/YCW2EKBdr8n/yS9lb2Aaiuwyd7QI9ChSnCWYhMuVfSgB6FpZITCKZyLt17Z7/qQWBAxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820663; c=relaxed/simple;
	bh=hzluJtK00TX5D7zn46ulDF3i8QdSXNNh0BgVT/0qfXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2RjCx8Rs3UzcTYdhhl48PTXQwNPsvQ5yaTAix4l8Unm/rjvbfBxZgyb4uVGYcTdJxuPvazHSyEoqa0Zev1mTBQN0e/PsOPKrpp5viOI1oHASys11mu22IJ3zBrnnH/IPKKw9H+NeO4T7SYVAwl7YUkI2rzxhzMx7nHRLqgHNKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DG9Y4hWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DG9Y4hWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001CDC4CEF7;
	Tue,  2 Sep 2025 13:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820663;
	bh=hzluJtK00TX5D7zn46ulDF3i8QdSXNNh0BgVT/0qfXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DG9Y4hWdPOmm+Pg7xIj2Q7E07uJ9HWRiJKnU4QfrJN2bV0P6zuVNr7zgrYI7N+wKW
	 s3oJ9EwLg8KlKG4gqx1dDAd9nBosyu71CwVY4bZ8dKiClbRVW6yyq9f0RZB5EqF7KP
	 qlN8+bk23B79uQv9GbSLkMumk8/GwlHu7vaEMhLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/34] net/mlx5e: Set local Xoff after FW update
Date: Tue,  2 Sep 2025 15:21:41 +0200
Message-ID: <20250902131927.225147867@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit aca0c31af61e0d5cf1675a0cbd29460b95ae693c ]

The local Xoff value is being set before the firmware (FW) update.
In case of a failure where the FW is not updated with the new value,
there is no fallback to the previous value.
Update the local Xoff value after the FW has been successfully set.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-12-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index c9d5d8d93994d..7899a7230299d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -346,7 +346,6 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 	}
-	priv->dcbx.xoff = xoff;
 
 	/* Apply the settings */
 	if (update_buffer) {
@@ -355,6 +354,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 			return err;
 	}
 
+	priv->dcbx.xoff = xoff;
+
 	if (update_prio2buffer)
 		err = mlx5e_port_set_priority2buffer(priv->mdev, prio2buffer);
 
-- 
2.50.1



