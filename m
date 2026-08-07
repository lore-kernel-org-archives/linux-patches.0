Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482D33D3327;
	Fri,  7 Aug 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115497; cv=none; b=NH2SuZysm/ccg0KYFfPj9v1rBQ0jmNC9t4Qr5EcpHkG6ogUZV/bUT0thB2Ood5GSG4wEslU4Sy3IEIKFLlu+g2CmG6NBoKNtFOOvpLe5PPJhfFiWf3WjEf9vwPWWEjl7LPrLSe1q/x8UdtkRcHDXLxijUuluUPUP5fpbAjZ6D+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115497; c=relaxed/simple;
	bh=S29ejtjeud6zU2+Vx4kw5avmuD61N1ikTNrB8mJHp/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NopnasPqLI9n26d8w8YkJntmknzj4upyEaqq4UguY/4RuvRruwN8EnW1liSs9RGAoxo8IQKotgcf5So8tVRbnld6mlW8fZRJhh4fZHLKM59ki21RDuFMSWt/45rq0uvacIEzXfOzKWSQ1oR7PZ2VVqE/29zyi+m6kUNWMZ5+zn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMl+1imF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMl+1imF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97EA1F00A3A;
	Fri,  7 Aug 2026 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115494;
	bh=NQmTQdWErcMb+ZwU2320RFxzBLh34arCcOZHz22zKiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMl+1imFMMy6Zdgjd1/SP3BUbmNfkZd+1au598TjicKCOfP6QiRHt28WJqXW+z0kl
	 XADy9otGECCu/+OBlejLyRMR7Rwy6Yk6aV44OdBFYYvjdMznH2Xz8WhNTZ1mLe6jga
	 /W3tppS9myZBJRFiBWIENokItIXJUPSYaZYKsaVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 297/396] can: etas_es58x: es58x_read_bulk_callback(): fix RX buffer leak on URB resubmit failure
Date: Fri,  7 Aug 2026 16:37:37 +0200
Message-ID: <20260807143430.676719664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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


