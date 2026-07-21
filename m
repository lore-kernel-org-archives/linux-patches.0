Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55EB3368A5;
	Tue, 21 Jul 2026 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663632; cv=none; b=uFEb0aTb/MZ5WfraGbehUejd5v143jarVVYkccZVPXnc3QXVormLf/+CaBMH/S8bLa3NOl8C+MRdlHnDS2JnFYjsJ9fFg+7MPjg2EaiqNiSUgli6552jIxB/Ng961gTjsbi3/0OKrLwPANpwlNYxxffNcw15w2hzGmdLQJpNSHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663632; c=relaxed/simple;
	bh=X3IV3PqXtC4TPS82t8XeqmBq7xvEF5zk2sAKINj/nnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gz3U5wBLzdUhKtIi5+1WsddihRRx/S9Kj7zTViysDm7bKKlJCQwQ+sXUpip3XqSx4c7Yrlwe/0lfEZdMPO1tGCOhZVdcYQ4MsKJQh9jEIiD3tIRyhwfkSByaa+h1m1f9ls8rr5TThrIi2TUGMKQMwO5hvj7JrU/+iya3CsvW2YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHMofes7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHMofes7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414271F000E9;
	Tue, 21 Jul 2026 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663631;
	bh=wB17J2PMaHz9c8o60JyqCuLyXLYHN41Jdtww4RLt588=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHMofes7nsXXuwCBHvaL0H+k02RjFJy2szb6wPhot5PhJiy8e/3jaCvNLAShlkXTp
	 tQZ+muVVbLsMbkXnUFgZPctQt9PyUrvYMuuQXuIVJRjME+y2TC5mfBRPAYb7kDiT/p
	 JnEhUiPmZZCcXIaPsP9xI6KSTL7OX/Vqza2WjEk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0896/1276] HID: playstation: validate num_touch_reports in DualShock 4 reports
Date: Tue, 21 Jul 2026 17:22:19 +0200
Message-ID: <20260721152506.096621997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -2247,6 +2247,12 @@ static int dualshock4_parse_report(struc
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
@@ -2262,6 +2268,12 @@ static int dualshock4_parse_report(struc
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


