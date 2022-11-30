Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B0779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AFEC433C1;
	Wed, 30 Nov 2022 18:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833426;
	bh=Ai+hrzc4H3xvMo4LJ7DdggybVsdLD6CWXVRNfhZ3qWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOGyzDJ2Bbj+bJOfD/qcTy8jjoRgctQpArpDvHXQSGvOUC+dUrg/rdm9ewAvCuQHj
	 NLrt4V7Q45Dh4miavNva2Z+KN+UOfzp2F4g1arGWxo8N5lPyf8baN5+J5pmBO5eQ/4
	 TX/Onudr4lh6ySCI5ETr32+SPbGgSiD5frfPCixU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Novich <royno@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/206] net/mlx5: Do not query pci info while pci disabled
Date: Wed, 30 Nov 2022 19:22:33 +0100
Message-Id: <20221130180535.618169897@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roy Novich <royno@nvidia.com>

[ Upstream commit 394164f9d5a3020a7fd719d228386d48d544ec67 ]

The driver should not interact with PCI while PCI is disabled. Trying to
do so may result in being unable to get vital signs during PCI reset,
driver gets timed out and fails to recover.

Fixes: fad1783a6d66 ("net/mlx5: Print more info on pci error handlers")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d092261e96c3..19c11d33f4b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1608,7 +1608,8 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
 
-	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, res, result2str(res));
 	return res;
 }
 
@@ -1647,7 +1648,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_pci_trace(dev, "Enter\n");
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Enter\n",
+		       __func__, dev->state, dev->pci_status);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
@@ -1669,7 +1671,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 
 	res = PCI_ERS_RESULT_RECOVERED;
 out:
-	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, err = %d, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, err, res, result2str(res));
 	return res;
 }
 
-- 
2.35.1



