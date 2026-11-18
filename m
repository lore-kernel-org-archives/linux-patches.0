Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061459;
	b=UVK2an84BTqz/eLcaPUulnKgu6wtIVKJGSfUK42yrpNyvlpc63GYA0nsS+PkPPitGYhl
	 zqAQv9V7Va7rQdOth1ybA8Fe7jTVbCwHPhHxeJLUMRlasQJKp6RMXk0bLBV53zya/bV9B
	 fTajkFEz2wyFied3nSDNq8dq3Kw2IePoPxM2ZOZrUPwSgG0zbr7VEdWYaDDYgkk3qmbUa
	 ew2ZiQkYkI76F51zu5puDj8WMWcyNb5Hw0B9nV3bncxkUbkWlRWDqhHbdIwKqaC48cAv/
	 488d78rggiLlDCTAPFE4FWCRRvu6v+3E2X2mhTxD5FpeoQkBM4KqYso70YqkI2Vtf1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gc3afVJ3ZDeHee/nBq0Q8jUtQOTw6/gnAuD8pqIvh2E=;
	b=djc4kto8s05pXQNTIa3bjylnaXI1JJ2RBbbKToYDZzInp/KF0l0UwwhxV8hhkxpFHfh7
	 aOIygz8NtoMuDCF20b9ywcPeRemkrSsuHmjzXdUepIRc43Q4EtRYFhYjgFwZxk/gitJNn
	 D79w/JXcHIX8vs6A0Tuc8xRobf71JOSwZY60U1h3xSwGcktxws3o87mHZn2xom986N5np
	 +IZb3dcA2cq7Wb+IcJteEloGX3m4whP0y7AJnQu1mKh5Q9n8hPX90Wr8QCA3lroTMf20M
	 lNxqC1shqxNYYSlPYIhvaSpVwdyuwCwwyHoysMdWzGSDybssf7Jbmo7dASZLF9SfXIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+zm7Gbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624BE606A320;
	Thu, 19 Nov 2026 04:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+zm7Gbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73421F000C4;
	Thu, 19 Nov 2026 04:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061459;
	bh=gc3afVJ3ZDeHee/nBq0Q8jUtQOTw6/gnAuD8pqIvh2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+zm7Gbw5ETzi9q+iU68Kshcs401pbmJqZxZg5qgquIK9zaM/xSdajTTqJJf2Lwcn
	 t0xyUXwlR0C+uUYUSlXYr4nJ8AhfNBEcMGSRSSrt0XWE9rn1MHyRvHtMGzEVLy9sNH
	 atbAIcYQVxB/WrV0flloP1GfLc2gMmgdP5trPOWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1561/1848] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:59:59 +0100
Message-ID: <20261118150024.954072574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit aea64024ac37d29e99b82b315a56a9145dc0bc23 ]

Page-fault EQ work can remain queued after the notifier is disabled.
Destroying the EQ before cancelling that work can let the worker access
freed EQ memory.

Cancel the deferred work before destroying the EQ.

Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261007234216.2765-1-prathameshdeshpande7@gmail.com
Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 5c853ec1b0d81..c4b85b629ada1 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1644,8 +1644,8 @@ mlx5_ib_destroy_pf_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	int err;
 
 	mlx5_eq_disable(dev->mdev, eq->core, &eq->irq_nb);
-	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	cancel_work_sync(&eq->work);
+	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	destroy_workqueue(eq->wq);
 	mempool_destroy(eq->pool);
 
-- 
2.53.0



