Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064628;
	b=OL3Qcue+nM9xmI4E34SPRJkSW9frB+7WZrOgvh3Qp3Il0h+qCusqgYbDhVhxtZHp7lJ8
	 zbVavCj5mTrTmYJYTGHt344WESC3S7GH9wm5rZPXznqttC7VsBjur/y80k1YQ2kactKBI
	 80hKpeBete4p6C2pB3SfJMuS27ogZdMyq0YZ1Kg9A5HB5nhwpJaqRbcYTcE3kL1G81/7z
	 dbL/4apGsyBhpvgAmPT4oriqQBlKev/M/Ay/5La8S8Go/UAhxcH2pYqW1TZbFZ84IHWcA
	 MJEdJbk1N01Azv3jolWNTrAfDrnKO01+oCR4NFcdxy0pDS++y1/3XfLs9AEjCDCY+kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5DhAUUVePDWaWI2HkCkUQlw3mLMrv8bOa3Es3fSRQr4=;
	b=NBCmo8RMbKu4aWwTplvZDtRn13aPaTvDD3yff9PfZPdYwieV5KX78IqARfDx4kBOWPUz
	 ATIdktvg0DqaQ7X8flxGzsQVex7XI45EOmpbQVP4RyEYu57KqtuvZtxkDn/UOiZbSYJJA
	 ABmEwXJdYd08fv1lHPcPNop2aj40tBk7eEdGK8D8C6pIR18j0ljwv/YtupUil5+jmkVPa
	 mpRGvLcxZdtWQDJzoR0VN3EZoe7uF/0/wK2+ftDQfji0eAcdiyoIzRJz06qv1qC1lWw7c
	 wBHmb2CLZ8Bru/9b+hMs2WezGYgaQ2dnHx6T6oSKOph6idMt+lQFCj4uXfibUbJCjxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+oYca4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78827606C005;
	Sat,  7 Nov 2026 15:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+oYca4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E111F0089F;
	Sat,  7 Nov 2026 15:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064628;
	bh=5DhAUUVePDWaWI2HkCkUQlw3mLMrv8bOa3Es3fSRQr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+oYca4tvXcS+hYNfBA+37LCP5gkmj4/SsIBCkdgIeEwvz5EoFWjBUwrS7Tde32L4
	 KOG5uEzsuScI4DOUrC16l4aYdH5kKk7UeT42CDjvYAuNPJWbYwBuN7Cj2ayN/b82z/
	 v6dRHOu+1Icr7EtPn5iY7i2Ko/S1L3lvegbbkXjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0637/1257] USB: serial: sierra: fix urb leak on write completion
Date: Sat,  7 Nov 2026 08:48:53 -0500
Message-ID: <20261107134956.875609615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e7daa54802c566ed3f22e81513f84c8c9197c5d1 ]

Make sure to drop the reference taken by usb_anchor_urb() also on
successful submission of delayed write URBs during runtime resume to
prevent them from leaking on completion.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while online")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/20260916165352.2085480-1-vulab@iscas.ac.cn
Cc: stable@vger.kernel.org	# 2.6.32
Cc: Oliver Neukum <oliver@neukum.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/sierra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 6e443aacae07d..f2cc7f364d204 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -972,12 +972,13 @@ static int sierra_submit_delayed_urbs(struct usb_serial_port *port)
 			intfdata->in_flight--;
 			usb_unanchor_urb(urb);
 			kfree(urb->transfer_buffer);
-			usb_free_urb(urb);
 
 			spin_lock(&portdata->lock);
 			portdata->outstanding_urbs--;
 			spin_unlock(&portdata->lock);
 		}
+
+		usb_put_urb(urb);
 	}
 
 	if (ec)
-- 
2.53.0



