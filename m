Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F388356746;
	Tue, 21 Jul 2026 19:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663286; cv=none; b=lLR1f1Jnd4EiCNPQIDsG5bjZbgI33TdR7b0tHEe3tVINwwyZ9H3o8xAqWCWp+aRPr7To26tBeBtPWsJvjE2floszEGSDfShUkOJ71BD59dbahbY+HnD8Xo53nXrcwkrfnmdV6IegkZeN39IvpQdYP0r9LF5GfciVlh4d8RF4Cd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663286; c=relaxed/simple;
	bh=Nf+5SHZ3FITjDQwatFg2ljuH+f1tk5KY7k2tip+VPEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfo6k5jFWUy9HDSdcMbu5uW0LZZQVfl9JzkzW7gIYbJFRVADWotNKhPSs4F8mDs9PaB8sD99N1argH5mDaBuQRN770OZ06zAUZ/IO2AgldwKEWnAAdOW2tpTslMhtbWxz9tbvaMLFMAC8jdlbQxFTQbgqcUcyLLfSpj0CKlOxB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MJtHn5b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MJtHn5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE351F000E9;
	Tue, 21 Jul 2026 19:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663284;
	bh=52ZUXm1+C/fqCv94OfQXy/NYyIfn1ZO4qwd/KzMeKEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MJtHn5bUHHVZ/lkslQ843l3OmLA/eG3Qvp6WVGBk9h7DidCOGuCIEpZLPBiEgL98
	 5gp1KN8ndLwD1AKp9Lz3mFnlM6p5wIrZhGAJRBz4Qgn5+Ts7k+C1Svf2iPVzpDAY/0
	 dFc55eKuSYAxhlE32jNiz4vt2w9TRCPlvXD435nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0765/1276] net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
Date: Tue, 21 Jul 2026 17:20:08 +0200
Message-ID: <20260721152503.195287019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit d4b85f9a668b9c44216bb78daf4ec1a915cc92d1 ]

mlx5_mpesw_work() returned without calling complete() when
mlx5_lag_get_devcom_comp() returned NULL. A caller that queued the
work and waited on mpesww->comp would block indefinitely.

Funnel the early-return path through a new "complete" label so the
waiter is always woken.

Fixes: b430c1b4f63b ("net/mlx5: Replace global mlx5_intf_lock with HCA devcom component lock")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260630112917.698313-3-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 2381a0eec19006..c433d29a62f25a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -134,8 +134,10 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	struct mlx5_lag *ldev = mpesww->lag;
 
 	devcom = mlx5_lag_get_devcom_comp(ldev);
-	if (!devcom)
-		return;
+	if (!devcom) {
+		mpesww->result = -ENODEV;
+		goto complete;
+	}
 
 	mlx5_devcom_comp_lock(devcom);
 	mutex_lock(&ldev->lock);
@@ -151,6 +153,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 unlock:
 	mutex_unlock(&ldev->lock);
 	mlx5_devcom_comp_unlock(devcom);
+complete:
 	complete(&mpesww->comp);
 }
 
-- 
2.53.0



