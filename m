Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036425;
	b=Inz4R++7c+g1S9KUFeknIgzzUFuJlo2BO0jLM7hz2yIskR0wV+wOfnn5prw8dHftx+Jv
	 nj13x8qSk23S59TlIg6UJc69I2ijpZmjhpnaFUUENkqnV5pMp8vTlKXICanDdsLSZB3rO
	 kJI94OHs40tg5810G4w6HYjzsYiFeQL9Je8jQy0FLH6P3RmLi2PbJFGsjyysKRsUbh6th
	 orV3ycisAf89zZVXQQC3F3hJ1FPVjsAD879KqQrYAkABCKorexIxuYOpIpoWZCeW8ck9m
	 3CJaVKQLbKAwEo2f5PE3kqTTdUnu81EFa8Oxsm2Lphv+F33daXgt1zHqEWvjGbg+1tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPJRr3vIy6AbudWfZXRXC3xcAb1ouH/KIFMcd2BEyXY=;
	b=t0oTFWujEJEu1M76N0ZIHIDJKJDpCCK3RP3kVQyH4N3rBSRuG2KpBdSwIHy9hMRq8zN1
	 JBQqOzRF4mkMssaAK4CtkBvXvGpL4jWzjCzXeoThVaSCFG3JTAPapgtmcCQMNj5MU++Tt
	 qBLIz8kGnetwxEBXYVHWCjsooAy5QsdnIBDfEIgxs/28j0rIoh8jNQ7IF6iGFqJs0bLtP
	 PGEEULSiln+4fF4Ma0cEJEfoWfXTIBbe6GHSafUTHsB+PdYrbaf+ptz46MC84r11WcVOc
	 6ojlFF0cTdY4ujg/tEDCfQoox/k0psRHSkoxPVrMulkm0nprxNTThy57iJ+z0Nd9DKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpySzaw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7693606A31C;
	Wed, 18 Nov 2026 21:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kpySzaw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097C01F000C6;
	Wed, 18 Nov 2026 21:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036425;
	bh=BPJRr3vIy6AbudWfZXRXC3xcAb1ouH/KIFMcd2BEyXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kpySzaw+J/y0zUSiM/NuUqKHWKEt/IiFFbxXtRTpIuwaGeGb79fDRNb+wB6MOf6ar
	 bPiDm7Rf47qiKka8XzFN0fgzgEzfz9KsH/MTHtSQ/iRYmeGgSc6oI6NnyzdDMrH5Mj
	 SkO7PGpw6EeBR+aB2AAO0sKAVnFC6C7XB+JwcLQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1053/3318] USB: cdc-acm: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:27:55 +0100
Message-ID: <20261118150351.518802373@linuxfoundation.org>
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

[ Upstream commit 648b08aa37c1b24a61662ad78964f2bca659ca26 ]

Make sure to drop the reference taken by usb_anchor_urb() when removing
URBs from the delayed URB anchor to prevent them from leaking when the
device is later disconnected.

Fixes: 140cb81ac8c6 ("USB: cdc-acm: fix broken runtime suspend")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260917161217.2161883-1-vulab@iscas.ac.cn/
Cc: stable@vger.kernel.org	# 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261009122934.464142-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7c6ea7d1d6d77..917114d0d5b1c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -782,6 +782,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1710,7 +1711,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



