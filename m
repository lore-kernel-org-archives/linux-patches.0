Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A9E3BF699;
	Sat, 17 Oct 2026 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259330; cv=none; b=J6ll5Com6+/Ts3oxcDV+bp80xFG07+UgewggCX0hsHIyYvK1rm8KyjvsHhUSVk2562oe1ig0uwMKn1A01nmcJB/wrNOIGj3SFkjKZtI3kFw5AIfgX+Wm3yYqaDY+bWvKvsDnOGgnhwXCzaL3HxKXsKDe7ZQO5U8sG9KpZbAHIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259330; c=relaxed/simple;
	bh=7j5htXwUNTf8GhKZ4AQGGOFLKXVJt5c6DAxYNPvWFfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1nBkPtAFh9gyx+FVu8/8Pt9up/DNwlSZvzM1DU4y2tSgG/PUkOnunRLNhvqg7tt5tEmfnkEOmPBO8CkEm5Xu9RzqKfAs7FJDtOZh/0/FNcHpB5xbHxPPMCpso0hGkt02vqnCqzhiudA8eVeL3BYGCarX5zUA0KcmXijhgyzEIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2LJ9YmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2LJ9YmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AAE1F000C4;
	Sat, 17 Oct 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259327;
	bh=TMilb9qp5lrhDyiqfCW1XqNWM59LanzboLoBXF3iZL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2LJ9YmM7+9kCAb4trcUXFm88OBF/59YsSQvAXkU1yVbUjxKsHWRK+QJ94vUcqetj
	 kBbUrNHLHl0H2igdmcDa7rnmLtQpZNMD5Ir5gg1lTGMRV6gfCh4FgEdhrl6DJaMyCt
	 t0Vrlaf6f69CPjO0ShOG6A/1KCVLbCqLj84sbnqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1176/1674] nvmet-tcp: allocate socket file
Date: Sat, 17 Oct 2026 17:57:28 +0200
Message-ID: <20261017160501.336810195@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 79a4f186ad37423996e7835e9d3d6055ff1a181d ]

For the TLS upcall we need to allocate a socket file such
that the userspace daemon is able to use the socket.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 4dae39395609 ("nvmet-tcp: fix page fragment cache leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 2e3814873d818..c6610b7fc9560 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1602,12 +1602,12 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	nvmet_sq_destroy(&queue->nvme_sq);
 	cancel_work_sync(&queue->io_work);
 	nvmet_tcp_free_cmd_data_in_buffers(queue);
-	sock_release(queue->sock);
+	/* ->sock will be released by fput() */
+	fput(queue->sock->file);
 	nvmet_tcp_free_cmds(queue);
 	if (queue->hdr_digest || queue->data_digest)
 		nvmet_tcp_free_crypto(queue);
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
-
 	page = virt_to_head_page(queue->pf_cache.va);
 	__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
 	kfree(queue);
@@ -1734,6 +1734,7 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 		struct socket *newsock)
 {
 	struct nvmet_tcp_queue *queue;
+	struct file *sock_file = NULL;
 	int ret;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
@@ -1753,10 +1754,16 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	init_llist_head(&queue->resp_list);
 	INIT_LIST_HEAD(&queue->resp_send_list);
 
+	sock_file = sock_alloc_file(queue->sock, O_CLOEXEC, NULL);
+	if (IS_ERR(sock_file)) {
+		ret = PTR_ERR(sock_file);
+		goto out_free_queue;
+	}
+
 	queue->idx = ida_alloc(&nvmet_tcp_queue_ida, GFP_KERNEL);
 	if (queue->idx < 0) {
 		ret = queue->idx;
-		goto out_free_queue;
+		goto out_sock;
 	}
 
 	ret = nvmet_tcp_alloc_cmd(queue, &queue->connect);
@@ -1787,11 +1794,14 @@ static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	nvmet_tcp_free_cmd(&queue->connect);
 out_ida_remove:
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
+out_sock:
+	fput(queue->sock->file);
 out_free_queue:
 	kfree(queue);
 out_release:
 	pr_err("failed to allocate queue, error %d\n", ret);
-	sock_release(newsock);
+	if (!sock_file)
+		sock_release(newsock);
 }
 
 static void nvmet_tcp_accept_work(struct work_struct *w)
-- 
2.53.0



