Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208744;
	b=NE13RWnt+qySL0TI6/kzIlH2WyY54+uhxBjSljlit5wp1pm+YrDT+rRxuZ/nWN9D5U5A
	 ziSRiTUVuSgfxl1BnVhUtskL9Fv4E1gP7BAcE/lJdUxD+zViZlvCws6CWM24/UzvVIILV
	 +Z+si2JZn+7a9I7NwYtMUfFb1hUxjjUTMtAxFzhrLbvd+jHWbCtAxOARanM255IGmEtsQ
	 BCwcfAK8ltcX634qBkNBmW2tBi1NZ1DHZNgSQOL7v+y6+ms9ILwvLoeK2pOtPu0TmT92a
	 SQManqrZiW7hPmcAS7npUvwxLdalzMG6mREn9AV2GsN7no8Qq62NZHNpN810XlpeJOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5//NO8hDP4vTK5URRFFaYBcKG4v/NemBVUT5KfUKaF8=;
	b=dPMWNGNIWsndWBJlgrsBCmKcstM8lAxcU/kpfY6ha7J1PM1mD32FJnts6ejjokY0cCnt
	 mPDpA3ud3CBgaZJDXVHRWv/Tkf0/1NKS4iq3STlcfJA62nfQM9ZPWGZKxkPchZaPmx5mm
	 lm/UEqE0TF23wfPK+My/YqJr0SA12Zhoetr2uZJCiDOz/bJht4h8fm1R76gdJIJJZ/AAW
	 lZlMGsjxwjGmkAl7Kujpc33yohpYH6Fy7gS+3AxFFzMwXFrLimpG6dVBPofga48OBucst
	 RJyjXuVhpE2ozaVYIHRqkP0Yx1uVUjJNCkTJvCvfvbkS4hgUt9E21gD53cvQ6NRapmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lek30y2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E2B606A31C;
	Wed, 28 Oct 2026 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2lek30y2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D211F01825;
	Wed, 28 Oct 2026 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208744;
	bh=5//NO8hDP4vTK5URRFFaYBcKG4v/NemBVUT5KfUKaF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lek30y2LbR0G6zvO/VrYrim3iE+RIvPSrFhUjTPCvpbkxakzy/LBZIPo/Ta4KC31
	 Z2XZsFNaxg2goliXMyXACrOasjqYcq4ucKvTWK4ALIOR2fD+ycqdkTxuWzTA2rRSZj
	 aKsGQqit7wRmiNDxT+cDMVP67X+VXQo02xCwRpWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 226/516] USB: serial: fix dynamic id driver deregistration race
Date: Wed, 28 Oct 2026 17:56:18 +0100
Message-ID: <20261028170008.860455855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 63594e8ffe097bc0b7639936f33799a7653dded2 upstream.

Only free the dynamic ids after having deregistered the driver and
removed the "new_id" attribute to avoid leaking any id added by a racing
write to the attribute.

Fixes: 93bacefc4cc0 ("USB serial: add dynamic id support to usb-serial core")
Cc: stable@vger.kernel.org	# 2.6.21
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -184,7 +184,7 @@ int usb_serial_bus_register(struct usb_s
 
 void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 {
-	free_dynids(driver);
 	driver_unregister(&driver->driver);
+	free_dynids(driver);
 }
 


