Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE652E7374;
	Thu, 25 Jun 2026 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393118; cv=none; b=KCHveQLTM31hmfow/Hj7KojQbzJKfK63jIqVnK9S88vcViuJYruRB2rNNtrA+SWixEDYE8ltHWGh6Sbx1ILFFaprqdQOdFTKgBfhVmQg7p9U3L9nl7YYZpg6/TIPGcEOTvwRiOWAdPnjMN90txPyKAtbH6wyolkrYHwuQCJlITM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393118; c=relaxed/simple;
	bh=iY0duN96lGpWNGrexsv+5yJtBeR5Y36p4t4oMR5rU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhktE1PtE67wgzOPRhbpaa4cJ9v8+gS+XN4wbqGiLUEKBUICjo5n5s7YB4QaZsjwKxEIGpllXe19jg53rPAAEtYx+uV2ou4u85ZdAbVkLxnhMGvV2zPoz46mQbphyQJWhoa2iPFcOrDCM0NcZSzaiFSMwPXpdImC5oSp2vdNn0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sw1Vc18N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sw1Vc18N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727EB1F00A3A;
	Thu, 25 Jun 2026 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393117;
	bh=kGTqlSnTGYyrDFEgQ37xJ3DFNhaOecYeyk847OtJCLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sw1Vc18NXpwFKXewRF6CIe8CEsSwF2yLrnpE28NbTvzgsEamOoWkRFC8G98FC+IXA
	 xbZ+LnmBsRDY/EKhs0gFisR3wStUGtmR72I50x4lqKjLnslzYc1eVRB8BkWYPWTrhq
	 UnHA+4b1guniUaIzvKWp6qQuGL2nfLYooic9Db3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 12/21] Input: rmi4 - iterative IRQ handler
Date: Thu, 25 Jun 2026 14:04:04 +0100
Message-ID: <20260625125614.954173114@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit b6ca982afd0e8fbcbb340092d3c6d3b4a217686c upstream.

The current IRQ handler uses recursion to drain the attention FIFO,
which can lead to stack overflow on deep queues. Convert it to a
loop.

Fixes: b908d3cd812a ("Input: synaptics-rmi4 - allow to add attention data")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-6-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -198,24 +198,24 @@ static irqreturn_t rmi_irq_fn(int irq, v
 	struct rmi4_attn_data attn_data = {0};
 	int ret, count;
 
-	count = kfifo_get(&drvdata->attn_fifo, &attn_data);
-	if (count) {
-		*(drvdata->irq_status) = attn_data.irq_status;
-		drvdata->attn_data = attn_data;
-	}
+	do {
+		count = kfifo_get(&drvdata->attn_fifo, &attn_data);
+		if (count) {
+			*drvdata->irq_status = attn_data.irq_status;
+			drvdata->attn_data = attn_data;
+		}
 
-	ret = rmi_process_interrupt_requests(rmi_dev);
-	if (ret)
-		rmi_dbg(RMI_DEBUG_CORE, &rmi_dev->dev,
-			"Failed to process interrupt request: %d\n", ret);
+		ret = rmi_process_interrupt_requests(rmi_dev);
+		if (ret)
+			rmi_dbg(RMI_DEBUG_CORE, &rmi_dev->dev,
+				"Failed to process interrupt request: %d\n",
+				ret);
 
-	if (count) {
-		kfree(attn_data.data);
-		drvdata->attn_data.data = NULL;
-	}
-
-	if (!kfifo_is_empty(&drvdata->attn_fifo))
-		return rmi_irq_fn(irq, dev_id);
+		if (count) {
+			kfree(attn_data.data);
+			drvdata->attn_data.data = NULL;
+		}
+	} while (!kfifo_is_empty(&drvdata->attn_fifo));
 
 	return IRQ_HANDLED;
 }


