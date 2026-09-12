Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177102F617C;
	Sat, 12 Sep 2026 18:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238620; cv=none; b=ZurYrk7k28JpqU3SUWnISKMF6lXZD2CREZN3TxdqiPz7aijr2zgfqYdBNyI9jlJcvGcH7HwXtdOw6Sk4StEp5OaRE0rrtCgA9X+rhAohcMz7JD28/aM5bFrKfHsTbWHkdUO9NA2NsdhdBqcrIIyFP2KfBXuvcSJnhLPRSX8aq/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238620; c=relaxed/simple;
	bh=t864vqcFkuPjuNTIUyzSV9lKczT9NKYCKDtYhaz/Pvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwvxKTLKXHytigRXn7nsouIcDUqi1CRuGFDM4US6bUpN6oiEo7nDT5gSSwuNFg1IFuwEB/VWOU7qJay6YgLmfkukkHtdk7BEOef+lFIKaJWUsMN7ODcNRtsJrgBmf5mIvXp19rf1YrFNVxCxCRJ6VJ89t4ozKaH5gZDQ4wBBjvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHEmRW6K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHEmRW6K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9881F000FF;
	Sat, 12 Sep 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238619;
	bh=Znz7tM7q+X8nmtbvOHVlee9ripEPLUYRYY4evxGmzH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHEmRW6KVpJY8LxncwMXRayBJdUe3jfwwTfUEB+vC3iafSa1aJYfh0lZW7vHOn+sE
	 CJ0QB783IqslHBVJM/DsX2Oyi/QZBcUEybXmcCl1cYDQTyGc7nucAIerVRE11HPlU6
	 B5WGpgGACXXjR3abV9HvQrFSYf0zmZKmWj4VUEbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/935] RDMA/ipoib: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065538.287459324@linuxfoundation.org>
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
index 1ea95f8009b82..e956513943c60 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2672,6 +2672,7 @@ static int __init ipoib_init_module(void)
 err_sa:
 	ib_sa_unregister_client(&ipoib_sa_client);
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 
 err_fs:
 	ipoib_unregister_debugfs();
@@ -2689,6 +2690,7 @@ static void __exit ipoib_cleanup_module(void)
 	ib_sa_unregister_client(&ipoib_sa_client);
 	ipoib_unregister_debugfs();
 	destroy_workqueue(ipoib_workqueue);
+	rcu_barrier();
 }
 
 module_init(ipoib_init_module);
-- 
2.53.0



