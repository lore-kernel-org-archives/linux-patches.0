Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ADE28312F;
	Mon,  9 Feb 2026 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648752; cv=none; b=bCn62tmwu78ri0+mwa7FCnHw1dN0M/oDr9zJmEi1i/T70GVg1AGjubo54biqOxyqrhzmvvCrinYV/uCfhvQ6F3zp5yqVvm9YWKBP4qb3wQfQew+bL3mPe7WgPPZe0gmXDcLxy2cZ/zC+Vq1zxy8dZ/J/fS83D1oR0uqy8yHU3Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648752; c=relaxed/simple;
	bh=3AfTZfkKwIyM4oS9FkGOrVB87bOy7k2+0DCrVP4ks5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmGmy4HbepYTRSWO86dP39veRgR2+J9fMyXZ2ZAKdQbv9JqL2kKTEvWEhAWsaYDaUR5ET5szPq/ULTiY4/rK3bzVDetHaVWHgSXU3+byWMLWRox2lT/BAvEGZXMTHodslCf4BzNyMk2vvQljrp45itI+jkFFCWs9ZxPlQhP8oSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnWxMJk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnWxMJk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E961C116C6;
	Mon,  9 Feb 2026 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648751;
	bh=3AfTZfkKwIyM4oS9FkGOrVB87bOy7k2+0DCrVP4ks5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnWxMJk/dG8P9pPRhSOn68tIlasTBNXBi6FibwJZxj6/WMKCFjrCVqRlEh3h9owL6
	 Z1rMKa30LkGT+BKqrheAarIiLB1b0LbwtIfhCWrbLp3syJl1V9x3BMZjMkptov5qRq
	 CIx3i7N0wWnmW8oUhZFzGQDhofdmWSGtAKoWYSaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/41] nvmet-tcp: fix regression in data_digest calculation
Date: Mon,  9 Feb 2026 15:24:54 +0100
Message-ID: <20260209142258.009158684@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit ed0691cf55140ce0f3fb100225645d902cce904b ]

Data digest calculation iterates over command mapped iovec. However
since commit bac04454ef9f we unmap the iovec before we handle the data
digest, and since commit 69b85e1f1d1d we clear nr_mapped when we unmap
the iov.

Instead of open-coding the command iov traversal, simply call
crypto_ahash_digest with the command sg that is already allocated (we
already do that for the send path). Rename nvmet_tcp_send_ddgst to
nvmet_tcp_calc_ddgst and call it from send and recv paths.

Fixes: 69b85e1f1d1d ("nvmet-tcp: add an helper to free the cmd buffers")
Fixes: bac04454ef9f ("nvmet-tcp: fix kmap leak when data digest in use")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 52a0a9854934 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index bf34849c15a20..bc0e860a2887f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -395,7 +395,7 @@ static int nvmet_tcp_map_data(struct nvmet_tcp_cmd *cmd)
 	return NVME_SC_INTERNAL;
 }
 
-static void nvmet_tcp_send_ddgst(struct ahash_request *hash,
+static void nvmet_tcp_calc_ddgst(struct ahash_request *hash,
 		struct nvmet_tcp_cmd *cmd)
 {
 	ahash_request_set_crypt(hash, cmd->req.sg,
@@ -403,23 +403,6 @@ static void nvmet_tcp_send_ddgst(struct ahash_request *hash,
 	crypto_ahash_digest(hash);
 }
 
-static void nvmet_tcp_recv_ddgst(struct ahash_request *hash,
-		struct nvmet_tcp_cmd *cmd)
-{
-	struct scatterlist sg;
-	struct kvec *iov;
-	int i;
-
-	crypto_ahash_init(hash);
-	for (i = 0, iov = cmd->iov; i < cmd->nr_mapped; i++, iov++) {
-		sg_init_one(&sg, iov->iov_base, iov->iov_len);
-		ahash_request_set_crypt(hash, &sg, NULL, iov->iov_len);
-		crypto_ahash_update(hash);
-	}
-	ahash_request_set_crypt(hash, NULL, (void *)&cmd->exp_ddgst, 0);
-	crypto_ahash_final(hash);
-}
-
 static void nvmet_setup_c2h_data_pdu(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvme_tcp_data_pdu *pdu = cmd->data_pdu;
@@ -444,7 +427,7 @@ static void nvmet_setup_c2h_data_pdu(struct nvmet_tcp_cmd *cmd)
 
 	if (queue->data_digest) {
 		pdu->hdr.flags |= NVME_TCP_F_DDGST;
-		nvmet_tcp_send_ddgst(queue->snd_hash, cmd);
+		nvmet_tcp_calc_ddgst(queue->snd_hash, cmd);
 	}
 
 	if (cmd->queue->hdr_digest) {
@@ -1156,7 +1139,7 @@ static void nvmet_tcp_prep_recv_ddgst(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvmet_tcp_queue *queue = cmd->queue;
 
-	nvmet_tcp_recv_ddgst(queue->rcv_hash, cmd);
+	nvmet_tcp_calc_ddgst(queue->rcv_hash, cmd);
 	queue->offset = 0;
 	queue->left = NVME_TCP_DIGEST_LENGTH;
 	queue->rcv_state = NVMET_TCP_RECV_DDGST;
-- 
2.51.0



