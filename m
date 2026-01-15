Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AD63C0088;
	Thu, 15 Jan 2026 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500054; cv=none; b=blFcG0WCuA3JDq5iWW8T5HQwBuX89gWXjGxRQvFzfPVrOj2/wlw28VeTY0ThH/Xqs6rCB+XwzAvrtlrogaKaoAG1JnpA9s8BJqC3+VQ9OGNAbJavk2gmb/zzEw55sWYGum7No3nKxX3ufuf7QhS7265JrlEcP9/47onMOg3atnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500054; c=relaxed/simple;
	bh=3SQw6w6++6Vvjc3VKvieI9YNimzP72bnrZeyHsvIcwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M8wMVxAU3qwp+N3LelQ+qfxAUyvFigd1kMSMbizm/mx+uxkpSMQYwb3T8c6i+4z2+ga+qsRXs4zcaEJsHMlqahXdtExxKrXQMeMuT2DiJNCdqdLj2lQGOKqLh/Rr4yF9u8jpGYNnZr4ujf9u1jtnqEtEhRrcXAhxqAaOidsA5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsGzj8tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsGzj8tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FB7C116D0;
	Thu, 15 Jan 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500054;
	bh=3SQw6w6++6Vvjc3VKvieI9YNimzP72bnrZeyHsvIcwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsGzj8tkw4YeLK+XQ6xkKZsK9TrA9l+0H1IG9gLptDsQ725MV2Kbc5A7xRgMToBy+
	 jtDZFMV0+QYyKLosW1/9tn+PiUs/N6y3BKNJcFVwWsCDe/G1rVtamSfYtkyWkXmRVc
	 m0C9iCi8A/NY2qGmTGOSMJ5RgrA+4irV7RBXH8UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/451] HID: quirks: work around VID/PID conflict for appledisplay
Date: Thu, 15 Jan 2026 17:50:42 +0100
Message-ID: <20260115164246.900277586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ee99f5b3342da..0d15148d52533 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -220,6 +220,15 @@ static const struct hid_device_id hid_quirks[] = {
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



