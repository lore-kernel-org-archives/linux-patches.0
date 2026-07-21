Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343130D3FF;
	Tue, 21 Jul 2026 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667169; cv=none; b=VCzhKag1Ga5X7x7zwWpcw4vfe66FpG3/uu3nrZUlFEls6HGRt0IBEupYyPnQ5tmq8YVEXhini8ePF1r+CEOGWh13ySS57fklaJLX+3zdR6Q1G0VBOPfIMCx3IPe4w0ZTfILdUzoqZ4pCVHh12KRTErLm50yfJzmb18Zi1Ku9D2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667169; c=relaxed/simple;
	bh=Rx4+LSzEhzYa/eC5uAmrpzSpVmD+fOFtsiBPQnhfvvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLgvLQZgm/+VrS1YqKQL2iqsTn8WZu067i3i9kUSDmsB5R/6sgcJ12Oi7gTsT3U+sqWNNilazkBzr5aLFGbjIM2VkeihCge87QoF2QyEg+Pr+nN8mvt3acfjmIncttpSX1j76/Vy3Ezfh7qI3F6rHkLbeUu/cThA+09tlpoBgjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0tZA4a2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0tZA4a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693D41F000E9;
	Tue, 21 Jul 2026 20:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667167;
	bh=3MrCk1PkQ10M1f5nJY2CJuGx5utMzfPfFCPaVM12Lx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0tZA4a2eHFa02fI1BplwjIzZ6ecYnbYupgLMfS2dvwYWRL3GULZxthUo6wdBaaHI
	 JtyZwy5BkX+8fYxx2rU5nKcAq64CdoTr1R8ORGyxrth1Jo4zkJh4Iu6/9w8JL9zCk+
	 TEuq8uiZF45SvYBflL8UgKhd24y06xbrft8ujXFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0958/1266] HID: playstation: validate num_touch_reports in DualShock 4 reports
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152503.265554508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Benoît Sevens <bsevens@google.com>

commit 82a4fc46330910b4c1d9b189561439d468e3ff11 upstream.

The DualShock 4 HID driver fails to validate the num_touch_reports field
received from the device in both USB and Bluetooth input reports.
A malicious device could set this field to a value larger than the
allocated size of the touch_reports array (3 for USB, 4 for Bluetooth),
leading to an out-of-bounds read in dualshock4_parse_report().

This can result in kernel memory disclosure when processing malicious
HID reports.

Validate num_touch_reports against the array size for the respective
connection types before processing the touch data.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-playstation.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -2199,6 +2199,12 @@ static int dualshock4_parse_report(struc
 			size == DS4_INPUT_REPORT_USB_SIZE) {
 		struct dualshock4_input_report_usb *usb = (struct dualshock4_input_report_usb *)data;
 
+		if (usb->num_touch_reports > ARRAY_SIZE(usb->touch_reports)) {
+			hid_err(hdev, "DualShock4 USB input report has invalid num_touch_reports=%d\n",
+				usb->num_touch_reports);
+			return -EINVAL;
+		}
+
 		ds4_report = &usb->common;
 		num_touch_reports = min_t(u8, usb->num_touch_reports,
 					  ARRAY_SIZE(usb->touch_reports));
@@ -2214,6 +2220,12 @@ static int dualshock4_parse_report(struc
 			return -EILSEQ;
 		}
 
+		if (bt->num_touch_reports > ARRAY_SIZE(bt->touch_reports)) {
+			hid_err(hdev, "DualShock4 BT input report has invalid num_touch_reports=%d\n",
+				bt->num_touch_reports);
+			return -EINVAL;
+		}
+
 		ds4_report = &bt->common;
 		num_touch_reports = min_t(u8, bt->num_touch_reports,
 					  ARRAY_SIZE(bt->touch_reports));


