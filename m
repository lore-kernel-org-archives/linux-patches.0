Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83531258CFF;
	Mon,  1 Dec 2025 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588661; cv=none; b=aVnNB1ddq6ds42WyhSmZ8wBDzuQwjUM7VkJWZHLmWZv6BN3uONUdtxTbIOEOgG5WqBNE0w6PfRPnKleFUJSlVCjxJmNvkN33Yowaj4fv7mWlb+gk24pR1xVxLH8Y99x1dOlQ2krkYWdrOyu8tnyB6iZwXYn6e1++2xu/4YIExDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588661; c=relaxed/simple;
	bh=bkcMJvDY4jd4ZHOE6eqw+e6Cgblaiyxs9dbDkG8rcSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv4lsWoD1FdalhufvMa6TwKco3DSa4QklL4/mThUIQGpPrZqbngaLJ2aVYvBFjdU2T+2sOFZAECC45BgdShbASlbtY69b/FTOpr4zt6uTRemA4ftDTQDr5oN/HbZt2912IB+V77Wa9a89E6tVaVzPJu4kx+6iS4YGa2bBEID0xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYUcnPE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYUcnPE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82ACC4CEF1;
	Mon,  1 Dec 2025 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588661;
	bh=bkcMJvDY4jd4ZHOE6eqw+e6Cgblaiyxs9dbDkG8rcSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYUcnPE+YIKk8OGsJiNyinweh1pv7m92dvbJy0F6VkpFPw3YCvulNf/cxYZNLaUT8
	 6zIz5l36zjzjDdMJTtqYDDjylHISPiClueQn7aXELBDYs3pMN9fHMKV++wNooYTBXU
	 xbWb01j5U7D1NgBCjy2HqBl3/fE2Pdfr9C9qsqfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Lobb <tristan.lobb@it-lobb.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/187] HID: quirks: avoid Cooler Master MM712 dongle wakeup bug
Date: Mon,  1 Dec 2025 12:23:55 +0100
Message-ID: <20251201112245.815062801@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tristan Lobb <tristan.lobb@it-lobb.de>

[ Upstream commit 0be4253bf878d9aaa2b96031ac8683fceeb81480 ]

The Cooler Master Mice Dongle includes a vendor defined HID interface
alongside its mouse interface. Not polling it will cause the mouse to
stop responding to polls on any interface once woken up again after
going into power saving mode.

Add the HID_QUIRK_ALWAYS_POLL quirk alongside the Cooler Master VID and
the Dongle's PID.

Signed-off-by: Tristan Lobb <tristan.lobb@it-lobb.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d2e355a9744a0..39b2602c41c7a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -303,6 +303,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOW_FIRST	0x1500
 #define USB_DEVICE_ID_CODEMERCS_IOW_LAST	0x15ff
 
+#define USB_VENDOR_ID_COOLER_MASTER	0x2516
+#define USB_DEVICE_ID_COOLER_MASTER_MICE_DONGLE	0x01b7
+
 #define USB_VENDOR_ID_CORSAIR		0x1b1c
 #define USB_DEVICE_ID_CORSAIR_K90	0x1b02
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index d1cfd45f2585a..f81ea6c36040b 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -57,6 +57,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_COOLER_MASTER, USB_DEVICE_ID_COOLER_MASTER_MICE_DONGLE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
-- 
2.51.0



