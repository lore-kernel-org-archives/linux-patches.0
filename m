Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE58306D53;
	Tue,  2 Sep 2025 13:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819599; cv=none; b=cevLNTLxnKl9buSYPOchc7cy3lEaYm2F4Nyq0bJw+ovTfNGCvH9Q/M1eEIgDOx3CvWCZ8GCeR7ES8qdlejx2sn6NmCg52K0ABrW6Gs8dwfP1ReuK+Bb1Yngma//ChIEZxXlnpuDnsXxn/OjVW6MEAw1zoYW4Kug0A+30sl/nFe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819599; c=relaxed/simple;
	bh=vuScQYnPhuJ9vrFiJk5qzBPI2J/6jmCmOmf8JC2V8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I94sf4vnRq9s+ySarTEjgxlteUTWSfuLU0IYVWgBxgayjzChGeVZkaH+33jW3Icfajqghr3RxLRGJbE7QQQ5vRQLV2SDsv33pdjz+1uqoFq3czXPbRnN7RKONypbU+v37QuozvYNq26uxlJGy0y72wtwg16pm/dYxS0Y4v9ATE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0m5PNA8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0m5PNA8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559F3C4CEED;
	Tue,  2 Sep 2025 13:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819599;
	bh=vuScQYnPhuJ9vrFiJk5qzBPI2J/6jmCmOmf8JC2V8XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0m5PNA8GqKVKa1VJ/zXqv5lVeEKQpRpCBPYkX5Od8nMNRfzdYfdt9eZXRRYUkhn1C
	 on2QwfH8UqoLQiZEs2KC9hIfy+5MiSHM/c85lzPJtcXWcejbv/q3XC0KMxlvMCY4Fm
	 a9vn5Nnl0NKFzBz9zt1sFVKpBQqmbHJiny8BKUA0=
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
Subject: [PATCH 6.16 082/142] net/mlx5: Reload auxiliary drivers on fw_activate
Date: Tue,  2 Sep 2025 15:19:44 +0200
Message-ID: <20250902131951.407966267@linuxfoundation.org>
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
index 73cd746443788..42c70862095e9 100644
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



