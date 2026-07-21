Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E2946AA71;
	Tue, 21 Jul 2026 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648784; cv=none; b=pxTp4+REA3JJ29LLCT2cyNs3KxtAr+RHG915GX+/wFYu3njazK7A4uTh5vOXTWQxNoGD21c60jWHCqnQdIxY8P9NHZ9riIPIbykjSwSaUE6rEqg7RotBP8TVD5zGqRolqcMeYNZGol55EwMS0MT3wCia6/l2Sd2Wu2AMpRRgOio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648784; c=relaxed/simple;
	bh=blDeyNcnnnB+fsc9y5DOgxN+oKz8zWroo/ueEjGi6j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMwIzA7YIIHihjA+M68Xmq5cgKIZVLXftRfVtIQHaO75HC9VAA2aaamKhJeo0vMFYWFlbcaY9DImJgxzNT+R41kz+G6OV9g/jUF4vluZDiC9oB4dQ6ImcJsPSQWBAXVp2prx+FM2BiYkN3V+4S07EyYXs6j4IiXyuFn5KVE2Fl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9xDnuZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9xDnuZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EFF1F000E9;
	Tue, 21 Jul 2026 15:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648783;
	bh=uM6UImhAPglHXvEteBIYVghqrOrM9CWBeAAPLO7jJ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9xDnuZxeOObt/4IWTANZry8sxr5zdlLO96sXbw6wFd97c1nXabL1X9K2Plhpk89M
	 e6X9tgNoNlYgX6kEXfwzelrQt2CWr54Oz+JPszpgpFhAP3XEr/TgEmihKMXz21HB43
	 XAV8NfLZEByXrv2vY0KgO4UYrXwPekgE02e6YM+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0331/2077] nvmet-tcp: fix page fragment cache leak in error path
Date: Tue, 21 Jul 2026 17:00:04 +0200
Message-ID: <20260721152600.491226896@linuxfoundation.org>
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
index 20f150d17a9625..57a6da696fa0b0 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1999,6 +1999,12 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
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



