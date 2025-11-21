Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C503630AADC;
	Fri, 21 Nov 2025 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731612; cv=none; b=i9zVKlqfZSpWpu2GG1aGDrGaKpfGkDOJxyzZcsOFKg6wbS2otjUnquHiig1mwj9wqRG6W4OHqGm9Xbep5/FrCzrhAuszyhZl9bhuztM65/WE7vBZHDO+pzOWj+Zfjlap9Z6jXHOm1jUoqT7Nho12tBtDk/oQovDMItWQxOax474=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731612; c=relaxed/simple;
	bh=aVtrzOLtCHMb+ufzCUdvZh/MLj1inUPNPSC+92DgQ24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUYTGNZK6F9hf3fvS86fjgBDj9anm5eRL5TiZ7O+lO/2L2FB/A/h0T2twM39bjrGMgSbKq5X0jkkK3D9xrfAMIV9n6IPBRzsoW4W6/PivczgUVw/HEFRY4GD7Bfrm2yQqPix3cz6+4cfuszOACe0VMV11+9YPu24pS5Rm3zCsLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bymttkc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bymttkc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CD0C4CEF1;
	Fri, 21 Nov 2025 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731612;
	bh=aVtrzOLtCHMb+ufzCUdvZh/MLj1inUPNPSC+92DgQ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bymttkc9U+YWdY18W28zVSE8qPArccqCK4QFT8LC5SkLuIrmmbhwI/pJCpSFcwceM
	 WPJTNM/1lvnymeXuMy8KVGYAJPy7Z2TUn4KOe7btNyRnyvETZ8Dj3mcdVFNtu8oBu9
	 tV0IdFnVWlTR7Mg4FOhs5gbBoOVj2zDpOvU7Ds1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Lobb <tristan.lobb@it-lobb.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/185] HID: quirks: avoid Cooler Master MM712 dongle wakeup bug
Date: Fri, 21 Nov 2025 14:10:48 +0100
Message-ID: <20251121130144.640542757@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d41a65362835d..63eb60effcaaf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -338,6 +338,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOW_FIRST	0x1500
 #define USB_DEVICE_ID_CODEMERCS_IOW_LAST	0x15ff
 
+#define USB_VENDOR_ID_COOLER_MASTER	0x2516
+#define USB_DEVICE_ID_COOLER_MASTER_MICE_DONGLE	0x01b7
+
 #define USB_VENDOR_ID_CORSAIR		0x1b1c
 #define USB_DEVICE_ID_CORSAIR_K90	0x1b02
 #define USB_DEVICE_ID_CORSAIR_K70R      0x1b09
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 64f9728018b88..468a47de96b10 100644
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



