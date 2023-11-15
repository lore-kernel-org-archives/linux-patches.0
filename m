Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7403DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzjNntBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53927C433CC;
	Wed, 15 Nov 2023 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078350;
	bh=e6PvNud0gCpCKx2u9hLkLY4E6tCA5eNJFgqWAzAzFWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzjNntBkP4fyZ/bsFgQO0wMxVXnnhOtxYP7gvf5P46nHw6JjA0lHoqd7SZb14IkEK
	 P3qJ9h2BdZL02vbatXxtTwEhG4iLfr54yMGEpUoAdzPBP03uVzcB8RcPJFSaejbtte
	 lTo54JTfXKqF8X4/YJCdAAV8Ly6m9gjypHPk4JF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-Ju Bai <baijiaju@buaa.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 268/379] usb: dwc2: fix possible NULL pointer dereference caused by driver concurrency
Date: Wed, 15 Nov 2023 14:25:43 -0500
Message-ID: <20231115192700.986372862@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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
index 657f1f659ffaf..35c7a4df8e717 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4769,8 +4769,8 @@ static int _dwc2_hcd_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	if (qh_allocated && qh->channel && qh->channel->qh == qh)
 		qh->channel->qh = NULL;
 fail2:
-	spin_unlock_irqrestore(&hsotg->lock, flags);
 	urb->hcpriv = NULL;
+	spin_unlock_irqrestore(&hsotg->lock, flags);
 	kfree(qtd);
 fail1:
 	if (qh_allocated) {
-- 
2.42.0



