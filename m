Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678793B3880;
	Sat, 17 Oct 2026 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257426; cv=none; b=tUsVTqmKNTNPFqF84aOqDDIe6N9qtSeMsQmWX4ahfeoOb+KzqEWDt5k39OM+/HCsuPxAz7y+FlohVJeWDvwtLfCEcda2TpSNh8/3J4r7WwbumOgMS+GWDAaEJLXCnFQUgnqZZPlUVvhDVmAw33IUeZ711l0CP4lroCnRgLfRqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257426; c=relaxed/simple;
	bh=1fG+fnY8CpL4zLCX6TJ+ffaADox5p84oSV9aG37fN60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKiSenDhWTlQM9zEn4+P70jqWLFIPglItSR3rYC4tpzOmCUlvYgB4f6XhiIdF1hxbKtWx3pfTg5QsYe+wzgwtMtDLn9e887P3dWTo/4XTulKjHpO4Bwm0qilU8Gov7i+FkDzEjauXgtLWRg2LQn49b09AFsjpVqajjITQWykm8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRLKuUrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRLKuUrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D7D1F000C5;
	Sat, 17 Oct 2026 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257425;
	bh=NQ1reAnsef9Fb6qck8+NXF0QJCMS9vqlyK9a5IWeAO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRLKuUrMyhqiemwTOzH03jXGe89NDXKe0bMM3yVZSss5eNmvkHboI3HovcOKasGCZ
	 FIr9NppNKZ+xo0zH0XcGtKPu9uWIhvnC+XD7Gw71iihGj9OeGqDijZMHVISTtzSpQW
	 M3omsbN06m+y+wnkHJxCrHVoX/FYSh+e8CJvnkKc=
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
Subject: [PATCH 6.6 0554/1674] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Sat, 17 Oct 2026 17:47:06 +0200
Message-ID: <20261017160445.314287583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1146a8a4ea19b..e11e07f7f3550 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1073,10 +1073,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
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



