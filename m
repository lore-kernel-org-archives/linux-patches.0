Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3269D1D7E5C;
	Tue, 21 Jul 2026 20:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665778; cv=none; b=KYRMWZM/NCG/1CTkmj5Q2uAIzWOYufVBFeozn0WRSF1f0T36gbhNHfeVMZjsUuOV2/KphCwqVJZ+XCPyv1iAQEvDDvonXV6NVIZb7CdujpRjDI9wc7aMQ2J1N2YShcyfQZYH0pr2I6DlgPYRw4ix6SHBQou8pxF9Bce8HzcDwMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665778; c=relaxed/simple;
	bh=jK0GggU48YoVGyhmtYlB9Kr7Xq9GLtBIVpRWzAJ791Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVRjDCDDR1j00u1wbHIXHzBMoS2ipk7cdFhJBn08gV9P7uzzT5SJPWRTKeM1H+UemJ50RGpMJm5IgJlO0XT/YmE/gTh2xeE9lmZ0HeKe7cbPb3gtESHg4wh21NSCe8izFoJ8r2GdyoDaxvoqs9+6+I7ceV1JA+C1/7h02oaxI1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXZMNU01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXZMNU01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981261F000E9;
	Tue, 21 Jul 2026 20:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665777;
	bh=ChyeFTPq47prMqReHG1KT+RZybkpHtwhesxDsIptMJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXZMNU017l9J+I50TPhS7x86NoQZYU65N1ya+uFF+AiOE04vfu/SxBWCrAEsumlZ0
	 dfEbZuFs10HYG1US2UabZAiyuoRj+5YJMmK1LTuPcnvd/4EB/0PEa5k57q7vuhdzrz
	 Ryv52dFxjCwxZNsBP8hNSnFdcobJBNF6mz2i11h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0432/1266] RDMA/counter: Fix incorrect port index in rdma_counter_init() error cleanup
Date: Tue, 21 Jul 2026 17:14:29 +0200
Message-ID: <20260721152451.506512735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



