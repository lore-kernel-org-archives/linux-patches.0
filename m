Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043EC3B4EAF;
	Fri, 15 May 2026 16:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861840; cv=none; b=rexuLyCX4fJum80Xn9/yq14vVoL0nwFp83IKBFP/D/IWh8lUTIKHopW7F+baNAxcnPqt0iDXiBjbTGg4ZXEEXeyrxRIqMz2ZE53VrBJ+O5x2ZW47V3InbS/vzjWISCCHWXChk9mqADm/GwD+XzotKwZ2jFt47ntiU6rpqgN0f8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861840; c=relaxed/simple;
	bh=hXiQJptjOfQckX4sa83RGJGooapz7GczEm40j1Mx5vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxGHznvyEtFDxPzIJ7r18/D1J+QQebfR5iH5e/uLwfzFa5aeY6D0jBWj+pKnVtpy83rcZmEaUhysYIoItgGLnx0pvypNnXdFX4j3bL5MDtLpDXRuyqTv8pYVOzxfvwYUK7yefTEI8TEEmiYeZ1uu6GIF/X+o0QE7JiXqZJWdqko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHYG2b5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHYG2b5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBA7C2BCB0;
	Fri, 15 May 2026 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861839;
	bh=hXiQJptjOfQckX4sa83RGJGooapz7GczEm40j1Mx5vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHYG2b5sPGrJzX/m76w065jDTkO64XzawDdANCdrKdU2jc2UAYpk5G1DixblyYuYr
	 DS1BC5GN0WkRopvuVwlKrzoKCpmuoTUDcJs1DJYuK1JQnXcvVHW6Zi49fDbg0aqgoK
	 f0iD32djSBJtcxac4o0YynHHR/PJ9UXZBaZF1sX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 001/188] HID: playstation: Clamp num_touch_reports
Date: Fri, 15 May 2026 17:46:58 +0200
Message-ID: <20260515154657.342987963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2378,7 +2378,8 @@ static int dualshock4_parse_report(struc
 			(struct dualshock4_input_report_usb *)data;
 
 		ds4_report = &usb->common;
-		num_touch_reports = usb->num_touch_reports;
+		num_touch_reports = min_t(u8, usb->num_touch_reports,
+					  ARRAY_SIZE(usb->touch_reports));
 		touch_reports = usb->touch_reports;
 	} else if (hdev->bus == BUS_BLUETOOTH && report->id == DS4_INPUT_REPORT_BT &&
 		   size == DS4_INPUT_REPORT_BT_SIZE) {
@@ -2392,7 +2393,8 @@ static int dualshock4_parse_report(struc
 		}
 
 		ds4_report = &bt->common;
-		num_touch_reports = bt->num_touch_reports;
+		num_touch_reports = min_t(u8, bt->num_touch_reports,
+					  ARRAY_SIZE(bt->touch_reports));
 		touch_reports = bt->touch_reports;
 	} else if (hdev->bus == BUS_BLUETOOTH &&
 		   report->id == DS4_INPUT_REPORT_BT_MINIMAL &&


