Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DB73C0A16;
	Tue, 12 May 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608034; cv=none; b=gw+ZkGAikiOmf6TsWwHglYhNvM/JHKCq9tejOD+PcVdT8J1mKNDWkMeczu/JVsJVuLf3j6SAGOtJ/rk/xg0IfH93sK5c5qeQeIO6OqikjBGqiorQ4nYm4p32lVudkDeWo31zEwkQQmKzPBhLBmPGlZDEoZ8dOqlnh3eexcArEGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608034; c=relaxed/simple;
	bh=zJIR4OBQM7L1NC4VtHyE1Mu0EvCodpy8McqACrNlzHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKIfiYRMacomE0YTR/2FbQQ5JQRSGi/KHIvEd5A890cYy0P2j5a4JAQ5HiNtNns55YamDTB5upUbLaxzPqfQJi2M9f+Lp3hzAPihLB/6mf02pJUy/UYIAbsF2AyCfDi0Iii2UMtlkdziTHPG8ZW03LVfAQBsijx/fF1jaZAhW90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOb1XRDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOb1XRDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAD8C4AF18;
	Tue, 12 May 2026 17:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608033;
	bh=zJIR4OBQM7L1NC4VtHyE1Mu0EvCodpy8McqACrNlzHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOb1XRDYTwDU/GCD9z/EaC/kvJ4UL14dHFiyS0RqBJCtN6Jt859Qe9tHoo6UUeZEA
	 IhAQJQ2ev4n5q4HoqG3ULFFnprsygx1Tp+296E5n8s8Ilz6r7B7lT1c1b3+NgBmUb4
	 HG93iJtaIP869odhzsyPfQy3Xl3TwltyNu/bZSDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <skumar47@syr.edu>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 130/206] nvmet-tcp: fix race between ICReq handling and queue teardown
Date: Tue, 12 May 2026 19:39:42 +0200
Message-ID: <20260512173935.611224652@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Chaitanya Kulkarni <kch@nvidia.com>

commit 5293a8882c549fab4a878bc76b0b6c951f980a61 upstream.

nvmet_tcp_handle_icreq() updates queue->state after sending an
Initialization Connection Response (ICResp), but it does so without
serializing against target-side queue teardown.

If an NVMe/TCP host sends an Initialization Connection Request
(ICReq) and immediately closes the connection, target-side teardown
may start in softirq context before io_work drains the already
buffered ICReq. In that case, nvmet_tcp_schedule_release_queue()
sets queue->state to NVMET_TCP_Q_DISCONNECTING and drops the queue
reference under state_lock.

If io_work later processes that ICReq, nvmet_tcp_handle_icreq() can
still overwrite the state back to NVMET_TCP_Q_LIVE. That defeats the
DISCONNECTING-state guard in nvmet_tcp_schedule_release_queue() and
allows a later socket state change to re-enter teardown and issue a
second kref_put() on an already released queue.

The ICResp send failure path has the same problem. If teardown has
already moved the queue to DISCONNECTING, a send error can still
overwrite the state with NVMET_TCP_Q_FAILED, again reopening the
window for a second teardown path to drop the queue reference.

Fix this by serializing both post-send state transitions with
state_lock and bailing out if teardown has already started.

Use -ESHUTDOWN as an internal sentinel for that bail-out path rather
than propagating it as a transport error like -ECONNRESET. Keep
nvmet_tcp_socket_error() setting rcv_state to NVMET_TCP_RECV_ERR before
honoring that sentinel so receive-side parsing stays quiesced until the
existing release path completes.

Fixes: c46a6465bac2 ("nvmet-tcp: add NVMe over TCP target driver")
Cc: stable@vger.kernel.org
Reported-by: Shivam Kumar <skumar47@syr.edu>
Tested-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -406,6 +406,19 @@ static void nvmet_tcp_build_pdu_iovec(st
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue)
 {
+	/*
+	 * Keep rcv_state at RECV_ERR even for the internal -ESHUTDOWN path.
+	 * nvmet_tcp_handle_icreq() can return -ESHUTDOWN after the ICReq has
+	 * already been consumed and queue teardown has started.
+	 *
+	 * If nvmet_tcp_data_ready() or nvmet_tcp_write_space() queues
+	 * nvmet_tcp_io_work() again before nvmet_tcp_release_queue_work()
+	 * cancels it, the queue must not keep that old receive state.
+	 * Otherwise the next nvmet_tcp_io_work() run can reach
+	 * nvmet_tcp_done_recv_pdu() and try to handle the same ICReq again.
+	 *
+	 * That is why queue->rcv_state needs to be updated before we return.
+	 */
 	queue->rcv_state = NVMET_TCP_RECV_ERR;
 	if (queue->nvme_sq.ctrl)
 		nvmet_ctrl_fatal_error(queue->nvme_sq.ctrl);
@@ -962,11 +975,24 @@ static int nvmet_tcp_handle_icreq(struct
 	iov.iov_len = sizeof(*icresp);
 	ret = kernel_sendmsg(queue->sock, &msg, &iov, 1, iov.iov_len);
 	if (ret < 0) {
+		spin_lock_bh(&queue->state_lock);
+		if (queue->state == NVMET_TCP_Q_DISCONNECTING) {
+			spin_unlock_bh(&queue->state_lock);
+			return -ESHUTDOWN;
+		}
 		queue->state = NVMET_TCP_Q_FAILED;
+		spin_unlock_bh(&queue->state_lock);
 		return ret; /* queue removal will cleanup */
 	}
 
+	spin_lock_bh(&queue->state_lock);
+	if (queue->state == NVMET_TCP_Q_DISCONNECTING) {
+		spin_unlock_bh(&queue->state_lock);
+		/* Tell nvmet_tcp_socket_error() teardown is in progress. */
+		return -ESHUTDOWN;
+	}
 	queue->state = NVMET_TCP_Q_LIVE;
+	spin_unlock_bh(&queue->state_lock);
 	nvmet_prepare_receive_pdu(queue);
 	return 0;
 }


