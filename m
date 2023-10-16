Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12A1A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6/RFbtp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD3C433C7;
	Mon, 16 Oct 2023 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446242;
	bh=AcJecz7edoeNPjFXNQaku93oXSM1EBLJaBL6uMBKmts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6/RFbtp4hEYlOPluu8jHbYqjRQFATYW37KKOETUWs5+wUAx84WZvHdU/De9GE3KS
	 7GmY8/7Xe5alYuFpAr35teyW9sMG9gV079mz5XPCYjOG7evv0rbYf4SQM8P97ZKtpu
	 BYqd+g+68Sz4JTOwzex6lko2ZKxh/50jf2GFFW+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 079/102] usb: cdnsp: Fixes issue with dequeuing not queued requests
Date: Mon, 16 Oct 2023 10:41:18 +0200
Message-ID: <20231016083955.802979810@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 34f08eb0ba6e4869bbfb682bf3d7d0494ffd2f87 upstream.

Gadget ACM while unloading module try to dequeue not queued usb
request which causes the kernel to crash.
Patch adds extra condition to check whether usb request is processed
by CDNSP driver.

cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230713081429.326660-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1125,6 +1125,9 @@ static int cdnsp_gadget_ep_dequeue(struc
 	unsigned long flags;
 	int ret;
 
+	if (request->status != -EINPROGRESS)
+		return 0;
+
 	if (!pep->endpoint.desc) {
 		dev_err(pdev->dev,
 			"%s: can't dequeue to disabled endpoint\n",


