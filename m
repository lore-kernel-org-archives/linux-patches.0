Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16472EACE1;
	Thu,  3 Jul 2025 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555834; cv=none; b=AyEbijAhq4AyIr2/IGPa0BObsb9h/4M0mi3XX5sBYcY57T87Ahurq0ZKvHKQOuIdbVQvwJ53UhR7OYDVH7lCxK+GoHJcKysGrTyUlT8JT54BaA/r07BS7nbjKOWYtVYuX5EfODqIiwvkNSn0rx/HlB7Uo/XQqABGP1xi31vUEBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555834; c=relaxed/simple;
	bh=iTuPAW9G3aKemG+LEcHshYs1ztx/IKtYQsknlr/ZWSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KV5niaJcoepjkCHmk2Z9cPOxtyuIdOCb12Moc+KASko/O+4TtLhBbRFrPhoER2OR/qQQxlxCs5W6Oi5zynNq+iFmMyF2otVL+BIz+YGf9hH0/HxdClTQaju4PqYjgJWQD6e4K0lDHTMD6DcwAHvnG9Za70jW5zB3DAuDaQ7pPH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUwGWF1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUwGWF1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202E2C4CEE3;
	Thu,  3 Jul 2025 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555834;
	bh=iTuPAW9G3aKemG+LEcHshYs1ztx/IKtYQsknlr/ZWSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUwGWF1Q+FScd9WV5g+5Usa9fXTSqRoSP2kq3nYsHZmxZ+1gs1R6mOxWVjut+BQkH
	 svwZcAbnUw4sgHqVIK9sddTJg+fBDCyCaQKZm6jUMyZvkcVX53sfyyAy1QC96OCrhs
	 u+cx1RBqNM+deQTBbFxJSQg3uOHUGvhiIqzHhLx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iusico Maxim <iusico.maxim@libero.it>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 104/139] HID: lenovo: Restrict F7/9/11 mode to compact keyboards only
Date: Thu,  3 Jul 2025 16:42:47 +0200
Message-ID: <20250703143945.245334220@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -529,11 +529,14 @@ static void lenovo_features_set_cptkbd(s
 
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


