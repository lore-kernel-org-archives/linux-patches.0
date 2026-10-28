Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215604;
	b=poNoVIq1NGu9t9QkEfSfkmavhLidxKZWDaHuq9pZCozeaPC1b5AOKARLAJqkKWyYScMh
	 gQKQXdVhDVLZ9g3SXPopKiffvBzO7Ha9nLy/xy9TqABvWNXz8GMxs4fT8g/NxyNX+9oDV
	 yCycUgv3JV1nL9B6FZGwv+HMcAwh2rXRXn5mDcDdL2DB932nBf1mx/Z/3Ov/86wArJyow
	 AFMuOaoaiO2GrwdOqEn/Mi0yQcHQtAIMg9LSVorTVqH/ReVHmTbGrE8Ukvj0Pq3R1fY/m
	 wh0ntvPmVLRujyW6OGZmlKz6olVWnv+biY4Uk4keKTKgzj5AOm810zrqLhU2uDAYzEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IzLgCQfl3dzgd96nwgqDe1fT2mCovkx9S4GfSwD0Jmo=;
	b=1xcA9FPVAZgwP1fuex1eXo+QLZJaT/2430gdmGlnkqpnv2a6wDx4+q9CAbsRQWe2F2gY
	 /9e2BcCa/UKNxnglus950L04MLciWwSAqyKg1e0oB5oKsoFN0J8sFWqgFwWb5P/ijVLcw
	 ydR9AbTNGn88Im2jdJlff6zP0ZiojIv2zy/46hq96mwYUN3v0gQnnWJke+DIH9NPodZ+F
	 z1pEu5viECyZFchFZLfMRJdF0u4L+y5FkMx16lHNHZAMH41wdrLSo07/3TUppc5nIPjld
	 lBCs4Rt9XiJ7oqqqhj4lu94QVfks5jwbYZ1ywvF/rjmYm6hyoQzpab4n+2ZjwePo83A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ulP4J+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C8606A31C;
	Wed, 28 Oct 2026 19:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ulP4J+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DE91F01825;
	Wed, 28 Oct 2026 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215603;
	bh=IzLgCQfl3dzgd96nwgqDe1fT2mCovkx9S4GfSwD0Jmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ulP4J+Cr0OQdBBaX49+OwkvZz4ykYov8HqPeeGSfZg/zENlhnvDU1v2IL4+4TqCl
	 GsnSOGEPSbybRhgva8fg2gjmVMVsidRj8E2Qgh1zjX+pKPqt0/fd4AyrhrMzKzEjyD
	 W5WTHObybQJYbnZH46jfCSWdUFvyja3+1o2DQlRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1266/1887] nvmet-tcp: fix page fragment cache leak in error path
Date: Wed, 28 Oct 2026 17:56:02 +0100
Message-ID: <20261028170528.232232985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/nvme/target/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8af62bd244864..6ae2402327601 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1744,6 +1744,14 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	nvmet_tcp_free_cmd(&queue->connect);
 out_ida_remove:
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
+	/*
+	 * Drain the page fragment cache if any allocations were done.
+	 * The first allocation using pf_cache is nvmet_tcp_alloc_cmd()
+	 * for queue->connect after ida_alloc().
+	 */
+	if (queue->pf_cache.va)
+		__page_frag_cache_drain(virt_to_head_page(queue->pf_cache.va),
+					queue->pf_cache.pagecnt_bias);
 out_free_queue:
 	kfree(queue);
 	return ret;
-- 
2.53.0



