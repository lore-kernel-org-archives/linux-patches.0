Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E15B3C0601;
	Sat, 17 Oct 2026 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259326; cv=none; b=KZlrZQUlk1aj9rW/3rkXt6YTbVpaiBwjYMwt9wRYleBwVx5WBZb5Qdso6+5NbbJjLlqJMZF/k9RV48xUasitsdTNr4MfYhUe4dwtXk5AbPGP6gDI7M1ftXMcu6g1fU1YYqcAKKPwX0k9frCs5pkxygV1TGaXMdGAd90JO19p1tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259326; c=relaxed/simple;
	bh=Q7jcv3RkAvgPk2ZsRDoEdu4dd4TIhvGc1LeiUKYWqnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttuJBBsNwyUv5pqv2Hwf6hTqjvL5sr/hMgJMvLSLqwuNEvfos1ko3rpMPbjmxQBZlRDVZ7mnDjtbiO0qWg9GXRIiGduMx2pTzYgxtZQjzBIngvmwXVUl70crdzVI3HDccG5a3JD3DrHZ8yxpp7qTvA0ibbCZLKhLXfh/ENudp+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TD/Bq6Vq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TD/Bq6Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657991F000C4;
	Sat, 17 Oct 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259324;
	bh=xABD7GdeUyAGWKIY9FTdMqr+A5CVDb1MykYvMcTg+Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD/Bq6VqtMIrgaThJXA/9VgXoWXQFAM8FH/GytJzbT0plcAHlBP62TAQxspwsQzj4
	 RKz3YoSYGY9Py6qmTJDCVtiROLQsEou5qlSBe20Aqs+sORcjy1CisAGf0kpneRAVqT
	 3bN0UYkDDSGnsu7hwn+MOeTSsJp7F2ntro7EyON4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1175/1674] nvmet-tcp: make nvmet_tcp_alloc_queue() a void function
Date: Sat, 17 Oct 2026 17:57:27 +0200
Message-ID: <20261017160501.311374706@linuxfoundation.org>
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

[ Upstream commit 4f8cce2d32a3011bff8c8a4bbc69bca5a7bdd030 ]

The return value from nvmet_tcp_alloc_queue() are just used to
figure out if sock_release() need to be called. So this patch
moves sock_release() into nvmet_tcp_alloc_queue() and make it
a void function.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 4dae39395609 ("nvmet-tcp: fix page fragment cache leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 15b2e05d13198..2e3814873d818 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1730,15 +1730,17 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	return ret;
 }
 
-static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
+static void nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 		struct socket *newsock)
 {
 	struct nvmet_tcp_queue *queue;
 	int ret;
 
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
-	if (!queue)
-		return -ENOMEM;
+	if (!queue) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
 
 	INIT_WORK(&queue->release_work, nvmet_tcp_release_queue_work);
 	INIT_WORK(&queue->io_work, nvmet_tcp_io_work);
@@ -1775,7 +1777,7 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	if (ret)
 		goto out_destroy_sq;
 
-	return 0;
+	return;
 out_destroy_sq:
 	mutex_lock(&nvmet_tcp_queue_mutex);
 	list_del_init(&queue->queue_list);
@@ -1787,7 +1789,9 @@ static int nvmet_tcp_alloc_queue(struct nvmet_tcp_port *port,
 	ida_free(&nvmet_tcp_queue_ida, queue->idx);
 out_free_queue:
 	kfree(queue);
-	return ret;
+out_release:
+	pr_err("failed to allocate queue, error %d\n", ret);
+	sock_release(newsock);
 }
 
 static void nvmet_tcp_accept_work(struct work_struct *w)
@@ -1804,11 +1808,7 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 				pr_warn("failed to accept err=%d\n", ret);
 			return;
 		}
-		ret = nvmet_tcp_alloc_queue(port, newsock);
-		if (ret) {
-			pr_err("failed to allocate queue\n");
-			sock_release(newsock);
-		}
+		nvmet_tcp_alloc_queue(port, newsock);
 	}
 }
 
-- 
2.53.0



