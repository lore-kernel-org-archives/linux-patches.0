Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D351314D07;
	Wed,  3 Dec 2025 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776524; cv=none; b=JTCyxa2e1cV9y5z3UbXMQy2kqgSAbnvhx9NNvwU/U1mma1fFXUaAzVBLbKTUhVk/PN1KZzS9lRENkj8K7TDJ+yHwZ2KgzOJNtrT0QMimuX0SejFpJDywi6r9SShBUdlJcZHyBkV0SGDGQLHIMl70p3OPjuuYHRLEuDhQ35BDGOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776524; c=relaxed/simple;
	bh=RBWXA1jLu1TVFufsGibaY1DuP2xULPT0+YH2bWQxYP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoQ4naOm8UlvcpaLqVi5c4mRDIVVA6VYi8v8Gb+hZs9IPYQUSexm0Vqj4v7OcQceglBvVMH5bNJ9I4Wl3EZ4OTcDDPb0a2QwkMxXo8wQAObv1whdTAmD8pT4rm5NZ1IGnYS8DqXe1QTM5Fn56gRfvE1RzqtIXhKLmw5zpWaKkiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aERIidKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aERIidKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B8EC116C6;
	Wed,  3 Dec 2025 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776524;
	bh=RBWXA1jLu1TVFufsGibaY1DuP2xULPT0+YH2bWQxYP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aERIidKDkgjulYRdHPaKyr7oEYknTv/29csgM0FBPQ8n/61HnKeEO6X7y44RdytVf
	 k2BdRtXt6D4JYsVKsibE26J3Er5h/enji6v91iyxZiR9/cR9HhgZlSOiajcmhQ2Khs
	 VC+dEym+CKuZlMummdmqXMKpmnC/yl24rUR0jOGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Lobb <tristan.lobb@it-lobb.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/300] HID: quirks: avoid Cooler Master MM712 dongle wakeup bug
Date: Wed,  3 Dec 2025 16:26:20 +0100
Message-ID: <20251203152407.147811096@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8bfa90e37ea17..c213f1cc8aebc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -298,6 +298,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOW_FIRST	0x1500
 #define USB_DEVICE_ID_CODEMERCS_IOW_LAST	0x15ff
 
+#define USB_VENDOR_ID_COOLER_MASTER	0x2516
+#define USB_DEVICE_ID_COOLER_MASTER_MICE_DONGLE	0x01b7
+
 #define USB_VENDOR_ID_CORSAIR		0x1b1c
 #define USB_DEVICE_ID_CORSAIR_K90	0x1b02
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 9c1c65612adb7..5fcd6f7b5f787 100644
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



