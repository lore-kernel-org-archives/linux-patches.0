Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E7531DDB9;
	Tue,  2 Sep 2025 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819617; cv=none; b=r1ba77IaKOIOs7ui3VFLjVVCkL7A301/3mZZLy2FBueWCx/uz7Dp/6RLx2V9DLEovxdYQL9+A3c22QZilQAnYeNj7CPg9Ng8VcpOcFB+m3I4vygxa7nPJX4Gksa28UdNdU2zES74RYghfVtqtJneqlMh3BDgq7lzNGnZnFB7NaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819617; c=relaxed/simple;
	bh=ZQ2WdV9byjvu9YBWqgHemgWLx0XROL5HCd0d0izLS9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMyBNPyolJ6ANzv7nRGX+lboPXm7dXM+xddXWOZ5bnm9Uw9M/hHcPSdfVK1j4qqEqouXkeV0xF70M+IyflO3KfhYxKU8xUVgjyKtU1ln0jzKAhIkJzkptN4a2ojixnCO9CIzrh5KpNY5WaQCONsJClqxW1jcK2rfCWXObwyNTnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HM5mquR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HM5mquR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A29C4CEF5;
	Tue,  2 Sep 2025 13:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819617;
	bh=ZQ2WdV9byjvu9YBWqgHemgWLx0XROL5HCd0d0izLS9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HM5mquR9B9lUNvBTVF0cwsD/bm+mEvyz8fk14mhWWTM3I1jfhMQ8oIYmk5297Joqt
	 8hifOKOFWErE+6XdfUB+bTIE5HAAmWCnB+QQv1OBoOoc5DRh7YA83f4/ViRnpaRoSN
	 cBMEp5MShYtLET45rnmGk4rlWYefA1+4p2yhpPMk=
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
Subject: [PATCH 6.16 088/142] net/mlx5e: Set local Xoff after FW update
Date: Tue,  2 Sep 2025 15:19:50 +0200
Message-ID: <20250902131951.636065576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 3efa8bf1d14ef..4720523813b97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -575,7 +575,6 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 	}
-	priv->dcbx.xoff = xoff;
 
 	/* Apply the settings */
 	if (update_buffer) {
@@ -584,6 +583,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 			return err;
 	}
 
+	priv->dcbx.xoff = xoff;
+
 	if (update_prio2buffer)
 		err = mlx5e_port_set_priority2buffer(priv->mdev, prio2buffer);
 
-- 
2.50.1



