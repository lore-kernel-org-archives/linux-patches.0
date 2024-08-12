Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4AA183CD4;
	Mon, 12 Aug 2024 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480048; cv=none; b=JaTUt369nXJv6cynGxJ7RK4OxqCYINR/Hziw9G4dTMsPxFGlqtatKMFrB9Il9rID/pDIzH3ObcQ22orJ0RTFwbEeaVcW5KpshKdnx6mSz/7O/FbLPR66EDO4hGgOLt8/iEKijEK1R4GY8BifzCn9G0VPOfU07AUVIFnkBenkJOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480048; c=relaxed/simple;
	bh=ie4TIhnuZfbw2Toyovfd0uilNHDmH8XTSzzu557rurk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqoZAXp/G6VvkA0iSy+OWJE0NJHy8JhgqIbdrfG6ElEIs3wQk+wBV4ifgGVPFKSgR7T+Blf7TgBMqgD9BXy2Pr0HH0zxPcNh7fUZ0p4BRrA8Jm01Nv8zGoY8xS1nxmtAw5wf8dOvFnZZjJxx9b2rmyISAWCMhX6QOaMeIGmofTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEGCvLpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEGCvLpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0C3C4AF0C;
	Mon, 12 Aug 2024 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480048;
	bh=ie4TIhnuZfbw2Toyovfd0uilNHDmH8XTSzzu557rurk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEGCvLpelyTSNspkGFEmbY/JgYt9J5xxckeU9+uLaG9Ny8CSCffwEgCqBNSWOtGQh
	 R24E9eMkl3OIv3pnQEDly2v1PQVkk6YvU7AJvbEkCGRKUwsyQ9pzlDplg3yycaAk21
	 gHq9Xzvfk18Dwwi4h8oElNxV7xXJzFxC2bwr1e5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 079/263] mlxsw: pci: Lock configuration space of upstream bridge during reset
Date: Mon, 12 Aug 2024 18:01:20 +0200
Message-ID: <20240812160149.569619078@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 0970836c348b6bc2ea77ce4348a136d6febfd440 ]

The driver triggers a "Secondary Bus Reset" (SBR) by calling
__pci_reset_function_locked() which asserts the SBR bit in the "Bridge
Control Register" in the configuration space of the upstream bridge for
2ms. This is done without locking the configuration space of the
upstream bridge port, allowing user space to access it concurrently.

Linux 6.11 will start warning about such unlocked resets [1][2]:

pcieport 0000:00:01.0: unlocked secondary bus reset via: pci_reset_bus_function+0x51c/0x6a0

Avoid the warning and the concurrent access by locking the configuration
space of the upstream bridge prior to the reset and unlocking it
afterwards.

[1] https://lore.kernel.org/all/171711746953.1628941.4692125082286867825.stgit@dwillia2-xfh.jf.intel.com/
[2] https://lore.kernel.org/all/20240531213150.GA610983@bhelgaas/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://patch.msgid.link/9937b0afdb50f2f2825945393c94c093c04a5897.1720447210.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index c0ced4d315f3d..d92f640bae575 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1599,6 +1599,7 @@ static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci,
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	char mrsr_pl[MLXSW_REG_MRSR_LEN];
+	struct pci_dev *bridge;
 	int err;
 
 	if (!pci_reset_sbr_supported) {
@@ -1615,6 +1616,9 @@ static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci,
 sbr:
 	device_lock_assert(&pdev->dev);
 
+	bridge = pci_upstream_bridge(pdev);
+	if (bridge)
+		pci_cfg_access_lock(bridge);
 	pci_cfg_access_lock(pdev);
 	pci_save_state(pdev);
 
@@ -1624,6 +1628,8 @@ static int mlxsw_pci_reset_at_pci_disable(struct mlxsw_pci *mlxsw_pci,
 
 	pci_restore_state(pdev);
 	pci_cfg_access_unlock(pdev);
+	if (bridge)
+		pci_cfg_access_unlock(bridge);
 
 	return err;
 }
-- 
2.43.0



