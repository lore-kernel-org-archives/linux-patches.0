Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6711279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BB5C433D6;
	Wed, 30 Nov 2022 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834034;
	bh=zll4oUZn+dvMKHBx8B0YWV5FQlSxmV/vB4eQmqejaVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NWzDn1Pv7fjA4LEe+uPwXCqKZkRrKH5RMdILL7pB4VBZx3rUUR50P/ixWd5h1NCw
	 Rl0aepXqnvIa0CoBk99+u9eiAR2OX6+pdI+80cIRmzBjMfd8FrMYkz5MPByrM9plkH
	 468FGIGjso9dh+JwM4TBLZKVkYb3Uudol+cV64KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Novich <royno@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 104/289] net/mlx5: Do not query pci info while pci disabled
Date: Wed, 30 Nov 2022 19:21:29 +0100
Message-Id: <20221130180546.497168657@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index e5e32430b6af..ac178796e484 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1759,7 +1759,8 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
 
-	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, res, result2str(res));
 	return res;
 }
 
@@ -1798,7 +1799,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_pci_trace(dev, "Enter\n");
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Enter\n",
+		       __func__, dev->state, dev->pci_status);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
@@ -1820,7 +1822,8 @@ static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 
 	res = PCI_ERS_RESULT_RECOVERED;
 out:
-	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	mlx5_core_info(dev, "%s Device state = %d pci_status: %d. Exit, err = %d, result = %d, %s\n",
+		       __func__, dev->state, dev->pci_status, err, res, result2str(res));
 	return res;
 }
 
-- 
2.35.1



