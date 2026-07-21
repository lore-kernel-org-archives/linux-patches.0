Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5BD46D2B3;
	Tue, 21 Jul 2026 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653733; cv=none; b=iB5OLHlvMrsiyTzR0gpX28myBdTxXXro4hFrqyb3w/VPZ20D7wPYu6V1ZyIprMf8y1B8gGqM4LgvHWUoYT1mHhKH1t6mz/I+V1KkV+/yCv//XB2snT/dEMV1aZyMIjSIVi/GL87T5M4bIF7in9PaYqlLCrRzjhbsQty1O3u8m6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653733; c=relaxed/simple;
	bh=KebQdQa5jcV2Y4DiNwR/SBJzEqQyzD1JpfgZVweQwNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh/KkzfwZsVxmD70/EO95M6PWPeqsv9sPqsQFKofGtH/7Ua9JfuOlSt5MV/6NZAvq6Ykabc/a5o8dzIFRpKl9q4kKnGY8RaUcwh/on1d16sXInQndAnVYDFQGABbScfeE69F+kxGzjEop6E/1vQ38ibjoI/Ka6C/nJxGiFJIbZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tx7aFfr6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tx7aFfr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704BC1F000E9;
	Tue, 21 Jul 2026 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653731;
	bh=BNhJcikuSk1lmzUpbwVGWS/4hX1mhg4dStLgmXJhpg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tx7aFfr6Gj0OX+2LyiVsHyoodwKCLjCZs5MJYQBplXj4qYWnmURj6ll5Dxpl/9fDS
	 sDfpiexdWEBpK0PSROpI/KZYBChf5njhe7acu3XYO1GP8T5SXEgbBGyxM4ugpGrK/Z
	 y/qIXTACutoNENcurNQOGVMzcuPA57pp9fpC5UyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1439/2077] net/mlx5: LAG, MPESW, Fix missing complete() on devcom error
Date: Tue, 21 Jul 2026 17:18:32 +0200
Message-ID: <20260721152626.746632194@linuxfoundation.org>
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
index 2cb44084e239a3..97334b563c2427 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -118,8 +118,10 @@ static void mlx5_mpesw_work(struct work_struct *work)
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
@@ -135,6 +137,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 unlock:
 	mutex_unlock(&ldev->lock);
 	mlx5_devcom_comp_unlock(devcom);
+complete:
 	complete(&mpesww->comp);
 }
 
-- 
2.53.0



