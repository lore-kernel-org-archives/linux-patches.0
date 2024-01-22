Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8F3110A;
	Tue, 23 Jan 2024 02:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975759; cv=none; b=XjrGZ0ZpcUnZGhqYApbjXdbYTZ+mGDq1ztxedUz0CFMdhhuoJ03A56arXuQMmicD6Apgm7txpK8KblJpdlIonqFuU1R93Y/HPBYNff0fkIVLW9kwbWd3LgM9xbN6sKThn+iRlLqzkbh6FPZBP+QzQEkaRMg1e8+j2E8hbyb3q6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975759; c=relaxed/simple;
	bh=DFpd0iQggj+gP2gogvA0yALDmpvcuDOG/XjRkp0iMyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTxGGL07kzcq9pl0TUXJK/mKyE1UPMPjELjnNuUMiXRw2X2TVylzq+c6u0vmr7GUmS4e8OYbDExpMGVYBcGqyPZ0qPhZuEVNamXqGeU4J6kLbNsrKE9za8Xf+oOf2Usu2wLUJR+JxuyxaFJxqgHa71/mw1zoynt2tZW9F+A8Xy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd3mFKnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd3mFKnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81612C43394;
	Tue, 23 Jan 2024 02:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975759;
	bh=DFpd0iQggj+gP2gogvA0yALDmpvcuDOG/XjRkp0iMyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd3mFKnN5x5fVpTH8pwz8Lj3Ezrc3zggdsNdVnMSYzJassX0AyZqvANzVbm1gV+pW
	 gF91C7JKpfP32KzWdglXcs8rAKkn0DcgVEBZmqogNAyJ5ojcy3YJ39DnoQsY98ge+f
	 P1taTzrLmd+P+5OG8q1U1vAGIxxTu3ZOzzRiE134=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 519/583] nvmet-tcp: Fix the H2C expected PDU len calculation
Date: Mon, 22 Jan 2024 15:59:30 -0800
Message-ID: <20240122235827.958337405@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7f7fa78f0698..a4f802790ca0 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -954,7 +954,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 {
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
-	unsigned int plen;
+	unsigned int exp_data_len;
 
 	if (likely(queue->nr_cmds)) {
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
@@ -977,9 +977,13 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
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



