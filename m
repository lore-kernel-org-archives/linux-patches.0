Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A406340A93E;
	Thu, 17 Sep 2026 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670381; cv=none; b=tYCXirrtwo92FEzaUt4SZvgzzJtoTN5yk5UKNy9dWtrA3wxYzn+rLvA/5D0o3xYqAyd77gHya+X0SSSUKcSQgtmUtravgLc6PTwuqmvwqdGk9U2B9PDSzk3xsrKgzAfgDOgl5bkaZg6KVF1p+iTK/xkeDw1I90eGFcih/E5sC/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670381; c=relaxed/simple;
	bh=A88/rqlAmaq9P2EZBO1yVmqS98t5m1WusjthCttQA78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOb1YfFGALGwAPQcGyrvh8w9tPdyjYFXys8Q9BCo6cPEmuWoXazg/j/Iionv2G+HUkLz0drOO9K1XLju+/tzo64OqMIW0o4MDCrK3NGQ2xn4jTrp9bYl6CZpmjiMpV9aKCl7JriAlbKGH8eFfSRWa2TO2vcTmwCRFgL5D37I4Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7r8hXsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7r8hXsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57021F0089C;
	Thu, 17 Sep 2026 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670379;
	bh=2NWWluHCLDGjTfjg9XGaOJ32duN9heKNp6FW4jzBPEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7r8hXswAnnjgWZrj4M6+sD1OfRZmesUuDEkq3hwol76MmQt8rEWqaBHjT73+ujkd
	 skg6klRXWMzBS6qQnwJBcfh+7Mdc2me3AoUp1pseG9rkbu3wW+ckkYyhwZ0AB88Wt5
	 65+buWsvt7ikCP6RA4n+rqAueb4juuEsu6ncEibU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0646/1102] nvme-tcp: open-code nvme_tcp_queue_request() for R2T
Date: Thu, 17 Sep 2026 16:09:49 +0100
Message-ID: <20260917151556.367382703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 674f872b7cefab4564ec8b34c799a4a653e34513 ]

When handling an R2T PDU we short-circuit nvme_tcp_queue_request()
as we should not attempt to send consecutive PDUs. So open-code
nvme_tcp_queue_request() for R2T and drop the last argument.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Stable-dep-of: 08acb54b063a ("nvme-tcp: defer TLS inline send to io_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 545704f1efa63..8a6707a592930 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -406,7 +406,7 @@ static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
 }
 
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
-		bool sync, bool last)
+		bool last)
 {
 	struct nvme_tcp_queue *queue = req->queue;
 	bool empty;
@@ -420,7 +420,7 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 	 * are on the same cpu, so we don't introduce contention.
 	 */
 	if (queue->io_cpu == raw_smp_processor_id() &&
-	    sync && empty && mutex_trylock(&queue->send_mutex)) {
+	    empty && mutex_trylock(&queue->send_mutex)) {
 		nvme_tcp_send_all(queue);
 		mutex_unlock(&queue->send_mutex);
 	}
@@ -828,7 +828,9 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	req->ttag = pdu->ttag;
 
 	nvme_tcp_setup_h2c_data_pdu(req);
-	nvme_tcp_queue_request(req, false, true);
+
+	llist_add(&req->lentry, &queue->req_list);
+	queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 
 	return 0;
 }
@@ -2678,7 +2680,7 @@ static void nvme_tcp_submit_async_event(struct nvme_ctrl *arg)
 	init_llist_node(&ctrl->async_req.lentry);
 	INIT_LIST_HEAD(&ctrl->async_req.entry);
 
-	nvme_tcp_queue_request(&ctrl->async_req, true, true);
+	nvme_tcp_queue_request(&ctrl->async_req, true);
 }
 
 static void nvme_tcp_complete_timed_out(struct request *rq)
@@ -2831,7 +2833,7 @@ static blk_status_t nvme_tcp_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	nvme_start_request(rq);
 
-	nvme_tcp_queue_request(req, true, bd->last);
+	nvme_tcp_queue_request(req, bd->last);
 
 	return BLK_STS_OK;
 }
-- 
2.53.0



