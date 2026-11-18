Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029889;
	b=Wi3Ljpk8FGYUQlZCBwkY1FiOrRdlScGHin6Vj2hnCpuGXWFtgbuOQ+3Yt6jeWgAvh1ku
	 fE2BSPexawglY4vRb9lNeRVMzzOThfvHKDtuXC3MAYegd3L+KIx6mYw+j5ES7tKabteqf
	 q3HwJoFNI3JGM4b8+j0yQaO38ixAtqZVazrQOMyj2Ao8vUfuoFKR984+YpWyJoe1/WipY
	 RfmLY5VGdOq+iX9f6AaPt27wYP4NiqCq6MLtKk81O9fjr55H9UkmqpggVYMKJiFrec1Am
	 /LcR9TOEZf/Je9N72yodpaYWeUocFe+8h5PK++6/vw/N8ZYduUuqkj/STxV8DbM6r4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKB2WUrL29FZPfWQMgHE5cWf1kcCC5Sgvx4xIJd0ZqI=;
	b=Sq/Lk1fihRkH9ZZnn+gaEVGGCr+FAmCmu0AK/j/sYEC96/8lsq69vFCaDRN2M8X1BjBX
	 qD9zK7fwaA7S9sPsH1zBFcBbwNW2D+WAPifoW9U2XOzPWwsJ9rZy0jE9XE+ET9QL6YbTj
	 Ix4oa/vrnTfa9+5OhG3Koz8zPhOe2cXTqVqypiN58vQF/99QOUhYY9O2h9QQ8DxmFoXBE
	 wsEhGdRVx0Tk+FXjw77TqkjcJrZ/N+HI/wVhkK5KkRbaDsis7vhVs3emuc6sm1dKFap6h
	 aI4YSx+MobNUs/5Ug1Auc/koi6mbhc4ozIjhoQMkt/Ghga4ajBxQz9+fIylhB6F5DYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDHG0dIA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7210060A2600;
	Wed, 18 Nov 2026 19:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDHG0dIA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7A91F000C6;
	Wed, 18 Nov 2026 19:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029889;
	bh=aKB2WUrL29FZPfWQMgHE5cWf1kcCC5Sgvx4xIJd0ZqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDHG0dIAWCAr+U65WbDetzZ6q1Vh0m7WW84YcFoXV5VkLGlWwGh+oNiDZLVi0N61y
	 NC393DaP2q3B7knQh9zSUuxwC5/kQhtcfXqLkZ6WO9PphaXtPbTXvjjmq+kWwVpA/F
	 rlw5MPCIb5boIDHyT+7NLvNltDT7UDTA9+MI6wKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0508/1756] RDMA/mlx5: Fix RQ resource reference leak in mlx5_ib_wq_event()
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118150029.380851978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2b0047e6fd49a..6259eeb6f9776 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5171,11 +5171,14 @@ static void mlx5_ib_wq_event(struct mlx5_core_qp *core_qp, int type)
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



