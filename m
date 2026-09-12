Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF46B415B9D;
	Sat, 12 Sep 2026 09:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207092; cv=none; b=Dl0BH2eDTqYs0deI7qKj3BRW12kXcCyceX0H5stD+fAQNQ6hX573/bKAHxIkLlkMMqmjeXsWfQLwozzGW0eNBcJ3sz/GXMpt7r8fYCVnxvmnDNRdhvTFLpUzOTbgNlJjTSog/yMCcQXV0c9gTmRLbqEv/EOlQ+GWbqF+MK9V8sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207092; c=relaxed/simple;
	bh=xd/hsrJuZBYGx5I/iAMY0L+9hRFhnAeL8u6zt0TIkEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnELa2oClL1vkz69XRnUVpkQts91v9coKXFeVyrKb0SglhtPH2OoGEm2Z82YjcvpHNlL+V8uEsPEY9XVACENNu0HDSHES+4iYl9Q50tGEj2Ngl5tvrY01/KL9avCPbO7QOMQKmkDXjGzo3emzObImhpuIdkN/IVZK1Tbx0FCJhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuJb/LNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuJb/LNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29981F000FF;
	Sat, 12 Sep 2026 09:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207090;
	bh=y2fHG0mihHc1mp10MFLAFCUQ9E3dRWMSHME7zA9J720=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuJb/LNX5Hz3k8Fu0SyZURN1p4GQDStMdsCvL+ulx+PwO1lu8y8L6/GzmJJzypYAd
	 gafM3EM7QakmJm/gl1UoQAKL1SG1+fObfKjEZ1pYrbEWtpWizEP9egekpsPK/OBMwV
	 WhNrzs3vhVCtfDXBeDv3YPgosJK8xT5YceArDlHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0341/1518] RDMA/mlx5: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:41:50 +0200
Message-ID: <20260912065631.189183320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e37cdd75f8d61c1123d324ae5667ac3da562290e ]

devx_free_subscription() can remain queued after the last DevX event file
drops its module reference or an auxiliary driver detaches its devices.
mlx5_ib can then unload before the callback runs.

Registration error unwind has the same risk because driver registration
can attach existing devices before failing. Wait after all drivers have
stopped.

Fixes: 6898d1c661d7 ("RDMA/mlx5: Use RCU and direct refcounts to keep memory alive")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Link: https://patch.msgid.link/20260709-unload-rcu-v1-2-fccd27211e5a@nvidia.com
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 09709ae5bd471..433461ab6c75d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5225,6 +5225,7 @@ static int __init mlx5_ib_init(void)
 dd_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	rcu_barrier();
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
@@ -5238,6 +5239,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
+	rcu_barrier();
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-- 
2.53.0



