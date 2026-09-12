Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF03B19AB;
	Sat, 12 Sep 2026 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238819; cv=none; b=s3GseB9uy/wL9/0R3P/75zldq0j9JXxMgTd3mxhj6VaJWXO9UL8r5FvlWxvvTilMvqjI0616KjQWP8hhBxnMtPpkhrNbwpvEPwpeMWbtauYAhhGAIXzbriZtP0yOhhOMKFf99glgtetcmODGyXo/gwAnjPvwX5NBdUv8P9KLIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238819; c=relaxed/simple;
	bh=k9CnjSsCagJG80vwsA4YI6Gw4+NtLXBpbKnMwgKLftU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9ELnDIYFPtN37BpfhiRSm8sZynZXFh+FNUeIG4XR08p2pdVPzVo3m9ooqcAOFOr50v/8B52yghQFPTXRg20dHVkqJUoEBmsJmnpyUnpuaHbXEwKLBMGMRj6oGtcFbGO6qO+lWi2qOQLxovjcM4FEqRqlkwfbMipdwsTWY+cDKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hp/uWtgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hp/uWtgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF39E1F000FF;
	Sat, 12 Sep 2026 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238817;
	bh=JfpUnzDtRFI63X1zTQEhaGbk59pW1MhbIUqWfl6YPsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hp/uWtgc02iouszwa2fM8hEgvYyTpjM8gOYOZJRFqbn3Y6uRriWfRv8dKGvZ/E3FC
	 BLmPXP/TiXL65jlRPhLsq+pXXO7Sucxov9WP0wQxOEIONiniLibjIZBBGliCEuUkvU
	 qJguC6Bkeq7ihJFO1P3Jfji3KZ1w0wGUwEoelo1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 496/935] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Sat, 12 Sep 2026 08:58:46 +0200
Message-ID: <20260912065538.194469428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7d75592114d1664623c8cf191a12b38052c04483 ]

put_gid_ndev() is queued with call_rcu() and implemented in ib_core.
Stopping the workqueues does not drain callbacks already queued, so RCU
could invoke it after the module code has been unloaded.

synchronize_rcu() does not wait for callbacks. Wait for them after all
producers have stopped.

Fixes: 943bd984b108 ("RDMA/core: Allow detaching gid attribute netdevice for RoCE")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Link: https://patch.msgid.link/20260709-unload-rcu-v1-1-fccd27211e5a@nvidia.com
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 8f987f57a5d62..a3339b710f461 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2919,6 +2919,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



