Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FE29D288;
	Sat, 12 Sep 2026 16:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229475; cv=none; b=hRjRMRDCeJeohonowuKzyyRZ7pzARUU1yG3l4VVGLXCLGI0McVHexrOTO5GWY5gxmFFzwgmo77Tb86KDgPRpqkNiZoyyrhD2j6pp2pBJlk4rptm7Rlx/sU28f9nw2w1ifj/IOQ6K3bNL8EsakUwMdEYWkMV3NpcjShmcnfEcLOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229475; c=relaxed/simple;
	bh=Mig2u0G9IBEe4NkzZVwfzcv6fuRBhLPIsk2sr2lolQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj95o9RAwSE3OmPXDsTgH8rs2F5mwB4bQonLnzqJZK0mSQF/gfMKDdIQrWxeyFhDNZNRNLFlqbcxbu6t5g0UgUKUtwoBTqHpeWX656jybOLjfaCwPs8hDN2fn7b5JhBY7cLy35fxblRXHGYoQIIyW9k5gFwh5ZSVnJf4qehZl6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGI/1s6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGI/1s6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4F71F000FF;
	Sat, 12 Sep 2026 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229474;
	bh=4NQx2uhDpECBXhfRMlqI/zy9qVWjIIYiyEirnk1Qq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGI/1s6k+tJWCUYEDoEoAYcMw5iWyA8hZMxb8oaPNOBTSIbEKxtbN5C8/cFGoMwpn
	 8oT47Ul3PwdO+9kaad0QnbMwio+nNuc35uhOTuEqbNCiQF6xxuoPuQrd5b/nd/KJj7
	 hnXnGnd1e9nLcYUtQ30ElGEtssPph37Gr86xArqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0595/1191] RDMA/mlx5: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:55:23 +0200
Message-ID: <20260912065601.611989160@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0c3c26a14db4..987e9087c9d92 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4431,6 +4431,7 @@ static int __init mlx5_ib_init(void)
 mp_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	rcu_barrier();
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
@@ -4443,6 +4444,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
+	rcu_barrier();
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-- 
2.53.0



