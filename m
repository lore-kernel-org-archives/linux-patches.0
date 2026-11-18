Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019604;
	b=t50lf8Hx/fe5cyzbRDbR1/rtzsuvesUHjfvZkoXg/tfMF0vYHWrpgsgbe9XsCF7YfabK
	 /X5evMjaafeWC4tH7HyCfv1j4Yn+bSf9+nphsKisHCE6kHAKAe+3t8GONEhbfIOXoNY/F
	 lNu7WCQeeAgsOAqVcFcv4BdJ9ptyW/T5l43mux1jOVe7JUKgIvJfnzldKYfKLIoAwch8z
	 yluqojv5orowD9Qjmm37Nb6mdnKejZ9Fn8YTEMzD8PDSlA1ou6m9Hn8cKjd0N6kSRWJ1w
	 jN+nsti7/yuqmJpDICkxzKjufKZKV3vB/GSlD++AYa1Ea0Tl68JMPyNUxni9N08yqsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kBWVoc855cYa6xYnxHO2IEkDvVUbnbUsBqf29ClFAL8=;
	b=QtekNItoTJKH0TjO+A0XbNQd/6ElhbUV7FKTHP+rpBlVv5cRfudpNqCHNOCIkt69zEZq
	 rYjzBtnh+4vmyX/jGLzQCCavY9gARb0MA/Yeza/VHA/QZDB6gHDnFymftQEimODt9yMfe
	 +gZJ8pY3NCzKcnKoKpOID/SyxVC8S6HO1TUXYN1EOy2yT/Fl7n5TsuI2n0C0kIlEh1wv/
	 qIapof29663LdpgxWSrdK9aFCs+A2TGs3Suchqzs5/hK9qU5IjVxjhzKNxwKrwL2IF7Q0
	 qQPFqid5Ai+/MkqBgQUWWkv7dY7V/vUbmlJayl9DnJI2ffcHiSbkD7L1XIi/oQTHzxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbGZ52C9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C749A606A7CF;
	Wed, 18 Nov 2026 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nbGZ52C9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF211F000C4;
	Wed, 18 Nov 2026 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019604;
	bh=kBWVoc855cYa6xYnxHO2IEkDvVUbnbUsBqf29ClFAL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbGZ52C9p61/qm01v1sW2BW43PCrU74btGQ9+jd167wYW+Mc2ImZqVjTVg3q0mHEq
	 2CRFxuDUu8n04ijmuKG393mZC2n6T7p+8XqYRuznpSOGUCJPHEyvEcRLapOAuR5L0C
	 /0qYUnqlYNDqTGPUdsnGsr2TUWtyyspwb1drQEPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1618/2651] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:47:38 +0100
Message-ID: <20261118150346.108769313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b8618610737aa..1f28c30095dc1 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1885,8 +1885,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	if (!eq->core)
 		return 0;
 	mlx5_eq_disable(dev->mdev, eq->core, &eq->irq_nb);
-	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	cancel_work_sync(&eq->work);
+	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	destroy_workqueue(eq->wq);
 	mempool_destroy(eq->pool);
 
-- 
2.53.0



