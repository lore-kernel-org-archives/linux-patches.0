Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F96303A1B;
	Wed, 10 Dec 2025 07:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352052; cv=none; b=GN908LtPAgI4wT4L9pLkeft8yplesTUyFFz2H3N6OGsFQJwTiZhtk7fWZFiBT16pKFZz2dUQw9lHFAfk1uBljP+9D2zq22P6BcdfaKSdqiHot7vFADeoi33yLXNQRzzk+K2CEfYirZGsWYyBbSIDrDe/8HMtfNtsGx/DzvOpR3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352052; c=relaxed/simple;
	bh=4m2CvxuS8oemmv17ubMzF1jaQSBcsujoZ9UgkaLFSHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWzKQVbWTcyYm4f5fAepwJUZdx81k8ChJ11SBayeojAVTMYgqjx5BgXjmFtnQ04NyQDN61B0GoohH0Lqv02kPYbwGnfqLi+JS42grtKAAWjlSV6GMqEpY/qjspy/vvlsTPOV97X56ba6MS91od1/kCjN2ThwduNWD+sC1ehWM40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2EiTLOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2EiTLOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD9FC116B1;
	Wed, 10 Dec 2025 07:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352052;
	bh=4m2CvxuS8oemmv17ubMzF1jaQSBcsujoZ9UgkaLFSHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2EiTLOjoj5vZmBqwqbHQUeFJ4JYVyk8VL57ZsQdTu3Vp3j5/u11l2gpfhIgAkm4y
	 mr0iszafJBCuqfk02vQo4jQbpZZkLvVNN0bhJrnYwKgRKf/gMCZztg2GKFifGs6Dt2
	 /3cRalH3fyyOsnncb7toqUOjgvu+eOaI7W1/u9Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lauri Tirkkonen <lauri@hacktheplanet.fi>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 31/60] HID: lenovo: fixup Lenovo Yoga Slim 7x Keyboard rdesc
Date: Wed, 10 Dec 2025 16:30:01 +0900
Message-ID: <20251210072948.601340830@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lauri Tirkkonen <lauri@hacktheplanet.fi>

[ Upstream commit a45f15808fb753a14c6041fd1e5bef5d552bd2e3 ]

The keyboard of this device has the following in its report description
for Usage (Keyboard) in Collection (Application):

	# 0x15, 0x00,                    //  Logical Minimum (0)                52
	# 0x25, 0x65,                    //  Logical Maximum (101)              54
	# 0x05, 0x07,                    //  Usage Page (Keyboard)              56
	# 0x19, 0x00,                    //  Usage Minimum (0)                  58
	# 0x29, 0xdd,                    //  Usage Maximum (221)                60
	# 0x81, 0x00,                    //  Input (Data,Arr,Abs)               62

Since the Usage Min/Max range exceeds the Logical Min/Max range,
keypresses outside the Logical range are not recognized. This includes,
for example, the Japanese language keyboard variant's keys for |, _ and
\.

Fixup the report description to make the Logical range match the Usage
range, fixing the interpretation of keypresses above 101 on this device.

Signed-off-by: Lauri Tirkkonen <lauri@hacktheplanet.fi>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    |  1 +
 drivers/hid/hid-lenovo.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 52ae7c29f9e08..85db279baa72e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -718,6 +718,7 @@
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA2  0x8350
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
+#define I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_KEYBOARD	0x8987
 #define USB_DEVICE_ID_ITE8595		0x8595
 #define USB_DEVICE_ID_ITE_MEDION_E1239T	0xce50
 
diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 654879814f97a..9cc3e029e9f61 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -148,6 +148,14 @@ static const __u8 lenovo_tpIIbtkbd_need_fixup_collection[] = {
 	0x81, 0x01,		/*   Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position) */
 };
 
+static const __u8 lenovo_yoga7x_kbd_need_fixup_collection[] = {
+	0x15, 0x00,	// Logical Minimum (0)
+	0x25, 0x65,	// Logical Maximum (101)
+	0x05, 0x07,	// Usage Page (Keyboard)
+	0x19, 0x00,	// Usage Minimum (0)
+	0x29, 0xDD,	// Usage Maximum (221)
+};
+
 static const __u8 *lenovo_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
@@ -177,6 +185,13 @@ static const __u8 *lenovo_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			rdesc[260] = 0x01; /* report count (2) = 0x01 */
 		}
 		break;
+	case I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_KEYBOARD:
+		if (*rsize == 176 &&
+		    memcmp(&rdesc[52], lenovo_yoga7x_kbd_need_fixup_collection,
+			  sizeof(lenovo_yoga7x_kbd_need_fixup_collection)) == 0) {
+			rdesc[55] = rdesc[61]; // logical maximum = usage maximum
+		}
+		break;
 	}
 	return rdesc;
 }
@@ -1538,6 +1553,8 @@ static const struct hid_device_id lenovo_devices[] = {
 		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X12_TAB) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_X12_TAB2) },
+	{ HID_DEVICE(BUS_I2C, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_YOGA_SLIM_7X_KEYBOARD) },
 	{ }
 };
 
-- 
2.51.0



