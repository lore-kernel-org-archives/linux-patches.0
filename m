Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC979523781;
	Wed,  9 Sep 2026 13:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962060; cv=none; b=fAO2C0k9f214pUjm/miWovqueGauEHfI6p3JkTPk42cvgbonIOf+4hLuv+Sz2z2e/+90LFhB940eEek5+ZEhEOMDjHPRjMuwu1QNQ3+GXV6L0r2STblpjVGbayYPTAc1iQ5InF85Hj30sbjBIalF8q34QF8g57sglPzN7U1V69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962060; c=relaxed/simple;
	bh=dyOwgGgEeQr9Yh8lgsT4NrDeNalQTyCN4rthiZ2kmZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVsE6Ae6OwW3KRTqj53T9+QtDw8Uei+6PGaD0Gmipwmq882J8EiGWMzmF679j3zi5dB8LUnDq2EIxzefMZ+uDgmGq+PujFcYhEpf8uj5jEbY5o4h9b6PalOkfMDqPGMVSpWx3kTaVcTwS86P6i0VHAxFg/CWhX/PDYqWeCsTP4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1fGELN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1fGELN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B941F00A3A;
	Wed,  9 Sep 2026 13:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962058;
	bh=mYMezkAd7MoESONcylxDjqTwsxSkAR6U6kPeoEzZOHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1fGELN6qPGBWuS4WDpDJV0vEUNnLZQaQCeUZrS9GEqrbxB+4YwlPzB4UfQxDhMFX
	 Gjj5v0jRnLduhYRLkn5sXqZuQ3kBs+evbj+fVcAu0VKo7IOheKSMJTl3NKldGkrZUf
	 u8n5+nPEsabw+Hhw3ttbiXwu1IUAooIND0bJjBDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 158/556] nvme-tcp: check the data direction of a C2HData PDU
Date: Wed,  9 Sep 2026 15:37:18 +0200
Message-ID: <20260909134235.983779958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -682,6 +682,13 @@ static int nvme_tcp_handle_c2h_data(stru
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


