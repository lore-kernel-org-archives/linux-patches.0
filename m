Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BECF1DDF5;
	Tue, 16 Jul 2024 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144552; cv=none; b=DKgSQdToU1teEX8HBZfGBd91OM+bHOsy3KWxeiBxF3qB2Ajy6eS3go6U2X++abVRetlAX+86OH6KqspxWlCAFbTR2vmhLbAk0tj7EFxre3RKQFb+sqnLdgljfaK41NUd1QwBfoBT7WVpXEBPLrGCW18mdGA2fB4VW9p3i5WudrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144552; c=relaxed/simple;
	bh=5gTCUIxEcYT+gyOI96du+E90J4uPk6EWUGGTM3WHRPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se7sq8Ro3biMPYPgE3Z9ZMgXJ8PUX0Q35kNWcg650PnvyKAw5IMYqzxrPE7wIXqrdwrHe+8CD0SpB82lKXppbr0VQX7OxLtNTbm12Zl/+5hLwS6bfU9aAHIIbSSjvFhuSP6OFEJvEjRa0+OBHZi6MOyUwgs7E3D+RDRgeM4MGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvQP6U7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvQP6U7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DC7C116B1;
	Tue, 16 Jul 2024 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144552;
	bh=5gTCUIxEcYT+gyOI96du+E90J4uPk6EWUGGTM3WHRPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvQP6U7/jfxr3es2sOU9rZT00Vzm1tQWDixFRsA9zZkJoDYwb1xbKpkEN7hAIFlp6
	 qVFKv2EEgTrak7seK71jLEaAovyVg/WcMn8ZNuj+vUMZ0h0LozYaK1DYPjukWgXcNI
	 k3VYFTBFp2yesoeLIAgJsTsK5of7+KRHojygxFLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 003/108] media: dvb-usb: dib0700_devices: Add missing release_firmware()
Date: Tue, 16 Jul 2024 17:30:18 +0200
Message-ID: <20240716152746.125552896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 4b267c23ee064bd24c6933df0588ad1b6e111145 ]

Add missing release_firmware on the error paths.

drivers/media/usb/dvb-usb/dib0700_devices.c:2415 stk9090m_frontend_attach() warn: 'state->frontend_firmware' from request_firmware() not released on lines: 2415.
drivers/media/usb/dvb-usb/dib0700_devices.c:2497 nim9090md_frontend_attach() warn: 'state->frontend_firmware' from request_firmware() not released on lines: 2489,2497.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d3288c1079062..afc561c1a5d61 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2419,7 +2419,12 @@ static int stk9090m_frontend_attach(struct dvb_usb_adapter *adap)
 
 	adap->fe_adap[0].fe = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &stk9090m_config);
 
-	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
+	if (!adap->fe_adap[0].fe) {
+		release_firmware(state->frontend_firmware);
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 static int dib9090_tuner_attach(struct dvb_usb_adapter *adap)
@@ -2492,8 +2497,10 @@ static int nim9090md_frontend_attach(struct dvb_usb_adapter *adap)
 	dib9000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, 0x80);
 	adap->fe_adap[0].fe = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &nim9090md_config[0]);
 
-	if (adap->fe_adap[0].fe == NULL)
+	if (!adap->fe_adap[0].fe) {
+		release_firmware(state->frontend_firmware);
 		return -ENODEV;
+	}
 
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_3_4, 0);
 	dib9000_i2c_enumeration(i2c, 1, 0x12, 0x82);
@@ -2501,7 +2508,12 @@ static int nim9090md_frontend_attach(struct dvb_usb_adapter *adap)
 	fe_slave = dvb_attach(dib9000_attach, i2c, 0x82, &nim9090md_config[1]);
 	dib9000_set_slave_frontend(adap->fe_adap[0].fe, fe_slave);
 
-	return fe_slave == NULL ?  -ENODEV : 0;
+	if (!fe_slave) {
+		release_firmware(state->frontend_firmware);
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 static int nim9090md_tuner_attach(struct dvb_usb_adapter *adap)
-- 
2.43.0



