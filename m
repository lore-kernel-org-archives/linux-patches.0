Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904B2BEFF5;
	Tue, 21 Jul 2026 20:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667324; cv=none; b=Tivcct8pWQNqHAdrbvVrFHVoEJ8tatd4PiqttnzNMU4uVQxo3Biy+zoh6wnKyA927i+Sq5BCejtCa9jwdnqqJTWzDnlwZap4/+wUY+UuMvq1Oh88PZYS04fbgAA5gRgbQuvmYtLqS6xF13LSMcVTD2txYb2f1RQ3asazmhamNUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667324; c=relaxed/simple;
	bh=9eywBXgte/5nOOP+PR7tSAd2W30pyPNen5iFMlG7ZmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhKF65svYq2yrxXMhj14uo9C12SUZ7dPSkdPIxpSFO5oIVRXHyKhA95TWnp+ykQdPYVI9vYADVxv0QppmeD0HiyMsTv1J09SHexdfkNoRQWnEKDUswYaN/OlGgeVZ1Oyf/yR/DSnClmpd8qlzMGPtMQagRTxh/YLOZKTNtoBt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCWbrH0v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCWbrH0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF621F000E9;
	Tue, 21 Jul 2026 20:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667323;
	bh=femvBypjf0AdrcUdguMNAJxrUtftbpC3rEUhY5SwfoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCWbrH0vydGmpxaFVuaypPqYjkou3PrTn1S7VhVL+j4Ib5gDTtBqC5NiTHvmfO2Iy
	 e2BguKzM6vDun0CJIcC1hhzjH9+x8CKQ+BF0o18CWiHJwERnlwY0DB7S6RBCqzGEAS
	 bIDHMesGj3MAemwbEwI7I165kXrodDVE5Jk+/4AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.6 0974/1266] power: supply: cpcap-battery: Fix missing nvmem_device_put() causing reference leak
Date: Tue, 21 Jul 2026 17:23:31 +0200
Message-ID: <20260721152503.637779296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit a2c14ff63e0e02e3c832385e523e9cc81301171c upstream.

In cpcap_battery_detect_battery_type(), the reference to an nvmem
device obtained via nvmem_device_find() is not released with
nvmem_device_put() on the success or read-failure paths, causing a
permanent reference leak. The driver’s retry logic on subsequent
battery property reads can compound this leak, preventing the nvmem
device from ever being freed.

Found by code review.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Cc: stable@vger.kernel.org
Fixes: fd46821e85de ("power: supply: cpcap-battery: Add battery type auto detection for mapphone devices")
Link: https://patch.msgid.link/20260424011013.879639-1-make24@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cpcap-battery.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -415,10 +415,13 @@ static void cpcap_battery_detect_battery
 	if (IS_ERR_OR_NULL(nvmem)) {
 		ddata->check_nvmem = true;
 		dev_info_once(ddata->dev, "Can not find battery nvmem device. Assuming generic lipo battery\n");
-	} else if (nvmem_device_read(nvmem, 2, 1, &battery_id) < 0) {
-		battery_id = 0;
-		ddata->check_nvmem = true;
-		dev_warn(ddata->dev, "Can not read battery nvmem device. Assuming generic lipo battery\n");
+	} else {
+		if (nvmem_device_read(nvmem, 2, 1, &battery_id) < 0) {
+			battery_id = 0;
+			ddata->check_nvmem = true;
+			dev_warn(ddata->dev, "Can not read battery nvmem device. Assuming generic lipo battery\n");
+		}
+		nvmem_device_put(nvmem);
 	}
 
 	switch (battery_id) {


