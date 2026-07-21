Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99946D549;
	Tue, 21 Jul 2026 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655986; cv=none; b=rffXiK7+7YPtkdB8htOUikQdwZ5dlxc/Y3fVJi8yC6OeXijNDQ24febaOXp0SWsm3P89V7F+qe6Sz7eEJfsv2J2/tJ9WQrZfyiIuhrDBeRTDpYYIEjruU5Qnj25AiAsQ1jSIT14J+2Z9aJCYHIUOg73119AbVq2A6ds7AdB9WQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655986; c=relaxed/simple;
	bh=23fwUBMOor8M1zkTDjz/5D4wiHWl9X14Cis+MYZgWXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivuz1jThJ0knmcZCPZarNyBUCHjxw5pDpbVPYf6UiHr6R8arTIv099bmSi3BXeTVL1UTDrhCnM7h4RyUYT1YRYIf5i2t8Og4L/A6AZKEYS7cmOLV6kwCNEhuuXgAfGFMZ1T2pu2R1veK5jfLWOFzGtP6DTfI7WUjucEVw81iqqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIml3KZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIml3KZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02FC1F000E9;
	Tue, 21 Jul 2026 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655985;
	bh=dc0T7emLlHRhT+o6wp5w3BDaLq2Ri33Lqj8vmsqxf/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIml3KZmfBP0YdqsZtveIrd0u30922ZmsdTB4437MdTQ9BCNISdGoFSWJDRj4rKku
	 nBUMmMt8YKK8bwZVJ1+6xN7NcD02todWPrxle4V5/UDhDFSkHtMCiKOxxM8BWBSI05
	 vv9CzL8cZQAB2vOggWlxV4M+0qa6XKMNd4gNVKJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0216/1611] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Tue, 21 Jul 2026 17:05:32 +0200
Message-ID: <20260721152519.847966513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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



