Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019616;
	b=g1AmBI4J5eflcdX21N5l65ukX62uDLTA1Ho92TBg1WYgG8Yh3Yj/RW2GwvTIjzcH+O7o
	 qAi7jrQbB8vgjngoL83MFnM+5nDRGE9Znn+uageFwmTNJMo4d8ctxCNC2EGHoGdIPm9wR
	 Dy+2fhuzktF++sD7HZOB2s1tPnuXLroKsLmxufTsIh6WQvHhtsrd34PIn41YiGZt9Ijg8
	 Urq/jEgPtWqmecyCzpR2wrJ5rC3MES18CKs89Ldc58uI38MWxU+RkZKb6PQedINSRsxA/
	 5Q8mXVaxtTURZjVR61gOXM3s3CmR3AcY9Uo4Tpvooi2jpy4oZXVVb3ZgET08VauOBUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iJLl7ph59DkK+o+mVlzDazSbup0gYLnd1cXMLkP0O6I=;
	b=ic2IS4NLqQEo/uxpXpg7AhPxBjI0zUHnuu16EAaHyL1x2c73h2GCNfYy+CbPPuX4g1+T
	 yCsuYba3sc5xoczDgs6J9X68MEwpDmQAVgL9nuKMd0TFZiFfleuO6Tjjya31tkUiKsV8S
	 /rch+T8ajRhdCw82onlk8pHtumY4JTeZNFKimB02+0dxB7enWob2Cxif57bsJeB1Q6GMY
	 rHseyNdEEu6RNqQss/m87nSkuDGVilOsAaQKBiwT6YzXgF0xUytM3bFl1r0FG7qEsAcU4
	 h+5EXSvumW8bA4iyrN0fq/Gn/WVTJyyl2LKIgVpMTcaUwFR0akOiDhtiGMjeNjOEq0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLzwFnJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FF6606A7D6;
	Wed, 18 Nov 2026 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLzwFnJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2161F000C4;
	Wed, 18 Nov 2026 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019615;
	bh=iJLl7ph59DkK+o+mVlzDazSbup0gYLnd1cXMLkP0O6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLzwFnJDLYHUOg2EwHNrVxb1Co72vkf117UtuICseKnHCMlK5yohyz2OdSukPRf/a
	 rM9c/TeWTGNQQ7mQViutjKVqGypVW4LNaQrsEyOwFhmt5ZwTzv/P4h02yj1exSEk80
	 Jd3berd0Bc2zzmn7GoclPNVqWGJL3sxNgt4q10+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1619/2651] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150346.143582372@linuxfoundation.org>
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

[ Upstream commit a0ab2bb269e7fd8523f87950b91a42a36c7f8f2a ]

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 49b4bf148a4a0..1653b2747f5ff 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1117,6 +1117,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



