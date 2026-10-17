Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86593AFB07;
	Sat, 17 Oct 2026 17:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256703; cv=none; b=P5lHevTClfg5UiAmgtASNW88LpbmpVZEwTITpB36Lt3SWWlu8P17TlHcTuoBi8ymNfGRLfKfg1/QdYYCUcfH5mjOT4Hm2Gw4DFGz+UmibRV9umZYD76yBzOWRr+rKVojqO/irET59+892VnnyU73sA6+cHt8syYe08uQOrjOM98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256703; c=relaxed/simple;
	bh=MKVWh88eeYfBfI2tezc8R6CzHUZhT1ivF5rVFTsEWRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emoVSN03Dv+vmQd/BND70reuO7dfTxvYjxp/ZEbtuCkEPgZ8jT3fnjMHatBXozOBnM/dscP3l8meXlcZFDUppaJkdndpv8AYk+uK1QH86ks5HZ+Lb/qdRQsgfg9zgqCJ3T9TwpEw3pb6bwLpO5G/WZdr+3MJUsdD+CXxwujEmjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOv+nqXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOv+nqXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F73F1F000C4;
	Sat, 17 Oct 2026 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256700;
	bh=43XhLYw5VHZivlC/D4z4DFGhuQ1elVlnbqY37ntac3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOv+nqXywVvt6hUeVchiKOkJqvn9TGg4TBqkN3fHtQes5Gy7+/Fo+NH7RyiRND+jY
	 AMFZiPGqpNPB/fa6XGwJAG82R9mE1U+V51LNfLLgjRa6ADbeEkNFXJEuSLJKOz5ltV
	 p5Jqg7lpvpr5kCG/GLxRoTPwTHXWfhXPx/8OR0+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 0323/1674] USB: serial: fix dynamic id driver deregistration race
Date: Sat, 17 Oct 2026 17:43:15 +0200
Message-ID: <20261017160439.416255270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 


