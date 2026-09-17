Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F8924A078;
	Thu, 17 Sep 2026 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667680; cv=none; b=qtbdfTpI5L0afE5YEEaQkov3ethP4FkoTFzJN/5x3aDG2zqXlgKbgdkN/aLUulverjmInvdpR0RZ8OLvyG3IFZakPDkKbghQyjPr9O8Ra4mYp0OXZmsFZ2xyoAUL/EZBT0V+72f5aDarf/oDZmmXOiEcm5giYeth2aOHJD3QoXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667680; c=relaxed/simple;
	bh=PXWuv3OMpiLGSGuuEfk+wyO/mo4SBzYm1KsHvYM33Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ud9ivFR245yRwoHiYvBvKqZWYgCm+PnHisFp7VN0rR/eYMVROzBArSwUPHwt8kpOjuitnk3lv3Si83lCo+H70AVLKWVUFFDe1gWhX1FhL2XfEczLTP9K62/3oNU2wVY0KZonTuQlrOZKSQ3vdP1SKtPal/xJ/d63dRnXPE1asYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrruIcTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrruIcTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F831F000FF;
	Thu, 17 Sep 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667678;
	bh=vu1TLcU82+CX9XCj9NdklYwf8bJiho+OKk0gMpyay2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrruIcTEynigSl3RGRu4HODdNeVub+3gcgtvyMCG2awWqYOqQVvVhsXvEdTlYojii
	 S9r5w/u3tg7FE1aAWxcDRLmTAJPC+OHHonn+c+Fucj7+yHPz/n//z710d8poksQrE1
	 /IkLZyofsCkerwJM60xYvOI1uF747H8c15tP3xwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0135/1102] usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue
Date: Thu, 17 Sep 2026 16:01:18 +0100
Message-ID: <20260917151542.911317949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit e2ffaac1884b921b8ec2b3a964c6a8b5d610bf4b ]

ast_udc_ep_dequeue() declares the loop cursor `req` outside the
list_for_each_entry(). After the loop it tests `&req->req != _req`
to decide whether the request was found. If the queue holds no
match, `req` is past-the-end. It then aliases
container_of(&ep->queue, struct ast_udc_request, queue) via offset
cancellation. Whether that synthetic address equals `_req` depends
on heap layout. The function can return 0 without dequeueing
anything.

Default `rc` to -EINVAL and set it to 0 only inside the match
branch. `req` is no longer read after the loop, so the past-the-end
dereference goes away. No extra cursor variable or post-loop test
is needed.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Link: https://patch.msgid.link/20260521065428.3261238-1-maoyixie.tju@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index efcceb886bb40..de00e53977ad0 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -694,7 +694,7 @@ static int ast_udc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 	struct ast_udc_dev *udc = ep->udc;
 	struct ast_udc_request *req;
 	unsigned long flags;
-	int rc = 0;
+	int rc = -EINVAL;
 
 	spin_lock_irqsave(&udc->lock, flags);
 
@@ -704,14 +704,11 @@ static int ast_udc_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			list_del_init(&req->queue);
 			ast_udc_done(ep, req, -ESHUTDOWN);
 			_req->status = -ECONNRESET;
+			rc = 0;
 			break;
 		}
 	}
 
-	/* dequeue request not found */
-	if (&req->req != _req)
-		rc = -EINVAL;
-
 	spin_unlock_irqrestore(&udc->lock, flags);
 
 	return rc;
-- 
2.53.0



