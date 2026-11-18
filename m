Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036434;
	b=JyYINPDtEhDn4UEDFyAlDzCdWA1EKB2AW1vyVciMuUT7wIQ9WMt4hlXdyagCjiZvqBkp
	 G3IZzgbTHMeU9hDY1bKCLvntfWihmiz8cPjeohb8WUCAK+aUl/W8JZPtaCW9DY8GoU79/
	 Cx/VX8E5vpbfP7wDqvonryBYlK2x6hAWIFzeSspK9Frnwmy+L6sydOjVlEInvp6s3d8N1
	 xaUqTSPR7nz/cxyzrwngSkhdeAh309oJPimagJ3hAu0CHs6mm1bx/HRR+ep1UCMcXbWsK
	 Vt6M2pD61fwtHy4rwb+LPSCaJ3UdnPO/0SO8BJcVJjMxb/3Y/CDiNtOIAJcmXyfY8vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jx4wHDrfXH83ksXebQz9S/EsyO08T1IWqASux/cr7NA=;
	b=zU/GEYB5+me2bamH8wm8Bg4bucU8gBsD4KskfknLayG+dgaJJ8Q+bx38BnjCPdM4rrJG
	 Kxw+Pxz9Gw26OfJ9JgiJE9ew4ZnBfoqdn3rVyR/f3wkdKavdizJi5JdQxeajiLdkpovm0
	 70J+5M5lnmgAa1nArunqiSjIHvsVvrlcNfDnSvEytkFH95Om4cVDktGswgaKhO2dyibyM
	 wo90JBa23Z3NkPK+M3K5JVPTrX/kvFZtVoJxo74EyC6F8MtPHGR5qY6cuW9YCrnMCcMRX
	 x8uEGIdknRHFGtls4sqEx6dMglOpF1Xl1IL6SSEuVECZ+3BgZwBtvmRMx0q73Wv1b3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ8OW2Vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95B4606A325;
	Wed, 18 Nov 2026 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ8OW2Vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D331F000C4;
	Wed, 18 Nov 2026 21:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036433;
	bh=Jx4wHDrfXH83ksXebQz9S/EsyO08T1IWqASux/cr7NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ8OW2VfhWe1L2fuY8nujYJkxQQU5QU02D5jJZO0yF0RZpOhfzJSNvJJbgqI2iM74
	 TmBOYyk3qVlboB4ZmNkQAKRNzhuy0BV5J/6iKLAthFR1wkcc4DI6N/VALEgqSmmkps
	 1N66h6g6i1zL32hGjvnRAoGXoPmxJMfXz+2o3mI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1056/3318] USB: serial: usb_wwan: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:27:58 +0100
Message-ID: <20261118150351.624314380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



