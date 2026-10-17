Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487AF374E60;
	Sat, 17 Oct 2026 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257617; cv=none; b=ted45s4RVzJE3xvtQE33o3z9wANSkOlCGNaslqDa8hRdgYpe+JJYlwjc6CagFgNyq2qf4Pas2YVY/o6Qye1DR4E8YGXWeHQ7zjTBqJhc0Ezo/9UGhB2TFIfNxIJuRRLKdXgNESXh6fGLB6YVv+6RGN0UpWM/+y99tXm8ZhnB8KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257617; c=relaxed/simple;
	bh=m5YFDB830duRBKdUlbp2H/Wf5Shu2Ghkqq3j3dR3Nws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCapSSnt9U4jYVXRwUEemUWiQtA8TA+Xmu0Lyr+cNjAS/i0PDUAIgfOMu5fFy/aZwjtKW/Kiu89CKQkbDbiGjNSm6Ooditl6K9IKVi/p55yxUQRRJAwyJffzpnvj0v4MD7PuBdqVuApoIWG8JpzFhkwz+XnbMHQBEiCzFCwu/cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqiWkMKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqiWkMKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955AC1F000C4;
	Sat, 17 Oct 2026 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257616;
	bh=e6PiSmKZQh18UIMBD96luVT20PIwbMdkp/RtDFrwPEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqiWkMKVXPJKQwIEdG79R9o8A07q6nTSe/oEDhwNsnQkKzLAK2Tt09oQ35RZFFCq5
	 Nl9wYptCqJvxRhZUaFtyTf40nuf8Dr6O2D9eBQj7Jz9HnBj0KHlXTJDelWCclxVfmV
	 E/luGOpxYNwpZanrA7vOtf0VNcsm13PePcMSSu58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0574/1674] nvme-tcp: sanitize request list handling
Date: Sat, 17 Oct 2026 17:47:26 +0200
Message-ID: <20261017160445.827251024@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 0bf04c874fcb1ae46a863034296e4b33d8fbd66c ]

Validate the request in nvme_tcp_handle_r2t() to ensure it's not part of
any list, otherwise a malicious R2T PDU might inject a loop in request
list processing.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 88489a787e677..e270024fe5490 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -385,7 +385,8 @@ nvme_tcp_fetch_request(struct nvme_tcp_queue *queue)
 			return NULL;
 	}
 
-	list_del(&req->entry);
+	list_del_init(&req->entry);
+	init_llist_node(&req->lentry);
 	return req;
 }
 
@@ -493,6 +494,8 @@ static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
 	req->queue = queue;
 	nvme_req(rq)->ctrl = &ctrl->ctrl;
 	nvme_req(rq)->cmd = &pdu->cmd;
+	init_llist_node(&req->lentry);
+	INIT_LIST_HEAD(&req->entry);
 
 	return 0;
 }
@@ -739,6 +742,14 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 		return -EPROTO;
 	}
 
+	if (llist_on_list(&req->lentry) ||
+	    !list_empty(&req->entry)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t while processing request\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	req->pdu_len = 0;
 	req->h2cdata_left = r2t_length;
 	req->h2cdata_offset = r2t_offset;
@@ -2374,6 +2385,8 @@ static void nvme_tcp_submit_async_event(struct nvme_ctrl *arg)
 	ctrl->async_req.offset = 0;
 	ctrl->async_req.curr_bio = NULL;
 	ctrl->async_req.data_len = 0;
+	init_llist_node(&ctrl->async_req.lentry);
+	INIT_LIST_HEAD(&ctrl->async_req.entry);
 
 	nvme_tcp_queue_request(&ctrl->async_req, true, true);
 }
-- 
2.53.0



