Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4F15442C;
	Thu,  3 Jul 2025 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555265; cv=none; b=VUJeTNb2by/f7lySyAex3qXJU1OnDqSk/MQhTdNoeK1oH4NoKX8e1nbA6ev/iRjyt7EOaSZq6FTCTp/95EszE53Q9fo+tDj780vEPNGRkqO+ijkJ+U7seXIHufOn0ZXf+ciREdmCCcHbsmFzrKu2tqi7w7NUTExTbIJ9/KUal1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555265; c=relaxed/simple;
	bh=do1KaS68jRcyysliux/t1OpLFu3u30Xc+ccHMr2laHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3q84WVrMTM3He0DmcPjGNYBe5uKfBG+GJATDSw+USc60PCKbtoKq7DMvuNVJdXwBZehFsl4mJlO4DT15StL2iMGgk4kkvN5e2Y9B8xNhh63QJaJQZWmpkVcRA+yBVmI9h3kGUnFMOZY89OWjWVZH1837YYNy6H+wYtSbHhy3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTXgwIfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTXgwIfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21691C4CEE3;
	Thu,  3 Jul 2025 15:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555265;
	bh=do1KaS68jRcyysliux/t1OpLFu3u30Xc+ccHMr2laHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTXgwIfRq2OZy7E9riWXTqn7Vl5Tkd/hjwDRW2u1vIa8OplVAnx0HkDiCH7AGpMo0
	 5sT6kTNSfS9W7YwYI6OX3FLSZQJojsKQyS4B3U6Sg17Lfn7hN12VcCIB50Mf3SHN/Y
	 WIOzFFYxoJHhn/v859bF2n4k97ucsc65br4QDNW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iusico Maxim <iusico.maxim@libero.it>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 194/263] HID: lenovo: Restrict F7/9/11 mode to compact keyboards only
Date: Thu,  3 Jul 2025 16:41:54 +0200
Message-ID: <20250703144012.134166346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iusico Maxim <iusico.maxim@libero.it>

commit 9327e3ee5b077c4ab4495a09b67624f670ed88b6 upstream.

Commit 2f2bd7cbd1d1 ("hid: lenovo: Resend all settings on reset_resume
for compact keyboards") introduced a regression for ThinkPad TrackPoint
Keyboard II by removing the conditional check for enabling F7/9/11 mode
needed for compact keyboards only. As a result, the non-compact
keyboards can no longer toggle Fn-lock via Fn+Esc, although it can be
controlled via sysfs knob that directly sends raw commands.

This patch restores the previous conditional check without any
additions.

Cc: stable@vger.kernel.org
Fixes: 2f2bd7cbd1d1 ("hid: lenovo: Resend all settings on reset_resume for compact keyboards")
Signed-off-by: Iusico Maxim <iusico.maxim@libero.it>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -548,11 +548,14 @@ static void lenovo_features_set_cptkbd(s
 
 	/*
 	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
-	 * regular keys
+	 * regular keys (Compact only)
 	 */
-	ret = lenovo_send_cmd_cptkbd(hdev, 0x01, 0x03);
-	if (ret)
-		hid_warn(hdev, "Failed to switch F7/9/11 mode: %d\n", ret);
+	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD ||
+	    hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD) {
+		ret = lenovo_send_cmd_cptkbd(hdev, 0x01, 0x03);
+		if (ret)
+			hid_warn(hdev, "Failed to switch F7/9/11 mode: %d\n", ret);
+	}
 
 	/* Switch middle button to native mode */
 	ret = lenovo_send_cmd_cptkbd(hdev, 0x09, 0x01);


