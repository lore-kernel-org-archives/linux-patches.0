Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211058;
	b=QiDpW6X0kIIR1csG/Re5zfGZm0eLPUc6Vl+fpYG0WodNex88/gsIxCfyt0931TOgzrFq
	 /DyhB5A5Va4kWFt/42JWp6XOjKQT4W6KE7itkHLRZPy2OgWrjxkWdaevR26mTFQTeNjFF
	 ELhF8mOFqURSiMSChdWD68F1tmbo3ydugPgZCJ4D+Cg5xkYHo9CbWHJUJDdN3AGWev7XW
	 g5LsZ/pJrSb69kbOSGVHqOqZa5nHI84/3BEDexvzxujzkwlNWB1nTtYJWPNuL9svyAGSg
	 +8u7JUmPSHJSVgK/BOSc3kPDJpnrQPda/V3WGtH4cX/BwHoAaS7HkFEHgfFR19nTHCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OTakROPhkF5Vq+ji66gmzB7VcfhJV781phDDCVBDob8=;
	b=NgpRK9QAnoHGmPv0pm89B5kCRsCffgRui/j9djpZ0q3q15JksKcWj+Bd0I8qqLI9hrff
	 GCZePFjKJlFNjpxmfJZB9Qbd79+UdcEJwhN04OmFV3hjqLRd6FUz9xoFkgeChUf2FuTx4
	 sLkhna6+4t+qj3msoWulEcgU8oibXwjtm1BEG2sKsjRZFijpgOnQKAKs67N88ATALpx+3
	 OdpUOXYlPS7mt4MgjdMNfAFx0jBip56vlKGRWkEjN0OZopUycRIQfj31ntHKGWJE9ezhf
	 hXzfR+T9qCCWj7QMRHmlxTyW8m4XKUFI/e9fPpoI6EJWO9j1k+vZ38d6UOG3tCLhrHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlqaWERJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764A2606A969;
	Wed, 28 Oct 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NlqaWERJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68761F031E3;
	Wed, 28 Oct 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211058;
	bh=OTakROPhkF5Vq+ji66gmzB7VcfhJV781phDDCVBDob8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlqaWERJzswDO/ynEfD0Y6AvWC1NZ/VVo3uhXl1PoU42cK8JQSsYNULV5c92i1prc
	 ZAsTstzjIh6l++MoonRbVdRBoXgfg3RX48vTGf5e+swEzDkZI1+2EwT529fpG6IFs4
	 rkeJRR5Oks4ProYfL5OsAfqfK0onwmb8EEqQLx/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 244/571] USB: serial: fix dynamic id driver deregistration race
Date: Wed, 28 Oct 2026 17:56:31 +0100
Message-ID: <20261028170013.796172407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -167,7 +167,7 @@ int usb_serial_bus_register(struct usb_s
 
 void usb_serial_bus_deregister(struct usb_serial_driver *driver)
 {
-	free_dynids(driver);
 	driver_unregister(&driver->driver);
+	free_dynids(driver);
 }
 


