Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7C32D73A0;
	Thu, 15 Jan 2026 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496631; cv=none; b=BlHbJ0C3EpKXwsW5pBdjNH+0+X8wI2SkI5rOpefIEslsQ8XnbsDbT/EwvFK1D96enArNw8Mk9FiYJKuqs2IUKuaIZZ/O+I41OBTh3bb+g5FCUgRtIbygg5V2m2LIP71MBnZ5XtUQYzmBBqP9udVM9CGCXePW4HdJXRg08PfnSF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496631; c=relaxed/simple;
	bh=vLu8X1PAwoaHoe7Ysu153t7VwCk76nrWND2vl3n7Yl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sylOZpt417EFTuzL9uUACrmwDqabRj1E6g/mOm1tCXD17LgfJTqXbfjdd32M2Nt1Zg1nkAFmTsjJ76dwNFjesCVOk7PQE0Vy4YkPoNFrjFHVvgWzFQoGwp+spjXnx3vTmHSzRj+ZWqIO39WEvZvHdXVffeA7UX3nXvX4VLmEC5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZIWHh3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZIWHh3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE3CC116D0;
	Thu, 15 Jan 2026 17:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496631;
	bh=vLu8X1PAwoaHoe7Ysu153t7VwCk76nrWND2vl3n7Yl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZIWHh3SDsz0gx8fcck/Az4ESVDorLRz0goXNuQlJcmhkp0ELMgZxeUQ6R/IB8Wn8
	 hiELVoTDCQsiqv72QepZoxGYrGnZ8u3YM4q7PxS2b5zW6SA8y84L4wgslBUhXQrChE
	 ryZvT3qzyUPq3VX4fp4lKDU7qf039tgGMcBWsazU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/119] HID: quirks: work around VID/PID conflict for appledisplay
Date: Thu, 15 Jan 2026 17:48:16 +0100
Message-ID: <20260115164154.874920857@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

[ Upstream commit c7fabe4ad9219866c203164a214c474c95b36bf2 ]

For years I wondered why the Apple Cinema Display driver would not
just work for me. Turns out the hidraw driver instantly takes it
over. Fix by adding appledisplay VID/PIDs to hid_have_special_driver.

Fixes: 069e8a65cd79 ("Driver for Apple Cinema Display")
Signed-off-by: René Rebe <rene@exactco.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 2da21415e676c..192b8f63baaab 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -232,6 +232,15 @@ static const struct hid_device_id hid_quirks[] = {
  * used as a driver. See hid_scan_report().
  */
 static const struct hid_device_id hid_have_special_driver[] = {
+#if IS_ENABLED(CONFIG_APPLEDISPLAY)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9218) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9219) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x921c) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x921d) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9222) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9226) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 0x9236) },
+#endif
 #if IS_ENABLED(CONFIG_HID_A4TECH)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
-- 
2.51.0



