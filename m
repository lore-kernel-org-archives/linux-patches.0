Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062202;
	b=SSEDMKj9EqlIUjd2nQr4AT0AMiXrbBAzz93ypmrl/cqcCfIR5GDq6QAhjQxdmHUWaov4
	 FIRQNvp3lf9tOhjNn0f7pnPZZz1nmdsN2c3UbCdmDbtrl2IX1pZnXnL7twU6PvZ+aQWAq
	 BBskbQlSCb7TqOIWWwXTHeHtzA3e9h92A5xVYg2RLgLtqQQR3Mq1pnBMFXYVZagJp2uSm
	 yQfpa/PsuyGkv11nyLzSS0Jhfi2Q+mFvSTomewKDrfuBSo4RlmEAIqIAI/4wdaHKqN5YB
	 J7NVqKZ3hdMkcnHdSIClg749USt1NwB7IJNVcVSWw+xoc4mh94uOeXJV5j9uNf/Wu5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rttDlOtx/m9qM5S67tAec/BB4ZfEsXsNVaMHrlLc2Pk=;
	b=ur/83FbbPi93hX0oqHd+C/GP+ioWxKfvIp7rlvAP0eGFmU0T+y97dhcoAialYqJ1Tpux
	 j5ghqT4GSwUBL8fSyNW3Oum97Lv1wd+Xkq3FY+Q1AgMQpdr7vdlgmG8k61Q7yD1X3QbAq
	 Yb1MqQ0Z6mwj764GcxmzQLUBgO7Gi3Oa0I9d8NWSlxgre2Iq5cCvCYFhN/h0Vioazbge8
	 mgkDvPY660R4SWbBew8bxKuYisXWpH2MwInJK3lB/3EW203zHPuU7y87Qjq+a2SqY0fk6
	 jjEJ+LSiEHXN1k3Zl52y/XnFR3PFFG3UaLLyNho71MJTn9Ti41OLU8BadZepsrAC6fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsK0El24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC08C606A326;
	Sat,  7 Nov 2026 14:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EsK0El24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4271B1F008A2;
	Sat,  7 Nov 2026 14:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062201;
	bh=rttDlOtx/m9qM5S67tAec/BB4ZfEsXsNVaMHrlLc2Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsK0El24mBWPQYBre1CovFkSH7Roj+2lCaAKS6vr8sCqgiugRH8C5bm7FCiGVLLCl
	 04H0QszwjRn7+nSNn6GdvA7J+6VN+jsDdnDhfFPrBb0e4DS4HSkiPYRUP68vhPdqMW
	 jqu+r1ABydjFK9NRdsMDYzIfBnbU2AcUCP1Th7Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1119/1536] media: rtl28xxu: fix SDR platform device leak
Date: Sat,  7 Nov 2026 08:52:15 -0500
Message-ID: <20261107135029.137672259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f7884bb56fccf..5a1e2a38d8154 100644
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



