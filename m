Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533458BEB;
	Sat, 30 Dec 2023 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze9hdjk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13FDC433C8;
	Sat, 30 Dec 2023 12:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937728;
	bh=8nUuxXN2Dg4B+egj8mtxZ+VJRsBhRhfEaTgCF2LQnCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ze9hdjk9QnHcMjODHh67/TCWAC9MnRqrTHcOKwH5yygDAa/ObL+c7Xg3jtJbS3VjI
	 QT+HVZLdSD7fp2qTirTY++BVZ651IdKpJepLJGZArarQdtQvT+sbad2XjpFzje1BEL
	 JadNouqgZvkeEynm73KU0JuNs5MKzNkkTPT5s3Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/156] net/mlx5e: Fix error code in mlx5e_tc_action_miss_mapping_get()
Date: Sat, 30 Dec 2023 11:58:14 +0000
Message-ID: <20231230115813.671860349@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 86d5922679f3b6d02a64df66cdd777fdd4ea5c0d ]

Preserve the error code if esw_add_restore_rule() fails.  Don't return
success.

Fixes: 6702782845a5 ("net/mlx5e: TC, Set CT miss to the specific ct action instance")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1bead98f73bf5..2cfbacf77535c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5734,8 +5734,10 @@ int mlx5e_tc_action_miss_mapping_get(struct mlx5e_priv *priv, struct mlx5_flow_a
 
 	esw = priv->mdev->priv.eswitch;
 	attr->act_id_restore_rule = esw_add_restore_rule(esw, *act_miss_mapping);
-	if (IS_ERR(attr->act_id_restore_rule))
+	if (IS_ERR(attr->act_id_restore_rule)) {
+		err = PTR_ERR(attr->act_id_restore_rule);
 		goto err_rule;
+	}
 
 	return 0;
 
-- 
2.43.0



