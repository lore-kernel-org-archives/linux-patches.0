Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1B4F5E04;
	Tue, 13 Oct 2026 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894539; cv=none; b=p1w4Lgrx0LF3T6toB/9J8QP3SaTXNik6qK0kGQDdDNXaO4dH/uE2QMgmN6zbHDelE1ovnWrCfoA5FRPDnSDu7fpzlNM5XwEn2ccDGBP7vrEAooz4HZgDFlmGtQpvHcOvtInLdhI4gu7libwBXtgw37tKCUHHwtzHkxw0+whkPfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894539; c=relaxed/simple;
	bh=NzT0IsIa1d6TWus4vELXnwwwVB3P0bWow+ozr3zJuyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxLv4kRL242sJFObMSxvrzu/QBgyyEnGmsHn53JfzbtdcNATiSJAuQEj8eU8FphZ/408tHLE5A911IyR6bfVDyNlwmfdFf2nwrQ0cyD/2sxkJ+Ry07Ppm9ZOKRPHcK2B+gkp8gLScncmOOvKTnQwUERJyk0ZgspyvXtG2LNOi6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep0GpYDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep0GpYDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8BD1F00893;
	Tue, 13 Oct 2026 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894537;
	bh=jcDVHRPHq7Whk91Aqrt/k5god+5gIBVKqSjTlvY6MSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ep0GpYDBzcBvf7EsO0TrQZjnqeGFhrwbEF5k2LqU6yJRTR90uWhU2BpB4+upfEOY9
	 w7l3Hgzip4Q+fBbUB5NJJnBYG6IaGbzaBHBPu/ChGRD9FligBrTHAR7FteukwPWA7Y
	 PAM0v4JV6C7VeZUBqT5h6GRxcBCQpFC66nVoDHeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 595/621] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Tue, 13 Oct 2026 13:39:50 +0200
Message-ID: <20261013112934.921557633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b056ca4d3742d0769f91137bb1ce3215428398f7 ]

mlx5e_poll_ico_cq() requires sq->cc to be updated only after
mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.

The current implementation updates sq->cc before the CQ doorbell
record, violating this ordering requirement.

Update the CQ doorbell record first and use dma_wmb() before updating
sq->cc. This ensures that the CQ space is released to the device
before the corresponding ICOSQ consumer index is updated by software.

Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261006105820.257208-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e688ce9d383c5..6fced90cae604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1079,10 +1079,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
-	sq->cc = sqcc;
-
 	mlx5_cqwq_update_db_record(&cq->wq);
 
+	/* ensure cq space is freed before enabling more cqes */
+	dma_wmb();
+
+	sq->cc = sqcc;
 	return i;
 }
 
-- 
2.53.0



