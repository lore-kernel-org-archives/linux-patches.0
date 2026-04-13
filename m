Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA5E238D27;
	Mon, 13 Apr 2026 16:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097945; cv=none; b=sXOUyl5JsVqqDCGxL6r4dQ2zL8bRNeAsSq2jBEI2S07Oi3NKd07e5FLWBWUeXnRzcC0GoujuOmvE1cElgpL4J+9MphtfHcCwfJkjVtxotEy92gH0mTnl4PiMK7ruBRTR3ewnT8hCFP69mYPsvjj+6wLAgnOf+C1Me2r2Nn1yMY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097945; c=relaxed/simple;
	bh=+FVppw+0AqKleYCupdv4a2srKsNVNermd9bQI+EtvNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fujhbDSpnGsL4kMB9iiNMPczUeqlBwYDZHeYx2NQm6kgZBzytQmwc7Bbh2qNztgTunPP0M2ShhAMar9zAc3wnTy5TKTANRIkiUqKfG9rXwcGsI8sQOEia+WTyCHQgpXmKjHUB0JVGqeUP7gfKReQSiIu9EphxjxQiBIZ/RldwEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf9yXdJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf9yXdJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B0C2BCAF;
	Mon, 13 Apr 2026 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097945;
	bh=+FVppw+0AqKleYCupdv4a2srKsNVNermd9bQI+EtvNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf9yXdJGcx7HSArQJmw5OP6QznW6hxrC0u8fwYsb73WLHO2MoMVr5xnolN3dnNz8s
	 HSB3v4kl856FdD9pEzXwKJCsbJ5tIsrrVxpC3j737fptHQRCg8U3t0KfKQRb1/oJdt
	 wJGrlBfnTtR6/Y8zXyAwXv6E14jtpNxelabUhUCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/570] nvme-pci: ensure were polling a polled queue
Date: Mon, 13 Apr 2026 17:57:13 +0200
Message-ID: <20260413155841.813334943@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 166e31d7dbf6aa44829b98aa446bda5c9580f12a ]

A user can change the polled queue count at run time. There's a brief
window during a reset where a hipri task may try to poll that queue
before the block layer has updated the queue maps, which would race with
the now interrupt driven queue and may cause double completions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c4a33e9d2c717..432c21d3a9c4a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1096,7 +1096,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



