Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3951DFDA1;
	Sat, 17 Oct 2026 17:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259334; cv=none; b=MBE2Wxy77WDIVpRw81mDTq1nYzRrQsbTLaptk0ODRoFRIkdKuM85yWxLl4ci6LAYuG7Mt5L04Q5Xk7QhqoFUFxUvUepPqCvgT1fuJSzRgvmN60bkwo9JZNGPfQ1UgAFUKaux3IsTbSr7EmExJE2wGhfF2qvmW1wG+7xb8Il6yW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259334; c=relaxed/simple;
	bh=ysNWYeVIgbI7WWHfNZr7CQHdOCNLe/0qR7rA1wQzMg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoQ93JVsrtUK9i3YcKb9gYUeCeBl6wbhZZweF/4TvmrLEZYqol0XMo98lKFw+wsbKAXIulUAryDruLbX8YlV7zePbSzHuQxEN7y3br6OZmbSD6MKLZmG9twNiYr/Gq186CpPqau0uShyoxlN/iXbSx9sOm+s8/g6hI94MnNJ/PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtJXwYqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtJXwYqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8301F000C4;
	Sat, 17 Oct 2026 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259333;
	bh=8XIB2qAIlEMG3JFgrmB/lc8iTvoVHENG6qCfd2iL2YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtJXwYqjDpmXSLwegMUsz46ZSEspCJxfbPZPXI0fLdavl7Mp7aTn36VwA3YJiJ4GM
	 pMvAq1i72QEZfB/k09iM8GbHxKGH4AlMP8yGhPfZSCTPurCY9iX7K5sYf2VUWsJKFV
	 rs7zNP34pjFRksi+BemUkohulmD38MBhUh92Fp88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1178/1674] nvmet-tcp: fix page fragment cache leak in error path
Date: Sat, 17 Oct 2026 17:57:30 +0200
Message-ID: <20261017160501.386671190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 4dae393956093c807212918fd91a8fc70df15338 ]

In nvmet_tcp_alloc_queue(), when a connection is closed during the
allocation process (e.g., nvmet_tcp_set_queue_sock() returns -ENOTCONN),
the error handling jumps to out_destroy_sq and then to out_ida_remove
without draining the page fragment cache.

Although nvmet_tcp_free_cmd() is called in some error paths to release
individual page fragments, the underlying page cache reference held by
queue->pf_cache is never released. The first allocation using pf_cache
is the call to nvmet_tcp_alloc_cmd() for queue->connect, which happens
after ida_alloc() returns successfully. This results in a page leak each
time a connection fails during allocation, which could lead to memory
exhaustion over time if connections are repeatedly opened and closed.

Fix this by calling page_frag_cache_drain() before freeing the queue
structure in the out_ida_remove label.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index e2d1f2e6012a7..52a435499f9cb 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1792,6 +1792,12 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	nvmet_tcp_free_cmd(&queue->connect);
 out_ida_remove:
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
+	/*
+	 * Drain the page fragment cache if any allocations were done.
+	 * The first allocation using pf_cache is nvmet_tcp_alloc_cmd()
+	 * for queue->connect after ida_alloc().
+	 */
+	page_frag_cache_drain(&queue->pf_cache);
 out_sock:
 	fput(queue->sock->file);
 out_free_queue:
-- 
2.53.0



