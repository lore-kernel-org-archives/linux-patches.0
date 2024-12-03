Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712B1F130F;
	Tue,  3 Dec 2024 15:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239413; cv=none; b=dhIXj4n5cl5PhuO8RyAYK+SXsrF+p6uIQDhaC8N4AKI7v2LKWBTddZqbMPza5KhGxkQCOL9hbtn670E0ib6DWtKyT9A4iHHQ4exKELehwn8Hs+6hUeYVj97Rf+0faqvpD0v2MT0TtJe+CL7fOj6Lzi7GXfXB2mwzP3Mksk98PPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239413; c=relaxed/simple;
	bh=OlhFBglXlkqKjZMZ41wzelmgHcYN3iSHPyaFzB25K2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5Dts7kZ7loD8n3vQBzaHA7bbciKyqVXono2FmrBgKBebeVqTtFw5hbKgo4wfPQhr2AeslLFP/mZnbE7akWTQ9MsX5UMus1ZP9p+QfxrcPlqzDjkp9awQorUbLDorbjUnhDxrpWDH8W080FKm+T8b/JO02z4/X98akpOx4CHpKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7/Arx5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7/Arx5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC96C4CECF;
	Tue,  3 Dec 2024 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239413;
	bh=OlhFBglXlkqKjZMZ41wzelmgHcYN3iSHPyaFzB25K2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7/Arx5xkxiMTt7Es6M6HWGB5y5Yt7r0MdEPj9doR5Za8l+PUV58tveCv+2+zBpYC
	 GLq4sxyTg9zFjHRlOZTBpB+jtO5VxrFsdafg2GcGimnC4E2k1wHfmTNJS1VBVuagzN
	 i7YApVwh4l1oJqrklAKuMYRkA9G/1muUdwKCDcwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 604/817] usb: gadget: uvc: wake pump everytime we update the free list
Date: Tue,  3 Dec 2024 15:42:56 +0100
Message-ID: <20241203144019.503324643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit adc292d54de9db2e6b8ecb7f81f278bbbaf713e9 ]

Since the req_free list will updated if enqueuing one request was not
possible it will be added back to the free list. With every available
free request in the queue it is a valid case for the pump worker to use
it and continue the pending bufferdata into requests for the req_ready
list.

Fixes: 6acba0345b68 ("usb:gadget:uvc Do not use worker thread to pump isoc usb requests")
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240403-uvc_request_length_by_interval-v7-1-e224bb1035f0@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index a9edd60fbbf77..48fd8d3c50b0c 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -480,6 +480,10 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 		 * up later.
 		 */
 		list_add_tail(&to_queue->list, &video->req_free);
+		/*
+		 * There is a new free request - wake up the pump.
+		 */
+		queue_work(video->async_wq, &video->pump);
 	}
 
 	spin_unlock_irqrestore(&video->req_lock, flags);
-- 
2.43.0



