Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C42812FF7D;
	Tue, 23 Jan 2024 00:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969034; cv=none; b=hF9K6dVXc0M5n0h9kPLL8iUgSQqZSKfD8eHUA0qXoZUUaexRy1W+FW8D4XCtgwpxKTXZx0ybS2D2LqUi/Sw3AxKxhfzHU9gyr3017jlB2FzvxknH5BWrF207/fZK8fxO7AVyAw2cLx5SIPv9bwKJmjcKUoBdEjerB0b0LPk3bk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969034; c=relaxed/simple;
	bh=IGVk8EKpb6HJlxhGpVTGxLvlcvvZTbWZzJxtVZY4kvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lidEE5dTwP0V8NbNf7D0oiG4AUqokmUy0p0NXl1OI+w+QFglVI0TU12DOEnK6gV0GIIjbvm9kQ9imoK8QwXkhpku4oAiiy+wHexVmEempAgI62UAjuQaxF6/RhpZkKoerj7iD+rS38Jl6g3pUZk5GGP2RBlrqclfIZK2lSrL2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OboMgV+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OboMgV+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CEAC433F1;
	Tue, 23 Jan 2024 00:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969033;
	bh=IGVk8EKpb6HJlxhGpVTGxLvlcvvZTbWZzJxtVZY4kvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OboMgV+JKSkxlehZGbRKZQ/kzLkO6VyrkbY8Qo096UIO4AG9yXAy7Y+xyzk5OWkVu
	 763I0bY5HMga+3Cx3OeByJHJ1yVIs1KoAVQwdj0Tc27enW0EmkAxpU7tmBBOpGHxgl
	 G0J1VX1cc5eUuE+G2sGQG3Z9mM1jcsD7FtiM+hcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/194] nvmet-tcp: Fix a kernel panic when host sends an invalid H2C PDU length
Date: Mon, 22 Jan 2024 15:58:21 -0800
Message-ID: <20240122235726.536393426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit efa56305908ba20de2104f1b8508c6a7401833be ]

If the host sends an H2CData command with an invalid DATAL,
the kernel may crash in nvmet_tcp_build_pdu_iovec().

Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
lr : nvmet_tcp_io_work+0x6ac/0x718 [nvmet_tcp]
Call trace:
  process_one_work+0x174/0x3c8
  worker_thread+0x2d0/0x3e8
  kthread+0x104/0x110

Fix the bug by raising a fatal error if DATAL isn't coherent
with the packet size.
Also, the PDU length should never exceed the MAXH2CDATA parameter which
has been communicated to the host in nvmet_tcp_handle_icreq().

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index e8c7135c4c11..1747d3c4fa32 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -18,6 +18,7 @@
 #include "nvmet.h"
 
 #define NVMET_TCP_DEF_INLINE_DATA_SIZE	(4 * PAGE_SIZE)
+#define NVMET_TCP_MAXH2CDATA		0x400000 /* 16M arbitrary limit */
 
 #define NVMET_TCP_RECV_BUDGET		8
 #define NVMET_TCP_SEND_BUDGET		8
@@ -818,7 +819,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 	icresp->hdr.pdo = 0;
 	icresp->hdr.plen = cpu_to_le32(icresp->hdr.hlen);
 	icresp->pfv = cpu_to_le16(NVME_TCP_PFV_1_0);
-	icresp->maxdata = cpu_to_le32(0x400000); /* 16M arbitrary limit */
+	icresp->maxdata = cpu_to_le32(NVMET_TCP_MAXH2CDATA);
 	icresp->cpda = 0;
 	if (queue->hdr_digest)
 		icresp->digest |= NVME_TCP_HDR_DIGEST_ENABLE;
@@ -866,6 +867,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 {
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
+	unsigned int plen;
 
 	if (likely(queue->nr_cmds)) {
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
@@ -889,7 +891,16 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		return -EPROTO;
 	}
 
+	plen = le32_to_cpu(data->hdr.plen);
 	cmd->pdu_len = le32_to_cpu(data->data_length);
+	if (unlikely(cmd->pdu_len != (plen - sizeof(*data)) ||
+		     cmd->pdu_len == 0 ||
+		     cmd->pdu_len > NVMET_TCP_MAXH2CDATA)) {
+		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
+		/* FIXME: use proper transport errors */
+		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
+	}
 	cmd->pdu_recv = 0;
 	nvmet_tcp_map_pdu_iovec(cmd);
 	queue->cmd = cmd;
-- 
2.43.0



