Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4FA3264D4;
	Sat, 12 Sep 2026 15:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228059; cv=none; b=PtRhBwu//oYwwtvW88IdqP5Rv4cDE3Jm8M0W3ihmc4B+O7VmeDsgM3wdkKuw3JcA0agG2+YDzVw1ACCbbD9sBT6yKEPJ5YsabknrSGsQxtO62eeaDjTZ7fLm31hJ+1kCG76pBJgEd1mGbs563wWuWWk6p8nCbjEyzcm2WTT8fK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228059; c=relaxed/simple;
	bh=XuIxVFD/0XIVIw4FqaqxHtzJKqjOYkBRvFHCSiMQK9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJWi+R/msAt+JhZFNRW9nHBwAQYXt1U1z4CVdbTLxGQunCdo9zyprDoNn+RnEpDJyM1uSSStF4oECVvAC909ifXoOwX5mWl3c+a/oUbdNXcINYGqKiwsXMr+GE6w1kbXxP+YqjpgIuW8uqe5HJiPGCMi6qEk8CtF3sjfv2Av9EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUc6ue16; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUc6ue16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E931F000FF;
	Sat, 12 Sep 2026 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228057;
	bh=IrWk/BHJ5WuOdnQA/yDxBndSYo1v9O08t5fitDEoiOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUc6ue16LzsiGCdYDOvsqeelLQmIK9lcZXdvEPaa+s7YLrHSKO9Uyo+7rFwZoMxU7
	 KkVMMq0H6RzTSq5EQXfmwM8agv8ct6mgCBRf47Eojug1Ax+vzIhGB4sRy549uSN3Hd
	 k8PHJOuxUOt6JmUOjGLZwMqRM2/S3co6eeJIEGbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0308/1191] nvmet-tcp: fix out-of-bounds write when receiving an over-long PDU
Date: Sat, 12 Sep 2026 08:50:36 +0200
Message-ID: <20260912065555.149419073@linuxfoundation.org>
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

commit 14cc5a7e77731497d5bea70f3bb05df7eda982e4 upstream.

nvmet_tcp_try_recv_pdu() reads a PDU header into the fixed 128-byte
queue->pdu union, then computes the remaining payload length as

	queue->left = hdr->hlen - queue->offset + hdgst;

and reads that many more bytes into &queue->pdu + queue->offset, without
ever bounding the result against sizeof(queue->pdu).

A struct nvme_tcp_icreq_pdu is itself 128 bytes, exactly the size of the
union. Once a header digest has been negotiated (hdgst = 4), a second
ICReq passes the hlen == nvmet_tcp_pdu_size() check but yields
queue->left = 128 - 8 + 4 = 124, so bytes 8..132 are written into the
128-byte buffer -- 4 bytes past its end, over queue->hdr_digest and
queue->data_digest. Those bytes are attacker-controlled (an ICReq
carries no digest), and the duplicate ICReq is only rejected later,
after the overflow. A remote unauthenticated host can thus corrupt
kernel memory adjacent to the receive buffer.

Reject any PDU whose declared length would read past the end of
queue->pdu before the second recv.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1192,6 +1192,8 @@ recv:
 		}
 
 		queue->left = hdr->hlen - queue->offset + hdgst;
+		if (queue->left > sizeof(queue->pdu) - queue->offset)
+			return -EPROTO;
 		goto recv;
 	}
 


