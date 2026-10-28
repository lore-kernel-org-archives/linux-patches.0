Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212916;
	b=w4RxWdtlyRTKzGUjZ5JdQ5FBWC9O4wWY/0NOniXu2ZwbqDL8n2CukOzirmrXQNHXRGw4
	 Tm2P13C+ftguVufyexQk87B1Hdq6/nMQykmgXen3laNWlJ6Bo4KjjzUsi/u5h2n/sZf7v
	 gUzmc5u/XpvVvAKqsudBPdBvLhn9u361LaMgH0Q5T+rYH5Ci9uuJOKOTHzwIpxK1H3RNl
	 vv1jB5Zh9mPDZRo/O73tPSaACw2/rpVszAheM4z2yaa1/HUjhair8+TihsWgGM0HF770p
	 fJI8PdWC5tsPRt+WC55b5jBRrmwg6/ig4C8HpZqdpDVTtRJJZR/154YzVTjVW23IIaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H1BklHVo4y5cF5y4Oyk2hkmv8+x40NcwQqj0AT38qkU=;
	b=oL0uiRFPLRxP8ymsdoBmcQU9N3uVWoP7vKffOvUG1izrxAPWiWkcPya2aydXUEj/r4pW
	 cT7zFiR6VKEz9QFbk7RQr8PQRZIG9lySLtfGqpPfwGBs/Hj7/+ooi6NIu/qkk2YypMqxi
	 ED+ajeBTpA7KSr043YCOb0s7/bBdqhc+zMEvmzei9TNBsaN7EkO2HMxmYG9KqTOFi5Hdc
	 RoTxhMTYVGwM88GvMXqjFIBiV8P8xa4cs2KtgKjCG1CvOefBC4eLkWaq2VXYGvo97kP/g
	 jom8/FhiouBaCeyzJbse8KvfbsAIO1UjiLvHD1evt/SbctJ1/3t+RnnqloFudl8JcBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjLtJwWq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7260A261D;
	Wed, 28 Oct 2026 18:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BjLtJwWq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F389C1F01825;
	Wed, 28 Oct 2026 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212916;
	bh=H1BklHVo4y5cF5y4Oyk2hkmv8+x40NcwQqj0AT38qkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BjLtJwWqfErNWIbUj53BLCgAGpk7D2S/8zvlPcm20MCWdS4Mq2EF0Xw4gBuKAQC96
	 gl33n1wlClHAkrNZY/NOb6JfdvDXEUsITxrRbce+Dapk7cz93jaGvuyX22Vw020nPe
	 xCmo2pSb0Kqgfnmcco49hbR+jtplVcnRqxxnqdoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0322/1887] USB: serial: fix dynamic id driver deregistration race
Date: Wed, 28 Oct 2026 17:40:18 +0100
Message-ID: <20261028170506.557676847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


