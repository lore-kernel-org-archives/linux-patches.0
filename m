Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BB8158A30;
	Tue,  9 Jul 2024 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524554; cv=none; b=Ah7ka3Q+7MjVi+40auYmfktIK/nDtqNYnzAhb+7+n64WAAcmNqvmuZea7/Yuic/l/whPauxBqnqIcWm9HFENvMQ1wjMjEg1vEKL6rkElltM6IoOKmsrive4FHGKnL0lL0WoHV3u9+aUmtb4QTNMSiYNtOiYQqDQAdcbkMWtESAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524554; c=relaxed/simple;
	bh=Jt9LubcBPiIPygBhUooiClsaJPBIuIKRZkTh6TjBrQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjMwZGPdlf8tzzptyXX8uhiRJPj34K44PTbDrdKLBAUC5gkiP3yQifITdjXno6tYWPUWL6zwZ59/0oi2DWAsDgjggXjVPRXf19TxhbMyQ1WNfBA8pRLL4tTqKQuY02bR3UJYN1EX8wnkJoc0HWPcbNctzkuVAunvrdpw9ugoEYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orkS4jqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orkS4jqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305AAC3277B;
	Tue,  9 Jul 2024 11:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524553;
	bh=Jt9LubcBPiIPygBhUooiClsaJPBIuIKRZkTh6TjBrQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orkS4jqMOo6rD5Y70rmEuNFcZaLQ5YBT7IrM/7u/31dPGZbCEmMqrmUZt/AZzoWVE
	 O5Gt5O4FXwC2qk7FjD8HliznWV86lBFYVz6p6WiPNMEEq005wBWHnf6mb80L7WUM0K
	 H/REMIRGtmUC0kE7fGa6hE+XWfSgH951cklJNquc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/102] media: dvb-usb: dib0700_devices: Add missing release_firmware()
Date: Tue,  9 Jul 2024 13:09:29 +0200
Message-ID: <20240709110651.606793613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f8bebfa3e8e9..3d14aba7a0dea 100644
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



