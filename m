Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B977533A02E;
	Tue, 26 Aug 2025 11:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208256; cv=none; b=knmrz9pkjjmeYkPnP62BwCaVAis1nrjTLxYlJabwAkPRmZWIlL6wSvSDi4nOXAUJiaGlAv2nsrGM8J0069kwzkTCTDBiaW/u+XtRCbyPMwXdXmiiW/3Bape+B4nUZTewIvl3lUq4QKJ426GsMaSGYDcpNwVrXw3kdlwzQahST/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208256; c=relaxed/simple;
	bh=bELnGM60o/yx+WHC7OxWobbBvriIv7AG7+6u3jOn4OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+s9HLtaRJp3DeAV1J5nM2K832qDNU3rpvVcqa+J9N3MC2Kf+jaGUJFGpfgnHmk4ADI2fMWrko+wg8fhdVtzuHiYZvLQDn8MeUvqPISDwBCOU+ADM3DpLUYqp9TG9fuoCuSRCxIgrwFvoI33HDN0NR9a6VPXfyIzFO/JhQ9Rlts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISx8xc5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISx8xc5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477E2C4CEF1;
	Tue, 26 Aug 2025 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208256;
	bh=bELnGM60o/yx+WHC7OxWobbBvriIv7AG7+6u3jOn4OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISx8xc5UhOfn3+ACZDu+5VgnKtcaEYCu3gXX212Xs3PxW5aRrFJRa5P29i8fHynfz
	 x5cQDZMHD1gSGkYVVaK2H2XdZKz0F3iUPCbarRmPOK0eeJNcrOSdQUKYlhmBn6U6A/
	 ZMJpQnNykh6CIVh/LxQiQ9lt49IpUlR2+evS+ArA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 010/322] usb: gadget: udc: renesas_usb3: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:07:05 +0200
Message-ID: <20250826110915.481065376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 868837b0a94c6b1b1fdbc04d3ba218ca83432393 upstream.

Make sure to drop the reference to the companion device taken during
probe when the driver is unbound.

Fixes: 39facfa01c9f ("usb: gadget: udc: renesas_usb3: Add register of usb role switch")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2658,6 +2658,7 @@ static void renesas_usb3_remove(struct p
 	struct renesas_usb3 *usb3 = platform_get_drvdata(pdev);
 
 	debugfs_remove_recursive(usb3->dentry);
+	put_device(usb3->host_dev);
 	device_remove_file(&pdev->dev, &dev_attr_role);
 
 	cancel_work_sync(&usb3->role_work);


