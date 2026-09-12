Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5233264D4;
	Sat, 12 Sep 2026 15:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228053; cv=none; b=mO0USp3oGI91Z9Yrp+VR7OUcByfrj2avStJC4UOkI7HGh32WB2Alb8SP7uHN2tzVoktoNyhTG5cG4K5aK0iii7eT2FOArExvrCyYkqUMmttzPEzfKbYCkRosIAzZG7jqE+iAlJQlBL18IqeqT3KcGm+htglC4bMEQ/scHaffCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228053; c=relaxed/simple;
	bh=9UTr02xSuvFkdzUEuo4WxLqpp/qVaT6Jvc/5piedFn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmAl7eDm9XtQMjXO9J3BAPlvEDw/4/EYpqoq9Q16o38ntwDGxUgDpwKk4rMTeoz7PolkMsCW4e1IeRXcjdQtp/gPHkTwmU+DwZv/EC3dI2mDZBv2i94kJw4Crh7GfHrc3X5P2q8aL8UJgexbGS6HmBurAwEj/ptYAsZ6yBmnXd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJNzxEFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJNzxEFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9C11F000FF;
	Sat, 12 Sep 2026 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228052;
	bh=3rW3FtuuPxfJS9DgSAedOeZASJ4C58bhPaKk8lHvaXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJNzxEFVXerl47Umx0MGcgam1bwkCSBcGzXv+sW9LE2mtEMtyjb2W4d3YK0ppqt3d
	 aE0/Y5b8+bQvHHoRkl6/MWRx8Lq0VZrO7Z4XG9CXOBXeIEpRxNygcorXHUZeKT+z9j
	 BSoptNFyD8vNxhjAVvvbOhHrd3w4uyNSG3+9+26Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0307/1191] nvme-tcp: check the data direction of a C2HData PDU
Date: Sat, 12 Sep 2026 08:50:35 +0200
Message-ID: <20260912065555.128206212@linuxfoundation.org>
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
@@ -596,6 +596,13 @@ static int nvme_tcp_handle_c2h_data(stru
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


