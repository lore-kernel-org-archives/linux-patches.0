Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ED34EB24;
	Tue, 23 Jan 2024 00:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970060; cv=none; b=QeFaxcl8dIRIn3mSnpm3RgQNXbiB43NfvOAMMGEizNNqScoqRSnQ5yNE9cEkR6gra7iOBVL0z05GsVq+mtkK+KKN5bzik/AIfuxq0W2ENlUB1FEwYS9ZJ3ZmgsdvjuE9GP5+XCaqyeUzhXK6YNvbEUuxvqaN5K+BHGKOGyFr75s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970060; c=relaxed/simple;
	bh=YpSnthyu7FYlNVxa0ewBwZiA0OwbikCbrm78ODeiJSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXVwtXStehp+1iSlKanp6peotNGuVBHSBxE04/e/5vBWnyrtAmL9HdSRYn0x9N1fRu9zV0NAUbzUZARPfbJvXP9vPItrpWSXhibdJvSdDYK4TkelAuqoxx94cgxSh3mrgFYdDYRtHBxPJSy/73O8+dPeSh5sSWIf3KJoK+CR/6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QomAitF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QomAitF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030CFC433F1;
	Tue, 23 Jan 2024 00:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970060;
	bh=YpSnthyu7FYlNVxa0ewBwZiA0OwbikCbrm78ODeiJSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QomAitF6XOI/f76GsFGges3MZuZsBQpWDn1988G+NO0laPMmWsETB8W1kY6dY0kjW
	 /RAyEs+wudJKVD+zGXy0x6kn2BAdwubQCsSyymEGxPU0En01sGxM+3SUxC+zxXzuIR
	 Zy70ubxjRJAnbmCBlNGPHbrNCT2f3VePrMgUrtbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 575/641] nvmet-tcp: Fix the H2C expected PDU len calculation
Date: Mon, 22 Jan 2024 15:57:59 -0800
Message-ID: <20240122235836.154484544@linuxfoundation.org>
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

[ Upstream commit 9a1abc24850eb759e36a2f8869161c3b7254c904 ]

The nvmet_tcp_handle_h2c_data_pdu() function should take into
consideration the possibility that the header digest and/or the data
digests are enabled when calculating the expected PDU length, before
comparing it to the value stored in cmd->pdu_len.

Fixes: efa56305908b ("nvmet-tcp: Fix a kernel panic when host sends an invalid H2C PDU length")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index e5a2cd9e8c13..80db64a4b09f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -979,7 +979,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 {
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
-	unsigned int plen;
+	unsigned int exp_data_len;
 
 	if (likely(queue->nr_cmds)) {
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
@@ -1002,9 +1002,13 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		return -EPROTO;
 	}
 
-	plen = le32_to_cpu(data->hdr.plen);
+	exp_data_len = le32_to_cpu(data->hdr.plen) -
+			nvmet_tcp_hdgst_len(queue) -
+			nvmet_tcp_ddgst_len(queue) -
+			sizeof(*data);
+
 	cmd->pdu_len = le32_to_cpu(data->data_length);
-	if (unlikely(cmd->pdu_len != (plen - sizeof(*data)) ||
+	if (unlikely(cmd->pdu_len != exp_data_len ||
 		     cmd->pdu_len == 0 ||
 		     cmd->pdu_len > NVMET_TCP_MAXH2CDATA)) {
 		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
-- 
2.43.0



