Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D316CA40;
	Tue, 16 Jul 2024 15:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144274; cv=none; b=snbKgIBcsHs4hX4hVAhy+VYdWOWUS3FhyJAbZ25CUNFeU9q9St5rhzPlRtswccoigrYN3EO4v3WO48K/kyV+bbWNonebehUSENdoFSs+rcuahmnXwy6p5F7YN/DLJYF4fqvgZtynEF5o8RNoyf57/0i+4EA1nmbb0Prlo1GSYcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144274; c=relaxed/simple;
	bh=l6W66jesZrldzx3Cy+XITbSwICd+MDC0GX2W6kHuf84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KphuycQPtAsJ5I1PCsNWEY72lnndh/YPLOgiAG2eaS3zRbS+eKw04PNG1C4gZ3+UV+s1aKau7lQiZZ3vda/dBckhkqoWhifFH5hY5xJ6O4aMBLemZnrP5P5kHnEbAzuZUYnIZHb4Zw4C4HOOaN08+J1+Hvsnl7BYh6BLpffzvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5juF4sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5juF4sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DA9C116B1;
	Tue, 16 Jul 2024 15:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144274;
	bh=l6W66jesZrldzx3Cy+XITbSwICd+MDC0GX2W6kHuf84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5juF4sK0ZFlMJaK3DQ2yVz0LGJ4EIxC7AnpYdpzeQI56OkRfMRDRnFBHHlqZX2Pu
	 2uoK18S0p8YnsiFgbSWwIk4T7kpVXCPGh9XbIOAN0cglEVmfy2ig0wFbydJmjdBxKb
	 lTX3BnpJ8T+c+5vvFbiZA2YL2X6QneyJxpEoD+UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/78] media: dvb-usb: dib0700_devices: Add missing release_firmware()
Date: Tue, 16 Jul 2024 17:30:35 +0200
Message-ID: <20240716152740.762233799@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ab7a100ec84fe..8eecbcdbbad8d 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -2424,7 +2424,12 @@ static int stk9090m_frontend_attach(struct dvb_usb_adapter *adap)
 
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
@@ -2497,8 +2502,10 @@ static int nim9090md_frontend_attach(struct dvb_usb_adapter *adap)
 	dib9000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, 0x80);
 	adap->fe_adap[0].fe = dvb_attach(dib9000_attach, &adap->dev->i2c_adap, 0x80, &nim9090md_config[0]);
 
-	if (adap->fe_adap[0].fe == NULL)
+	if (!adap->fe_adap[0].fe) {
+		release_firmware(state->frontend_firmware);
 		return -ENODEV;
+	}
 
 	i2c = dib9000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_3_4, 0);
 	dib9000_i2c_enumeration(i2c, 1, 0x12, 0x82);
@@ -2506,7 +2513,12 @@ static int nim9090md_frontend_attach(struct dvb_usb_adapter *adap)
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



