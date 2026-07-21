Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0846EF7F;
	Tue, 21 Jul 2026 18:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658735; cv=none; b=OkSyRwLniaRceKmmdsDiGpDYsFOOcD7uNhyV9B0YjT3dUf5fgwv8NfGnWtwWw4j1SR5D6fHQ54oaVJqFY0MjMmiHpAwAcFH+eymHuhbVvTKwrF6OAU0cUgniVxVy4l2sDhuU8kV6kMeFxhDf2XDnGBfwXhCTftZgH4bCipxoCO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658735; c=relaxed/simple;
	bh=v1+xpQ000OWA3xwqfS74CDlKdY10qfcs9ki4naz5XcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nowxo8pv5Dhwak0g5PPHUEinrq/QtLrBjhlvUiUBX4d98mUJlYxk/eqcIyDssqQJ6FF+cfX0iO770k3GlK6+T6ebZ1nz0QZJIqLZxPGPMub1aQCmtvOEDd5ZGcU9+YN8GEe22dmNvttYE3/e96bNLxrywcYSA75HzY7vi+zcQF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKN3kPOU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKN3kPOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54AE1F000E9;
	Tue, 21 Jul 2026 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658734;
	bh=XkNdFXsRUHoyfQLMRHM7SI9fLidLwZ5AT713Sh1cdng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKN3kPOUliNETfs0Ct1zMRQk1WyVdsezH2WtltdT2+SeAxbtkfX8QTrN71jYkv4+U
	 ZRZqP1Dvp+6FgJzWed80W5hMIv/+FPxuAWI20IpMDHRGv0DQBoMENrLsykPcX1R9/Z
	 g1p4Aekt0CCoypHv3krwHnUgvANXXsm1Ol/L3D+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 1211/1611] HID: playstation: validate num_touch_reports in DualShock 4 reports
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152542.674673811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2377,6 +2377,12 @@ static int dualshock4_parse_report(struc
 		struct dualshock4_input_report_usb *usb =
 			(struct dualshock4_input_report_usb *)data;
 
+		if (usb->num_touch_reports > ARRAY_SIZE(usb->touch_reports)) {
+			hid_err(hdev, "DualShock4 USB input report has invalid num_touch_reports=%d\n",
+				usb->num_touch_reports);
+			return -EINVAL;
+		}
+
 		ds4_report = &usb->common;
 		num_touch_reports = min_t(u8, usb->num_touch_reports,
 					  ARRAY_SIZE(usb->touch_reports));
@@ -2392,6 +2398,12 @@ static int dualshock4_parse_report(struc
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


