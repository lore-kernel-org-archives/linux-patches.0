Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2E430C635;
	Wed, 28 Jan 2026 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615527; cv=none; b=iE8hQkjdBfHDCVcwKpo4zHb+hSokwe2DR7SGw2PYWtZwW2OOkNp/z0t4hOK8ldHEUA7Yp9iGDz8r4+3eM6ZD7Qq0TEcnwQXuQS43LSPn+Xi7GnYdC0SSxBCH7BeylETntxyHxaD5MCAAVeylEj4yjvXS+bo09VGL0ond6fpSqk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615527; c=relaxed/simple;
	bh=KODLhUv/oWf3c8XVsVLV4ela3dsNpbj2RcqNclMoi9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZrSzUvoklE9McRl7OlQ3MvH/2BlXMAG1tX37dwpbdstxXDqp49vUY3i/wwixuh6lDV+YT9nNPyAGQKbMJVReHz8n6uGc6zfekOWtIFMFSNNzs9AR9ue5bDP/WwR1qtPFvq6yyzWZQuIQLwjhrKMzoIIzYJEFY4fkaN0UXIGTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgdAmQoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgdAmQoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A079C116C6;
	Wed, 28 Jan 2026 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615527;
	bh=KODLhUv/oWf3c8XVsVLV4ela3dsNpbj2RcqNclMoi9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZgdAmQoQv+Aj2+pUzf1EBlsNxLI2/jbJ5emJGoAUIK6JvtY5N8A2tSBXWw/bBoJgM
	 chqu4FmkrSE7yzniFpunaQD8g5As+Fxi7HpnMXgE9heewtHLHr6BofSsRZvC4coK2j
	 0StglzTHl2O6RqdaJ9zdicinZ5m0hq2DkoQeicDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/227] net: usb: dm9601: remove broken SR9700 support
Date: Wed, 28 Jan 2026 16:21:13 +0100
Message-ID: <20260128145345.358062577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8b6d6a1b3c2ec..2b4716ccf0c5b 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -603,10 +603,6 @@ static const struct usb_device_id products[] = {
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



