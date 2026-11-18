Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048697;
	b=1zm9LLG57uWyiXwD25Dufw+eVpM6t/ODbyHdts5hWKmUkGkPfuAQeBajv48I+Xfh1KlT
	 IDSvSr7ZD+Q9q7FY+XDhWN3L9sdR1+8cppm9gQVatDCsNknSuTD0W53HW5GHwEQ5pfvqT
	 BiFZl+cRk3UJgBrInCnH0O/ji+bn4/VKuyT2SNzfa/bcvbTPmX/OWYQMC8NiFAYiawq6a
	 OiYM8Nj2QGCLRNWRXLUhPFJ9W+PdmmKY7VQZmoYvlZs9sv3lGK9Jit3QwhF88elA6IK/C
	 etgAmTYmqAhoP9PZTBPMhYAab5mRxNxB98SfcMQV7kZwYiylmHgzG8v/TnFAjm5yZeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1h12OI4+Pz0DDbQSrJvg9gazQizGG1AYaVNAYNtEsoY=;
	b=5juBfQz4Naafe3Nci/Vj6cYDbJF1KVdm4JW0kKJ9zDKXCJBL9gO5Wvb1dNq9XOeVhFad
	 2oxsjeRBHxy9PRrm+6zacAE4wKLb6cU2A3mP3xqOtp4x0ukDGUquhkWmgDAFLEyCXLTW2
	 +e4cAXolW3wMwp4LDANZL4wbc6J20LoKoIAOY44vg3msrMcVBWUBKyvHN3FdlfqZ1hvHL
	 bYjdJdSlPf1XeLXMjup7IggNr5d4mssZoheWH6FzLBLKvlFS+lL4DuHcMewf6XNelsv9I
	 KcQVei9j5Or0WQAOlwTmMgm+wJfl8gWtIi0uGF2L/GhGCtewKaMb0yKuVMtY6GYWeog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGpnKu3K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA7606A320;
	Thu, 19 Nov 2026 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGpnKu3K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521131F000C4;
	Thu, 19 Nov 2026 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048696;
	bh=1h12OI4+Pz0DDbQSrJvg9gazQizGG1AYaVNAYNtEsoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGpnKu3KKa+UyRikDjLRC8hMt0F2W1HzUr27HIiR/BFMQbl08orpXAwxNiBtVMret
	 Fh0ItJZpx9hfEzcT+cH1geyl43pi2IqaGGPQWkebUWO6K78YPc/rm3HDys26Bs1cO7
	 KlaLyhoUbRkgb/REgCyTuCE/ZO+lJVusJkbDXwY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2088/2857] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150316.588285751@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 829a0e65deff3f826a7870a52404aeaf1a3fec3f ]

create_resource_common() inserted the resource into the radix tree
before its initialization was complete. A firmware EQE in that window
finds a zero refcount_t and calls refcount_inc() on it; the refcount API
treats this as a use-after-free, saturates the counter, and permanently
breaks the resource's lifecycle tracking.

Move the initialization before the radix_tree_insert().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-15-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 24787ad71a947..4617eeb8ecffb 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -160,6 +160,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -168,10 +172,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	if (err)
 		return err;
 
-	refcount_set(&qp->common.refcount, 1);
-	init_completion(&qp->common.free);
-	qp->pid = current->pid;
-
 	return 0;
 }
 
-- 
2.53.0



