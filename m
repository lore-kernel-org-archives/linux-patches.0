Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0355B47ACE8;
	Sat, 12 Sep 2026 12:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215305; cv=none; b=YRsBfrAvEZYs+b4PrC6fhlG0ejndNB/2DsPu28nf+puJrIQeHCqI9JCHQL63kTd8rK7uCYVADOvC1mrKLfx2Wfs3SFdsltrPn5TPq15UA7tgs9pMJNI2R+f0afpY3fSpzWXvWArHmFEWSuzRJmEnsGl6oPetQKXkjk2f/FO2eFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215305; c=relaxed/simple;
	bh=/4GDT4srpo4SUdD9IsXPYX/Ypj05jyUM0Micov0UhOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYLcbu5E26S/jb8GlXAv7I9++IOG6ibUlhmKRtYFws7TbzMhnSOP3bU8e3I6siA+ZQHNIty4PfXqzTmqIvTW3jj4SLKcRe/lISmmm+TK7DS/FWzePhp2OJ3uPMgwUGXxOuNMm5SIQPWORMVFRUmYSjqB/7WCqqvi8tguWGYs2Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVrFFbhI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVrFFbhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3021F000FF;
	Sat, 12 Sep 2026 12:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215303;
	bh=+JQeeZ0WlHDjK6TmKprAAmyl9YMlRKFaBR1HRN3HY4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVrFFbhI33Kt0tcXA2god8WS1nq0Xkju23pFgwt6gsiXcumlt3rDythdA5Gs/yPK3
	 VCJBOToCrOkufWJJCHQtROrfE67PsM+rUx/r5vi68hpvn8Fvi2UTzdjUhsXHrBZkbK
	 2M44e4z9ur8z9G5u5hTYM4M+qumb+d89fv9uolGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0503/1376] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:48:49 +0200
Message-ID: <20260912065618.750335519@linuxfoundation.org>
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
index d65f3a5963651..bbb00fdc12db3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2703,6 +2703,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2720,6 +2721,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);
-- 
2.53.0



