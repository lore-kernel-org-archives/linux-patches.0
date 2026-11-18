Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045406;
	b=LlFPpHfJTeNVq+VU4mp4uF2s6JdyEXAXsXyvGhPeas+pNVNNawNqHNlrTg73c0Wo0i0R
	 2Wcel9+XedhV54eL9AC1/WJlg0uYuIEahpjo0VTBspEJX27EWdH52u4mG8wkxGbbPN2MP
	 mTWSZ51XUMXmBa+mkH9vf74F5n6seVPMyWt2fOyQheAYlIXmvvdxFPVCPDrtMrEQ3J9jY
	 LZv/Vj+EDpZYYNxja4eS4OvhyH3s5B5rMW7bUIqrHlbaTAE8s7GMum+jmyd6ca/JVzqPa
	 FNIvrD17TBNPOPcuhsnpyDgD4P9mFX2rmB8329oH8pEE7hs9D3IovtZ2+dWJvqS+cnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+gbqTTqCz55HF9aO/Lq4k9aBPT61MdynERcYOH4gNS0=;
	b=BYjSRYL/Thj6VU7Ma9QfYKHaqWr3DNVUNVAyighiywALn5cbh5epGHSx6IgXGyma4VQ9
	 W3vTi9B7TXQ9+jh+1RWKbGOqwjDy9tqvWqxtYNk2iJxdsWUxbBkF1lvumDpdaLzn4l4zx
	 z0xZKXZ9ZvliUPKuNA0MQFogsyCpe5IWGYtDxt3x1IM+kb0Adb/oZe26seEd2E3QWYqUI
	 Tc/eLwGLiQqtxSmRcKTy8EZruvw0dAEwcrul7Wdp/gTlaZhtXMTbC9ki4M3+7lxDVHVXZ
	 VmtfnSLCnznZFhMqbZ/8nrfReHR2Uxd5VvLeElY2GuZYJ4oCAL9RuGxma7vqRqLy8yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfJpXhKP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EDF606A31C;
	Wed, 18 Nov 2026 23:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfJpXhKP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F841F000C4;
	Wed, 18 Nov 2026 23:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045406;
	bh=+gbqTTqCz55HF9aO/Lq4k9aBPT61MdynERcYOH4gNS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfJpXhKP8pkprQ7g8/Ajk9B8MCd9d5Ivr1r65nGQqhvdrpvMlAxIBacWTTCDmG0Xw
	 tKmaKwt8QJKhW85VPtdwNoaBPtxn/dQ4l4s82dxbYTNSo+GHZx3pcpMijtPkDNL/bP
	 LMEGBajLSjY8HhFtzvCZWb7QeK/4uBtop/8gOnNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0912/2857] USB: cdc-acm: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:32:26 +0100
Message-ID: <20261118150234.416430419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 80e86fa38eabe..a699a00a503af 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -771,6 +771,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1685,7 +1686,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



