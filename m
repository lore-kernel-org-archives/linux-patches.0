Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040337;
	b=JFJBcGVzQshmeOWQtIFouIWZtUjj8CRUZ9P/wy2SuYjTLZuEcCI8Ql+LKPe8E6dkWE/v
	 Yrcjgcb0FuF0zh3EKo9C5Rt/elt+TxvCxGURbGGst9xVMWVqE1Y6rZlUYPwIdCuTpRman
	 AXhAtApVp2Nb8VEDdfKeZieqi1rxPOfuxobe1yXfKgl72q0QZzmAP3t0JHnZ0vms5cCVb
	 qbsIt0dedJc7zo43Wul27oQI5zumI8J5EfmxIw29wix1d9NmD2KYta8kcL7pgV4h9cEd2
	 iknZcyIZNw8k6TqFE2qcQbcFkm1aDWRhk+PZWBsB+0EQaJ0p1J+B1+UlQJTCHMI9dYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSRrvQwbI73SCIDOCYpJfWExWUa+B89a6VBgMIEovT0=;
	b=LFe9ldwcDsJqI+gIYPVuI7KVx68NEkzv+93bwgPOS42CAbOisB4msNDKI/8wWxfQt9fx
	 UDFIk/bnpenTZZSK71e7TqCD440Sie2g8aI62749QRGC91mkErFIDHrbWjxgz2o7JheC2
	 HDxTXUDy+TxnmJBfTr1dVmbFT990v9ymXYH80agAMnb4r1eiOwr4rlSxbtxub1VTmcK4I
	 75LZhE8YdES1kWjvjdKNPgqUYcQ6GddZSsK8UFmuf9mHwkgxjndABejT0TQsnSMRfAIAF
	 N8OxHuL8LxSuOIQ+Kq6Qa8i0RdEHWj6G1cDzPvoOH0zshpMHJ1zWngCQRKuZ486GKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvJGrxCS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB46606A339;
	Wed, 18 Nov 2026 22:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvJGrxCS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3089B1F000C5;
	Wed, 18 Nov 2026 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040337;
	bh=RSRrvQwbI73SCIDOCYpJfWExWUa+B89a6VBgMIEovT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvJGrxCSu7Tjl5NQkt4XLtuT7RZNiKElQShcRnDOMM2+q3ArK6/bUU087TfZEXYdI
	 4qNkdT44G/0IOjJiW8Hqwcx8bBosEtrqEGISkjInWTT+WYbkKK+JBKMdLw1wVKKlaR
	 dpdnd/LmON0ESz+rDy6jOI0F+a/NwR/ci2pH15dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2404/3318] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150433.620926389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9de9bea1025e2..bba42790be37d 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -165,6 +165,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -173,10 +177,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
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



