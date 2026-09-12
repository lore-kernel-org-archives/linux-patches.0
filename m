Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D7B202F71;
	Sat, 12 Sep 2026 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228063; cv=none; b=Y21gYyqrzWCJbUFqrW2XcU0ZCdzzEEyUThIJhU4XVCCM5GNGYHW5BFVlN+gDMW+QOUJAhe3ZfTuiyl4F6LbcmYqskW08jOMwgARI9B6vz3sBKUj7x4MI1TMrbuFnhwi2sUjMfPBhtSLbhuCMcs2OVofz6bkRgFFSlxLMI3VW6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228063; c=relaxed/simple;
	bh=BlpVqyo7DKssXzG93UzoRB8LDsN8e7RHuGWzuUQPboE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjco0WCnGxOksLYhieLFILWQNZwVuiT004MhL8G6b7BD+gCNE0G3pkYCpjDyuyu3VdhcJN2twRSXwwL4qVmh36WngObnCmKWTrpzfnl1C40OaAo/552z8qNDYBhLZN1rNZVlYVDZXJ1jMavzc7B8M1K1gFWCijr+xzis/Ynme2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIA1jfGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIA1jfGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839FE1F000FF;
	Sat, 12 Sep 2026 15:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228062;
	bh=JSK28NVJE1ysKwFw86QyOeVNTIecwcDisaaefCnbR5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIA1jfGx4uqo8mJ5Q05n/o28GTHRTXzJD97mylqdD3hW9qzh4Z27OUcitWCZx3PAE
	 IHi/Bf9Taz35giKodkqMqlnzt60V/NB2uCOjQDhRRc45uU03+XwV0gy4ebIGG9y1Fg
	 U7wn2AGGqYehx7fWabOjdHQECYjNhm3iJK1sjWQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0309/1191] nvmet-tcp: reject unsolicited H2CData PDUs
Date: Sat, 12 Sep 2026 08:50:37 +0200
Message-ID: <20260912065555.172472325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -61,6 +61,7 @@ enum nvmet_tcp_recv_state {
 
 enum {
 	NVMET_TCP_F_INIT_FAILED = (1 << 0),
+	NVMET_TCP_F_R2T_SENT	= (1 << 1),
 };
 
 struct nvmet_tcp_cmd {
@@ -722,6 +723,7 @@ static int nvmet_try_send_r2t(struct nvm
 		return -EAGAIN;
 
 	cmd->queue->snd_cmd = NULL;
+	cmd->flags |= NVMET_TCP_F_R2T_SENT;
 	return 1;
 }
 
@@ -997,6 +999,12 @@ static int nvmet_tcp_handle_h2c_data_pdu
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


