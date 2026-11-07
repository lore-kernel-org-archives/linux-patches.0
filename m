Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063243;
	b=qtZDuEVrcBL7OT+cp0lHVLt/KaWWtRZQc7/WgcnRrNQQnKjh47DKlKTPMJkH8ZD0iM8Q
	 6iFaPJvfbsEBv4MSVlYOk/1QQq5PFwOn/33IU+w1IBszBj2Yf88ShyPlLq2FdttIpfIAt
	 XZyEstEOCbmQo5hyThHVC4/Of859QJhiBU7E3a0y0Ba9UOhNPOwab3z3PVVDq2N0RZUfj
	 WrLV3hkXQuPwHKAhwqpzCknfx/Nv4jQPSkRnmv0Y0oYgOsHJG301PzDhpE15YDMf9lrur
	 Mhqjp1gTh2R6kWI3nUkNghkW6T7EPBfGbBv7lX5bAWIWQi4vRgYrZ0LEM9FjcWjzqhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAU1RcJgcd89RaTT+2u4K8MH4NNJ9vz34nFgWB7obRQ=;
	b=36lZZpGebt6GSGHimG1pwwukUYSdUepAh7lFMIbBKUg6An6gbSaMlBbbqnSLUwdKJrUR
	 XoFdxaZTm4wEMr/IbGjKc15pkP+VXo0GSu5DfjWUQXTr4kOi2YIt8xm0+AuWpid+mg2CQ
	 aO0Bnqwmkvr0lodqYECXcLLkVszyF3lVIoRcFKY64WDGLf6riUHYloRLygL0PnBwgXjFY
	 P3QjT90tVM9E5Nn3Nugc62Vx8pKVD0gUO8R0ZBkZM/ngur0yslvW0+nehIP1zaErZETpt
	 a6uOr6fd6EXV0YPMWmjucrriW7S16xyoLpGi6BxXlxj8oGylJG4a8XicniMcvBgc7LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4oEGwk4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9873C606A33F;
	Sat,  7 Nov 2026 14:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x4oEGwk4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473C01F0089F;
	Sat,  7 Nov 2026 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063243;
	bh=iAU1RcJgcd89RaTT+2u4K8MH4NNJ9vz34nFgWB7obRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4oEGwk4btOyM/1wS8uxtQRlE/Ef6zJqpE4ZPdf3IV2yMudtPKBiX4g/uzZLIirJu
	 QGjqP88y1uLmTkWRIUVuqXDeTrRMZ4WgNrpjUa+7p2ZAobstzdaLKe51TGOeQlBPI4
	 qf5uINsxbVJtrSZQnj3/h6byVOUs6XbpljnZGmVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 448/869] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Sat,  7 Nov 2026 08:52:10 -0500
Message-ID: <20261107134908.919381034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c78dd373b5c56a5a02da591b583c6b48d0d62954 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the option driver")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260916165608.2085613-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org	# 2.6.32
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/usb_wwan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 0017f6e969e12..67e1820bbbafe 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -402,6 +402,7 @@ void usb_wwan_close(struct usb_serial_port *port)
 		urb = usb_get_from_anchor(&portdata->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		unbusy_queued_urb(urb, portdata);
 		usb_autopm_put_interface_async(serial->interface);
 	}
@@ -579,6 +580,8 @@ static int usb_wwan_submit_delayed_urbs(struct usb_serial_port *port)
 		if (!urb)
 			break;
 
+		usb_put_urb(urb);
+
 		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err) {
 			dev_err(&port->dev, "%s: submit urb failed: %d\n",
-- 
2.53.0



