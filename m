Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566BE321457;
	Sat, 12 Sep 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221388; cv=none; b=diWphsBdJ7tB3n+QmqWUXDOoHGwxcHbE408QmG0IkIKt8cUhrVBQIAnQ4m9E6EgnGLcVyjbTrA4O57EF40++1OuitREX9GdZKOdZZRpvHxXUSvb4x/DhFKvW/Mkm4GSmW/ga6zG78KHA5RcCN86XGlmFZAoTZKWUWXyI68dkZDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221388; c=relaxed/simple;
	bh=7+hyM+nX3jueGrlUvuDFbuJHz/5KTqdgaAUk0IG9IpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZBZJpX3I5YcCG70DdizXwKv6dHRnHWFas+VUelPZSj30+2vqc4TQEpKdEjKVDuUGt2f9sW1KGO7X/d0rtMPC7PkoNvyiHno3pC1BYfs4W5nKMQvizI0uwpOdb478NewGkl5zpcQE4fAdi1ec4SrlThParE/8TfCb8fNYB/wIuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh3UX35p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh3UX35p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B474A1F00898;
	Sat, 12 Sep 2026 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221387;
	bh=cqZv7FaVg+Lf4xm6uPPwsne0t1JUWLFWKV2cDe7kDPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh3UX35peldWzAskC0q3Z4DQoZ4d8yuLKXM4WzZubM4OC2ZtPJkPs+McGxFEyxZLA
	 ePfE2Nl/PKP+XOA5Pi4WcbGW+vpZU6+sZpFPvOFYLnBwUXMLqdPWiwsWDO5BCF6/xL
	 XCY4n8rLCxLh9oMj6+wjZNn5YcFNWTcv+DQpU04k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0372/1424] nvme-tcp: check the data direction of a C2HData PDU
Date: Sat, 12 Sep 2026 08:46:44 +0200
Message-ID: <20260912065615.624367894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit f83af377c148f6ad94b41c0e8313f12adf45e1c1 upstream.

nvme_tcp_handle_c2h_data() finds the request by command id and checks
that it has a payload, but it does not check that the command asked for
data to be read.  A controller that answers a write command with C2HData
therefore reaches nvme_tcp_recv_data(), where _copy_to_iter() hits
WARN_ON_ONCE(i->data_source) and returns 0.  The receive path turns that
into -EFAULT and resets the controller.

No data is copied, so this is not memory corruption.  What a controller
gets is a kernel warning it can raise at will, which is fatal on a host
booted with panic_on_warn.

The send path already knows the direction - it consults rq_data_dir()
when it builds a command - and nvme_tcp_handle_r2t() checks the length
and the offset of the request it names.  The C2HData path does not check
the direction at all.

Reject a C2HData PDU whose command is not a read.  Rejecting it fails
the command and resets the controller, as the neighbouring check in this
function does; what goes away is the warning.

  [    6.885580] ------------[ cut here ]------------
  [    6.886457] WARNING: lib/iov_iter.c:193 at _copy_to_iter+0x289/0x1330, CPU#0: kworker/0:1H/71
  [    6.888137] CPU: 0 UID: 0 PID: 71 Comm: kworker/0:1H Not tainted 7.2.0-rc5-NVMETCP-gf5098b6bae76 #1 PREEMPT(lazy)
  [    6.891165] Workqueue: nvme_tcp_wq nvme_tcp_io_work
  [    6.891875] RIP: 0010:_copy_to_iter+0x289/0x1330
  [    6.903739] Call Trace:
  [    6.904085]  <TASK>
  [    6.909254]  __skb_datagram_iter+0x433/0x820
  [    6.911026]  skb_copy_datagram_iter+0x37/0x120
  [    6.911622]  nvme_tcp_recv_skb+0xa07/0x4320
  [    6.913378]  __tcp_read_sock+0x1ab/0x810
  [    6.915788]  nvme_tcp_try_recv+0x152/0x1e0
  [    6.918222]  nvme_tcp_io_work+0x1e4/0x6c0
  [    6.926906]  </TASK>
  [    6.927226] ---[ end trace 0000000000000000 ]---
  [    6.927878] nvme nvme0: queue 1 failed to copy request 0x71 data
  [    6.928709] nvme nvme0: receive failed:  -14

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -609,6 +609,13 @@ static int nvme_tcp_handle_c2h_data(stru
 		return -ENOENT;
 	}
 
+	if (rq_data_dir(rq) != READ) {
+		dev_err(queue->ctrl->ctrl.device,
+			"queue %d tag %#x unexpected data for a write\n",
+			nvme_tcp_queue_id(queue), rq->tag);
+		return -EIO;
+	}
+
 	req = blk_mq_rq_to_pdu(rq);
 	if (!blk_rq_payload_bytes(rq) || !req->curr_bio || !req->data_len) {
 		dev_err(queue->ctrl->ctrl.device,


