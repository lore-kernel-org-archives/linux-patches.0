Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048462;
	b=EC+zOfNgbX13hfUoLi3S5wzwG4xRkaY6817gDzu8jrdg+NYGqlqkEify+WKynUODJPKJ
	 i19e25ADGQadwQk4I2DdZ7jojirDIUQeXfbhN24iBjAxfoDtNjW3fDJaeGCAAnzn+92eB
	 GVTYyzstJZIqWWE/sHojZli9K3+WTuC8MFjUr7hsw4wEds3Q7K/y1b8gmopKXamG1CAte
	 BXv8l6aNv5euJqL+0Jl1Cp8eMopsbIBiSoba1vdHgkwUoQRQrd4gXB7UnK74LFMPNYLm6
	 82uQR+zgsQVjyQNi/V4aWwGPzWHiYQA/fSe2mnVd7+4+FAVbJspBXFi3nC5emwgu1aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dtg8LjZEma3ImY3QkId2DvbFYyuE1M4z8vXtTRONKzs=;
	b=f2GUe8WcMPq2Dp7Tp24ZRFpsNP2kpD1B20cndRIMrnq0vk8WR3tRPtEQDViz+jdCN6Yw
	 Th19J1epLjswaMV4Y1SHFoFBkix5NbWTm6SwHIjdeg1uMizo/oOqdR+W4aNWvRp8hLYMM
	 cuQXZXtaGL4Y//YdSj0xVF1MzjwHLSae9mrqflUu1m6U3CgDyarRVnV0CgIp4vm0+dpDL
	 FyVc346GxDDWY1XtZF0I1bjQJiAm0etl894FW9AyOYsC+YDKggDEb4WZXIexZ4VrTKp6E
	 we6pShBCuVGxC4vIBDkoYGzevje8VAe5kB1H2ZkN3ImTI1YBVxY6SmAINE+/vvnBnKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSTJ6Rv6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEFF606A32A;
	Thu, 19 Nov 2026 00:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bSTJ6Rv6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2E31F000C4;
	Thu, 19 Nov 2026 00:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048462;
	bh=dtg8LjZEma3ImY3QkId2DvbFYyuE1M4z8vXtTRONKzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSTJ6Rv61PGee5znqFSIOrlKyQ0Rpiqd0Mqt0HvnB+VNiKDkVSCzmKSzLOqdbTcGD
	 prPb2rUdylpRAoGfiLAqnGCIIZWTnXDVdmWm1Wf3/TKSbN0dQqwCVmofGMNiKwWOYW
	 9KatF5WS+7EJjDIizg8vljwMDkig3wE/f1HV5wi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2004/2857] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:50:38 +0100
Message-ID: <20261118150313.517410144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 65f3eab431944415bbe5e3af1bbb2736d4bb1523 ]

Since commit 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in
workqueue context") rsc_event_notifier() expects the event handler to
drop the resource reference taken by mlx5_get_rsc().  mlx5_ib_wq_event()
was missed by that conversion, so every RQ event leaks one reference,
which keeps destroy_resource_common() waiting on the completion.

Put the resource reference on all exits of the handler.

Fixes: 312b8f79eb05 ("RDMA/mlx: Calling qp event handler in workqueue context")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916183921.2092821-1-vulab@iscas.ac.cn
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 93ea672325ef3..24fcfdf30c602 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5127,11 +5127,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
 			break;
 		default:
 			mlx5_ib_warn(dev, "Unexpected event type %d on WQ %06x\n", type, core_qp->qpn);
-			return;
+			goto out;
 		}
 
 		rwq->ibwq.event_handler(&event, rwq->ibwq.wq_context);
 	}
+
+out:
+	mlx5_core_res_put(&core_qp->common);
 }
 
 static int set_delay_drop(struct mlx5_ib_dev *dev)
-- 
2.53.0



