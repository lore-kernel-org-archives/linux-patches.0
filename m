Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F84212C46D;
	Tue, 30 Apr 2024 10:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474085; cv=none; b=OknrJUFlZXRNE3kl12Jvzl4gQpzMvBQLIZNkliw5kuqgqDFZVccgWXx7rR45z4Ij3zughhEDPCB3QhhLmZbtfqKJBdwPvaklSoRHBwl48jdUGhwLvMbD9phMoAnlCPBGleLMMaBoIQAn78cbzD0MU+xqIWzi1mNrs6xVxhMMugA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474085; c=relaxed/simple;
	bh=xHPxUBCryXvurBPQd8a9blCGZph+jAi2dxENZnavGUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxnOqqFgx5VYtbQiqBzC+Ftjh3yB9VaQ85KcLeomNXZgCLZwHZ9JjkLC+0FuFmAjUOcIf/aE+WlBPAlUb6r/yJ1YVaFKFTiLAObl3hiMcsPY4MDwCfnaIPCfB0YvV84mEcKXxK6/MGN4VNeRtX9k7OptOjrZdfW0UrYoWdWHmHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tiJQSzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tiJQSzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64487C2BBFC;
	Tue, 30 Apr 2024 10:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474085;
	bh=xHPxUBCryXvurBPQd8a9blCGZph+jAi2dxENZnavGUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tiJQSzI05eq8dZ+k/2nGwRDnt1lxuYM3qqP2iRQpD34PY3E6XXQOsn1mmkIOf2WH
	 o+UbZZYDR8Jl/Si34RWrtX8pwdYb0EqcnbJBUoyfmTClfW5S7OO5x1y4ovL6UvPOe0
	 ErhJ0NBagvW6fSUcFeR3FQwOFR0RQvhBFpLvknPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim mithro Ansell <me@mith.ro>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 052/228] mlxsw: core_env: Fix driver initialization with old firmware
Date: Tue, 30 Apr 2024 12:37:10 +0200
Message-ID: <20240430103105.313437839@linuxfoundation.org>
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

[ Upstream commit 7e2050a8366315aeaf0316b3d362e67cf58f3ea8 ]

The driver queries the Management Capabilities Mask (MCAM) register
during initialization to understand if it can read up to 128 bytes from
transceiver modules.

However, not all firmware versions support this register, leading to the
driver failing to load.

Fix by treating an error in the register query as an indication that the
feature is not supported.

Fixes: 1f4aea1f72da ("mlxsw: core_env: Read transceiver module EEPROM in 128 bytes chunks")
Reported-by: Tim 'mithro' Ansell <me@mith.ro>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/0afa8b2e8bac178f5f88211344429176dcc72281.1713446092.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 53b150b7ae4e7..6c06b05927608 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -1357,24 +1357,20 @@ static struct mlxsw_linecards_event_ops mlxsw_env_event_ops = {
 	.got_inactive = mlxsw_env_got_inactive,
 };
 
-static int mlxsw_env_max_module_eeprom_len_query(struct mlxsw_env *mlxsw_env)
+static void mlxsw_env_max_module_eeprom_len_query(struct mlxsw_env *mlxsw_env)
 {
 	char mcam_pl[MLXSW_REG_MCAM_LEN];
-	bool mcia_128b_supported;
+	bool mcia_128b_supported = false;
 	int err;
 
 	mlxsw_reg_mcam_pack(mcam_pl,
 			    MLXSW_REG_MCAM_FEATURE_GROUP_ENHANCED_FEATURES);
 	err = mlxsw_reg_query(mlxsw_env->core, MLXSW_REG(mcam), mcam_pl);
-	if (err)
-		return err;
-
-	mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_MCIA_128B,
-			      &mcia_128b_supported);
+	if (!err)
+		mlxsw_reg_mcam_unpack(mcam_pl, MLXSW_REG_MCAM_MCIA_128B,
+				      &mcia_128b_supported);
 
 	mlxsw_env->max_eeprom_len = mcia_128b_supported ? 128 : 48;
-
-	return 0;
 }
 
 int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
@@ -1445,15 +1441,11 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		goto err_type_set;
 
-	err = mlxsw_env_max_module_eeprom_len_query(env);
-	if (err)
-		goto err_eeprom_len_query;
-
+	mlxsw_env_max_module_eeprom_len_query(env);
 	env->line_cards[0]->active = true;
 
 	return 0;
 
-err_eeprom_len_query:
 err_type_set:
 	mlxsw_env_module_event_disable(env, 0);
 err_mlxsw_env_module_event_enable:
-- 
2.43.0



