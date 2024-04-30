Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C8F12C46B;
	Tue, 30 Apr 2024 10:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474088; cv=none; b=NejQ8/swyAsPPbXwecigN8/BxmLp4fMXIAhmWcDEPgPWByeW4k0MXcGaaVZtMwjIC3suXDoi81nWjilYj7+OSGpErwaIl7hTyLbvwq3sphG+hCHm3dMWSWJAmLeGG4qH0l7s5CaGJKFoQqCEBRyG+JfRdTRD+C213XGHuRI0U4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474088; c=relaxed/simple;
	bh=7RILrJCM6aSdprwvV64bwDaadOPGbKRi/Lgv++GzYL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RX5f/rL6PL/cqENUpFuH7sO3U1F1dYBW5YBagCtznVHjB5Ac67PxDiYByurxppDNh4D/SUT4klZPNa0heItluWsB1NvZWr9Bo7RTNmKUCcQdT+hzPw9gkKPNzfSgUXCP8wRRVG8QqrL8pconY2b+1JrcshjvbI8WI7dGTSKDD7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K49fB1jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K49fB1jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED769C2BBFC;
	Tue, 30 Apr 2024 10:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474088;
	bh=7RILrJCM6aSdprwvV64bwDaadOPGbKRi/Lgv++GzYL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K49fB1jyJOdTx8py6aaBPsNiSJmv8fFprcwCJWRjXZ8r1xdEMxiSfu44LgPCiDbQ3
	 e7LwPuT+2LW5qLeRP41yab9OZjjNQ7I4ygm8M1mQg6mI6s42iGWVASw/EOZkiSM/c/
	 S6rsI7TnG7U6iwibrpq4yfG8jX8hSHb2FaDHhmSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim mithro Ansell <me@mith.ro>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/228] mlxsw: pci: Fix driver initialization with old firmware
Date: Tue, 30 Apr 2024 12:37:11 +0200
Message-ID: <20240430103105.341958502@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 773501d01e6bc3f2557882a25679392d982d5f3e ]

The driver queries the Management Capabilities Mask (MCAM) register
during initialization to understand if a new and deeper reset flow is
supported.

However, not all firmware versions support this register, leading to the
driver failing to load.

Fix by treating an error in the register query as an indication that the
feature is not supported.

Fixes: f257c73e5356 ("mlxsw: pci: Add support for new reset flow")
Reported-by: Tim 'mithro' Ansell <me@mith.ro>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/ee968c49d53bac96a4c66d1b09ebbd097d81aca5.1713446092.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index af99bf17eb36d..f42a1b1c93687 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1530,7 +1530,7 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 {
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	char mcam_pl[MLXSW_REG_MCAM_LEN];
-	bool pci_reset_supported;
+	bool pci_reset_supported = false;
 	u32 sys_status;
 	int err;
 
@@ -1548,11 +1548,9 @@ mlxsw_pci_reset(struct mlxsw_pci *mlxsw_pci, const struct pci_device_id *id)
 	mlxsw_reg_mcam_pack(mcam_pl,
 			    MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES);
 	err = mlxsw_reg_query(mlxsw_pci->core, MLXSW_REG(mcam), mcam_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_PCI_RESET,
-			      &pci_reset_supported);
+	if (!err)
+		mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_PCI_RESET,
+				      &pci_reset_supported);
 
 	if (pci_reset_supported) {
 		pci_dbg(pdev, "Starting PCI reset flow\n");
-- 
2.43.0



