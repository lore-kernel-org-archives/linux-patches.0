Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACBD13DBB7;
	Tue, 23 Jan 2024 01:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971991; cv=none; b=GPqqsHjCXVy2E2rm8I5VOl3iUQba4XxiclJ5fHOUXVbznlGf+NNiD4hCY73/8F7gGhrz32LDIOn5jJvHnxrrAfThdWDXyds0noBr0pjaommmqWPvZ09MpwAiZTbrSnbyasUFALVz+FjpfZmB8CNISOU2KBt1LXJD0QDW3N4Cs+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971991; c=relaxed/simple;
	bh=uKa1UWUHB5p8RuxiQUXvF0EWdJJeDk68iSqQBrhbGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwVB3jaX/0IOeythoJj2JoqY0Sb7LYwDtFP266QEuVwaR0ySn9fvg9HbHa4yZuKEozikWbPBDHD35ODiwXaaY9pazMT0TxmjNoRQGlRO8bLkBEuUQTIoMRF2acdzvQglA2K3pGepYVgHwctAkBOAri+Fejl85hTg7vve6lpBAcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPi6KV00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPi6KV00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B411C433C7;
	Tue, 23 Jan 2024 01:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971991;
	bh=uKa1UWUHB5p8RuxiQUXvF0EWdJJeDk68iSqQBrhbGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oPi6KV00hOYYdryEjLZRAAb11IUOgDDKuRjOtae7C8zpYuXaIOo3ooHcOh+zhwfmi
	 vNNuxZfb3xL34ryZXkPrlAxGxoSaLODKkOGGElKlwBoRkV3Os4llSA08AXWwxd+z8Q
	 4IM5h/Ab2F8Xk5ck0gtMk6oq9ehlV9oB8e2O2WPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 373/417] nvmet-tcp: Fix the H2C expected PDU len calculation
Date: Mon, 22 Jan 2024 15:59:01 -0800
Message-ID: <20240122235804.731158798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6d46143bcfe8..ce42afe8f64e 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -915,7 +915,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 {
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
-	unsigned int plen;
+	unsigned int exp_data_len;
 
 	if (likely(queue->nr_cmds)) {
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
@@ -938,9 +938,13 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
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



