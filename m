Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAFA3955E0;
	Tue, 21 Jul 2026 17:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653730; cv=none; b=VuNT2RZ2sj17GBCIHLhqjHtmTJUTTQUl/4oVJgIEgUnMMjeZXe1ccpPqv5wMtkFziBH4wOC4jd1I7CVynpbsjNqsPQZ8gptolzlk5//yurf1dPT6rsobloJJolZY7ScERnivsUuxSjJg/bzUhS2qKdWFyVvql0UUr+w07glf77c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653730; c=relaxed/simple;
	bh=cKUmvk2MKuO+M0ZOMYmNIwK3apiWdB0f1bKVdDth/vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1y8whKXxMy8ST+7evg/1+Ltrd+sjdaLjljtAd4rUpZjJU9AnmVGgFRkhbjwZQ4GX9fh/HQHETO1YQ2Rgqz8lvRdVSzb5cHMn5gXf9J9Iq9l0QJ/6tBCwbAWkQ2mmfsI1Y9OpjK6Qcy7pke0tPLLYCcv6M3kJ6i+Hk0prlyNZRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2540XvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2540XvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1DB1F00A3A;
	Tue, 21 Jul 2026 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653729;
	bh=nvamW33AxGtfhS+BMVAzotMi32ypWRNgR0fiIl3skus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2540XvLBlXpp99wb4DhOuBMPKnoujfNUgh3poylbQxUv/HkgTtCO8GfKQvX3EFnh
	 d/bfAm8pXAk8UPxi6izSt/kXxmR+yErDtPpF9H6DNfhdzR03cMpya+XxwxE09AnLFT
	 +IpDezcquVOzgPiWPEgFYe8b/SmGwjKsfm69yN4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1438/2077] net/mlx5: LAG, Fix off-by-one in single-FDB error rollback
Date: Tue, 21 Jul 2026 17:18:31 +0200
Message-ID: <20260721152626.722389290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 0f0e4ae6975c773f7854fc48932a267f6c79088f ]

On failure at index i, the reverse cleanup loop in
mlx5_lag_create_single_fdb() starts from i, so the failed index
itself is rolled back. That can operate on uninitialized state or
double-tear-down a rule the add_one path already self-rolled-back.

Start the rollback from i - 1 so only successfully-installed entries
are undone.

Fixes: ddbb5ddc43ad ("net/mlx5: LAG, Refactor lag logic")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630112917.698313-2-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
index 1371e14c4c1312..b72e8659a96860 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/shared_fdb.c
@@ -78,7 +78,7 @@ static int mlx5_lag_create_single_fdb_filter(struct mlx5_lag *ldev, u32 filter)
 	}
 	return 0;
 err:
-	mlx5_lag_for_each_reverse(j, i, 0, ldev, filter) {
+	mlx5_lag_for_each_reverse(j, i - 1, 0, ldev, filter) {
 		struct mlx5_eswitch *slave_esw;
 
 		if (j == master_idx)
-- 
2.53.0



