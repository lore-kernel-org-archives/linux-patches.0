Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5404FB9C3;
	Wed, 30 Sep 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788898; cv=none; b=tpDBVpj1QKYWoNqZ7ag2mAcPrVUcSTKQShQuTmmK+UXDWASpQ5LWKKJ3E85uLAQfs8Y+N8vA2nKOJupLA1fCtoBJMGXCvBAAZFwhsLe1IBShKzezSa7ZzLJa1hfXI4KGtSXUeoSnrl4vwSqWmO8RyJq3uBkZr9TfJaT/dULGKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788898; c=relaxed/simple;
	bh=8iVxnYTksXCsiJ32iwPtYtpfPJCPzmvyKQaorOGvNpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urD6wy/D6waZZV+2owiwkjnYGDoTnr4yMgvBjALYTvW68fTnwyo72BTHka7pUvOzOvHxAGoDKSKeeLi+I6Vfutt0ZgkNO1fV0gvRrFnUjDCzqs3dRB/1S2GfwbCM2keyTXgtr4jQ1vrxnKdqZYVjeMN0jxd7MeqeAYftaZ4et1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XV/h+iom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XV/h+iom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A0D1F000FF;
	Wed, 30 Sep 2026 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788897;
	bh=LwkYKNcSGzqcczCoWOmiLRSfoqQSc1F/Qwx/9If6EZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XV/h+iomLImMt8mtZBIgfF6Lhbo0eETkm8EVsHQoqkzZZW6n71+Mbnv3OSz4+Aa28
	 vdIH5O4095yN+aXrqHpZ8WLB2W4eoTkOWYpoeR+WbJ/ShSUyaNdtwzvB0ba1I/DYhb
	 /+JXXxHCF9fkoLdQzagVrlnO2s5H+VJqZXFEZsAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Denis Benato <benato.denis96@gmail.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/877] HID: asus: fortify keyboard handshake
Date: Wed, 30 Sep 2026 17:19:57 +0200
Message-ID: <20260930152420.883995584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit e82ae34af29e910c96d33c8b3a90c60e27f1625e ]

Handshaking with an Asus device involves sending it a feature report
with the string "ASUS Tech.Inc." and then reading it back to verify the
handshake was successful, under the feature ID the interaction will
take place.

Currently, the driver only does the first part. Add the readback to
verify the handshake was successful. As this could cause breakages,
allow the verification to fail with a dmesg error until we verify
all devices work with it (they seem to).

Since the response is more than 16 bytes, increase the buffer size
to 64 as well to avoid overflow errors. In addition, add the report
ID to prints, to help identify failed handshakes.

Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Reviewed-by: Denis Benato <benato.denis96@gmail.com>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20260122075044.5070-5-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 28426337a2f11..1708396a04502 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -48,7 +48,7 @@ MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 #define FEATURE_REPORT_ID 0x0d
 #define INPUT_REPORT_ID 0x5d
 #define FEATURE_KBD_REPORT_ID 0x5a
-#define FEATURE_KBD_REPORT_SIZE 16
+#define FEATURE_KBD_REPORT_SIZE 64
 #define FEATURE_KBD_LED_REPORT_ID1 0x5d
 #define FEATURE_KBD_LED_REPORT_ID2 0x5e
 
@@ -393,15 +393,41 @@ static int asus_kbd_set_report(struct hid_device *hdev, const u8 *buf, size_t bu
 
 static int asus_kbd_init(struct hid_device *hdev, u8 report_id)
 {
+	/*
+	 * The handshake is first sent as a set_report, then retrieved
+	 * from a get_report. They should be equal.
+	 */
 	const u8 buf[] = { report_id, 0x41, 0x53, 0x55, 0x53, 0x20, 0x54,
 		     0x65, 0x63, 0x68, 0x2e, 0x49, 0x6e, 0x63, 0x2e, 0x00 };
 	int ret;
 
 	ret = asus_kbd_set_report(hdev, buf, sizeof(buf));
-	if (ret < 0)
-		hid_err(hdev, "Asus failed to send init command: %d\n", ret);
+	if (ret < 0) {
+		hid_err(hdev, "Asus handshake %02x failed to send: %d\n",
+			report_id, ret);
+		return ret;
+	}
 
-	return ret;
+	u8 *readbuf __free(kfree) = kzalloc(FEATURE_KBD_REPORT_SIZE, GFP_KERNEL);
+	if (!readbuf)
+		return -ENOMEM;
+
+	ret = hid_hw_raw_request(hdev, report_id, readbuf,
+				 FEATURE_KBD_REPORT_SIZE, HID_FEATURE_REPORT,
+				 HID_REQ_GET_REPORT);
+	if (ret < 0) {
+		hid_warn(hdev, "Asus handshake %02x failed to receive ack: %d\n",
+			 report_id, ret);
+	} else if (memcmp(readbuf, buf, sizeof(buf)) != 0) {
+		hid_warn(hdev, "Asus handshake %02x returned invalid response: %*ph\n",
+			 report_id, FEATURE_KBD_REPORT_SIZE, readbuf);
+	}
+
+	/*
+	 * Do not return error if handshake is wrong until this is
+	 * verified to work for all devices.
+	 */
+	return 0;
 }
 
 static int asus_kbd_get_functions(struct hid_device *hdev,
-- 
2.53.0



