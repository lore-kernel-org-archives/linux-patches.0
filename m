Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E369423A91;
	Wed,  4 Feb 2026 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216901; cv=none; b=eFZSIEaPg41DboSNLvQNiYDT4TxhdY3FAXezeSSzzuFsmqRK0upctSBGZOQfL9Bo9i2jhTSINvXdL2o76dIAd38xg1TwD5FYGUP5e0aZBZfERKoOEcBSXDeDPHgbOw3f/nmS4W42erQujnYGt/kZ9nqm7j9ULRKw/5pW3JlM7sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216901; c=relaxed/simple;
	bh=sPyKGl6tmLsD13/njDltul/yw6XYLRz7epmmeGqd3Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsMDSm7SOpjduGjs0cCxo6I5Oumg59oghwSlivVe+lE5y6eM10fhSeetNRalhYXW8PDHSp2r1LGu+ejiN2MtBDvbyqbJ/+LFrbFE8xImQD6op+OX9XjrrOyljCKpxHZKDfOPOKjIC7zlqJXXEcW5lvp8kxeqlgLtX/CJIFE/c18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpJygPYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpJygPYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C25C19424;
	Wed,  4 Feb 2026 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216901;
	bh=sPyKGl6tmLsD13/njDltul/yw6XYLRz7epmmeGqd3Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpJygPYhUks3zpCTj22sRdk87ilFRhOv4F3/3TsBjw4B8Aw3+Y0CU+R3oUw3KHej7
	 cxLhhHAxTYmCcflROSqa1MgbHP+3hu/7p0LxbXTbhMPMbtk2q+mjz5u+zHhRci8zQC
	 Uv2bj4eWgfM2pEOet1s+RXy8swh66Jk9a/1mIAuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/206] net: usb: dm9601: remove broken SR9700 support
Date: Wed,  4 Feb 2026 15:38:17 +0100
Message-ID: <20260204143900.591732978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f7357d884d6aa..2d98238293a64 100644
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



