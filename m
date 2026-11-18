Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052585;
	b=DD4Dzid+97+Gl/J8sj1Ez4OvktaAQFlXn/n6i811gBVhmpObpK+VRvfsYWwoEH02qwc3
	 QOLMytqvo97p5tbr6HtcimfkhJ52lLeLDsqVpjKyXfsxKNsV+hnnWAPY0ATaczR2WJuPH
	 kEhSBIPDou5e6pTrbUrBC9WJqNNYb/E3X1c2VmREgZETwV+AumFDtaE3N+aNFUuGRZapO
	 IBQQmgbH5CQUVpNQiMfsPNCA0AeSFmjZ49BYoKSCoTDifqZfDxWgjcPfp9G646aYOLzBz
	 DzWr8AL+uouZhQGBf2x17/7Arwiwjmy1EAvgOFC77dIUAuqy7UtA+v8BeZm0rMZj0fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052585;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+Fqt5BgJO0iXGWFin9SLypyYwOqxjk6KxzlUi1FDQA=;
	b=WBet2PrjlMPwrQS78YVcKgdHf4n5n5UTlhTkYCQtyUEzqnMOEmzj8OnHbh3weJXrVbH+
	 Ky003HSlUeNT+bmzBnCE7aa6Lp8GnYpYyw7qQzyJvmEtExJnRw51gB2nNESVRYMVuint6
	 ongsJNsKLg0+MrxGPlwzkzU/eO0g/p0qt2nbs2LgZ5+8pPUgpEJCLZTuLqWSP5C5jMdJw
	 pM2Il+NlAUnOfGzgKxrrgDOQabxTKG7Omcf54Pp8eYc4VnqFUe8fb+63yMDBW/Xjg/6Zj
	 1XeXCrcIQQN2rPeBWvPkLyi1NzUMz4OInRI9GIbCy/Y3WuJon4hvRqSG+honZJCfSEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCiLC6nC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF6606A32C;
	Thu, 19 Nov 2026 01:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCiLC6nC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C108E1F000C4;
	Thu, 19 Nov 2026 01:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052585;
	bh=l+Fqt5BgJO0iXGWFin9SLypyYwOqxjk6KxzlUi1FDQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCiLC6nCCnLgwwMbiA1T0KR8oPjbsPKQjHM+lLW12GgBo9uPSMqXBGyGVsAejk+Aj
	 7GyfubBZgP24hn1KPwsfB2Jz17JOwhA6ZNQ95HgCJZKPiQSYOdm6dDzBQI6STD4PM6
	 s/95hokd66kDhj89Bi7w++jgKbJ4fFch7a9l60DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Oliver Neukum <oliver@neukum.org>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0614/2214] USB: serial: sierra: fix urb leak on write completion
Date: Wed, 18 Nov 2026 15:38:10 +0100
Message-ID: <20261118150035.957267061@linuxfoundation.org>
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
index ef6a2891f290c..e54bde833f28b 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -974,12 +974,13 @@ static int sierra_submit_delayed_urbs(struct usb_serial_port *port)
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



