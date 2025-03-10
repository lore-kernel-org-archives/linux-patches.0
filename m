Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9651156861;
	Mon, 10 Mar 2025 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630968; cv=none; b=VQULw5ZemKHHarT58gb91qUGf3qhgVxec9Vx43ouVOVuWvOkk4xoGTSgdQ2IL5V70tuPwCWzO73QTZ8X+JdSPY5aHfO6mrISFrvMCVL9N/JELS6G0fqTsO+rK2MPk7+zh/9TMwSQLonwNNXudv2u811+k5Wt3SZ6XIGcHbYi0HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630968; c=relaxed/simple;
	bh=pyW/GzeBJ7yJvpGOUzXJoIr8PaJNmiwNu3q68hUc01A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAYgwvFMFw5BcswQqzUMQ8g+Wdwjdj6t6K7iNE1b4F7xeXdrDBo016Y2idAnHwqwnQ6JU58M2n+Fp8EnjOqFFbEcYKrWRqmj9Ke5UOIN5P6YCezIgEiJ8FXfSgMxe93pykl2CQmGSqyRd7Tt3GURbIEliYqbRH6WK+cmXDuKK5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4JHCXiL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4JHCXiL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC3FC4CEE5;
	Mon, 10 Mar 2025 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630967;
	bh=pyW/GzeBJ7yJvpGOUzXJoIr8PaJNmiwNu3q68hUc01A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4JHCXiLuPSzatdNB9LlRpAIyjSkqBTYXxGtJrI/eG7YbiwH8qf6UjDc5afFdord3
	 TVtdI/tQsDQii90IAr+jfzTx1owyTHixoI+d6VICezH/JR6wJXEcJQ5YgkF++vI3Rf
	 dKTTTLoaDuduM9bLPFAy+mDNgQ28azDMgppt2dcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meir Elisha <meir.elisha@volumez.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 555/620] nvmet-tcp: Fix a possible sporadic response drops in weakly ordered arch
Date: Mon, 10 Mar 2025 18:06:41 +0100
Message-ID: <20250310170607.455370641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meir Elisha <meir.elisha@volumez.com>

[ Upstream commit a16f88964c647103dad7743a484b216d488a6352 ]

The order in which queue->cmd and rcv_state are updated is crucial.
If these assignments are reordered by the compiler, the worker might not
get queued in nvmet_tcp_queue_response(), hanging the IO. to enforce the
the correct reordering, set rcv_state using smp_store_release().

Fixes: bdaf13279192 ("nvmet-tcp: fix a segmentation fault during io parsing error")

Signed-off-by: Meir Elisha <meir.elisha@volumez.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 809b03b86a009..2bf2c775f7451 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -539,10 +539,16 @@ static void nvmet_tcp_queue_response(struct nvmet_req *req)
 	struct nvmet_tcp_cmd *cmd =
 		container_of(req, struct nvmet_tcp_cmd, req);
 	struct nvmet_tcp_queue	*queue = cmd->queue;
+	enum nvmet_tcp_recv_state queue_state;
+	struct nvmet_tcp_cmd *queue_cmd;
 	struct nvme_sgl_desc *sgl;
 	u32 len;
 
-	if (unlikely(cmd == queue->cmd)) {
+	/* Pairs with store_release in nvmet_prepare_receive_pdu() */
+	queue_state = smp_load_acquire(&queue->rcv_state);
+	queue_cmd = READ_ONCE(queue->cmd);
+
+	if (unlikely(cmd == queue_cmd)) {
 		sgl = &cmd->req.cmd->common.dptr.sgl;
 		len = le32_to_cpu(sgl->length);
 
@@ -551,7 +557,7 @@ static void nvmet_tcp_queue_response(struct nvmet_req *req)
 		 * Avoid using helpers, this might happen before
 		 * nvmet_req_init is completed.
 		 */
-		if (queue->rcv_state == NVMET_TCP_RECV_PDU &&
+		if (queue_state == NVMET_TCP_RECV_PDU &&
 		    len && len <= cmd->req.port->inline_data_size &&
 		    nvme_is_write(cmd->req.cmd))
 			return;
@@ -806,8 +812,9 @@ static void nvmet_prepare_receive_pdu(struct nvmet_tcp_queue *queue)
 {
 	queue->offset = 0;
 	queue->left = sizeof(struct nvme_tcp_hdr);
-	queue->cmd = NULL;
-	queue->rcv_state = NVMET_TCP_RECV_PDU;
+	WRITE_ONCE(queue->cmd, NULL);
+	/* Ensure rcv_state is visible only after queue->cmd is set */
+	smp_store_release(&queue->rcv_state, NVMET_TCP_RECV_PDU);
 }
 
 static void nvmet_tcp_free_crypto(struct nvmet_tcp_queue *queue)
-- 
2.39.5



