Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0360E220696;
	Mon, 18 Aug 2025 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524387; cv=none; b=n/xMMu8q4ejGwJOzyk2aKlTqk+XOngdMAmX9DmV0MsPtktk2AiZw8rbqnzDePBMQefib8zpGklaWom8ES1xPDiV6HCmwA59oWMg+zbQWL4v73Aw8M6WZNtBf1X9cu2/T+8/CpGsJPXqDjpbNpHXt1vJX9hliQDrwKnkHNRf7PTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524387; c=relaxed/simple;
	bh=i+DkHewD2WPhsc2h3yMWklfHJfkNlKOKP+PyrRxHZyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRVKWcYTWz6NWo4HJKB9Sa/D9ejxiIOK9mOVsSeoyAfd4hX5xLxE414Oahr2YUYlZ00VpwM26ZXxxsPrIwNgcFN8KR7RhQmNDr54ALCRakNWSFIESFKRPw+nHSC4DdbI8pPWHpPhillOHsajuVNnvmbi69tzbkJW2Q8Ea+5Laz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWWuSqwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWWuSqwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637E6C113D0;
	Mon, 18 Aug 2025 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524386;
	bh=i+DkHewD2WPhsc2h3yMWklfHJfkNlKOKP+PyrRxHZyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWWuSqwjpv+PtIhRbFfIJeN9Quby2eZs8uDjUQhS0g2Z0l13bZXu78IPzi5f4GXX9
	 +1EeLIzJA8748PuJGMbcd7ioppIPtnSZW5FPWYkP42ytYQFqIuu9edhTnPTDYmQ/7i
	 bIWxIZLIWQEbyiVJ3l+epvHGQwyf0bb7V1HPCBU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky Wu <ricky_wu@realtek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 456/515] misc: rtsx: usb: Ensure mmc child device is active when card is present
Date: Mon, 18 Aug 2025 14:47:22 +0200
Message-ID: <20250818124515.973405273@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Ricky Wu <ricky_wu@realtek.com>

commit 966c5cd72be8989c8a559ddef8e8ff07a37c5eb0 upstream.

When a card is present in the reader, the driver currently defers
autosuspend by returning -EAGAIN during the suspend callback to
trigger USB remote wakeup signaling. However, this does not guarantee
that the mmc child device has been resumed, which may cause issues if
it remains suspended while the card is accessible.
This patch ensures that all child devices, including the mmc host
controller, are explicitly resumed before returning -EAGAIN. This
fixes a corner case introduced by earlier remote wakeup handling,
improving reliability of runtime PM when a card is inserted.

Fixes: 883a87ddf2f1 ("misc: rtsx_usb: Use USB remote wakeup signaling for card insertion detection")
Cc: stable@vger.kernel.org
Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250711140143.2105224-1-ricky_wu@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/cardreader/rtsx_usb.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -698,6 +698,12 @@ static void rtsx_usb_disconnect(struct u
 }
 
 #ifdef CONFIG_PM
+static int rtsx_usb_resume_child(struct device *dev, void *data)
+{
+	pm_request_resume(dev);
+	return 0;
+}
+
 static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct rtsx_ucr *ucr =
@@ -713,8 +719,10 @@ static int rtsx_usb_suspend(struct usb_i
 			mutex_unlock(&ucr->dev_mutex);
 
 			/* Defer the autosuspend if card exists */
-			if (val & (SD_CD | MS_CD))
+			if (val & (SD_CD | MS_CD)) {
+				device_for_each_child(&intf->dev, NULL, rtsx_usb_resume_child);
 				return -EAGAIN;
+			}
 		} else {
 			/* There is an ongoing operation*/
 			return -EAGAIN;
@@ -724,12 +732,6 @@ static int rtsx_usb_suspend(struct usb_i
 	return 0;
 }
 
-static int rtsx_usb_resume_child(struct device *dev, void *data)
-{
-	pm_request_resume(dev);
-	return 0;
-}
-
 static int rtsx_usb_resume(struct usb_interface *intf)
 {
 	device_for_each_child(&intf->dev, NULL, rtsx_usb_resume_child);


