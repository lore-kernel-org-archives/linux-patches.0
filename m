Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624813;
	b=Hb4vuBtlPPfFrbjR7NnBnmAYtIH0uz3zlw5yc/rQWEpZYqMGuM/7tZl1BCibCV6d+WJ1
	 gypvdEx76xY6oL7fo4mj37yarn79EzqZfpoAFgKkvQ1VMJAKoSvmEcpMZvpedlVUy+ong
	 U6DckNbdBAA2YmTid8kS7gJMIjHl5lE2Ztsg2TAv//UJrgv5ztLwabCxdKTGDTz89CF7j
	 O/9uGwofyt1x4YNBMP67AnRk/Q+i9bfaT7+NsLcS1ScaPwRrDdD7oRmoHQukdE9LNmOqC
	 0MCKGu3T+zDa2Mg84CDLA0QW8MrkfGfgXIegj8Us8X9zqxyeoFtmyG4oWu2zWwiNc6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pc6pYcZbYXYzN1/aINRQINMrkacZUp4zDnpgnUxEcZE=;
	b=EeWGW5xp7YPPSu8vTGb6qBuLmHE7VHCuzYosPfTDVM3HMDh7BOJgPFmGxineE/Ro+QGq
	 h1bKDBe43LooY2UUiI6xjykWpRZbD11tkKu3AnlIyUbzV257VJ4g4B5IL8YTdNNlQCgn2
	 H1Sq0VI+19OrNlGDlvHOYaQl0NLvCys9/maq6Faa0WiE7+PyZ+vs9VvLrxc9dFv77aTwe
	 hq2t7pM1sqrKUSPDHwJMw202O4cNk9Mg51XgfB/nX/eYI+XVlBRZP6cf/KP8fK6ENyb6Z
	 4L93dzCxDii/aHLuTzOnNGoZAI9n4fV9PyDYfK+yDkeCasfDfDvm1TzwpaujxtEA9mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Plpcbcd4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6222606A33A;
	Wed, 25 Nov 2026 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Plpcbcd4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1581F000D2;
	Wed, 25 Nov 2026 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624812;
	bh=pc6pYcZbYXYzN1/aINRQINMrkacZUp4zDnpgnUxEcZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Plpcbcd4Cux9U6Wabev5OH/jAnznn3qhsFohCbHMNHHFrYMeI+Y1D5SDFq/gkhjg+
	 7rBXRFMrcfHFVKWEO8B7ajaM8Qjno4KZbt1kpGtL9tYx3IyzuUpgfHMbi7ISMk1wpv
	 /ezBkTiUFWqyRp4bFhDxStY3/ue7Tm4+qLVb0EdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/816] net/mlx5: Lag, free steering resources on LAG destroy failure
Date: Wed, 25 Nov 2026 15:31:01 +0100
Message-ID: <20261125143856.444634493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit deceb70d1303105e4368a19b251a6fd94428eb11 ]

When firmware fails to destroy LAG, driver returns before releasing the
steering resources, leaking the associated software objects.

The bond is no longer eligible for offload, and the driver cannot
prevent its teardown. Release the steering resources even if LAG
destruction fails. Preserve the error logging and return the original
error after cleanup.

Fixes: da6b0bb0fc73 ("net/mlx5: Lag, use steering to select the affinity port in LAG")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104183947.772195-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index f055aac1b436a..dd0da4081bad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -734,7 +734,6 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
-		return err;
 	}
 
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
@@ -744,7 +743,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-	return 0;
+	return err;
 }
 
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
-- 
2.53.0



