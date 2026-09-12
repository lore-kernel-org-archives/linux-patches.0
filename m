Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C0826ED46;
	Sat, 12 Sep 2026 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240768; cv=none; b=Ss4afc3sHg9E2LMGV4kfP+EIzuQP4jbju/jzY7SQW8yTt00d4S7JOAupjw1rGwZgvZsQs69vuvNJkbAMVJST8KW+k+Dl36FiyuyH6Uz4Obh5R+vutWC1ZqQmFFeiHKaI8ERcjjXwxRaruAnpndlzff/jf0rl4fgjNa1+dy61mQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240768; c=relaxed/simple;
	bh=a/uqTYcQFLVwIVzzGJpQ496jF0MGIeZVg0XHd3NOuHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isbW9NGIKsFh+4aROhxFElmwxv/E9Fh/fBIo4UkQ7uVDb8q3mQddZrVG+9d+2RTA/1TaKanCNxwrtk8GlLxPCVsaClQ+0NrB670m6IgMvzTz4zEONwtUTW5CMH5pvRw/5O9dMjSs7j9QcTQbXaV7+d2gw9EW6ZGt27BifnTFHdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nb63v86N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nb63v86N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D174F1F000FF;
	Sat, 12 Sep 2026 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240767;
	bh=0o4n85wNJYRCOVZCA1i1jBb2QOIvfRZJv53bbp/tYHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nb63v86NrGe0+Q1alx0XmLJ1T6arYtynmvAi6AJ+s1FWLrr8+ZzURrfEldRS3Qv1h
	 8czj5KSAGOM5VTRUAVZ1P8+FsvxATcSyoQgFo5lJme4L7B+JnWSMrcqmWejxxCRR0S
	 Cjimb0kSQQTyhLWtKvYxQPQIzirrIEFXZ7ivpLkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 934/935] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Sat, 12 Sep 2026 09:06:04 +0200
Message-ID: <20260912065548.241462764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

commit fb1ed67788e21832b614c23767a088c08cfdd2f2 upstream.

When pending disconnecting queues exceed the backlog limit, the
connect path only drops the device reference and leaks the newly
allocated queue and its IB resources.

Fixes: badc53620fe8 ("nvme: target: rdma: fix ndev refcount leak on queue connect")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1627,19 +1627,13 @@ static int nvmet_rdma_queue_connect(stru
 		mutex_unlock(&nvmet_rdma_queue_mutex);
 		if (pending > NVMET_RDMA_BACKLOG) {
 			ret = NVME_SC_CONNECT_CTRL_BUSY;
-			goto put_device;
+			goto free_queue;
 		}
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
-	if (ret) {
-		/*
-		 * Don't destroy the cm_id in free path, as we implicitly
-		 * destroy the cm_id here with non-zero ret code.
-		 */
-		queue->cm_id = NULL;
+	if (ret)
 		goto free_queue;
-	}
 
 	mutex_lock(&nvmet_rdma_queue_mutex);
 	list_add_tail(&queue->queue_list, &nvmet_rdma_queue_list);
@@ -1648,6 +1642,11 @@ static int nvmet_rdma_queue_connect(stru
 	return 0;
 
 free_queue:
+	/*
+	 * Don't destroy the cm_id in free path, as we implicitly
+	 * destroy the cm_id here with non-zero ret code.
+	 */
+	queue->cm_id = NULL;
 	nvmet_rdma_free_queue(queue);
 put_device:
 	kref_put(&ndev->ref, nvmet_rdma_free_dev);


