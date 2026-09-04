Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25839023A;
	Fri,  4 Sep 2026 06:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502600; cv=none; b=KE0jbpyxGGORKb6WUwYzDS/txIE014avLb0qkGRfsmMlzzD8Q6DJNzxiBa+6Rc3EwlABrNv7Wg30zMhijVRtkzXsLRIUNNJVmgMZSFUV0WYqDyqUUAsTT/sBdZ2Ud1Gl4ZCn/Ek6vkXEPbk1agpMEnkP67Y/hC1c1g7fmT3WQXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502600; c=relaxed/simple;
	bh=1oO29PlD613v9obMGq9FFMK6HClqhS3NdCedpyLWP2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p71io0Z7dbyqJ9DMaS0aG09WV6zv3XYgh1+ZFQM4v+bM/TyRJcVciU6WtBsm4qlvGYBpTdDSjeiInSfV4aYUAk+i4+eEQ3SE0gyfrqKSA64saNicIZ+NDeK5/oYiGTdfNkcPicj0p6T4UZaCRfcn7Y4toF3W4DYj1Ej2PJQk/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/ajYeo5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/ajYeo5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44861F00A3D;
	Fri,  4 Sep 2026 06:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502599;
	bh=krpNPnKv9h1JRGiDH6QvOHq/vZp3Xl89q5rMvijeuic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/ajYeo5r1uHnxeQNqsCzluRTuZdUrcg0D2V1tAkpPgZfr458jfK6SOgs8xx+tYn0
	 jXOQXx0Oe1tNFiW0GtTbzVAMjrNl2Ea1+Nw1x2FVOCANYbz0yeCyLsa1dHwmOwXqtw
	 60ZLOx6RKgzgXvR834ayJJyJWNh+wXTBQTVLWOWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 263/403] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Fri,  4 Sep 2026 07:01:06 +0200
Message-ID: <20260904045740.843500723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 6efbc52237facda35d2d874fe1765bb4839275d8 upstream.

nvme_tcp_handle_r2t() does not check the direction of the request the
R2T refers to. A malicious controller can send an R2T for a READ and
the host will answer it: nvme_tcp_setup_h2c_data_pdu() builds the
H2CData header and nvme_tcp_try_send_data() sends the request's data
buffer. That buffer is the READ destination, so its contents go to the
controller.

The command then completes normally and nothing is logged.

Against a test controller that answers every READ with an R2T, a 4096
byte buffered read returned all 4096 bytes, split over two R2Ts. The
pages contained stale kernel data, including an array of struct page
pointers.

Reject an R2T for a request that is not a write.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -752,6 +752,13 @@ static int nvme_tcp_handle_r2t(struct nv
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
+	if (unlikely(rq_data_dir(rq) != WRITE)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t for a non-write command\n",
+			rq->tag);
+		return -EPROTO;
+	}
+
 	if (unlikely(!r2t_length)) {
 		dev_err(queue->ctrl->ctrl.device,
 			"req %d r2t len is %u, probably a bug...\n",


