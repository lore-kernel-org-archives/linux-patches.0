Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6034024633C;
	Tue, 29 Apr 2025 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949951; cv=none; b=SYXoKO/RW1mGQO4oTEcu+t0gDylcpGksjnWAMmzQtSqfzjzRfODFdv79BJYq3Ekw3xfrioet5YOq9yGKiKSD9dXPywC9KNVziWh9N5SPRmcNwcCOGx+7rML3KIpiIhdmgrUKU32EFBWScH68vk2Gdu0+PliMFjbzVRWsJZQuIh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949951; c=relaxed/simple;
	bh=BaB83UkOFOXNFfOIA7WBr0Pe6U9lTENWNjzzfmZd4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvE1gq6MZJwuCgI9lghymBH6Do6q0dxZqz9WwOXf+tgq0pikm6AElxIkYC4/mkXicFuf+1495RnuMytvSwhhiGyjOUmJ5OgW/Nw02zg191NoW71CWwy58qraOQqRS6KNDsWxvnwNh5Cva2tMabgm8aY8kdK9AyHsYNzQFwVj/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq6k5x/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq6k5x/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D845C4CEE3;
	Tue, 29 Apr 2025 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949950;
	bh=BaB83UkOFOXNFfOIA7WBr0Pe6U9lTENWNjzzfmZd4UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq6k5x/sJoXe7+sBiNIPOEGPLscnJFVQtUZjN0ys7+nUSCSPZ/l+FQVrvRZdbLR32
	 OStH05HzDqcrUUkCgMM67VTtvYgUUfxXo33h9T6WkPX29067R+yVaXajsU6xE4lE9Y
	 Pd+XWWr16A3dm62WADE8rQytULb0LRMgkhdbeFXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Miao Li <limiao@kylinos.cn>,
	Lei Huang <huanglei@kylinos.cn>
Subject: [PATCH 6.1 091/167] usb: quirks: Add delay init quirk for SanDisk 3.2Gen1 Flash Drive
Date: Tue, 29 Apr 2025 18:43:19 +0200
Message-ID: <20250429161055.441575626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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
@@ -369,6 +369,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* SanDisk Corp. SanDisk 3.2Gen1 */
+	{ USB_DEVICE(0x0781, 0x55a3), .driver_info = USB_QUIRK_DELAY_INIT },
+
 	/* Realforce 87U Keyboard */
 	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
 


