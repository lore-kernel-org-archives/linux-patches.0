Received: from mail78-58.sinamail.sina.com.cn (mail78-58.sinamail.sina.com.cn [219.142.78.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC66C26B2D2
	for <patches@lists.linux.dev>; Wed, 27 May 2026 06:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=219.142.78.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779862883; cv=none; b=KC/nB0senH5g8m43+6cEYOgQ1gQdLVMe83RTbkl67urnVuL/5Fps19PM3uvcq02w5wObxaKFGa/XLcL0CUBxCZn9oarcfTHcPUYsqcJ1BN/2WT1CtDQwOWUZLjFK9/6ewJAyyyEQKT3XyMTYwARpy/LRMV6wjbJC6nH6szxYvGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779862883; c=relaxed/simple;
	bh=SpvfvBhg8uS2HxBhP5AfLteJqEFvFAIKcGE0JExYEYc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LDrVlf70IXvMJxGrFrM0YF8QEIbbmgreqWCJG8vBs3sFE1ioddioxF/g6VK/RrYuwJi/Vwg+/co5XzPRL5gUomYbxW91RajjpnqI7k2HNT2opJixNCjsEYD5HSmJO8sC3N89cs0eAKJ4XwyAkriXGfHtWT1cwjUI6tYtspUGKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=P0HRk7Ki; arc=none smtp.client-ip=219.142.78.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="P0HRk7Ki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1779862880;
	bh=V/Y6MuG1dUmeFRhVhwjtGhY2waWpqlhOBuklwr+jydU=;
	h=From:Subject:Date:Message-Id;
	b=P0HRk7Ki3ziCUFiL/8OUAXU1D9d9rLPh3gK7xCOHCQQpDpWGyLnuJQJgkC42AoBOm
	 tHIA0Vohh5QHgQorXrF/2jPi9wU+66lVnNDc9z+Ne0YTP1Xh2ayC7ydlZshogGEzwQ
	 7f4GUOQZD/I3RCbWQtdOHpOvek7eKweKPabJTfFo=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.24) with ESMTP
	id 6A168D3800001848; Wed, 27 May 2026 14:20:41 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 81871510747978
X-SMAIL-UIID: 3EF491FA24E547F983570195DF246D43-20260527-142041-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	adrian.hunter@intel.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexandre.belloni@bootlin.com,
	Frank.Li@nxp.com,
	sashal@kernel.org,
	billy_tsai@aspeedtech.com,
	npitre@baylibre.com,
	boris.brezillon@collabora.com,
	linux-i3c@lists.infradead.org
Subject: [PATCH 6.6.y] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue
Date: Wed, 27 May 2026 14:20:39 +0800
Message-Id: <20260527062039.3612331-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit b795e68bf3073d67bebbb5a44d93f49efc5b8cc7 ]

The logic used to abort the DMA ring contains several flaws:

 1. The driver unconditionally issues a ring abort even when the ring has
    already stopped.
 2. The completion used to wait for abort completion is never
    re-initialized, resulting in incorrect wait behavior.
 3. The abort sequence unintentionally clears RING_CTRL_ENABLE, which
    resets hardware ring pointers and disrupts the controller state.
 4. If the ring is already stopped, the abort operation should be
    considered successful without attempting further action.

Fix the abort handling by checking whether the ring is running before
issuing an abort, re-initializing the completion when needed, ensuring that
RING_CTRL_ENABLE remains asserted during abort, and treating an already
stopped ring as a successful condition.

Fixes: 9ad9a52cce282 ("i3c/master: introduce the mipi-i3c-hci driver")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260306072451.11131-9-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 624d00b853a5..61007167606f 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -448,16 +448,23 @@ static bool hci_dma_dequeue_xfer(struct i3c_hci *hci,
 	struct hci_rh_data *rh = &rings->headers[xfer_list[0].ring_number];
 	unsigned int i;
 	bool did_unqueue = false;
-
-	/* stop the ring */
-	rh_reg_write(RING_CONTROL, RING_CTRL_ABORT);
-	if (wait_for_completion_timeout(&rh->op_done, HZ) == 0) {
-		/*
-		 * We're deep in it if ever this condition is ever met.
-		 * Hardware might still be writing to memory, etc.
-		 */
-		dev_crit(&hci->master.dev, "unable to abort the ring\n");
-		WARN_ON(1);
+	u32 ring_status;
+
+	ring_status = rh_reg_read(RING_STATUS);
+	if (ring_status & RING_STATUS_RUNNING) {
+		/* stop the ring */
+		reinit_completion(&rh->op_done);
+		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE | RING_CTRL_ABORT);
+		wait_for_completion_timeout(&rh->op_done, HZ);
+		ring_status = rh_reg_read(RING_STATUS);
+		if (ring_status & RING_STATUS_RUNNING) {
+			/*
+			 * We're deep in it if ever this condition is ever met.
+			 * Hardware might still be writing to memory, etc.
+			 */
+			dev_crit(&hci->master.dev, "unable to abort the ring\n");
+			WARN_ON(1);
+		}
 	}
 
 	for (i = 0; i < n; i++) {
-- 
2.34.1

