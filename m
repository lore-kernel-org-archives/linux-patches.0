Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5005379C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6133C433D6;
	Wed, 30 Nov 2022 18:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834278;
	bh=5Yx0XtmbS94yFIgGjpNj1vskK5cp1PTcHdag5jO3Ng0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iINROIWQKSEdBB6h/CIZZ5zGuYCC+5oCsYXsfozmVAVasAuw74cEtqJ9jg9JYuBaD
	 fs5hv222EWkIldrzgm1UnjcEfwZl8SV7hjtp1uzM+pIVZYcsVOARVYK/6S7GWu7aOr
	 SS0BinKqphZRt6tjDt4rQ0csTyiWpiJLwzEavVKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 194/289] usb: dwc3: gadget: Clear ep descriptor last
Date: Wed, 30 Nov 2022 19:22:59 +0100
Message-Id: <20221130180548.520666651@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit f90f5afd5083a7cb4aee13bd4cc0ae600bd381ca ]

Until the endpoint is disabled, its descriptors should remain valid.
When its requests are removed from ep disable, the request completion
routine may attempt to access the endpoint's descriptor. Don't clear the
descriptors before that.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/45db7c83b209259115bf652af210f8b2b3b1a383.1668561364.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 448c8e6bc99d..6f61a288073b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1016,18 +1016,18 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	/* Clear out the ep descriptors for non-ep0 */
-	if (dep->number > 1) {
-		dep->endpoint.comp_desc = NULL;
-		dep->endpoint.desc = NULL;
-	}
-
 	dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 
 	dep->stream_capable = false;
 	dep->type = 0;
 	dep->flags &= DWC3_EP_TXFIFO_RESIZED;
 
+	/* Clear out the ep descriptors for non-ep0 */
+	if (dep->number > 1) {
+		dep->endpoint.comp_desc = NULL;
+		dep->endpoint.desc = NULL;
+	}
+
 	return 0;
 }
 
-- 
2.35.1



