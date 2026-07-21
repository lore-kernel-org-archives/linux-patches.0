Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ADE400E17;
	Tue, 21 Jul 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658174; cv=none; b=Y3q1oe2sxLyX304svVTlb/SF0BWcahgi2/a+OiF/qnouN4vVG0iKP/HGa9DSEp/Pr1H2LKkIEYglDIWR4bw7+Om2qdU6Ek3BemeEd+kFxkZpig4H8ZqCyfMSfU0EWjQwg5qNiEl0QcY7TxFc+rVU8SKxWXynlw7cAx4lyD5w5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658174; c=relaxed/simple;
	bh=223uop01AHr0Jf3yTrerM7WQmA7Ne+ZvVbSbJPxsvEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4k5yBWttwt8B5fbSS/hRSkM8H3XqLNXTHDULVQW15G/DhAhqHNr+oiMnbbQJ6HN/SwhP/BVcYJz6FykVrUao7UpYB72pI+KE4HvCCLjoOIexTPPGJOKQ6GB683R6/CNIL2qR7Lm3iDuvFC9OUydMg4HxyYqxoDP13kV6GKi/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKa4ayQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKa4ayQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF4A1F00A3D;
	Tue, 21 Jul 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658171;
	bh=Pmqevo1g7Clj7B0kP35fUNX+YtUdHzWLVdU6aZuJTIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKa4ayQk/QlfZSBRsEDmPjNLxvb4PwDMtsaOcU+b5IcRZ9Gf+Ao8fy/48TcZD2CYn
	 jq+4n86tMWXWzW+GwHRLGGo4wI6Hd9vJ4CkewyaQWe1UAXfSh+ismbYAt9GEHyrtT1
	 zZFktZIOaViGlv+WV0mUrjdTR1fl6lW68nPdsrxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1043/1611] net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152538.862509222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c217998604fdbc..fc914ee2598693 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -139,8 +139,10 @@ static void mlx5_mpesw_work(struct work_struct *work)
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
@@ -156,6 +158,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 unlock:
 	mutex_unlock(&ldev->lock);
 	mlx5_devcom_comp_unlock(devcom);
+complete:
 	complete(&mpesww->comp);
 }
 
-- 
2.53.0



