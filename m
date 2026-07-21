Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CAA3B635A;
	Tue, 21 Jul 2026 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648727; cv=none; b=URJ3Jv/sJMzT88Tg27gsl5VObcQZj420HxwwGNo8XsghbhaI2Xq8W6moMC2XzgpjDQzcBcvAPb3Ejm6OjlFld0YewALHLVqAmKd/pI0Zg8NPZfo8FKBefdLR9WCQarMdFpm549xNo8a6S5wNICoa1IWe5vwsZifcMIvp2eCH45I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648727; c=relaxed/simple;
	bh=egOE1el0elvPCWp0d8qf+ymFDH/WHCk/KMt16JIcPCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJzxCoiibxNhY84h+0bxn+1RLicfKa5UfWBvomIKWAINRLtoLFfzl2/J+QZ1jPrcEcJKVymGLr9wCRUL+GWTIBm/76ZKvWRgpmbquyHQeeRqhEUEVCpyubBG5rygoZ96HJ56rOXOYbDrQ/njUyMr4kUF0BURrK1kNZWttGehaks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmqaWNcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmqaWNcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58001F000E9;
	Tue, 21 Jul 2026 15:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648725;
	bh=gs3wK9udExQdY7BKSmRHiFzvwjxdQdmiZl3JBsPkEkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmqaWNcySj5eQ0SuH0NHJdPGJyl4Utti200p3YGzw9/MMXi2YuWdYH9yKhuUEG8Nw
	 l/CMfeLe6VDJpMsn8CM33OsKA5KiYkonm9BkF2jBSV9A0RYWrp8MKfxVmitOCqOSTw
	 F7S1IOBbv/YuqneWuC1vpjFpajL1ZNI4tysGqX4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0307/2077] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Tue, 21 Jul 2026 16:59:40 +0200
Message-ID: <20260721152559.919913561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c3aa6d7fc66b6e..5dad5d77ce2747 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -661,7 +661,7 @@ void rdma_counter_init(struct ib_device *dev)
 
 fail:
 	for (i = port; i >= rdma_start_port(dev); i--) {
-		port_counter = &dev->port_data[port].port_counter;
+		port_counter = &dev->port_data[i].port_counter;
 		rdma_free_hw_stats_struct(port_counter->hstats);
 		port_counter->hstats = NULL;
 		mutex_destroy(&port_counter->lock);
-- 
2.53.0



