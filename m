Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9641B362;
	Wed,  4 Feb 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216309; cv=none; b=ObSeqPH7rOV1/AH9LEyZsoNQfdxBK6jK7Up2NMjDK94wyM+mFrzrkLrUZE6Chuz5TTvCmLnnPOicWJ3eAfDOSjfFz5xQ10dsdX2AdBOGlUYuWkV1AKEs2i+5LgJ6eduIWnl/HCIlJQiOZ11R4Fz8tbZ8+fnDL7a+RcZxMPAKdVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216309; c=relaxed/simple;
	bh=aU+hIMb8NXnRaOec12XuAajdroonDr8DyPOLIYh7VEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwEeH9k/B5ne75/MfIQzXUYZmVKrFl8RG3hvhqA942GRoCEdpQ3SvX4iOXH536xr4xeIC3G/HAtCSD9uN74gyrZOt7i4bZJGbkJsiecqIADLImzXmADfWhCaimPWEebER+/MI9rUzss5FiWctapWmEwutFUMqI4q8TAsg3ztM3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHh1pAKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHh1pAKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1075FC4CEF7;
	Wed,  4 Feb 2026 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216308;
	bh=aU+hIMb8NXnRaOec12XuAajdroonDr8DyPOLIYh7VEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHh1pAKsUs4sJCIFmosz/mYK+3pbl0Wb3R7KcFViFJTWSZjR6TGL60rBrHfP4RNVk
	 kVE5RzcWRe7+fLCiRUIxO2ioMVm8lc3MojxYwjz5ky+uu3vgDH4MyUh9/G/o+CNgDS
	 a84gmEMWNkLwXl1W0+rnjJK3tgp4Yc66D9nU/fWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/161] net: usb: dm9601: remove broken SR9700 support
Date: Wed,  4 Feb 2026 15:38:32 +0100
Message-ID: <20260204143853.526525720@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit 7d7dbafefbe74f5a25efc4807af093b857a7612e ]

The SR9700 chip sends more than one packet in a USB transaction,
like the DM962x chips can optionally do, but the dm9601 driver does not
support this mode, and the hardware does not have the DM962x
MODE_CTL register to disable it, so this driver drops packets on SR9700
devices. The sr9700 driver correctly handles receiving more than one
packet per transaction.

While the dm9601 driver could be improved to handle this, the easiest
way to fix this issue in the short term is to remove the SR9700 device
ID from the dm9601 driver so the sr9700 driver is always used. This
device ID should not have been in more than one driver to begin with.

The "Fixes" commit was chosen so that the patch is automatically
included in all kernels that have the sr9700 driver, even though the
issue affects dm9601.

Fixes: c9b37458e956 ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Link: https://patch.msgid.link/20260113063924.74464-1-enelsonmoore@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/dm9601.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index 9b7db5fd9e08f..287d54ada4714 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -602,10 +602,6 @@ static const struct usb_device_id products[] = {
 	USB_DEVICE(0x0fe6, 0x8101),	/* DM9601 USB to Fast Ethernet Adapter */
 	.driver_info = (unsigned long)&dm9601_info,
 	 },
-	{
-	 USB_DEVICE(0x0fe6, 0x9700),	/* DM9601 USB to Fast Ethernet Adapter */
-	 .driver_info = (unsigned long)&dm9601_info,
-	 },
 	{
 	 USB_DEVICE(0x0a46, 0x9000),	/* DM9000E */
 	 .driver_info = (unsigned long)&dm9601_info,
-- 
2.51.0



