Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC88408035;
	Fri,  4 Sep 2026 05:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500772; cv=none; b=neZ6zZBFb4ANZRZTpq4FBD2Sv7jyZUbxM5L7mLfrT12ARxx+dytncat+6D2867oZQKWd2WhGEIMGalYoVYDSAzrm0oBKQhq/fYNh76Qdw4OCdT0Kh0S4KzVWVahTVdrhqkAgMejDShRpr0f/Sk26p2oCsIWsW8OvGlfPJQhosHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500772; c=relaxed/simple;
	bh=P57h/Y6TiuyhraSkiEDlX30IJ+hbs4wqdFTAkn7fLGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rq2FBqm6/teWp872SilAJXA5LEpkxl6e/NeNhDsGD+42oVksc8Wzhg7dbX4bqWYtEKdw94iWC9dXb4l68V+YmSqhojgWTTpcNJHsRe9znJvW7xSPaPsSIcIqVXvswRJ5hICPbt0MRGU4zkgSst6fO7vjtxreA6tgnkhKMOsSg04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0nBmz4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0nBmz4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505621F00A3D;
	Fri,  4 Sep 2026 05:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500770;
	bh=k8koMPhERBodvjlp50Hri5cCKkScW9WhuSSkPKWR0HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0nBmz4Y6Qcu3npF6wF4VTU/stEhHknTD6SnEyUu6k3nJ3idpt7pEnM6Sw03fVVFY
	 2au75eJYGHSqwFxbJnHpENM4+QKpBZKnhW43ji86FweziGY5NPeqKbP2jJa1VZne9Z
	 6RxAKvatTIOjThRvg/t4IKP6HYQDo7ZeB09smafo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 175/552] HID: corsair-void: Check size of status and firmware events before reading them
Date: Fri,  4 Sep 2026 06:55:32 +0200
Message-ID: <20260904045752.990039941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

commit 08d8814521885e67b1bdf6a3036ee264e3e58377 upstream.

Malformed status and firmware events could cause an out-of-bounds read since
the size wasn't being checked. Check the size and warn on unexpected values to
avoid this.

Fixes: 6ea2a6fd3872 ("HID: corsair-void: Add Corsair Void headset family driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-corsair-void.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/hid/hid-corsair-void.c
+++ b/drivers/hid/hid-corsair-void.c
@@ -92,6 +92,9 @@
 #define CORSAIR_VOID_STATUS_REPORT_ID		0x64
 #define CORSAIR_VOID_FIRMWARE_REPORT_ID		0x66
 
+#define CORSAIR_VOID_STATUS_REPORT_SIZE		5
+#define CORSAIR_VOID_FIRMWARE_REPORT_SIZE	5
+
 #define CORSAIR_VOID_USB_SIDETONE_REQUEST	0x1
 #define CORSAIR_VOID_USB_SIDETONE_REQUEST_TYPE	0x21
 #define CORSAIR_VOID_USB_SIDETONE_VALUE		0x200
@@ -742,6 +745,13 @@ static int corsair_void_raw_event(struct
 
 	/* Description of packets are documented at the top of this file */
 	if (hid_report->id == CORSAIR_VOID_STATUS_REPORT_ID) {
+		if (size < CORSAIR_VOID_STATUS_REPORT_SIZE) {
+			hid_warn_ratelimited(hid_dev,
+			                     "unexpected status report of size %d",
+			                     size);
+			return 1;
+		}
+
 		drvdata->mic_up = FIELD_GET(CORSAIR_VOID_MIC_MASK, data[2]);
 		drvdata->connected = (data[3] == CORSAIR_VOID_WIRELESS_CONNECTED) ||
 				     drvdata->is_wired;
@@ -750,6 +760,13 @@ static int corsair_void_raw_event(struct
 					      FIELD_GET(CORSAIR_VOID_CAPACITY_MASK, data[2]),
 					      data[3], data[4]);
 	} else if (hid_report->id == CORSAIR_VOID_FIRMWARE_REPORT_ID) {
+		if (size < CORSAIR_VOID_FIRMWARE_REPORT_SIZE) {
+			hid_warn_ratelimited(hid_dev,
+			                     "unexpected firmware report of size %d",
+			                     size);
+			return 1;
+		}
+
 		drvdata->fw_receiver_major = data[1];
 		drvdata->fw_receiver_minor = data[2];
 		drvdata->fw_headset_major = data[3];


