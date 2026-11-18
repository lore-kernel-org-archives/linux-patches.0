Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055454;
	b=P79kveOGDHRiH59F6Fvjd6Akh7DMJhOSbG1oVTpQlpWHGOTmQDhLjKWcJcD/wUgIiqx0
	 CyyQsn11CKzZrTwExDSU8vZb24ounNxKEYWVnCvduVFyMJXh88FBsChOzlMmEYKOyCpUo
	 IIXciPZPdMZolbPG0YKiPX7SnDYZVXine71LHWLHCfa/XOJpZbrK0CORLaVue2T5+lTan
	 Drv82ZbvWkjW4XFgI3j1UPXNvy0+h1DyI7+Q5zbHNfX98ZVmea0CpXxkdhXi4Q5ZrjkMo
	 7bT5OUPS6CJh97GTcF6p7nJlyEPuc4BSg8O9kHa1XTh1eBg7BH2oxpGO2sgYDztu/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t4lPSK8NdQQ+/RO1Bd1wJug4miL4cPOeqVZVp+QA1Jk=;
	b=bkVYEJTfHJl8m9DDRLRSJlB6ZP7tMhbkQN9dlKpyzuuuJhLWpRqKypJ8rumX8U815pdP
	 TGoWKW+SGfJLk7XcIs3iCy8+xpr8AEJmpJX2wGrUIH2ZyVTVpcHqKVNPzH+OXHtwkTmT8
	 uyUQEj+DxMhQTQVBMN14aJxelOMuNC3s5QLOiWMzP6WnAIDn2Mu9xKRx+Me9mHXoNa3kZ
	 SHH00swW9Fu7ndPtWJKyyWCu45s0iS/ugVgyv4XK/AbTQNowHnjZEJiJ53nok0kjo0ycW
	 AVQGzGpRRIPXXyaE/Q+KsuZEK/u5aJ4mNLkVZLjhvTFAxJIMYTbfWOIbUoGHjt6Yauw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eU1fwGRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701AD606A325;
	Thu, 19 Nov 2026 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eU1fwGRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29681F000C5;
	Thu, 19 Nov 2026 02:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055454;
	bh=t4lPSK8NdQQ+/RO1Bd1wJug4miL4cPOeqVZVp+QA1Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eU1fwGRDijIWjSvegBCMcZ4CcWdArAPy3bznauawb29PRlr+Iy2NZhhKf9AyoYYOs
	 hvLkf4TFACYLf2YtI6POcMLZ/HXyjWq089bxd8JXgYVMdFSePot3gDEBk7IZ97om+G
	 MEU+7sokgqS+aOPGZ006a7QtsW3dH79adUxyIS/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1635/2214] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:55:11 +0100
Message-ID: <20261118150117.349884829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ab8d8d1204b8..b342dd0da21f4 100644
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



