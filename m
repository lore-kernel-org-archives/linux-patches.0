Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063106;
	b=hmwLofURW0CMXOD8Usw/QZlYwYX5Hzd6cAnVkNcVUJZzTK0q0ceq+vcp6p05pCExnPvo
	 D0bK7f6AksUtzpGToF03uodPmCZo4MQ3ozlGEw4eu6vKXszqrZ2d8DKWpOKnVK0a8+vUV
	 HDE3CL723PGD9d6hegKXLEoxVaBy8zeW55S0RVvdiCi1FQIUj4IM+Q/IxsGtcZn5Joh+u
	 uVDMm1pX7lqqaWsXyRjg34iWeRaIzejEPgZwEQOrXaVA4MjDUw+a24EX2vLnABTnPtrX3
	 iM3O5zWYJNDZldD/g7wFI2st+1Jcn0urdsSjo5jQUl6kXP0S/TlvBGWOUNn5rcUXepg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w1pQ9l9HgumiSIpNRvrf5S4MMAs0fn2jY2858sGuzAo=;
	b=1iWKMpRCEFBhfm1RyJRnkX2U4tUxpVRfAUjtsLJIlRq8VGUTGzSgEvoqk0IGjahJBfkD
	 wsGCruO5V/O/AoB7uNz/Jw8iRFQMti2AebbyA2JiGBGUuU++QIRrDCKIDU2Daz/f4RdeU
	 qxg7VdoZeIk0ayiFik8sRbo425v5AY12/kMhLit5N9nx2GaiSAyusmV6Wqk2Z98HRf+Hv
	 KqVmWLshcsgfELILzlvmO95E/qYv2Cc/L+yCiL/kcK4PjdX+m5HQTJCc5PtEbRsnaPuBh
	 LBtrY80UfdoRfYvpXYl9NciYXSp09XTRoRUH/G93bQTxRd0h8ke/6TPocjpgHk226Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNuMC197;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33B7606A33B;
	Sat,  7 Nov 2026 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNuMC197
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB571F008A1;
	Sat,  7 Nov 2026 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063105;
	bh=w1pQ9l9HgumiSIpNRvrf5S4MMAs0fn2jY2858sGuzAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNuMC197mOUrsMY8VVXkud6+7Cn2fbAsdRXGOnTgvQEwK1Fv8nys4XTz++TqqqNeD
	 Q4O/ts1bj0M6Ikq6Qo/iQk+ZyhF3NGR7fjLnG6j/v0XaoTY9XWFw5ShQWdnzVfxzfL
	 xaoiSMF7BaeMEBvy3j/mhKK0zlPlb2IU0q7zKs2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/869] media: rtl28xxu: fix SDR platform device leak
Date: Sat,  7 Nov 2026 08:49:54 -0500
Message-ID: <20261107134903.088827688@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 083a92996598a5080965f1baa84175082e14a45b ]

rtl2832u_tuner_attach() registers an rtl2832_sdr platform device, but
does not unregister it if no driver is bound. It also does not take a
reference on the bound driver module.

Unregister the platform device when no driver is bound or the module
reference cannot be acquired. Drop the module reference in
rtl28xxu_tuner_detach() before unregistering the device.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: a2f7f220df5e ("[media] rtl28xxu: switch SDR module to platform driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 487c6ab784abd..d2957e4bf0173 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1391,8 +1391,16 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 						     "rtl2832_sdr",
 						     PLATFORM_DEVID_AUTO,
 						     &pdata, sizeof(pdata));
-		if (IS_ERR(pdev) || pdev->dev.driver == NULL)
+		if (IS_ERR(pdev))
 			break;
+		if (!pdev->dev.driver) {
+			platform_device_unregister(pdev);
+			break;
+		}
+		if (!try_module_get(pdev->dev.driver->owner)) {
+			platform_device_unregister(pdev);
+			break;
+		}
 		dev->platform_device_sdr = pdev;
 		break;
 	default:
@@ -1426,8 +1434,10 @@ static int rtl28xxu_tuner_detach(struct dvb_usb_adapter *adap)
 
 	/* remove platform SDR */
 	pdev = dev->platform_device_sdr;
-	if (pdev)
+	if (pdev) {
+		module_put(pdev->dev.driver->owner);
 		platform_device_unregister(pdev);
+	}
 
 	/* remove I2C tuner */
 	client = dev->i2c_client_tuner;
-- 
2.53.0



