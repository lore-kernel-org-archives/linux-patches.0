Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024133;
	b=0k9pFqhmeujxHfMSzM9gMG+H0n9MfeNfPISprXdTF9MemHq7KXU+5wuI7d+Hwkd1Tqu+
	 g/zW2cexsbmP6uPRukBUDAA9P+l7ghmMr1ONFweWGa5+00oUxxiPwVfMRXPZmXaETENL8
	 kEQ+58owyuWgdS8EgSm1AUbpz6ZuUXZD5/qLVpW1sLTN/4X4b1olhbWaWT2ml645WKiRX
	 MEvfTYurpEfov27jQjl4uONohrcTPAvfDXT/nlWQz2JDFP1fGNluMJ3i9wmhpF4DQRJUi
	 0R3JA0X3swENwN/Zxskzj/l542yY496I7LvbnSve2QWtiVO+w+sO8JPGJHDr1H6fOtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uSWe8vh9r8NoefnYGT8/zLm4b6Qvfp7U2D+TBHIC1Q=;
	b=J5I/mqoweafp/QOQ85VKwv1EjoXGU3SCklE8Yt9MxbYWO9mjpSGPCDx77077aztWiLx4
	 ap4oEwqjPiC3bhAiqTMGGO4WrmQjFBIbnKUEtGRMz6tmg/CIA88y8CwsQ9+xMaGx8brWl
	 byvSDvhVZhU7zGaCbMEOC8Ha7yAu5XYoOmqd3l0Y8G4JurE744nyItsrjtG8q1NQlagaL
	 w0yrnuChuujUISH+/IRMotDGo0Fmno0VLxTEy7xZITPSZo23JSnfv3MZ6+C+P4yTlkpQJ
	 gFOA5mPCByM/JLRJhIqInJK8fKm1UPIWGzG1C8uVyw7O8VPRXHXJgqVspQfh/SgeCUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UncDWgsb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAAF606A32F;
	Wed, 18 Nov 2026 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UncDWgsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839E11F000C4;
	Wed, 18 Nov 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024133;
	bh=4uSWe8vh9r8NoefnYGT8/zLm4b6Qvfp7U2D+TBHIC1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UncDWgsb3OBcwCH+4mLDbWzioMwJuGhNaltJTS14GiHiqbW5r0XyuZZhcRR5Dc/AN
	 xKPFu6Y0q6P341hrr9KzXBbD9XWv2zRIjoNS/qjx4uK1sOlL4fhQn5vFOJCqwipOlr
	 A7ANB7ZJiGFGig+fwRXc+p/uP3B0xJKf6jbm/6GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0618/2151] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118150144.430329832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 50b20264c4bdd..3168d70315c78 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5212,11 +5212,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
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



