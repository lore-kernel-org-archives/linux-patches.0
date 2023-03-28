Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035218BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CCCC433EF;
	Tue, 28 Mar 2023 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015488;
	bh=LIci1sEodLQcOY8bE5V5xQxaWohW8aP85+rhhznkQIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqvJs5Tz25Dpxtr/o2ZjrLotX6R2em4zdO/XVvIU+sNo4ZC2cbk73j+lms8KHjHoB
	 E3SNdPp3MsSWAFqOeGIgy0kSuVufrnFxCrqMJAeQZ1wcmewY1Of1fCkUycBZdxcLuw
	 37dTTze1NEZb/mWLbO0KBKl3l1JLNx0RB6M7At2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emeel Hakim <ehakim@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Raed Salem <raeds@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/224] net/mlx5e: Overcome slow response for first macsec ASO WQE
Date: Tue, 28 Mar 2023 16:41:03 +0200
Message-Id: <20230328142620.143690217@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit 7e3fce82d945cf6e7f99034b113ff2d250d7524d ]

First ASO WQE poll causes a cache miss in hardware hence the resut is
delayed. It causes to the situation where such WQE is polled earlier
than it is needed.

Add logic to retry ASO CQ polling operation.

Fixes: 739cfa34518e ("net/mlx5: Make ASO poll CQ usable in atomic context") 
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 0c23340bfcc75..0f8f3ce35537d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1412,6 +1412,7 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	struct mlx5e_macsec_aso *aso;
 	struct mlx5_aso_wqe *aso_wqe;
 	struct mlx5_aso *maso;
+	unsigned long expires;
 	int err;
 
 	aso = &macsec->aso;
@@ -1425,7 +1426,13 @@ static int macsec_aso_query(struct mlx5_core_dev *mdev, struct mlx5e_macsec *mac
 	macsec_aso_build_wqe_ctrl_seg(aso, &aso_wqe->aso_ctrl, NULL);
 
 	mlx5_aso_post_wqe(maso, false, &aso_wqe->ctrl);
-	err = mlx5_aso_poll_cq(maso, false);
+	expires = jiffies + msecs_to_jiffies(10);
+	do {
+		err = mlx5_aso_poll_cq(maso, false);
+		if (err)
+			usleep_range(2, 10);
+	} while (err && time_is_after_jiffies(expires));
+
 	if (err)
 		goto err_out;
 
-- 
2.39.2



