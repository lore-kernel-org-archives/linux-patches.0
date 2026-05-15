Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557E830568A;
	Fri, 15 May 2026 16:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861465; cv=none; b=ikqCxNDbanjJydtUk5PyiQvT/+IXku54VC3nZvM+If30LMVaHcum0squnRcActkzbCqB741M4lpmWEr0dAkx6UM5nkHLIm6WxNdkgcc9gcVwy5M1vh9RTKvF1akIZt7y1X20y8YD1Zt4t8FRysFfkNPuAj+4enWsrBrXUQtb244=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861465; c=relaxed/simple;
	bh=MDs4iIQSS4wQ6u6oV8t4TIB2Eqw5mCIdJANisDYMz/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3vAvGX6h7WhFWqg1IQuTRwPtjHBFBxxec+wFKNSC2UNDdVSKTg+muqh/69Sk6Ib2aYcvy9k5IMd1Liydsglw1cwFgIB48MStA686EYkrBhq8sn5s9m1PM0h9UPWYdRpNjofOD/lx/qFH0EpqDKHzKYF3z7zxmPLUy2jZIFHIx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHzjeukF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHzjeukF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF594C2BCB3;
	Fri, 15 May 2026 16:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861465;
	bh=MDs4iIQSS4wQ6u6oV8t4TIB2Eqw5mCIdJANisDYMz/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHzjeukFxsj54x9D6EmuAwo03f3tdglLS7wSTtExE6hjVvr+k1Yt5Pxx7FDwRYm5L
	 2OdLrIcK0uotEnQNLLHUuL8qfhkOuWh+q9wi0xn4IjpnjROeeXtM4HFfTbSXY7RGi6
	 mAOyTHVlBQnF2dUkYMteIQAymmspK1+cQowTKfo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 297/474] HID: playstation: Clamp num_touch_reports
Date: Fri, 15 May 2026 17:46:46 +0200
Message-ID: <20260515154721.428771330@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

commit cac61b58a3b6340c52afa06bb15eac033158db2f upstream.

A device would never lie about the number of touch reports would it?

If it does the loop in dualshock4_parse_report will read off the end of
the touch_reports array, up to about 2 KiB for the maximum number of 256
loop iteraions. The data that is read is emitted via evdev if the
DS4_TOUCH_POINT_INACTIVE bit happens to be set. Protect against this by
clamping the num_touch_reports value provided by the device to the
maximum size of the touch_reports array.

Fixes: 752038248808 ("HID: playstation: add DualShock4 touchpad support.")
Cc: stable@vger.kernel.org
Reported-by: Xingyu Jin <xingyuj@google.com>
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-playstation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -2200,7 +2200,8 @@ static int dualshock4_parse_report(struc
 		struct dualshock4_input_report_usb *usb = (struct dualshock4_input_report_usb *)data;
 
 		ds4_report = &usb->common;
-		num_touch_reports = usb->num_touch_reports;
+		num_touch_reports = min_t(u8, usb->num_touch_reports,
+					  ARRAY_SIZE(usb->touch_reports));
 		touch_reports = usb->touch_reports;
 	} else if (hdev->bus == BUS_BLUETOOTH && report->id == DS4_INPUT_REPORT_BT &&
 			size == DS4_INPUT_REPORT_BT_SIZE) {
@@ -2214,7 +2215,8 @@ static int dualshock4_parse_report(struc
 		}
 
 		ds4_report = &bt->common;
-		num_touch_reports = bt->num_touch_reports;
+		num_touch_reports = min_t(u8, bt->num_touch_reports,
+					  ARRAY_SIZE(bt->touch_reports));
 		touch_reports = bt->touch_reports;
 	} else {
 		hid_err(hdev, "Unhandled reportID=%d\n", report->id);


