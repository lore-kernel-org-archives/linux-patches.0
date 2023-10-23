Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BC215E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GdQ+OD5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D6AC433C7;
	Mon, 23 Oct 2023 11:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060579;
	bh=gOV1LO/wlVdwnrwJQNMgo33eqUcustHlQsHkAWNFRKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GdQ+OD5kcFHBYwt+8RnQE/+SdbV6QFyM7eeVIzygCHaHuR6s6Ggu87Ai7GPDr6Qqm
	 gC1wP34Wn5ON4UkRqgRDdVze9T1+9mOcDWJZQeubeFXJOBXqZ+vblApKg+1IwkHcY9
	 SFwRHDuJXTInz3LpK/8CQAuSr8V54KMeUvM1MoOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingxing Luo <xingxing.luo@unisoc.com>
Subject: [PATCH 5.4 023/123] usb: musb: Get the musb_qh poniter after musb_giveback
Date: Mon, 23 Oct 2023 12:56:21 +0200
Message-ID: <20231023104818.511587188@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingxing Luo <xingxing.luo@unisoc.com>

commit 33d7e37232155aadebe4145dcc592f00dabd7a2b upstream.

When multiple threads are performing USB transmission, musb->lock will be
unlocked when musb_giveback is executed. At this time, qh may be released
in the dequeue process in other threads, resulting in a wild pointer, so
it needs to be here get qh again, and judge whether qh is NULL, and when
dequeue, you need to set qh to NULL.

Fixes: dbac5d07d13e ("usb: musb: host: don't start next rx urb if current one failed")
Cc: stable@vger.kernel.org
Signed-off-by: Xingxing Luo <xingxing.luo@unisoc.com>
Link: https://lore.kernel.org/r/20230919033055.14085-1-xingxing.luo@unisoc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_host.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -339,10 +339,16 @@ static void musb_advance_schedule(struct
 	musb_giveback(musb, urb, status);
 	qh->is_ready = ready;
 
+	/*
+	 * musb->lock had been unlocked in musb_giveback, so qh may
+	 * be freed, need to get it again
+	 */
+	qh = musb_ep_get_qh(hw_ep, is_in);
+
 	/* reclaim resources (and bandwidth) ASAP; deschedule it, and
 	 * invalidate qh as soon as list_empty(&hep->urb_list)
 	 */
-	if (list_empty(&qh->hep->urb_list)) {
+	if (qh && list_empty(&qh->hep->urb_list)) {
 		struct list_head	*head;
 		struct dma_controller	*dma = musb->dma_controller;
 
@@ -2424,6 +2430,7 @@ static int musb_urb_dequeue(struct usb_h
 		 * and its URB list has emptied, recycle this qh.
 		 */
 		if (ready && list_empty(&qh->hep->urb_list)) {
+			musb_ep_set_qh(qh->hw_ep, is_in, NULL);
 			qh->hep->hcpriv = NULL;
 			list_del(&qh->ring);
 			kfree(qh);


