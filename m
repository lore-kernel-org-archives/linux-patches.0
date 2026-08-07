Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2566438C2C0;
	Fri,  7 Aug 2026 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116267; cv=none; b=r3ZxXtGqoDmYeopZiQ+gw6BiaDWk+9LlGlPE5DrHaYwPn++oukFXYbUrrc36JBcmLXgh2EGc1UTjevhuPw4MGg0B5+UcKhM+qdhbTN2YhfmcJFViK42u5AaxU+vzc34rBK7zrVjh9fqxcnQFh33pmhc9K7y0ULnzS8RmMP4H45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116267; c=relaxed/simple;
	bh=TDSseCMYG1927bCvLw6I0eLbyaw3AggIdI9QRA80ggw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp6cKun8OZXNhEN7koh1tf+A8I3uizzjfebG8i2tRkWHqg1VM+r9iYhZOhcUVdvBEyVIaYXaKAZSvDGqMcpOpBXHwzw4xZ/90OBWUM0os4a1dNzeigw07lR+bc7GNz7Puqd6+XQEwUqAyTrjerP5w2gVLw6sUZJhkBdnPNWwj2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZg3y2cY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZg3y2cY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817B11F000E9;
	Fri,  7 Aug 2026 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116266;
	bh=6zz3jRWgdeNEXAo3Xh1Vq8BWwjIPMiCdGQSE42pL4sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZg3y2cYrdO5J/u1+RYF2z1CFMY9djnP7831pZpp/sYgrtK7qsGntNLQ6cdi8OHzU
	 qNesXGODANJV5oJZa8CktP8PfwyJmPz0gITVjZVVZI5B5SF2hxV5E5cmcScXG4m496
	 Ghmi4DxvooH3NEqFOmAVYe60mGoYtTVE0UseoEIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 172/261] can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure
Date: Fri,  7 Aug 2026 16:38:49 +0200
Message-ID: <20260807143419.077952249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 7a0cf2b2497c757c3cb1286eddf2986abb0d387b upstream.

es58x_read_bulk_callback() resubmits the RX URB after processing a received
packet. If the resubmit succeeds, the URB remains anchored and will be
handled by the normal RX path or by teardown.

However, if usb_submit_urb() fails, the callback unanchors the URB and then
returns directly. This skips the existing free_urb path, so the coherent
transfer buffer allocated with usb_alloc_coherent() is not released.

Reuse the existing free_urb path after a resubmit failure so that the RX
coherent buffer is freed before leaving the callback.

Fixes: 5eaad4f76826 ("can: usb: etas_es58x: correctly anchor the urb in the read bulk callback")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260706014601.415445-1-lgs201920130244@gmail.com
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -1476,7 +1476,6 @@ static void es58x_read_bulk_callback(str
 		dev_err_ratelimited(dev,
 				    "Failed resubmitting read bulk urb: %pe\n",
 				    ERR_PTR(ret));
-	return;
 
  free_urb:
 	usb_free_coherent(urb->dev, urb->transfer_buffer_length,


