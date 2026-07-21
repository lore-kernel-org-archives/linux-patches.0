Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7E9415F14;
	Tue, 21 Jul 2026 19:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661681; cv=none; b=EeXrxs55OGRsj1lXEadsPPX9zy1SObqoFiVDaaCAhSqs3fZSgy6/cqqeOYeAZAMADkZHzoF6dzHC/XtVsseh3mHaps6TnnyZ0BZCjI6tk3oAeV8BtlZjQkULiArxzu3ZFQ6DZSbkImaralcJh1Ty9DmIFYD4nVKYusUnr7UdOCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661681; c=relaxed/simple;
	bh=RHeqYxwlvCIY3rZkvx7ycHZTALGmEedBHG0Cirh0QQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcmuV1Zl+9j2Y+UvesblH9cBku9N6KgL43i62+B10l0U+44TZ53iMPJ50MgWhQhNufpiD+ivtOMHDzN2FBHAJS8Tu6efcJoaCxH9juq6Y7lQNFpn9sdIrh93ZdrCrXN9ux/8GR5EcAJj+5soJTVxaO3P72JyrZPM23WlMa43H+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdnES4R0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdnES4R0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09491F000E9;
	Tue, 21 Jul 2026 19:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661680;
	bh=kNCdBzqHxlMw/ndyiu+8kGVATgK6SFPuJLzykg76KXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdnES4R0xXmCoZjQRHJyb8+pOWR/zSR4DyQUG8gtfsUxrKrXzmxVvBVkUOpDjDcGt
	 0/unsrg0bcDP7xOdTCRc1eu6WUudjUS3vUPxf44srPiagt6dfUtG3FRXyerYDuzv+U
	 qvcTiYcVQgxIIBGFdNRYiJqwGijSzMxVDoRtwBHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0158/1276] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Tue, 21 Jul 2026 17:10:01 +0200
Message-ID: <20260721152449.635344811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



