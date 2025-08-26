Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF00933471E;
	Tue, 26 Aug 2025 13:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214732; cv=none; b=OBpjVSycJdda5he88MktZoiXHx88zipI+tkyUzxd6l+LI/j+iakwEQrvheWszanR1jUDeNsDqVb9xMWnijApj1tTcMhB8aELnehcmABuBAXvmlfMlo71ePgbuZuneielpAuXrhNtjptsueva1zHWapwiJXt7Vmf9wiezLbSciWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214732; c=relaxed/simple;
	bh=h2GZmPlh/irqPaMXc7e8u4ZQ50GoxZwzQkWvuOMTKg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYlTn/F6uunrM7YKAi4/yCvLr7ymQGHaTWL2JrO9rXeOze+du9/xn7wYCjDlTpngmFV6u3mvhQ0OMTCHDcACQEWInUH2xuhWOTdP2w8Pf/aa3O0hYXnYqAq8xUQtA4SsNS5+1mRnMWHyl0R9EJv18Tya4uSaUad3lO1zVaYpIIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=125ahH/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="125ahH/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6232BC4CEF1;
	Tue, 26 Aug 2025 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214732;
	bh=h2GZmPlh/irqPaMXc7e8u4ZQ50GoxZwzQkWvuOMTKg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=125ahH/DqglKGVmEabuqBOGXDBrWQ2EmMAL2x+b/RiMXkpEkxIcjq4EOjS5qXGOtE
	 dTqMgKCSJDl46waS6tMU2wZgUx6dAJ/9g/VRZ0xv9zHVd+yeLlPhF/VXliWQ9yqJbQ
	 DQPBWsxlyKb78Go3+mXxPSSqrk1xj2JSmdjvDOyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricky Wu <ricky_wu@realtek.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 247/482] misc: rtsx: usb: Ensure mmc child device is active when card is present
Date: Tue, 26 Aug 2025 13:08:20 +0200
Message-ID: <20250826110936.871404096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


