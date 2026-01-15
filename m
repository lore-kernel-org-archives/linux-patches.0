Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD8B3BF2E4;
	Thu, 15 Jan 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496392; cv=none; b=ny0p20qEuXMrSW+Lk2TbKJBDxAe/SkJSoD04tqi0WO1FUDZmEhR6KzemkSAHIk9/uU/3SIKAMIfrohDf1xI0+nB7wlk+GdC89dgoIsODICvmCcLwygxp0iOH7GU4TUOrK/UnKHb7IZ14TKmLxm1xSnDft+qhyimQabZj2Jb8NUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496392; c=relaxed/simple;
	bh=RQK+Uo6qD78QcuXeE1WmlNCmo4Q3T3qQ0HsE9mKI+JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pTEa9rFZUnzhNDnLlB8mBah9PEks55ghZVIbXs8C2LqTU1uJsBtNEhGxLULJDFHsDPyNu2O8OlYpVLEkwIfX19IB10nedgWG0UE4aGIIqJGDMoWCidbmabDslVdF1AQnWZqO6K1Ogsp08L1OngJpJRP0g8lEDPZjGJMfGbTdl3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlwJkh97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlwJkh97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF29BC19421;
	Thu, 15 Jan 2026 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496392;
	bh=RQK+Uo6qD78QcuXeE1WmlNCmo4Q3T3qQ0HsE9mKI+JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlwJkh97rb5udZh9q3z4SYQ8UfM0ayZKM1Y8DgeHiFwf+qUmV3ZqkkYIji4c7AONw
	 TmXEG4lSZ0eN+UvdorRBO7k39aqNFoSDVaeJhtv9fvMr8lE6GCKqY6AryhNJbwFE7v
	 tWtUQ5qjqqyQ3nZAT+FrLgZhmcRENxao+OsboFmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/181] HID: quirks: work around VID/PID conflict for appledisplay
Date: Thu, 15 Jan 2026 17:48:03 +0100
Message-ID: <20260115164207.586112968@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c89a015686c07..6a8a7ca3d8047 100644
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



