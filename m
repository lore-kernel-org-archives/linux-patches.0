Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7B8264A76;
	Tue,  8 Apr 2025 11:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110930; cv=none; b=E3DNDFC8XEfNPD5u630BS5t1m1ogmyHRlAmSEf5qOzjIS+LKyu6PpzthyljRp1A2y4W9A54HEvM/pUpN0QrAqAFUrCB/kJec26NKjSpnu7YBU8uzGvVnIoeJlZP3uVm/o/b7CPbwYTTX1bM4Fmoqgb9k6hilRuVdg0xj7bYjGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110930; c=relaxed/simple;
	bh=OwRqbm8A1YtZJb66KbnkMBqlq2e9CAaZjdUTPpV/q58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3CmsphVHnjAv6NuCnKBOKCdnQ68TdO0WJ5P+3K4FbeqX7dma/EmpYL+dNDRBxtfqx2xB3Tr8mYx5885uv4fn6SffHAA3FkgtFxZ40mSRYjolBQgBONXx5Tqw/RRG/TCOZYQaocukYMTRiVyDIPdy7wUkr1yv5Bko7+rAnK/WBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWmaGU42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWmaGU42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA04BC4CEE5;
	Tue,  8 Apr 2025 11:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110930;
	bh=OwRqbm8A1YtZJb66KbnkMBqlq2e9CAaZjdUTPpV/q58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWmaGU42/d3/Io+7799scEAsmQDDDiR7B4YgbMryM7VZBgpfHSO+NrpWVbv8NkWJc
	 ukFqcvl55anKXPR/HE5vhhcZsM10wPeJ+IO1+9/FpF2h89HktR2Skp5BVNz4VwQ3L3
	 BKDUBqUVdxKPYIaAxh68FVkDcJZYJgT6MqB76TNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 246/731] net/mlx5: LAG, reload representors on LAG creation failure
Date: Tue,  8 Apr 2025 12:42:23 +0200
Message-ID: <20250408104920.004801757@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit bdf549a7a4d738838d50833168881a0b6247446a ]

When LAG creation fails, the driver reloads the RDMA devices. If RDMA
representors are present, they should also be reloaded. This step was
missed in the cited commit.

Fixes: 598fe77df855 ("net/mlx5: Lag, Create shared FDB when in switchdev mode")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/1742331077-102038-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index ed2ba272946b9..6c9737c537348 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1052,6 +1052,10 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		if (err) {
 			if (shared_fdb || roce_lag)
 				mlx5_lag_add_devices(ldev);
+			if (shared_fdb) {
+				mlx5_ldev_for_each(i, 0, ldev)
+					mlx5_eswitch_reload_ib_reps(ldev->pf[i].dev->priv.eswitch);
+			}
 
 			return;
 		} else if (roce_lag) {
-- 
2.39.5



