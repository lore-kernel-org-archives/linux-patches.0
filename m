Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622036;
	b=vbtX294tVuyGN2YfPqP8R5DcFulkPXGeq5V/5QdN2DLaqADWoARnMGycMsOdcjBLOvxb
	 /t+FjmM09F9mP2n/EUrj9bB87GtwI906lSE3/yrUlEGBOkTjqujfjaZC7e3vNWlo4qOO9
	 qv0hWk2nvhYY6uciPpDktF+uYZY5QjcjJ2l53mu8++AHolTOCqdl5APki2p8D12iO4e7a
	 7dec7/aAwbdLcT4iaH1rQTMY+TgJuhV1rm2svEYfDYbtNRaBd5m27IMCmUVa6nkZC43J9
	 TwL5YDup+YPvAxnW5h/IFHvswoUZWVGbTIB774TyHa9uG7Nb014bbdwYqk8otlTJeLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RZ23mCAhjWD8cec7vVuddUfbGYDfsYZfrOEmWT9hhlE=;
	b=WJQOKRGDAbmKqa7n2mEgb9s1Bsxi9acZTtSeOTc01EZqvLpNa08OsFfpbPepS7FfrOnx
	 dj+RveDsIxdU1ycSIGvXhZUE5FplUWzR7X7nHQ5j12t+ll7rBvfzfFwcPnDZuDvBoXSp7
	 TV4rTIGbz+0vRqb9kj3xS0D8OLrwVJe+1y3goWyEBU4YrhOMP+B6fX9d1YZO165ZTxFQe
	 SXSb8PIEuS49kARIH51zAl/2d2RMeytJHXirNoDe/Ziu0VXguPMuJbYncTelrFB/1Cdqi
	 VdfOYHxCINftWIlAEOo2fmWTBjl9r6Id+lxpQUJM1BdukN8jeU2jUEC4tJ5Y2er0llQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stuvswg2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75807606A32A;
	Wed, 25 Nov 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stuvswg2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B011F000CA;
	Wed, 25 Nov 2026 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622036;
	bh=RZ23mCAhjWD8cec7vVuddUfbGYDfsYZfrOEmWT9hhlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stuvswg2eYidvqDBcPskEs6oxGsfOn+GZx8k7C7Ux+0FcQ3hgdzaHNxLYDHupWr9R
	 v8YJ0Lv+8Pt3BAdWwG8jEtVk6yAJdZ+gnfI6mTn7BCS3AGNwFD9sSEh+9EYHOiK5rB
	 fC1Ecr3V+3w9ghjnaex5HrTUC/8K0P795XeBOw/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/990] net/mlx5: Lag, free steering resources on LAG destroy failure
Date: Wed, 25 Nov 2026 15:29:38 +0100
Message-ID: <20261125143831.726401845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 17b9a5078f6c4..778f0208dc5c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -832,7 +832,6 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 				      "Failed to deactivate VF LAG; driver restart required\n"
 				      "Make sure all VFs are unbound prior to VF LAG activation or deactivation\n");
 		}
-		return err;
 	}
 
 	if (test_bit(MLX5_LAG_MODE_FLAG_HASH_BASED, &flags)) {
@@ -842,7 +841,7 @@ int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	if (mlx5_lag_has_drop_rule(ldev))
 		mlx5_lag_drop_rule_cleanup(ldev);
 
-	return 0;
+	return err;
 }
 
 bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
-- 
2.53.0



