Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E725D2D4B4E;
	Tue,  2 Sep 2025 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820772; cv=none; b=QKyXHrHq8ia30PZ6KTx+UgiCIH8whLAppWd9p00m5z6F1fukJGuudCJtV2y+/V8+3DlE0xnn1qQp+4eUa1BL5i7krMFM88k5jHWhxXkoWMH+7kNmPPi0uZ8/6jJ5hpOU70iA4qONlZml/UISlk7DmKwZlZJOTV8lud3Wln0fDyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820772; c=relaxed/simple;
	bh=yJ1Hi7Szz90FfCRlN3oBNPLqB/9Ilh8dGSfwPgZD7Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJgcz2O0drZZCfgF9G2rE5ig/JrqYrIUHPVFZlUO8z2ILodMQnpJcnDJ37aYzkEFKhqtgFMvSlJm7n++zmeGo6+vaXzJ3GfRs96D+tI4iOYQOx3eQLxEgeQomBcgWd6vgAh+vdr4EwQy6YscZDlVSbo1gu8758BbfhqSLeChNw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUI6jxFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUI6jxFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E99C4CEED;
	Tue,  2 Sep 2025 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820771;
	bh=yJ1Hi7Szz90FfCRlN3oBNPLqB/9Ilh8dGSfwPgZD7Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUI6jxFvqLucm0IyjZkmUJxs4H8iihWv0KgHxXkuN8gI8Sm2FItZlgb61O1nXNnGm
	 pZfFem5G8tR+mx7RJJfwVt2kATxhc+2JRBc117drlQkh4L//R4CU4Rr9iA3p/CJgXO
	 m1Vz+dw2n7lxyKhAWzjyTxCnwGegMP0e2yfcuN6M=
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
Subject: [PATCH 5.4 13/23] net/mlx5e: Set local Xoff after FW update
Date: Tue,  2 Sep 2025 15:21:59 +0200
Message-ID: <20250902131925.255640045@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 99c7cdd0404a5..44d3d6826f696 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -341,7 +341,6 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 		if (err)
 			return err;
 	}
-	priv->dcbx.xoff = xoff;
 
 	/* Apply the settings */
 	if (update_buffer) {
@@ -350,6 +349,8 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 			return err;
 	}
 
+	priv->dcbx.xoff = xoff;
+
 	if (update_prio2buffer)
 		err = mlx5e_port_set_priority2buffer(priv->mdev, prio2buffer);
 
-- 
2.50.1



