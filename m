Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE93BF2E8;
	Thu, 15 Jan 2026 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496915; cv=none; b=BRmPIdErk621XILbqkPpwo7psgj580MQAjFSuLD8StCp0HZ6p5y7KLQErWXjXg8e4gy+xk8TCk/R+TSCR3tU/JXHfyOsr7mwUfooXgGEzNAnGNGRb04BDJ9lr5KMgKOjIGKqQ7KaxDo0fk+0z+S5eOJn3mfr0A7lHs8krpjrveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496915; c=relaxed/simple;
	bh=hq+bYEq0Lup/xFCawF4+2SDhjCDFmsKqniGJ6vSyFRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gChcwQSFlDhNVtiAFLwDv9v0KJ+CxIAwYnbFHo1MwChXLqW2k5S8CKFbmuW2h3Ml3by/ub5VkMH3xuPg5wEqFgeaSj6VriNVg1zTSfruJmKun1suaZlCjhWj1cfpsxgnAZt9XOnQMKH+jBc+B1qrrkGfYQWDfdOrd9921LiOwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6Tb5JEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6Tb5JEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9A4C19423;
	Thu, 15 Jan 2026 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496915;
	bh=hq+bYEq0Lup/xFCawF4+2SDhjCDFmsKqniGJ6vSyFRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6Tb5JElAcX2e/K3UTuoSP3GeKx/bE63RlmnY30vmj4D7ierPAKEpHrYy5ImgzLN7
	 AoZVvgQezpHkzBWFiSaaO+6Ef0TmgBxBXkVqQaW4c+WJe5L5NGIPvIhGxwtticNfKx
	 WPo08bm2Q+t8VfIVTKwosJlL0VP1+kqc6Ktyt45c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 60/88] HID: quirks: work around VID/PID conflict for appledisplay
Date: Thu, 15 Jan 2026 17:48:43 +0100
Message-ID: <20260115164148.485667842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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



