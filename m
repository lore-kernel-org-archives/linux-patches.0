Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FE12E2657;
	Tue, 15 Jul 2025 13:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586497; cv=none; b=Om+UbU/VLEcZ3N+O4aNH7+4qG1xpKyetqn1UHj8Q+fpAXNXd/msI21Xa+RuM9v9CFGN0s922TWwEuu4RMq4ZycShpYvBiNok183WVsIrvfNH14SUhK05cwb/PwGm1qOSuTvXWiJAWYPtm/M0pqDys5qJqjI2zOLRUr0pl3vvp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586497; c=relaxed/simple;
	bh=ePAyti1bMynPuZxhvPhx/xEhEmLnx2KHJgXMdY4BHho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpC34zzqBsg2EruhFCnuVxeXB9buo7dInSnQsrPfC4Wal+n8pI+F0tEmBc/PxIGBJNLeXrguSBAkndzMsDSz0O+QozwiRl9Z68rIzz1vSJRX9xyBmwAngk9Nm+lEzdZRU+UMxI5CWNBJXAi4EJ12G7W1f9AvWPjmwapNPLScliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMLQ0VGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMLQ0VGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D34AC4CEE3;
	Tue, 15 Jul 2025 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586496;
	bh=ePAyti1bMynPuZxhvPhx/xEhEmLnx2KHJgXMdY4BHho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMLQ0VGzWDerdk/cAwHsxNm5srQ/dHE8joLxMEzuNHVR7lPaHh+hRHjWwvNbSdY+Y
	 U5U3D/kxuQRAuVVG2I8Swj68CpW0seQ6yh1ridZJqSLkvw0LAgPY0mM2Ss/teuIZuM
	 p2O3CCMVc3eQrSjUgVJkV/9AL11W5S1G6RgeFsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/148] RDMA/mlx5: Fix CC counters query for MPV
Date: Tue, 15 Jul 2025 15:13:29 +0200
Message-ID: <20250715130803.800482837@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit acd245b1e33fc4b9d0f2e3372021d632f7ee0652 ]

In case, CC counters are querying for the second port use the correct
core device for the query instead of always using the master core device.

Fixes: aac4492ef23a ("IB/mlx5: Update counter implementation for dual port RoCE")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://patch.msgid.link/9cace74dcf106116118bebfa9146d40d4166c6b0.1750064969.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d30c37688bdac..1b880b555412f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5615,7 +5615,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 			 */
 			goto done;
 		}
-		ret = mlx5_lag_query_cong_counters(dev->mdev,
+		ret = mlx5_lag_query_cong_counters(mdev,
 						   stats->value +
 						   cnts->num_q_counters,
 						   cnts->num_cong_counters,
-- 
2.39.5



