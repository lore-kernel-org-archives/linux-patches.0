Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D752517A5;
	Tue, 29 Apr 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945658; cv=none; b=QwP37SlCkivmb/xw9VmVyEaM55V0hjgJ4BzA63JYteI7s3de6w8paHF9Rd/J72DG8JMXCajUMgZs5Fz1RBTAY5h3rvRyvEC2MWPNTelC9nR2ioVWGrbsEmmV7C1xU7Bmp5GrqACT01kPVOdq7VNNFVT9Ev7MsFXZgiy2E0SZ5P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945658; c=relaxed/simple;
	bh=5vKuspXHMehPQ489/3yaVHx+uWWHriHUTyg0SiAIvtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufkIbPecmJ123s/GmjdS0c1QQOazAts0e8zNOYKZERbgbG+e41oEIp4u5X589RkARHRr0tfmiuRBSuTplrHF74DXBOYoE16H37f7iL6rTs0aHMjGNQMiNtWzoatWKdiu+mW8Y0KyYcYWFPVsQj1iRD+E/1qnFnxu8Ycbl6aJGKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDn0x2cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDn0x2cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F192C4CEE3;
	Tue, 29 Apr 2025 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945657;
	bh=5vKuspXHMehPQ489/3yaVHx+uWWHriHUTyg0SiAIvtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDn0x2cz6K4g/LPUenGXMh3Vf9W1bKNa/YG7mLf/oAWpN3nRkeDsgZSt924GFrs8z
	 /ZB+aVVAO33D6hfiVXeYV45ZGKU1x13F2OhiLDcv8BqXkw9b2N65wEfwLlK0EoQwS+
	 QzVVatjxjL8PBbEXsetErVinBO9Si+cXj+mez8kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miao Li <limiao@kylinos.cn>,
	Lei Huang <huanglei@kylinos.cn>
Subject: [PATCH 5.4 157/179] usb: quirks: Add delay init quirk for SanDisk 3.2Gen1 Flash Drive
Date: Tue, 29 Apr 2025 18:41:38 +0200
Message-ID: <20250429161055.733628934@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit 37ffdbd695c02189dbf23d6e7d2385e0299587ca upstream.

The SanDisk 3.2Gen1 Flash Drive, which VID:PID is in 0781:55a3,
just like Silicon Motion Flash Drive:
https://lore.kernel.org/r/20250401023027.44894-1-limiao870622@163.com
also needs the DELAY_INIT quirk, or it will randomly work incorrectly
(e.g.: lsusb and can't list this device info) when connecting Huawei
hisi platforms and doing thousand of reboot test circles.

Cc: stable <stable@kernel.org>
Signed-off-by: Miao Li <limiao@kylinos.cn>
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Link: https://lore.kernel.org/r/20250414062935.159024-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -366,6 +366,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 


