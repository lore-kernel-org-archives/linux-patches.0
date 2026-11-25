Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623815;
	b=xj8e4SbehUbn+ouTQzp9C4YfomaauqS52JKMU6vWY+hC0yOxKmeyCGsKXsg4TCQvOIVP
	 MMbw+X+TkEE459gwuWxJAEjQF861Fy1AVSCbUfFbplptgoXtTpDlYJa5SvbB36FLO+nDV
	 oW7F2tIonwwwTyb6DORHGNVUli7cpIBTI9Pc9VIy8t+xQIXiuGxHrd77ndOTic7JnIPwL
	 TApZtsg4huFmWHpq0d0dzVc6T98Sk1EGZUzoWpSam02/guwY0vkj1/tHPSrdJDelcOhMW
	 uyDGDa0lO5yJC14JqjEg8KgHoeWRnwoY0QA6XjnyX4KcuewkBu4DZxgfqJMbAB47y6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dat6xJCuOGUBBc4rkmQNlYujYOnjXFSPZwVOjiAhz9A=;
	b=YAtTNioikKzGEXGJjkmof8hu02mgAdp9k3J8hI210Ltxq8E4+9mMdscI+ktpiyEbhtqZ
	 oRsmaZLXHjprNhgoHVBPGXFRACVtf63Tw4PT8LUlJkqrfERnwL0Tkyr0TEzVq6YlPpXfb
	 U+rSBYisv6wrkfyqCnCNtk2zQ3efRhAxje6+nie7JFLSH6ikCNLx12j+mT0u52rWkPmbp
	 rzodEXqbNd689kuQXzFQfnEz39Fx2l7IKndq+lgvwHHXiJwEg0g9SF8nbFfW5AbXN5llW
	 suyZwfExTbfShrGpxxCkSzBvM5tAdamwZIQwY+VfiZ/Kz9rgdA5R2sE11TU342WV90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkaHVQCd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B27606A323;
	Wed, 25 Nov 2026 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkaHVQCd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F0B1F000D2;
	Wed, 25 Nov 2026 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623815;
	bh=Dat6xJCuOGUBBc4rkmQNlYujYOnjXFSPZwVOjiAhz9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkaHVQCdLlCg4oq+SGwbnBvG1G6Mzr6UaLuhWZ95g8P3v82S3qom8vV6o4Coh8gEA
	 FuEjO984d5qG5vbMNsS3q1ZUDVPOoKf2205QN/vlypi0GCELRhnvjeT1LlwXXn89X3
	 xHHZPbclRYFaX+ac61jYsawZhk5gQBzLPTtocn7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 934/990] USB: serial: sierra: validate URB length in instat callback
Date: Wed, 25 Nov 2026 15:38:21 +0100
Message-ID: <20261125143843.871902175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit a3d43b39032cc5565a5693a10c581844342372cd upstream.

sierra_instat_callback() reads request fields and one byte past the
usb_ctrlrequest header without first checking that urb->actual_length
is large enough.  A short USB interrupt transfer could cause an
out-of-bounds read.

Add two length checks matching the pattern already present in the
option driver (option_instat_callback): one for the request header
before accessing bRequestType, and one for the line-state data byte
inside the serial-state notification handler.  Use dev_err() since
failing these checks causes the interrupt URB not to be resubmitted.

Fixes: 033a3fb980b041 ("USB: Sierra Wireless driver update")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
[ johan: use sizeof(*req_pkt) consistently ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/sierra.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -575,12 +575,24 @@ static void sierra_instat_callback(struc
 				__func__);
 			return;
 		}
+		if (urb->actual_length < sizeof(*req_pkt)) {
+			dev_err(&port->dev, "%s: short transfer\n",
+				__func__);
+			return;
+		}
 		if ((req_pkt->bRequestType == 0xA1) &&
 				(req_pkt->bRequest == 0x20)) {
 			int old_dcd_state;
-			unsigned char signals = *((unsigned char *)
-					urb->transfer_buffer +
-					sizeof(struct usb_ctrlrequest));
+			unsigned char signals;
+
+			if (urb->actual_length < sizeof(*req_pkt) + 1) {
+				dev_err(&port->dev,
+					"%s: short interrupt transfer\n",
+					__func__);
+				return;
+			}
+			signals = *((unsigned char *)urb->transfer_buffer +
+					sizeof(*req_pkt));
 
 			dev_dbg(&port->dev, "%s: signal x%x\n", __func__,
 				signals);


