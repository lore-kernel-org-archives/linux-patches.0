Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC28F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB47C433D2;
	Mon, 13 Feb 2023 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300072;
	bh=SWX+N8cAuYw+iAUceW6dSqyWtMr7scDDktTVDtA4gjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD+OY/FfPdTa9mZz0kT/HqlNbYYe9UDZDZrTYZzynkga1BeMwsbZ6G8mHEWjH8cic
	 kXtKY063ei6J7yLej/WUYxA+CSdkoc7/hJXO9L5b3hQD3RyjZhX5cVgVScCB9A3oz1
	 qel1zWJrakJDF6z2r5QxpKDu1HO09y8BtI8doK+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/114] net/mlx5: Serialize module cleanup with reload and remove
Date: Mon, 13 Feb 2023 15:48:08 +0100
Message-Id: <20230213144744.964636922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 8f0d1451ecf7b3bd5a06ffc866c753d0f3ab4683 ]

Currently, remove and reload flows can run in parallel to module cleanup.
This design is error prone. For example: aux_drivers callbacks are called
from both cleanup and remove flows with different lockings, which can
cause a deadlock[1].
Hence, serialize module cleanup with reload and remove.

[1]
       cleanup                        remove
       -------                        ------
   auxiliary_driver_unregister();
                                     devl_lock()
                                      auxiliary_device_delete(mlx5e_aux)
    device_lock(mlx5e_aux)
     devl_lock()
                                       device_lock(mlx5e_aux)

Fixes: 912cebf420c2 ("net/mlx5e: Connect ethernet part to auxiliary bus")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d4db1adae3e3d..f07175549a87d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -2094,7 +2094,7 @@ static int __init mlx5_init(void)
 	mlx5_core_verify_params();
 	mlx5_register_debugfs();
 
-	err = pci_register_driver(&mlx5_core_driver);
+	err = mlx5e_init();
 	if (err)
 		goto err_debug;
 
@@ -2102,16 +2102,16 @@ static int __init mlx5_init(void)
 	if (err)
 		goto err_sf;
 
-	err = mlx5e_init();
+	err = pci_register_driver(&mlx5_core_driver);
 	if (err)
-		goto err_en;
+		goto err_pci;
 
 	return 0;
 
-err_en:
+err_pci:
 	mlx5_sf_driver_unregister();
 err_sf:
-	pci_unregister_driver(&mlx5_core_driver);
+	mlx5e_cleanup();
 err_debug:
 	mlx5_unregister_debugfs();
 	return err;
@@ -2119,9 +2119,9 @@ static int __init mlx5_init(void)
 
 static void __exit mlx5_cleanup(void)
 {
-	mlx5e_cleanup();
-	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
+	mlx5_sf_driver_unregister();
+	mlx5e_cleanup();
 	mlx5_unregister_debugfs();
 }
 
-- 
2.39.0



