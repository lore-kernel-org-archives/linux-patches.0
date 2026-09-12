Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F65A345749;
	Sat, 12 Sep 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227372; cv=none; b=B6HbJEPzkeIXMHQXz7gq2xpvPtKbm0h9OJ8EuFf6VfTK/Dc4HddP66vAkIxIhXGF3sClTTdgpsNQEeQBeLZva0PZDvKdQbwggMxxvEBsv9/TzcyquDTJ5ewyU5oNZ4OszdODYOg0+PA9pSD4z+E8VkFcpmuhkMtDHfPO3dCaWt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227372; c=relaxed/simple;
	bh=5fyhZNpTGz1VSA98sppvfCDCf5kNH64Zt4ifZbfYwIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmBZ7TwlgQy7LkB6ZATZMd9OikNgc719/FwaT84s7f5WJVtGIkZXH0LC6pA0Ji4RfGZqsd/vLCF2TSk5d27B8Bjm+jPhq2iWkdYE9FptuWrZQhYjmJMl/U5wm50BtUt3t5jNS7JtkuKyPe6afAwjzkwX9JTz0Y74R8dtK/EiZIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz6GrDvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz6GrDvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D191F000FF;
	Sat, 12 Sep 2026 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227370;
	bh=ULgcVeKzm+21aBnHaouFoiw1mRQGCV9B8+42tsuT7fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz6GrDvB+y1cXPqapeeRGagyxbKYdIp+qtQ6wbWmJyZh/3AcbSCqalVpeYhJxEYSd
	 TbP56/0GXHiJVF2Ga0dpV9yTy/cwoOnLQGpZh2QIQ7oXsiZzYKPbAmpudpLkKXzyMq
	 FkxbuQHhm3+osBPS+gFY/N7izL0z1AK0kpbUaZ2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 0167/1191] nvme-tcp: fix host memory disclosure on R2T for a read command
Date: Sat, 12 Sep 2026 08:48:15 +0200
Message-ID: <20260912065551.965083915@linuxfoundation.org>
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
@@ -664,6 +664,13 @@ static int nvme_tcp_handle_r2t(struct nv
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


