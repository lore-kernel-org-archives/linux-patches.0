Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412F1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZujLSRxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFEBC433C8;
	Wed,  4 Oct 2023 18:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443545;
	bh=M2WZuPYGjG3WzZVCeDmwZ1jg7BhqjUcmOvx7V3Uxus8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZujLSRxVfo+325B9Dk+Ev4PAJMYcA10f1l1D0UGfOZI9MacnnRHlp8A3sC7y9LO/1
	 fSl834VHm47Ej9WOogygeC1UG78WdLhAipYxSainJ4cA/Gt+Idk/dmfGwNQZL7FFz6
	 g645tFaKjG2MR43lEybjICWVtXRysmZ76uil8gFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/259] tsnep: Fix NAPI scheduling
Date: Wed,  4 Oct 2023 19:56:08 +0200
Message-ID: <20231004175226.223958948@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit ea852c17f5382a0a52041cfbd9a4451ae0fa1a38 ]

According to the NAPI documentation networking/napi.rst, drivers which
have to mask interrupts explicitly should use the napi_schedule_prep()
and __napi_schedule() calls.

No problem seen so far with current implementation. Nevertheless, let's
align the implementation with documentation.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6bf3cc11d2121..00436a6f785e8 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -65,8 +65,11 @@ static irqreturn_t tsnep_irq(int irq, void *arg)
 
 	/* handle TX/RX queue 0 interrupt */
 	if ((active & adapter->queue[0].irq_mask) != 0) {
-		tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
-		napi_schedule(&adapter->queue[0].napi);
+		if (napi_schedule_prep(&adapter->queue[0].napi)) {
+			tsnep_disable_irq(adapter, adapter->queue[0].irq_mask);
+			/* schedule after masking to avoid races */
+			__napi_schedule(&adapter->queue[0].napi);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -77,8 +80,11 @@ static irqreturn_t tsnep_irq_txrx(int irq, void *arg)
 	struct tsnep_queue *queue = arg;
 
 	/* handle TX/RX queue interrupt */
-	tsnep_disable_irq(queue->adapter, queue->irq_mask);
-	napi_schedule(&queue->napi);
+	if (napi_schedule_prep(&queue->napi)) {
+		tsnep_disable_irq(queue->adapter, queue->irq_mask);
+		/* schedule after masking to avoid races */
+		__napi_schedule(&queue->napi);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.40.1



