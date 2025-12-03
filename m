Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C122B35029B;
	Wed,  3 Dec 2025 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779725; cv=none; b=Ypfm108PMI3cBR5PFn92QhFXvuZsSHZtIuYkuvuCS2XkH9L+74X/QQlQRajiypUoaiHRo12YkvgZ0BTq/HNXPAKtBphu8gqrTi6gvf5+gFopRJgQoY27151JEgE0nCHV1AQN2NuDg9FUXop3Eg4plghZSc/TXJwaZjA2CTBgvQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779725; c=relaxed/simple;
	bh=EkGyPzJpxmyqsPRzs4h1zJU1p67up/ZODy6MPi/51UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5SM1Pl99zdpuB/21f9EvLzKm6TSTJQQ80cUQLKcU8BsnAVtQdX+Nu+l4SODkWV8YF5igBPXnOSqYWsaWQ/kpdj2uiP6U4DfpRvqH5vLMdS6k21PpV7y4KjJHF7X+gAVprS3LLqfo+dvB3FecS1OjAzppThTMD8DpZlp+RlwuqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1yN0a9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1yN0a9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C49C4CEF5;
	Wed,  3 Dec 2025 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779725;
	bh=EkGyPzJpxmyqsPRzs4h1zJU1p67up/ZODy6MPi/51UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1yN0a9KFbDeEclj/yKUVfmPwzirjTfaXdKUbrR2REnwCyKAf6I7Xo/6VDBWWNZcI
	 ryPojo58PCwlE4qp2Z/2o0eZbLX8r3lRHuWBK53QQWID9D4YMD2ub9Wzrhse1F6P3B
	 zVO6/2iUZgejfV5gF57oOrQWRMcFCdpab5cpc4qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Lobb <tristan.lobb@it-lobb.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/568] HID: quirks: avoid Cooler Master MM712 dongle wakeup bug
Date: Wed,  3 Dec 2025 16:25:44 +0100
Message-ID: <20251203152453.231746439@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0bbba80d6c51c..307f921a98068 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -321,6 +321,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOW_FIRST	0x1500
 #define USB_DEVICE_ID_CODEMERCS_IOW_LAST	0x15ff
 
+#define USB_VENDOR_ID_COOLER_MASTER	0x2516
+#define USB_DEVICE_ID_COOLER_MASTER_MICE_DONGLE	0x01b7
+
 #define USB_VENDOR_ID_CORSAIR		0x1b1c
 #define USB_DEVICE_ID_CORSAIR_K90	0x1b02
 #define USB_DEVICE_ID_CORSAIR_K70R      0x1b09
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index b37927f909412..b42aa9e22fcf0 100644
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



