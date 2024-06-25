Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599AC24B34;
	Tue, 25 Jun 2024 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309186; cv=none; b=ipfaftI8jP34froDRhstGuEacl2U4N/bVVD5OWAC1ut07czjpekfZnmUwSeUAsugqtG2/jwRCunQmCiUqjnpgs6i/Q1fJoE75FTn81DlKCJ+PwkvK6p65UwiyUi80abLUwxYLqsievY9A/J9VGU3AaTA1pfuiiAadeNdw1X+Zmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309186; c=relaxed/simple;
	bh=T/lf7iESDMJYOGgYG7oVhfitE0dOydlmppeTScdfXRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay5+WL2LqqW4T3d4nzFXPa2ygj0GlBrlPwb4JqKSFejatzDsnNyJJXycbnfgwoz6REJEG6/AQ2EBbyBCKEwKo215+qYRLLnY50kvAwlZ97B/uVaTnXP2ZIVcgT+OLwCnsn9zCo1+nBGG8v/xOjhXWhiH4P+VcSbTjIJUpOvPMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0cYNLu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0cYNLu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4518C32781;
	Tue, 25 Jun 2024 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309186;
	bh=T/lf7iESDMJYOGgYG7oVhfitE0dOydlmppeTScdfXRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0cYNLu+j4/xWsmVhiOPA4CewEgmi2Xl3ixHVo/Bk5I/Fdt7Vnhiol+Ham/bajlM/
	 jTuadFPOn+S7i30/7DkJVCnLLS090KmqArUZvtHYW8Dy6FMT9SOym11DDhpNL21XkA
	 Fx9/pv6x3Z+I2UbfpvdQAo3RvH2EeA7wHDTwUlfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/192] RDMA/mlx5: Fix unwind flow as part of mlx5_ib_stage_init_init
Date: Tue, 25 Jun 2024 11:33:17 +0200
Message-ID: <20240625085541.964890090@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 81497c148b7a2e4a4fbda93aee585439f7323e2e ]

Fix unwind flow as part of mlx5_ib_stage_init_init to use the correct
goto upon an error.

Fixes: 758ce14aee82 ("RDMA/mlx5: Implement MACsec gid addition and deletion")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Link: https://lore.kernel.org/r/aa40615116eda14ec9eca21d52017d632ea89188.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 102ead497196c..45a497c0258b3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3732,10 +3732,10 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	spin_lock_init(&dev->dm.lock);
 	dev->dm.dev = mdev;
 	return 0;
-err:
-	mlx5r_macsec_dealloc_gids(dev);
 err_mp:
 	mlx5_ib_cleanup_multiport_master(dev);
+err:
+	mlx5r_macsec_dealloc_gids(dev);
 	return err;
 }
 
-- 
2.43.0



