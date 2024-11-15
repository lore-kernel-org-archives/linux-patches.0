Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9D017555;
	Fri, 15 Nov 2024 07:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731654030; cv=none; b=uEgAo6HA3tJZGfgcSj1JEgwzmS4FLV2gnJb6bMyBARMk1aFKT7MStXqq7pGWkJvtnFPP/gbvfyv70HW+MKSnDTQ9XFZeNqQOqP0zP9T0xfsC7+thWPMnx3RhjVBGIXXn/hgGRZjqrFmk+Y0Lhr4Ok3vQDRglhG8BKDw9NssH/vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731654030; c=relaxed/simple;
	bh=l2iWhNikCN0XQugw7pHL7Y9KEuxBMI94Kwnr7vEakFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGKUt8HBDzcsPjSnRQam9BxrWxiOqfxdSQQ4/HHNcjwrijq4FNOn03sECVa0sEi7FBq940yTJDcUagPpEWKoXfsc7V07qtVsKrC1hqatSw20VdP7xplJH6f9uIPrVzZqA4OYIB1qcaZ65PJtj+kzSt4Ro+1m4MmavGCFFUSKpZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZ8G7nLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZ8G7nLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B16C4CECF;
	Fri, 15 Nov 2024 07:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731654030;
	bh=l2iWhNikCN0XQugw7pHL7Y9KEuxBMI94Kwnr7vEakFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZ8G7nLH15Ak4bui03hFpIebjmXH4mPrNnDU+zvLLsuzybmX077O83Tu3frw//EZg
	 A+yTb4Bij3kaqMAglrIbkhgQ6xU0Y3uO5rFU+9yzVIYHimn04gjR+lysJE9Wv8Xbbc
	 vSRdI/9rZo9qp4Cz/Jg4YKXt45HlGgq7BdzhFd5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Blum <stefan.blum@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/22] HID: multitouch: Add support for B2402FVA track point
Date: Fri, 15 Nov 2024 07:38:50 +0100
Message-ID: <20241115063721.333924895@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Blum <stefanblum2004@gmail.com>

[ Upstream commit 1a5cbb526ec4b885177d06a8bc04f38da7dbb1d9 ]

By default the track point does not work on the Asus Expertbook B2402FVA.

>From libinput record i got the ID of the track point device:
  evdev:
    # Name: ASUE1201:00 04F3:32AE
    # ID: bus 0x18 vendor 0x4f3 product 0x32ae version 0x100

I found that the track point is functional, when i set the
MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU class for the reported device.

Signed-off-by: Stefan Blum <stefan.blum@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6a3f4371bd109..116876d710932 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2017,6 +2017,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x3148) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x32ae) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
-- 
2.43.0



