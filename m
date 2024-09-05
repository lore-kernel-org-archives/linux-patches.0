Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A36A1494DB;
	Thu,  5 Sep 2024 10:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530632; cv=none; b=Qwk7WAw9CXQJKbffKU6035zydSwAT2kaVkc1Fis/6rMHqQON3Io/qjFg3/hUxsHftmzPrEtdqVC730qORwdeZPbgrNf3DZT7Hmaf4wRHzbO0AN0sJaihkAk6Acq+kIXqcg0lRvp+vRS7gaHKbIiRtmBCItiF4a5t5ZK6kUF3/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530632; c=relaxed/simple;
	bh=ELFXKJ0YND/I0J8oou0TLTLh/NGc6GFbtzs80vGM7/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOfTw0/JvCJyY/jjCo2+e20GzwH/DiyuAQJy3SGXrvyIN+JPr2CvvINFRKnJjsiRMdpu2w2e2RtSjtnEJKpGBoC7ieSkY/dI4IA+5xIz0Q8fUP1VjZ5j3IzEkmYp47n33ysQ71GuEU+mXJrGNyOFVFKGGvvPyX0GvGFFgwKG4Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5iT3T1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5iT3T1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B79C4CEC3;
	Thu,  5 Sep 2024 10:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530632;
	bh=ELFXKJ0YND/I0J8oou0TLTLh/NGc6GFbtzs80vGM7/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5iT3T1o32uQ9Y5WR18o6R2fdRcdG4/9Uk5fYeRwwVL+X3box9E/RW20y39KbusHW
	 aEdPmKRZuIBDYqbhxQ440XHaBRA5+ObOKppMJ3FIFhF/uYWPwvFM7QGcHhiht9RX83
	 cN8Apc3HpsdUcMUoQL7J+U87RsJQ8RS9KOleRpZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Dautricourt <olivierdautricourt@gmail.com>,
	Eric Schwarz <eas@sw-optimization.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/101] dmaengine: altera-msgdma: use irq variant of spin_lock/unlock while invoking callbacks
Date: Thu,  5 Sep 2024 11:41:56 +0200
Message-ID: <20240905093719.415060867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Olivier Dautricourt <olivierdautricourt@gmail.com>

[ Upstream commit 261d3a85d959841821ca0d69f9d7b0d4087661c4 ]

As we first take the lock with spin_lock_irqsave in msgdma_tasklet, Lockdep
might complain about this. Inspired by commit 9558cf4ad07e
("dmaengine: zynqmp_dma: fix lockdep warning in tasklet")

Signed-off-by: Olivier Dautricourt <olivierdautricourt@gmail.com>
Tested-by: Olivier Dautricourt <olivierdautricourt@gmail.com>
Suggested-by: Eric Schwarz <eas@sw-optimization.com>
Link: https://lore.kernel.org/r/20240608213216.25087-1-olivierdautricourt@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/altera-msgdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index 4153c2edb049..8c479a3676fc 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -583,6 +583,7 @@ static void msgdma_issue_pending(struct dma_chan *chan)
 static void msgdma_chan_desc_cleanup(struct msgdma_device *mdev)
 {
 	struct msgdma_sw_desc *desc, *next;
+	unsigned long irqflags;
 
 	list_for_each_entry_safe(desc, next, &mdev->done_list, node) {
 		struct dmaengine_desc_callback cb;
@@ -591,9 +592,9 @@ static void msgdma_chan_desc_cleanup(struct msgdma_device *mdev)
 
 		dmaengine_desc_get_callback(&desc->async_tx, &cb);
 		if (dmaengine_desc_callback_valid(&cb)) {
-			spin_unlock(&mdev->lock);
+			spin_unlock_irqrestore(&mdev->lock, irqflags);
 			dmaengine_desc_callback_invoke(&cb, NULL);
-			spin_lock(&mdev->lock);
+			spin_lock_irqsave(&mdev->lock, irqflags);
 		}
 
 		/* Run any dependencies, then free the descriptor */
-- 
2.43.0



