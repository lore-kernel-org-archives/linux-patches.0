Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A7F3E5A14;
	Sat, 12 Sep 2026 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207097; cv=none; b=LaZiiKLZf7xMLTUfrnJDK4XLyNduSPRZO75ig3etaTIVPpnyQqyTdt37Zv0PAQcBdhg8xwm8Zf2jDYZ4hnE+LQ/3m3xhqXQMNwwmnJTwPKQKACIDwUKtTPZ4l57EovjKr1BSY09k8fqfCo00N8X4rRG6vwwtsRF09P6dmaLK9EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207097; c=relaxed/simple;
	bh=EFUB9SJ6MyHf6GCEzynMnU1STzaP3s55HziLQUGdgeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdL6scX4wE/hQbpPrLw+jXWplfhbLxVVVIlUIXn6TlCvnrmYD4chZCvh09LYRUJN5wMjxldi/T9r6WmZYhMn0dL98wMeXEnFHMCNM/K+3skmFnNlWffgY03gQ79AEne4/NfPaywAsrMeoIuJ74ev0VeTu/l+1pjoeReIz9tx35k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/9C6Lu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/9C6Lu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC48D1F000FF;
	Sat, 12 Sep 2026 09:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207095;
	bh=P3DW0kwpENmFOQKgDAFnvHDJ9CAKOR8MVtS/0ShT8N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/9C6Lu3P/OUT3m3zFPXtPTuGcHuDNF0lz+NvbyPZY6VxA3u5dthq5ZGwTFoa522M
	 +2CxEg/n03tdo/wxsMeQUzvXZqDQfF6BICjo5hKdLwqd987RpHl79ILNx/4XINt7T6
	 AZtZ7F/IfWcLEq3JLAEjgqIMLa+QqVlDiSy6ngIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0342/1518] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:41:51 +0200
Message-ID: <20260912065631.212261580@linuxfoundation.org>
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
index 5b4d76e97437d..b897c1c3e4c8d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2755,6 +2755,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2772,6 +2773,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);
-- 
2.53.0



