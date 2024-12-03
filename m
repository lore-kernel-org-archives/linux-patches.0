Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DBB23CE;
	Tue,  3 Dec 2024 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242063; cv=none; b=adGcxjHO8UtnQIZncGF558BiK5EqN19SQPSITeyGxSY5HxfgW/dP9gpyuAfkUJNeDjl4W7VPav6KlkgoWEkv62C1CBPVoOnhhYznYkziHXHi21eIPPWK3+ycJssvuhLrXizSqaYEmKmH1UerNAbI5f+B9Aq76poDgoVfOWRZFco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242063; c=relaxed/simple;
	bh=xra+EnQm6SIP/1pLiNTJA7dd4CMzX7ilbsUxZXPTawI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aay/UY9RnWO5lNVNBvHnM6sY0ticEZRlwGqTyRbMFK/gOulaxrrCEPFfIhiHGsF8DeAl0sGJwcWy3YykiSF+ViNBB9b9PLwSlF4cqJ6gKa1EdEjqyTjZp07WyJZfbi2xm+WptzLwWpsANG3fhjcq4ohq52+AvU8W4AGp4ic656o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kHcuypJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kHcuypJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D8DC4CECF;
	Tue,  3 Dec 2024 16:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242062;
	bh=xra+EnQm6SIP/1pLiNTJA7dd4CMzX7ilbsUxZXPTawI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kHcuypJ6f1Cnqj9koHz+nNSlHrCofEuaSh7gd6GjJDlfho2KTlkiLdAVApye3nnS
	 hVhDz0nIJo45uc9E/Fq2bTFMK4oVaw7ZqBgMyhGgqmkWuLLgUOH2Yw9rykCy+Ff6bx
	 5R8of/0TkeyKscm9CQwkZL2UUVN8zurvd1qPAqaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 597/826] usb: gadget: uvc: wake pump everytime we update the free list
Date: Tue,  3 Dec 2024 15:45:24 +0100
Message-ID: <20241203144807.045141249@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57a851151225d..002bf724d8025 100644
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



