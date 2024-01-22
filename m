Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7162A0B;
	Tue, 23 Jan 2024 01:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974981; cv=none; b=cb3gq6D3p1IcxFkwEGyriWQ8gKToqWWwI1iFZkd7zpemLRm6lETMQAJLiWU85X7FJ+QSawg+p5vAEkmSav5KS/v3MISWDdgWap7QNwBwS4B8osTkbB0XK6tO2tB5kItXic5o9DjIvS7OAFmTQ1k8WrVGe7E1YVVJzZWOSvx7EWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974981; c=relaxed/simple;
	bh=4CZMEQUDC+tbQbSXuSBcOqfEuJWeI5hhJDUbSYi8apI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDOQkJcivK//ZB6yQoppeuZ30dfDQSH+9z2aLc8ycwxHbE4E3bB6/MUEqOfuKkFg755g4oRukUMlfABSDddO3HDFXaYtgZrihk8aKNJ9Mp0K2kiUiSQFo87VF9GecQTSEIlQuQRtwlkBmCHeI8kD3eh4o3xMRZCjcMGTTeRiBAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmfMS821; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmfMS821"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF551C433C7;
	Tue, 23 Jan 2024 01:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974981;
	bh=4CZMEQUDC+tbQbSXuSBcOqfEuJWeI5hhJDUbSYi8apI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmfMS821TDxXbpFFLgP6tQ7kcUB7KO0BMIlEcIPhhnf80VRC5tbt4ewdWcLsXBf3K
	 4wrJCe//1gN10bwYr2D5I5QiUDMrjQZmQV24gR3dcQtBoNxMUgDNyYNU4rdHyZBJ21
	 D2tPMlYQcDeJ4btuO1wbEuJp9nKpSSRa4abRoRfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/374] r8152: Choose our USB config with choose_configuration() rather than probe()
Date: Mon, 22 Jan 2024 15:59:22 -0800
Message-ID: <20240122235755.485557629@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit aa4f2b3e418e8673e55145de8b8016a7a9920306 ]

If you deauthorize the r8152 device (by writing 0 to the "authorized"
field in sysfs) and then reauthorize it (by writing a 1) then it no
longer works. This is because when you do the above we lose the
special configuration that we set in rtl8152_cfgselector_probe().
Deauthorizing causes the config to be set to -1 and then reauthorizing
runs the default logic for choosing the best config.

I made an attempt to fix it so that the config is kept across
deauthorizing / reauthorizing [1] but it was a bit ugly.

Let's instead use the new USB core feature to override
choose_configuration().

This patch relies upon the patches ("usb: core: Don't force USB
generic_subclass drivers to define probe()") and ("usb: core: Allow
subclassed USB drivers to override usb_choose_configuration()")

[1] https://lore.kernel.org/r/20231130154337.1.Ie00e07f07f87149c9ce0b27ae4e26991d307e14b@changeid

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Link: https://lore.kernel.org/r/20231201102946.v2.3.Ie00e07f07f87149c9ce0b27ae4e26991d307e14b@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e8fd743a1509..85b98fd06ba2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9872,7 +9872,7 @@ static struct usb_driver rtl8152_driver = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-static int rtl8152_cfgselector_probe(struct usb_device *udev)
+static int rtl8152_cfgselector_choose_configuration(struct usb_device *udev)
 {
 	struct usb_host_config *c;
 	int i, num_configs;
@@ -9899,19 +9899,13 @@ static int rtl8152_cfgselector_probe(struct usb_device *udev)
 	if (i == num_configs)
 		return -ENODEV;
 
-	if (usb_set_configuration(udev, c->desc.bConfigurationValue)) {
-		dev_err(&udev->dev, "Failed to set configuration %d\n",
-			c->desc.bConfigurationValue);
-		return -ENODEV;
-	}
-
-	return 0;
+	return c->desc.bConfigurationValue;
 }
 
 static struct usb_device_driver rtl8152_cfgselector_driver = {
-	.name =		MODULENAME "-cfgselector",
-	.probe =	rtl8152_cfgselector_probe,
-	.id_table =	rtl8152_table,
+	.name =	MODULENAME "-cfgselector",
+	.choose_configuration = rtl8152_cfgselector_choose_configuration,
+	.id_table = rtl8152_table,
 	.generic_subclass = 1,
 	.supports_autosuspend = 1,
 };
-- 
2.43.0



