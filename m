Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554725FA0F;
	Tue, 30 Sep 2025 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245961; cv=none; b=GywlWEZGvtePk97sEpvUKWlKr6j+zAI17Zn5law9Ph5ns4AWvf5ggSh9Zb1hmdumCo02591SOhN/f8XT7mxWR8ppj9WyNztPvPlsqgYo/awJdAl6kIGkvBaH0+T+juhAMgj05Up4jE1DjgwC7an5IMaUF34r3t9frV4CdPoUsyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245961; c=relaxed/simple;
	bh=vevNe6J88zNHLwa8BSGzeH1M2jnUh35N376OA4qfw+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWJp3ggVmL95G6U5i8TH7L58I0SKYv3x/CYnTwAhVOqtzxFboKlXfb6RBieXPhCgmGJ5XoTsTkKjAqFirthvIUl4zo16PGmvUgj2Sqc/zxBcecfiGv3Q1u7iIOsTLUaT5CvbpLSyWoBnGCRX97wN8G/drQhJtLFx1qAulc4TU7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hag/H/Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hag/H/Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBE7C4CEF0;
	Tue, 30 Sep 2025 15:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245961;
	bh=vevNe6J88zNHLwa8BSGzeH1M2jnUh35N376OA4qfw+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hag/H/VeB3gMhx1PKH9k8i5mfYRP2A+myvMBGG60C1I1Y7na4ijhC/Xh7iG5Uyfrm
	 pAgf2H5v2iBQDQic2wvi9EwbUL+iakx8FVOTG86Jj9VTu0jyUcB9p/WjRdHqYcGmIF
	 avS7SHHLV9cOEgURlMf5zLShlksFGVfZgjy8kxPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/89] HID: multitouch: Get the contact ID from HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar
Date: Tue, 30 Sep 2025 16:47:24 +0200
Message-ID: <20250930143822.292446193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit f41d736acc039d86512951f4e874b0f5e666babf ]

In Apple Touch Bar, the contact ID is contained in fields with the
HID_DG_TRANSDUCER_INDEX usage rather than HID_DG_CONTACTID, thus differing
from the HID spec. Add a quirk for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5c424010bc025..be2bbce25b3df 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -72,6 +72,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
+#define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -617,6 +618,7 @@ static struct mt_application *mt_find_application(struct mt_device *td,
 static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 						      struct hid_report *report)
 {
+	struct mt_class *cls = &td->mtclass;
 	struct mt_report_data *rdata;
 	struct hid_field *field;
 	int r, n;
@@ -641,7 +643,11 @@ static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 
 		if (field->logical == HID_DG_FINGER || td->hdev->group != HID_GROUP_MULTITOUCH_WIN_8) {
 			for (n = 0; n < field->report_count; n++) {
-				if (field->usage[n].hid == HID_DG_CONTACTID) {
+				unsigned int hid = field->usage[n].hid;
+
+				if (hid == HID_DG_CONTACTID ||
+				   (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR &&
+				   hid == HID_DG_TRANSDUCER_INDEX)) {
 					rdata->is_mt_collection = true;
 					break;
 				}
@@ -819,6 +825,14 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 						     EV_KEY, BTN_TOUCH);
 			MT_STORE_FIELD(tip_state);
 			return 1;
+		case HID_DG_TRANSDUCER_INDEX:
+			/*
+			 * Contact ID in case of Apple Touch Bars is contained
+			 * in fields with HID_DG_TRANSDUCER_INDEX usage.
+			 */
+			if (!(cls->quirks & MT_QUIRK_APPLE_TOUCHBAR))
+				return 0;
+			fallthrough;
 		case HID_DG_CONTACTID:
 			MT_STORE_FIELD(contactid);
 			app->touches_by_report++;
-- 
2.51.0



