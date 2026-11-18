Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031434;
	b=2C4ZKw++5OwnxJSz5jI06OR6XoCVMLB55mzKqS/pdaRlxf3/Rj/1BeoX3mSTgC7utqtO
	 ihcIcS4lOFY7vlbA5V23Ay88uMBorCIw+Uikt6270FA6HtOA/j32+7lvLLjGlBNhIT571
	 aKctdH8Ocm1SjeixoxyaVWWKi1eN9rEsClvKvGpc9D8inBAFLnD3Dod1YIz5x4zXY2qnF
	 v5uofhbUtmiChzRULAAvEEVvl124ZX93w/i72CcXpOXnQrOyh8NQ1Kr1JlN+NeJoDbgzF
	 UA5Agh+xBE1pQDZPsyTYnhjfSBy/P1+54Dkm0IGP+F2AFI9d14fUaL77u6ub7dUc8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WzyTWDfEHFwuNWoPIQXVvyUxsQjaZ4fyw9/W351obKo=;
	b=tzdFxgKjtGVHTNeQcjYi8/wFSbtgBIjozcjU6PrmaycUyKKBiu5lELZADfcASdqyl+5a
	 HRTPPfkqE4emQwz781X4jM472yEmrEvUiGZS8A4DtYjbM1/GEe/AmL2NSXsVQToMmZiJd
	 a3uZVYfxcxh1KFZLxhLKvqj/ojQ4yR5wTS5mvu6dr1gJxuvXfRrjosZskCcJ9gJg5xqCc
	 jnzx7NDe8qg8KLVOlnqsUtoHZ9HT9m3F7l/1OIRZwnsv+sVNVeRIEA8BGWWLtwJw1kH9p
	 GMr6PC/+yOt6rimi0L8p6f9IxPeoKv94Xletr97dB2yGDAc4zxpGbx/Sj71zMQVp1xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="k6rW/74w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26273606A32A;
	Wed, 18 Nov 2026 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k6rW/74w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FA21F000C4;
	Wed, 18 Nov 2026 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031433;
	bh=WzyTWDfEHFwuNWoPIQXVvyUxsQjaZ4fyw9/W351obKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6rW/74wIf4kulEKpLguk5iWrVQSL07gHZjsyGCLVPywl88oiu+X62GMR1igESUMQ
	 vssKKd73vpb0+rFppH2mc4uUgSeQTc3qiMv5sA2myn4nxIu1gAx//L5PAuiz0yn2bQ
	 LX3dIOOwAIcNm9AJCnUHdlxxSG/nCdeqtuOAujqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1055/1756] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150052.212849931@linuxfoundation.org>
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
index c6590dde68332..4f25aa8c72fd6 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1064,6 +1064,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.53.0



