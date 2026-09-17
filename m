Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB854E36E7;
	Thu, 17 Sep 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663896; cv=none; b=i/N1wOvK3fZmWcobTsQLWE2W5oaGSwOpUVarSfYC+6IOFbirWpaLObEBREFzCCVGMaM0USx7/CY69lo/lHu909xKXn3yzM039gD8sercVHcjEUOMWUldUX23ZGOBWAK6ZGtCF1426Zr16khzjvgiVJp4MTU+tM/EwotKhwOVM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663896; c=relaxed/simple;
	bh=1IFk/vzKFHQCuQ/amUnqNi5wEQhBpVLhEardW6vRwFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSkMQSaMBgQIbne9ZM/kMr/qXn93dVBJzH6evWtcI2f506X+YSBVr0KJWTrecUtLyi/5m59A2mXemzGr3R8Q+gvUD8Qd6QXoQJLsPi3aXaob9O6toRBBaf3zYscocZaXawtafgwtsxKsKjJmyyIhGNy/JFDr/nr+JXYJ7RB4XbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw9sZn+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw9sZn+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539371F00893;
	Thu, 17 Sep 2026 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663894;
	bh=S7p5a++0hg0MUKrL3/hWj0TbArWmaoFR1/FiC39eeaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw9sZn+ZQoGigdqCdXTUWn5teuftwXCZfeSXuSWlvZgcPvSkf+9Tc8ge7tisRpRzG
	 +4EIrGrL+YqqGLtK7Bm01A9EOdVDlo8AWNnNrrE7gNzg45VTjuw5C2rbbLuuIB9R1c
	 LkudTMF0QyW4dEhx/GD6p/B9JDj0baMCLQvKefk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0190/1250] usb: gadget: aspeed_udc: avoid past-the-end iterator in dequeue
Date: Thu, 17 Sep 2026 15:59:45 +0100
Message-ID: <20260917151557.265164564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1757570f7b3a3..94f5184412378 100644
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



