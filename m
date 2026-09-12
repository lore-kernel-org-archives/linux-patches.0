Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC393328FC;
	Sat, 12 Sep 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223101; cv=none; b=RJ8pZWEiUbT+maF82J+N7cp9EFo4ft52x/Glx2tgd+zdbnKBluuNsF4lHPK1mIVPJ/HILOouOYnF+5HOnRbWsnZN6IqKJoREBilCanoTWps5B83FnWsCgAc5rMyEyhkW7HcRADGngOp3wUJcqdJ5fWdpczuzeSOVBegeT+S5sok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223101; c=relaxed/simple;
	bh=v+ciPlxegh6AKfuXgCy0eXoete3lYgOtp3NqfrLSpSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay51BolOOhRITjtcpnSBVUuNlfjgXMCKXOtdWTKFk+V7eGokaMApQJ+qnKXh8Fv9hcRmiQ4NrR+6iwRtE1lnFvC4a5AAp/q7SD2NShwSShJ1yz1e2JU4n8N8WeW32eJip2seayZXxccb5Ufsp+QwICDZ5m0nSpESyxVKFSVZABw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/klA6Mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/klA6Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A33E1F000FF;
	Sat, 12 Sep 2026 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223100;
	bh=wG6oVW+lVoeT9E5VQUsCMEBQpIRU04gMGHif9Syp9vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/klA6MfmFJya8TXn97QZVsPYOSZJNrgQgv6Oq1SUGHL198xuUNbzeRZNNDj/ArsT
	 Hz1jWEjOOmMEGfNsWnxDyoTuTnO0LDC4LiFkccqi8v0mzT9rmYF/FQ6lTXtuiJ3nnn
	 797tr95U4G23Kz73Tk5HqzV1/BIx9TRCEx6snX50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0719/1424] RDMA/mlx5: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:52:31 +0200
Message-ID: <20260912065623.395576132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 10422dee6db81..57f0f9a6e8e5d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4603,6 +4603,7 @@ static int __init mlx5_ib_init(void)
 mp_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	rcu_barrier();
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
@@ -4615,6 +4616,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
+	rcu_barrier();
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-- 
2.53.0



