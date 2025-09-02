Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669441EA7DB;
	Tue,  2 Sep 2025 13:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820274; cv=none; b=DcUw4Vawt4AoPQ/vhrr5Tp2KoYK1x5PpaS7OKgrMN0YlG/W0p30HCe+CfnM5HGoQx8ObegEORK012Yd5Elr1AAt1KOOCUdaYugJFAlyN0f84jgNX3MfiD+8oyhYW1jrmoPGNgJ9NxAKMyC7BsBa+Zhb3F6QW+90kAE+8tLxB+ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820274; c=relaxed/simple;
	bh=oy/d6RNr67SzE7dw4uDNwfmDvhDsujTwHPjvE68uR2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HARceKuIENOtYXr5qXUt4qh7NiNzP4huK9hCU4mFWAIYOaxsYomZlURyMm5Yz6OwdymhyOq0apW8vWyCRBFM1vnZ96FhLducV8dgErHPrLKKrRFz6Dfba0h4fkK9LwYdt2tEvxZZsYO5mg5yW7r3sSv7k4n5hEdhwLKrq3/W16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGkQjyHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGkQjyHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE37C4CEED;
	Tue,  2 Sep 2025 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820274;
	bh=oy/d6RNr67SzE7dw4uDNwfmDvhDsujTwHPjvE68uR2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGkQjyHBbQYKUhRvbuLFtWG/FcnUSzQ7iS+fpbBDUt4Fg8Ra9RYzKm8ApJvjcx7fs
	 uq+Df84YicOc6sVmaKxEvVt5URmMEdDxu80BEV6DDf/Nv1XZoFzLKxOsG5GZ+5Ew3a
	 QUob/aN4Ek3XeuZ7LaO1j5JGB5S7kpyIE2ZP1UOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 36/75] net/mlx5: Reload auxiliary drivers on fw_activate
Date: Tue,  2 Sep 2025 15:20:48 +0200
Message-ID: <20250902131936.540317004@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 34cc6a54914f478c93e176450fae6313404f9f74 ]

The devlink reload fw_activate command performs firmware activation
followed by driver reload, while devlink reload driver_reinit triggers
only driver reload. However, the driver reload logic differs between the
two modes, as on driver_reinit mode mlx5 also reloads auxiliary drivers,
while in fw_activate mode the auxiliary drivers are suspended where
applicable.

Additionally, following the cited commit, if the device has multiple PFs,
the behavior during fw_activate may vary between PFs: one PF may suspend
auxiliary drivers, while another reloads them.

Align devlink dev reload fw_activate behavior with devlink dev reload
driver_reinit, to reload all auxiliary drivers.

Fixes: 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in case of PCI device suspend")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250825143435.598584-6-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f66788a2ed77e..f2d1f7cad7e72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -107,7 +107,7 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	mlx5_unload_one_devl_locked(dev, true);
+	mlx5_unload_one_devl_locked(dev, false);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
-- 
2.50.1



