Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582B833F59A;
	Sat, 12 Sep 2026 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215295; cv=none; b=JQBHtYcWaIFXLwsvfBUq2Rsq97eLCmq7v5Z0oo7f03ifdUWLjqPsM7+ro68Gno8sDZAki+YTarO/hHbWYJxMj2K5CMc6DPf5LszEUlcFzltghHniliJVePyOD/v/NkuXKNpYjV1mLrK7UyL2fZY9fUWfCYSKb9BUeyTAlHKvXH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215295; c=relaxed/simple;
	bh=nYqN/nnJfmi4p41Jk4vJpSQFUXBcy7d3BWR3S093yiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA8f1vuVBG1Tn3Am2db8ugDTdGyICphOdinHYkWz7/hCtaI+LRJ0MlGa1bfkyObbUG7k1tJ7h6eCIhe2ZTvxxGAktKmUZf6DknYwvhuimZy3QXH09CrMQmThhIg4pr76lieUxfnvU4A/qaS5B1Nsb0A2WG41k5duAg8sJt39duM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAib/XOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAib/XOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9F71F000FF;
	Sat, 12 Sep 2026 12:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215294;
	bh=gMMrMHDEYzmIjDFJO3wIW3rMn+Bsr/pxvMxAXiFoKIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAib/XOIYWHZBbznfqHPGJ5WWwi38rnm/sOS3ViXqmtTEQlYxt06HuQxuDB4wDU/n
	 9Inq8B9Vdm/05hmZ168ldJ/W4R4OPBbKvSBya3ZghNaobViAZjpDYF6XFF26qmc+mP
	 67CBH8CoWxmKWs2DHqixLjNOHOL35CbSB+oIsz7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0501/1376] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Sat, 12 Sep 2026 08:48:47 +0200
Message-ID: <20260912065618.706313462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 666ce83cc35c4..cd53e9c4f913b 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3017,6 +3017,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



