Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E02594BD;
	Sat, 12 Sep 2026 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229480; cv=none; b=NsCKmgK8XHPjTwffeL4txASx3+6wsq8NfX1G0VHqpIcoEsPogqPXilRpQhCcYNhz9zNK9bJNOSurYaUW/f6EkQQKs65YRyPX3AT3Io6pNjQtzb8qKS/16HqGgSCtWjDnyvTnITdBolakSEn9T7tgS/IA+zF5GaJ1im7cjyNp0SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229480; c=relaxed/simple;
	bh=9+A5e43GMFAeWhgv2WbRRUBvwAB4Sk3yqyA0M+5Ag6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNXy8ehaP6XXrp87Yh9PiGjNqxJ5ZQteSNtq0JA7Ouywekahfpb+gzOG8OOY9TeaN7hCr3e8Yl3TDAIyrNkht1dRQFsTE+4O83pqv9JIbKkGpkEAFbR1ubMZLOkZytgKgqK/3/9OPXpQXd5O0x1OSRaE5SALyL8gNN3/6b50ST8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlGqvhI0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlGqvhI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD261F000FF;
	Sat, 12 Sep 2026 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229479;
	bh=4xdwZMaTmgikgXUWKsXqEn41ETla4ldI/p7OgRMLYpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlGqvhI0ybEylFt16ZeqyLrFS+ie0fTsQStwUFQt17w/8NfqM0DEbO9Nk+0u4o9++
	 XcOUhXmzW+29cVwtd0adhRSPDfUctsGNtgpEtuEdZIRPrezG04epFI+IqfVaftq4bL
	 zYlcwU5WirXIBgqGEuAsnMpqc6VjQh80GL1Mf6XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0596/1191] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:55:24 +0200
Message-ID: <20260912065601.634783624@linuxfoundation.org>
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
index f10d4bcf87d27..81db89e95fcbd 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2675,6 +2675,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2692,6 +2693,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);
-- 
2.53.0



