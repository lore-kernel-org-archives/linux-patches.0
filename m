Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482A3BD64D;
	Fri,  9 Oct 2026 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556810; cv=none; b=ohl5hYv9METpA7JkLfx3sEyqNRJPeqEVy/iLrUzsmTscp339amf45YZbUfHgLQf95bi0MqzfMLsRHcvjgQ94f2X71O2y3P0fFEjBIgs5OO/sxWOT5AGLYMzF9yXisfZIzkxETzdBRfsknYWBwPy1Ozh9c4g10ypF64j+KAJEiVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556810; c=relaxed/simple;
	bh=3QSVsZenK7jY8dW/z+/h8X31AKGInrTGx7jjveFC4Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdTZfzlXj9UgArVEcRweZqTq4Uyl+TmHGSdeXdkgSXbrPw71u/1e/5A4G/Ts2qjpTGpd13mAbn7moApewrFkk1yyda6QFxmvfztfns2NByDvwo8MWSDXZnQtpsLOKaML7YbUdnvMuHrnX7Y+8220m0x/nRls409qk0szxikFOFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPVo6Anw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPVo6Anw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EF31F000FF;
	Fri,  9 Oct 2026 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556809;
	bh=h7W0vvTq/zx6Fju5A3vOLXRn1PXUIktUz550ZJyXC3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPVo6Anw5n+uFUpgeFzEVGOCWQvuzNRPdooNRnUMviety8kLw2LI4+rpAhoqYUMTO
	 pJK46wMvq1Rw2XagHVmiGIUayCIpUSA/QNfH3iPiH7TMgiwSy6nyI9NwSJwcbsH/4I
	 GYFz2Y7TAVl6hBf52vhSA8nB7SJBMIQFTiV0R7/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 279/403] USB: serial: fix dynamic id driver deregistration race
Date: Fri,  9 Oct 2026 16:10:40 +0200
Message-ID: <20261009140958.715219524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -165,7 +165,7 @@ int usb_serial_bus_register(struct usb_s
 
 void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 {
-	free_dynids(driver);
 	driver_unregister(&driver->driver);
+	free_dynids(driver);
 }
 


