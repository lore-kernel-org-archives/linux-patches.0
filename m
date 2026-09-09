Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F5058596D;
	Wed,  9 Sep 2026 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963538; cv=none; b=lUAJFiuFmMwdGi7sqgbIf7tdAsSdIDrkqtRqdDG9IEn/iBlxnnqXis6g9kYq1F14dy+ADTwV6yB2ekM9k7MwEitPAP1YX9BW9wHp5ZT8RcOTya9QtV1tgyIOj5zjFLybbO6Hg4ONNnDl8BZLSlTi7mkIjJNGbqlK72jjb8I2nBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963538; c=relaxed/simple;
	bh=cycthVAkSinL6oSb5q9yHCqCduG5ytlDLQve9KSHLvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbZuOOOiT1LKPUS6WZ5Li8lZJjvswgs3QrgrXx6nmvZHBt5kC/vEenO80omZ7pFrsn6pHJDm7bcWqZXgu/1f1OR65WIkDVALM8Iiv4uc0F049svh/PC7W4WLvM1Wql74IaTC4GCNIXaSzSxmzlvH0IpzEnEHmCndt/lor1dEFhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwCoileg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwCoileg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE271F00A3D;
	Wed,  9 Sep 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963537;
	bh=4x0/tvnYB9zNnmL+8WrjIWFtbU/IKeetfYV9dIISoOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwCoilegVckWikWnkOWKT23ayQ61yVnZZDYjhHg5ymqNSJMS2X0Fk8nUKNh/Hvg5N
	 PucT3G1+yEljCD61pFpyMdt/LNrYYuvJyFruwajgWNdsdA3dk+Yy9kpJ4DG+by7UPD
	 hj2sEPllN8k/CXeENBNE7Zx1aQequKGTsjm6QUgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 112/583] nvmet-tcp: reject unsolicited H2CData PDUs
Date: Wed,  9 Sep 2026 15:36:37 +0200
Message-ID: <20260909134242.013180177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivam Kumar <kumar.shivam43666@gmail.com>

commit db62b35cbca052860c519cbcabe7650708528738 upstream.

nvmet_tcp_handle_h2c_data_pdu() accepts an H2CData PDU after only checking
that its TTAG is a valid in-range command index and that the command's
data buffers are mapped. It never checks that the target has actually
solicited that data by sending an R2T for the command.

A remote host can abuse this. It submits a write command that takes the
R2T path and, before the target transmits the R2T, sends an H2CData PDU
for that command's tag. The data completes the command early, and when
the command then fails synchronously (e.g. a length mismatch caught by
nvmet_check_transfer_len()), it is completed a second time. Each
completion calls nvmet_tcp_queue_response(), so the same command is added
to queue->resp_list twice while it is still linked; the second llist_add()
makes the node point to itself (lentry->next == lentry).

nvmet_tcp_process_resp_list() then walks that self-referential node and
adds the command to resp_send_list twice. With CONFIG_DEBUG_LIST this
trips the "list_add double add" check (kernel BUG); without it the loop
never terminates and the nvmet_tcp workqueue wedges (soft-lockup). It is
remotely triggerable and needs no authentication on an allow_any_host
subsystem.

Track whether an R2T has been transmitted for a command and reject an
H2CData PDU that arrives before it. The flag is cleared on command reuse
(nvmet_tcp_get_cmd() zeroes cmd->flags) and stays set across the multiple
H2CData PDUs of a single solicited transfer.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: stable@vger.kernel.org
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -103,6 +103,7 @@ enum nvmet_tcp_recv_state {
 
 enum {
 	NVMET_TCP_F_INIT_FAILED = (1 << 0),
+	NVMET_TCP_F_R2T_SENT	= (1 << 1),
 };
 
 struct nvmet_tcp_cmd {
@@ -787,6 +788,7 @@ static int nvmet_try_send_r2t(struct nvm
 		return -EAGAIN;
 
 	cmd->queue->snd_cmd = NULL;
+	cmd->flags |= NVMET_TCP_F_R2T_SENT;
 	return 1;
 }
 
@@ -1022,6 +1024,12 @@ static int nvmet_tcp_handle_h2c_data_pdu
 		cmd = &queue->connect;
 	}
 
+	if (unlikely(!(cmd->flags & NVMET_TCP_F_R2T_SENT))) {
+		pr_err("queue %d: unsolicited H2CData (ttag %u)\n",
+		       queue->idx, data->ttag);
+		goto err_proto;
+	}
+
 	if (le32_to_cpu(data->data_offset) != cmd->rbytes_done) {
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
 			data->ttag, le32_to_cpu(data->data_offset),


