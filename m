Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B8443AB5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1nRnvFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7895CC433C7;
	Wed, 15 Nov 2023 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081134;
	bh=59uQ1Q1t0oNArnvIwNdAS0UG7N8KeFBmJRf9QBLLH8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1nRnvFiNvmdu3x2JKElP01A3QBP2rlajEjwg12X5DBijJyC0eEq0hrwc/7gXO9Ez
	 /XT/pldPOeYBQmLDbTe8MYZr8QixriNqCKJY1rtI9Z9s0TVOlLywbRF37IInfuQgMU
	 UviNzRCvF/CDIRjj36snl9VFgZuNPmBUJexnu3Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Blixt <jonas.blixt@actia.se>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/88] USB: usbip: fix stub_dev hub disconnect
Date: Wed, 15 Nov 2023 15:36:11 -0500
Message-ID: <20231115191429.687708818@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Blixt <jonas.blixt@actia.se>

[ Upstream commit 97475763484245916735a1aa9a3310a01d46b008 ]

If a hub is disconnected that has device(s) that's attached to the usbip layer
the disconnect function might fail because it tries to release the port
on an already disconnected hub.

Fixes: 6080cd0e9239 ("staging: usbip: claim ports used by shared devices")
Signed-off-by: Jonas Blixt <jonas.blixt@actia.se>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20230615092810.1215490-1-jonas.blixt@actia.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/usbip/stub_dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index c64964c32cc97..ebcb8d52d1e3a 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -497,8 +497,13 @@ static void stub_disconnect(struct usb_device *udev)
 	/* release port */
 	rc = usb_hub_release_port(udev->parent, udev->portnum,
 				  (struct usb_dev_state *) udev);
-	if (rc) {
-		dev_dbg(&udev->dev, "unable to release port\n");
+	/*
+	 * NOTE: If a HUB disconnect triggered disconnect of the down stream
+	 * device usb_hub_release_port will return -ENODEV so we can safely ignore
+	 * that error here.
+	 */
+	if (rc && (rc != -ENODEV)) {
+		dev_dbg(&udev->dev, "unable to release port (%i)\n", rc);
 		return;
 	}
 
-- 
2.42.0



