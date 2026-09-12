Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D22349CE2;
	Sat, 12 Sep 2026 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242514; cv=none; b=SoVpR3OYhmS/YA2LuNgjyW95CNiQ9V9moJ0MUEtRG52PHRYgPMvTSb5Y42W3LrHCKYhZnWweBCrmwbsd5wngfM1DzTwwY8zWxJ+t1sutCgFS2HJ5O6m+t8Q0+1XYq0LYNpTvmL2Sbx8V/hRnegODiGYHpZmkaGkDGeuBKqlOig4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242514; c=relaxed/simple;
	bh=5gRcBRqetPjVw/XNlcPhBkbhLPLb28K1W2+ayqZCH/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dm0MMImadUKeqB/ZCY/reudO1WHgpQoEM2LP8jgrnAYuVnzlsyFYn5P9/KQcGsIQLQSzF9zK4Jphfel5WrcLbKwCUZl3mKoC4miXeaX+km9sjP++zpqOb5Y95lc3XWQFG8o1SvQLcEpV5XIkglqCmAi6Tyn0suLQHRRBt7jWbR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDHtkEt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDHtkEt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEDE1F00893;
	Sat, 12 Sep 2026 19:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242512;
	bh=0j8D9CHxEUjad3ucTV5kKxt8Gd7Q/yZTWxrnx/oBecs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDHtkEt9aPq2amwiIkNeHxNSG7rwA4hdtbM5mzsx+zOR+95aFILBCU2uv7rkkc4Yj
	 tkkT6/LM84J0WhJszVNF0XRAere87IOLqNbV6EpXKYk9TAmECzwNFl8OJeVlseZ+fy
	 d/BvaoQmRb8f9ihGtWP7snyeUIzmOLo+nZ/Wvfnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 423/798] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 09:00:51 +0200
Message-ID: <20260912065526.842900359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 31b7c700670830a0e8a4cdcd451c88a13cc5dc48 ]

IPoIB reclamation completions can be signaled from inside an RCU callback.
Teardown can wake before the callback returns and unload ib_ipoib while its
code is still executing.

Client registration failure can also remove already-added devices and queue
callbacks. Wait after client and workqueue teardown.

Fixes: b63b70d87741 ("IPoIB: Use a private hash table for path lookup in xmit path")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Link: https://patch.msgid.link/20260709-unload-rcu-v1-3-fccd27211e5a@nvidia.com
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 35322d23fc340..6e61c256bb746 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2663,6 +2663,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2680,6 +2681,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);
-- 
2.53.0



