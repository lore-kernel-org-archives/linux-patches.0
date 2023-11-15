Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EAC3DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qCJcSPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B20FC433CD;
	Wed, 15 Nov 2023 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078665;
	bh=WxeX3xrxNYArzdkonNI6YtB6FyUvqpj0ygKZjH+YFz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qCJcSPwwBtLeYi8xr7aWmwR9lpkp4ndG1UMt1tKtVkZwqI9RXk1xhdnIPehU5aTy
	 j5dGvZgYMCLnzAN8T7feIa1m+gg/1fJVtD4uUBRQj8or+QPWKA8gtiKkqTlr8mqRR3
	 s8tCEPjROSUc8D05YXn0ozF262CnIR28OYWcpW7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Ju Bai <baijiaju@buaa.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/45] usb: dwc2: fix possible NULL pointer dereference caused by driver concurrency
Date: Wed, 15 Nov 2023 14:33:03 -0500
Message-ID: <20231115191421.148564705@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
References: <20231115191419.641552204@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia-Ju Bai <baijiaju@buaa.edu.cn>

[ Upstream commit ef307bc6ef04e8c1ea843231db58e3afaafa9fa6 ]

In _dwc2_hcd_urb_enqueue(), "urb->hcpriv = NULL" is executed without
holding the lock "hsotg->lock". In _dwc2_hcd_urb_dequeue():

    spin_lock_irqsave(&hsotg->lock, flags);
    ...
	if (!urb->hcpriv) {
		dev_dbg(hsotg->dev, "## urb->hcpriv is NULL ##\n");
		goto out;
	}
    rc = dwc2_hcd_urb_dequeue(hsotg, urb->hcpriv); // Use urb->hcpriv
    ...
out:
    spin_unlock_irqrestore(&hsotg->lock, flags);

When _dwc2_hcd_urb_enqueue() and _dwc2_hcd_urb_dequeue() are
concurrently executed, the NULL check of "urb->hcpriv" can be executed
before "urb->hcpriv = NULL". After urb->hcpriv is NULL, it can be used
in the function call to dwc2_hcd_urb_dequeue(), which can cause a NULL
pointer dereference.

This possible bug is found by an experimental static analysis tool
developed by myself. This tool analyzes the locking APIs to extract
function pairs that can be concurrently executed, and then analyzes the
instructions in the paired functions to identify possible concurrency
bugs including data races and atomicity violations. The above possible
bug is reported, when my tool analyzes the source code of Linux 6.5.

To fix this possible bug, "urb->hcpriv = NULL" should be executed with
holding the lock "hsotg->lock". After using this patch, my tool never
reports the possible bug, with the kernelconfiguration allyesconfig for
x86_64. Because I have no associated hardware, I cannot test the patch
in runtime testing, and just verify it according to the code logic.

Fixes: 33ad261aa62b ("usb: dwc2: host: spinlock urb_enqueue")
Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
Link: https://lore.kernel.org/r/20230926024404.832096-1-baijiaju@buaa.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 50ec2cd36db0a..6d2060377dc4a 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4842,8 +4842,8 @@ static int _dwc2_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	if (qh_allocated && qh->channel && qh->channel->qh == qh)
 		qh->channel->qh = NULL;
 fail2:
-	spin_unlock_irqrestore(&hsotg->lock, flags);
 	urb->hcpriv = NULL;
+	spin_unlock_irqrestore(&hsotg->lock, flags);
 	kfree(qtd);
 	qtd = NULL;
 fail1:
-- 
2.42.0



