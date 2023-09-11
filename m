Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC8611706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBC5C433C9;
	Mon, 11 Sep 2023 14:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443758;
	bh=Pi6FkcHoFrSfjBd1SCXu8xblxa6wlYEWEcvUf4WiXYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRZatp9dcDNrVDXDEexRzjpDnvnAU8uCiRjZjkz5E9eFaxhcbDD0/ryF6y6SaZEuW
	 vgIfG94nvxn95S5BXDqefWWt97QlePf9TfdkGPfp6SBB1egWx0gKoMNVRuV5fqnwag
	 GIeWWaFhn7967m8s7EM2Wmsl/4Fcw7CpQtDnmX1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Simon Horman <simon.horman@corigine.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 458/737] net/mlx5: Use RMW accessors for changing LNKCTL
Date: Mon, 11 Sep 2023 15:45:17 +0200
Message-ID: <20230911134703.390470382@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 30de872537bda526664d7a20b646adfb3e7ce6e6 ]

Don't assume that only the driver would be accessing LNKCTL of the upstream
bridge. ASPM policy changes can trigger write to LNKCTL outside of driver's
control.

Use RMW capability accessors which do proper locking to avoid losing
concurrent updates to the register value.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
Link: https://lore.kernel.org/r/20230717120503.15276-8-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 50022e7565f14..f202150a5093c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -332,16 +332,11 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 		pci_cfg_access_lock(sdev);
 	}
 	/* PCI link toggle */
-	err = pci_read_config_word(bridge, cap + PCI_EXP_LNKCTL, &reg16);
-	if (err)
-		return err;
-	reg16 |= PCI_EXP_LNKCTL_LD;
-	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	err = pcie_capability_set_word(bridge, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
 	if (err)
 		return err;
 	msleep(500);
-	reg16 &= ~PCI_EXP_LNKCTL_LD;
-	err = pci_write_config_word(bridge, cap + PCI_EXP_LNKCTL, reg16);
+	err = pcie_capability_clear_word(bridge, PCI_EXP_LNKCTL, PCI_EXP_LNKCTL_LD);
 	if (err)
 		return err;
 
-- 
2.40.1



