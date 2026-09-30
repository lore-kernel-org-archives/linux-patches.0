Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53673CEB9E;
	Wed, 30 Sep 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794118; cv=none; b=qub2Kil0u1u6P4Qhk04F03Pe440WXiZUrB8NT/4wlTbXLnx/74BLUbmeu3G7ie7b2JFA+6FVjVWJ/SqVxqLU+eUu+CZ/HaFN1Miv7rIBIEGcqOfg8119+ijcL/+aVYgmQPXrf2ICj8YmCqrY+LWrAbtWhjctxJt+c/blpw3yQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794118; c=relaxed/simple;
	bh=IQisz/YlLEi+2Id62vBsVrt18HyJMNPJbgWw+8CsPqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcRnIAagl8ZumFI0lwF4vsvXdZ8Xgpw80haphbLALF/gD6wGedgHwhZkyjKqmBLllpCLe0MOOogJeGohoQXs2itFFKoxzOaURsqkg+LzIlvLBoy4wtYUVuf8l46sBkVDsCLW+fBEpVDPUjYlKWalOFKKiLYdhmj+ixClzrgmzBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbPswnll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbPswnll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0FF1F000FF;
	Wed, 30 Sep 2026 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794117;
	bh=VxVvxbWufMDAW4QR8apj6e+DcGunr5Q/Td3nJgaeQhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbPswnllRlUHQnupcGeVSkb4TKupznUDAW+zm2DahP7X03la4B6A/uKSvNsS4PEHx
	 e5+2FklXrngtmi/y5D65uFwe2vrGsugfrdDnr6aBGwry/VdDc6eg1jEBMcNDs/W56O
	 kbQsRqxfXCw1urXTyFSEZB6GDNXCyIsfKSUpqQUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0096/1193] usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue
Date: Wed, 30 Sep 2026 17:13:00 +0200
Message-ID: <20260930152436.371947823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



