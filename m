Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BB0235358;
	Sat, 12 Sep 2026 07:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198278; cv=none; b=T93PnVy0/kT0w0c6rARci4iYqLaA1wJiW3BOjHCOo+bNYHGuBf0lAVj/Mxd3m7hKkDXPGsR6+GPYw0MVd9HshRuKILBxzed6mL3ebbs5DaQl/7g8ouoXczF0sl80eBlwFPfdYYmVA/svZD9OG8p6zAtLcyfiBUHvbn/sJJA09is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198278; c=relaxed/simple;
	bh=BoB1K1ZgA9LtFckUDjB8thUdHOAghbayTCixy/sbor8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhK7ACDuuqf6Q8iNzsNYRilZSIKZFoyvc1/Sw1V0/Cgtn/Y/vF5QfFeJZ+LL150hmY0f8k2zoNB/UPjy1SSyp/tCjwQ31FrPz+cs+F2SSsXxSHRDeK6yJVH2w8/DZqHElLeUaBQEREa8ypNGVHoxalGbiPszmxDQkW/gf3d5Lnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7tXaWjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7tXaWjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BCA1F000FF;
	Sat, 12 Sep 2026 07:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198277;
	bh=teVWZkm0hNUlP336UMe3mRXB92Zj6u0kUT9Yqr+RGHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7tXaWjYyyKt8PzNRfIp/1BsLtDsRn88nuvoGeafJ9EsBAEN+qFTCSPsUK1ugHcXS
	 w7Zm02Asu3+lkiSDd4UxxEav1J1q+S50/JtLvAVILC/MyTAEQQgBXG1bFLPrRFgL8v
	 sF7VapcaCobCcuG6kKpu2MwB8U/sOcf//iae1lFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0346/1815] RDMA/mlx5: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:34:56 +0200
Message-ID: <20260912065657.033805247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 02809114fc79a..4ff6cca7e581a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5538,6 +5538,7 @@ static int __init mlx5_ib_init(void)
 dd_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	rcu_barrier();
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
@@ -5551,6 +5552,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
+	rcu_barrier();
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-- 
2.53.0



