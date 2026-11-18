Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052560;
	b=mQs52fANRYJl0aqYlwUoOkCx/ndM2tO7JLyZM9tr8Nm2WObsFvO/vg6xXNuLEltGGniM
	 4lTiNhB2Ysw2FrSLfb7//nPBrIp38tf/F11XXQOmiEO2MnksoIKJWHVYq5cBAxdsS+KZm
	 48n12On6K4eUz/bRfHqMy7/yN5y2DK9P2eIIxOiwQRxqJ0NwrIo6tOJJGUMhy85WS1EoT
	 Ki9aHtgmSe9pJM7PxFDmL9tmb4B4rC16LuxkZB2tAB/OEK8RQZso05lhW1UnN3S7yMH7L
	 vOaCqu049vh/9YgfRSt/rXAZeQX4Kp4EjBRiUuhN2x6RKPTxBv9KRXX71bsLd2lSbiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aAJfp0cJW9qqAk0EMGJSB+bkI/a9KFSSGsZj+APQ9bE=;
	b=RRGHXSPPcjA776LhzgEnPu4ad1VJcK4QkVnmJbDALo+gkChIpbcAF2Uy1izzRk+/O2eC
	 40Y2tgxr8mg+56zmUa9k6S5JHxIx1Nj5vEpmKMNTvotDvWw5zxnhh61c5olJ+MbaLd3jW
	 iWpheaHOA/w6qbKNG6jpVP9XmvIQosJL4jcsmhnfA9EpSOMHQYDErkWqOqoRhAfSJkqdl
	 po+tE9RjmMSgVOM0aDMxqrNtsqRNBGsBibtuovoz3KbOLyHVfOZPZLyvpUOosSHs1xqN8
	 3AYUOI3RNz3EhpkJ6Hx2+0AFAeQ8RlsDYOmeYFefm7Mdn8PmC1sSP33YduEjjazxsLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mo+xSqeS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73576606A320;
	Thu, 19 Nov 2026 01:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mo+xSqeS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5321F000C4;
	Thu, 19 Nov 2026 01:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052560;
	bh=aAJfp0cJW9qqAk0EMGJSB+bkI/a9KFSSGsZj+APQ9bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mo+xSqeS+TAaRsnOrjbal7ZE/WXZTU7SmNT617z7C4HqA6fBU5IittoyJiksYTbFm
	 CjNHmUJav0Mt5v2mvLMDsHr5QSG4G5ANOy5/pVhjmsok4QiBPtL1XfVwAnNSBwVlK7
	 1F//8KrNmWZA1sie8AOkW1xaYWvvAlAa36m++884=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0606/2214] USB: cdc-acm: fix urb leak on disconnect
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118150035.342985335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 44820a020e66c..6bb29d679bb1c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -773,6 +773,7 @@ static void acm_port_shutdown(struct tty_port *port)
 		urb = usb_get_from_anchor(&acm->delayed);
 		if (!urb)
 			break;
+		usb_put_urb(urb);
 		wb = urb->context;
 		wb->use = false;
 		usb_autopm_put_interface_async(acm->control);
@@ -1658,7 +1659,7 @@ static int acm_resume(struct usb_interface *intf)
 			urb = usb_get_from_anchor(&acm->delayed);
 			if (!urb)
 				break;
-
+			usb_put_urb(urb);
 			acm_start_wb(acm, urb->context);
 		}
 
-- 
2.53.0



