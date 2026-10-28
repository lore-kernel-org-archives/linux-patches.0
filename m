Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215666;
	b=yn6XqKgGqaeFW5DG86GRrgUfHbZXnUxvdhTAXDpEH+xA+iJn9PvRyZDXDpVsYbRxkmSS
	 vCMDjX+Xqr96mW/yXRIHSyePWGwft6TIHUR5WhmViux0mX06gitIGXCKa4Co5S0xB2VAx
	 1g4ghT/eDEbp4JAnxei0C37mgP8Qaz/0vf0SNoyXDf7QQmdnt5PM02PgsA6O+xCcQOYwB
	 P804r5J4uRNrO50XawZMmykWGHoh4TZvOGy96Nsu6FDkuthWK/eqJy6H1pBDm1+cmFmWY
	 tHyMLFNPnUBami6/qRFONnL/FumgUpDX9kxXwqlQFnJwfqrKeJDnNJPsl/+W7YwpxKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VZcRW7jogJIZcBHjZ0Kr8Ijasj48HJpXK17rYOcPUgk=;
	b=LdMKQV0IsUL1EXeURU6xn5qX4qO3tVGEBq/k0avFZ1fCzOrDX+Mh72MulCMU8CZ0zQ40
	 fz5hoU5IWC8PPtOBTXHH2StIVUaBX6j0goh7z7MpvAQPHFt7CbIpzqp3BqZUEB/e55YDG
	 xNHQTUIyYgyrF/83vKxrcE70RmjudYK2BlthUniaeIF2eFSwTILtoruogjhkc0faiYex4
	 F4SpFyPFxIiRJ+5UE+74pSC1JcP1Fh4dQnJe66olakmPJxeywShcxpr3I/Q5NBLnkCPlZ
	 DPsXqBNv2olTzrfSj433tLyNV8DW8pYNOZ41n3Cq67QRqXvMarfELd5tzW9p94EnHew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2istLxE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69355606A31C;
	Wed, 28 Oct 2026 19:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2istLxE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CB71F01825;
	Wed, 28 Oct 2026 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215666;
	bh=VZcRW7jogJIZcBHjZ0Kr8Ijasj48HJpXK17rYOcPUgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2istLxELwW4gGlma3YWCMsw+EtoNlDzcPIaaf6VL487gHiWcZTkv5beLE3TZX31p
	 zVUnlWTRNo8CApewkuTsc5+rAaNFbrvVBgCY8ydr8CNBV26v+jvDP9tSPL9X+XINc3
	 e/Y8RFRyhJCfpIhrhhTR/CavDo5glfbzdoCSQ06U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1273/1887] IB/mlx5: Fix transport-domain rollback and initialize lb mutex earlier
Date: Wed, 28 Oct 2026 17:56:09 +0100
Message-ID: <20261028170528.389961373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit e79389115b9d27287ff6230a9750675106ed7668 ]

mlx5_ib_alloc_transport_domain() allocates a transport domain and then
may fail in mlx5_ib_enable_lb(). In that case, the allocated TD is leaked.

Fix this by deallocating the TD when mlx5_ib_enable_lb() returns an
error. Also return 0 explicitly in the no-loopback-capability success
branch, and move dev->lb.mutex initialization to mlx5_ib_stage_init_init().

Fixes: 146d2f1af324 ("IB/mlx5: Allocate a Transport Domain for each ucontext")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 993bdd815bbb2..72bba5f05d248 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1743,9 +1743,13 @@ static int mlx5_ib_alloc_transport_domain(struct mlx5_ib_dev *dev, u32 *tdn,
 	if ((MLX5_CAP_GEN(dev->mdev, port_type) != MLX5_CAP_PORT_TYPE_ETH) ||
 	    (!MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) &&
 	     !MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		return err;
+		return 0;
+
+	err = mlx5_ib_enable_lb(dev, true, false);
+	if (err)
+		mlx5_cmd_dealloc_transport_domain(dev->mdev, *tdn, uid);
 
-	return mlx5_ib_enable_lb(dev, true, false);
+	return err;
 }
 
 static void mlx5_ib_dealloc_transport_domain(struct mlx5_ib_dev *dev, u32 tdn,
@@ -3635,6 +3639,8 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 		dev->port[i].roce.last_port_state = IB_PORT_DOWN;
 	}
 
+	mutex_init(&dev->lb.mutex);
+
 	err = mlx5_ib_init_multiport_master(dev);
 	if (err)
 		return err;
@@ -3841,11 +3847,6 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	if (err)
 		return err;
 
-	if ((MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
-	    (MLX5_CAP_GEN(dev->mdev, disable_local_lb_uc) ||
-	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
-		mutex_init(&dev->lb.mutex);
-
 	if (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
 			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
 		err = mlx5_ib_init_var_table(dev);
-- 
2.53.0



