Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F34A43ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE3gVCzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1236C4AF7D;
	Wed, 15 Nov 2023 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081433;
	bh=0Vzj/7KOE3NjaAmJ/UWSlwCdegw6uWxnEP3591vR7+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WE3gVCzfZZezfDl33vliZen50b4JWO0aQG34w7ZZddLb6izGXUWYnY2kf9VBsvlr6
	 hlHZbJqc2GVVq5LYbqia7jHpPCCFEaVuC0dRqyFYNuzwBRLzF+3ofK+Uq0qZytQ9ML
	 W2/HBDVr0dwYOS2HVdntuK78G7951RKaZ34ffQ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/244] HID: logitech-hidpp: Remove HIDPP_QUIRK_NO_HIDINPUT quirk
Date: Wed, 15 Nov 2023 15:35:43 -0500
Message-ID: <20231115203557.396990987@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit d83956c8855c6c2ed4bd16cec4a5083d63df17e4 ]

HIDPP_QUIRK_NO_HIDINPUT isn't used by any devices but still happens to
work as HIDPP_QUIRK_DELAYED_INIT is defined to the same value. Remove
HIDPP_QUIRK_NO_HIDINPUT and use HIDPP_QUIRK_DELAYED_INIT everywhere
instead.

Tested on a T650 which requires that quirk, and a number of unifying and
Bluetooth devices that don't.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20230125121723.3122-2-hadess@hadess.net
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Stable-dep-of: 11ca0322a419 ("HID: logitech-hidpp: Don't restart IO, instead defer hid_connect() only")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 7681a3fa67dab..a716c6f3bfb58 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -63,7 +63,7 @@ MODULE_PARM_DESC(disable_tap_to_click,
 /* bits 2..20 are reserved for classes */
 /* #define HIDPP_QUIRK_CONNECT_EVENTS		BIT(21) disabled */
 #define HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS	BIT(22)
-#define HIDPP_QUIRK_NO_HIDINPUT			BIT(23)
+#define HIDPP_QUIRK_DELAYED_INIT		BIT(23)
 #define HIDPP_QUIRK_FORCE_OUTPUT_REPORTS	BIT(24)
 #define HIDPP_QUIRK_UNIFYING			BIT(25)
 #define HIDPP_QUIRK_HI_RES_SCROLL_1P0		BIT(26)
@@ -82,8 +82,6 @@ MODULE_PARM_DESC(disable_tap_to_click,
 					 HIDPP_QUIRK_HI_RES_SCROLL_X2120 | \
 					 HIDPP_QUIRK_HI_RES_SCROLL_X2121)
 
-#define HIDPP_QUIRK_DELAYED_INIT		HIDPP_QUIRK_NO_HIDINPUT
-
 #define HIDPP_CAPABILITY_HIDPP10_BATTERY	BIT(0)
 #define HIDPP_CAPABILITY_HIDPP20_BATTERY	BIT(1)
 #define HIDPP_CAPABILITY_BATTERY_MILEAGE	BIT(2)
@@ -3988,7 +3986,7 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 	if (hidpp->quirks & HIDPP_QUIRK_HI_RES_SCROLL)
 		hi_res_scroll_enable(hidpp);
 
-	if (!(hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT) || hidpp->delayed_input)
+	if (!(hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT) || hidpp->delayed_input)
 		/* if the input nodes are already created, we can stop now */
 		return;
 
@@ -4221,7 +4219,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		hid_hw_close(hdev);
 		hid_hw_stop(hdev);
 
-		if (hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT)
+		if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT)
 			connect_mask &= ~HID_CONNECT_HIDINPUT;
 
 		/* Now export the actual inputs and hidraw nodes to the world */
-- 
2.42.0



