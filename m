Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB6A29CE9;
	Tue, 21 Jul 2026 21:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668985; cv=none; b=YQEeaW00s07cQnRcytJ2nHa6VzCPLf6f3v9BT9XStseSLKZG2La+DKPRvlmbo9fsZH6IfK1fBgGmZppMVHnfuZpTL6aGHnLulRXHvmqQDIJ0utD11YQoPsgruuPAOXHC11Xpglz+Fq06O9UaSGyK8YcKfGTWHDgDJnzkmb7jbVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668985; c=relaxed/simple;
	bh=UlxMMWcLzpL1vni3oB+K+Rd1DvSZD6vDviNXGhUFyek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIPy4J+4O0IVh6oVx8zd7Y7npxwELqc0ynAyuaRC+c/wdhzNQOd1eO1R8Cqb+RH3071aWWBN4xjrpN4YsQciBz+mVkaicnF07MameI+DGlFaQnkdjR4KjmLBLxMZrQx24fwQCb+fwqEVmLQ1EnGHnDHR/ClI1+kP+s1sXPhhhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMyaYh4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMyaYh4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F481F000E9;
	Tue, 21 Jul 2026 21:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668984;
	bh=XuWKD0jfCC5uM2fz1gVAgtLTDjbWtlciMatdKGpOY44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMyaYh4Jg0Iwkf5LVduHTrXfGWEuSOy/Z8D3L6PXaWzNio8+XZZArnbr7YRjVsupD
	 f3iuy66E5VGBwyVfxtlmkA33LbDmshP1431xNggiENVJmCyr1kqQnGTVsXVM3YL4e5
	 neY3OwxNL0tJ/awJU94oO5ZI8rkeI4LDVF7iBoKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0330/1067] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Tue, 21 Jul 2026 17:15:31 +0200
Message-ID: <20260721152431.977717591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit b86fd95805a7bd4c5b9465c9e7f75e45bbe7eb6f ]

The error cleanup loop in rdma_counter_init() iterates with variable
'i' but accesses dev->port_data[port] instead of dev->port_data[i].
This causes the failed port's hstats to be freed multiple times while
leaking hstats of previously initialized ports.

Fixes: 56594ae1d250 ("RDMA/core: Annotate destroy of mutex to ensure that it is released as unlocked")
Link: https://patch.msgid.link/r/20260520104546.1776253-3-cuitao@kylinos.cn
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index af59486fe41852..d41af5ab6403ab 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -649,7 +649,7 @@ void rdma_counter_init(struct ib_device *dev)
 
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
-		port_counter = &dev->port_data[port].port_counter;
+		port_counter = &dev->port_data[i].port_counter;
 		rdma_free_hw_stats_struct(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
-- 
2.53.0



