Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1EE175A6B;
	Sat, 30 May 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164849; cv=none; b=awgLPibOkVGqAHjZWhslc7jQeDzV3FBK4hSDCqXOkV1wyc9zqzRaMAkqMtTKhR25RXAeNY9cVeYmteSdvPQpGxx3zz8a/5F0IR+QI+gqZBZnTQ0PhAYd+rkrW4Z5ktSaFVWcZD1JA8GfNI6TzS48Eng8pJitNTPG9BMb2tzOxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164849; c=relaxed/simple;
	bh=+NUT76rF7XhP2OUh0uViXMBKlZpWXAfgZ5GEOMRYUSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/U3oMgaIydWpbnkubjHRUJAu5ii63fwz52QGZkSQ0JVSkFqj/OU/rSCRyD6ue3bm90LNhbT1V9wYJYoNUTW/NRdtmqHlCYxCTh8x8xX5wAoMFWA3tFz3XV8FnfUWuJ6iuhHyxNuEUdzeYneOQK+LFJMbX4Ytwc3EzEmjgkhU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4DcGhgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4DcGhgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267B81F00893;
	Sat, 30 May 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164848;
	bh=PwuQxWxBYqoboXoRWMrvqDAgbPCXcmT2ovpaaKwEimA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4DcGhgxLRTyN6cL55GwhGKmHMAigFG/W79fymLAVPlUjBcn9yZZT3f6AfBbmRbVS
	 5AFBCnxktfyHXHNWkwQBPWiCAEXmPBqRldOnHnC8hcoja0wjx2S4ZJv57fs7NJvyIN
	 38davhGTvaSxUbPT/Xtn6SIDmvItaZWmpCeAe8us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jianqiang kang <jianqkang@sina.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 677/776] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue
Date: Sat, 30 May 2026 18:06:31 +0200
Message-ID: <20260530160257.360472288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index 168b21f6cf37c..d6678bee725b6 100644
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
2.53.0



