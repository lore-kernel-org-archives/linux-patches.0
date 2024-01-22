Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5896537F7;
	Tue, 23 Jan 2024 00:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970097; cv=none; b=IVKxD40caLb4EzgskGQHZ9q4bCau9X+jeCtPBvGsH0EiBqamD/M0H+RjHq9fa1n7M+vct71XyAWz80wCa79l/VpwRSc/JS0uWluuThx73wZrMd4ZNRDuDAczHZRUnlIcwzrVORKdxvDDdyb9s2+cc9WHiNkHyEQRp5G+MbxKXuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970097; c=relaxed/simple;
	bh=picb0tIOyorXWYzJIdB1pxQ7P+5AVxluWmRxdXgq0YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR77I6AwQj57alyQi1P/n/GLk+k4IAS/nJRbShnvy3qp75IjumOXkFE5jadHXWgrSPOnUzsLtgIARDDoE2PfgO7VDZ9EKksK2rp0mUMBKy5c1q6My0hb/dhD2sZyaSV06rDUKyxVArYz9hGr5TQsAxliMMPwNdl2YXKumv1vxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvFEotmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvFEotmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67257C433F1;
	Tue, 23 Jan 2024 00:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970097;
	bh=picb0tIOyorXWYzJIdB1pxQ7P+5AVxluWmRxdXgq0YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QvFEotmxT6w8sPucSEMYbo5dKHq205lpc35ON62qIt+yW0gqAZF7mmn7uoZOZWGt7
	 L1arEs5pyNgsPD0ZZzYZkcKSIEnaXbtqKUhPedEIctTgWLuL1LUhNPgNqltOTpOXNG
	 GciAOiqXh9dc/2DLEsidzQgfoFZDvll/5edLLm5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 553/641] nvmet-tcp: Fix a kernel panic when host sends an invalid H2C PDU length
Date: Mon, 22 Jan 2024 15:57:37 -0800
Message-ID: <20240122235835.447650515@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 4cc27856aa8f..ad16795934b8 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -24,6 +24,7 @@
 #include "nvmet.h"
 
 #define NVMET_TCP_DEF_INLINE_DATA_SIZE	(4 * PAGE_SIZE)
+#define NVMET_TCP_MAXH2CDATA		0x400000 /* 16M arbitrary limit */
 
 static int param_store_val(const char *str, int *val, int min, int max)
 {
@@ -923,7 +924,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 	icresp->hdr.pdo = 0;
 	icresp->hdr.plen = cpu_to_le32(icresp->hdr.hlen);
 	icresp->pfv = cpu_to_le16(NVME_TCP_PFV_1_0);
-	icresp->maxdata = cpu_to_le32(0x400000); /* 16M arbitrary limit */
+	icresp->maxdata = cpu_to_le32(NVMET_TCP_MAXH2CDATA);
 	icresp->cpda = 0;
 	if (queue->hdr_digest)
 		icresp->digest |= NVME_TCP_HDR_DIGEST_ENABLE;
@@ -978,6 +979,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 {
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
+	unsigned int plen;
 
 	if (likely(queue->nr_cmds)) {
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
@@ -1001,7 +1003,16 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
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
 	nvmet_tcp_build_pdu_iovec(cmd);
 	queue->cmd = cmd;
-- 
2.43.0



