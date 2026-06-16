Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB147AF5F;
	Tue, 16 Jun 2026 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631748; cv=none; b=Z9wMlVg5PJVRESxugzAOzw2y28E0PO3VL9xSywG5jBDNQ2G8a9XR6nAm8wwlR4IqnQHHtSIhN6PDZw/UpB3KPaGddmURsSXrnJOGD88AeikWNjI6YIHfsipluKL3yLNU5LuWpuF7SMUc86kVmKT23CNDs7WcEH3ifhlj/V1LAbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631748; c=relaxed/simple;
	bh=UFwP3mlYe1ZYNbbDf6a6wz9hfA5o1Co8GdZ+TbT5gdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZecwmKBUAmmih12ZUCK1ABebanwSpUlsJjfVZjnW+kZgPqfYnuut4yywMiu9plqoJ3/RDY2LPqPvzmp+IjC7hshqNPLAgAPKyrPnlQK4Q0PpVaPSSsGPizdqTW3IqdnNjmTiIqNZFTWHPvf1Yj2Ee532FiF2BNGOQ0UsElGYEgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ii4zhIzB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ii4zhIzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35A11F000E9;
	Tue, 16 Jun 2026 17:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631746;
	bh=62LwnqkX0doEhsLMBHZA58g8AkVU/jvVpMTjBREpz50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ii4zhIzBXkVALmAVAV/COXhg+I+c9Vs+lB6Ze2CcBbYbnrnx6AjevZMv+PRhti45U
	 j3Eb5fsGUTmgnrIJb16Gm4w2g8uI4JEuejql11cqM68GHFrDRsQJnmvBX2d6FFlYNx
	 4UEbO7ckWl+SuCUiDz8p6bxzKKYk0glsK/EFl6OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/522] r8152: reduce the control transfer of rtl8152_get_version()
Date: Tue, 16 Jun 2026 20:26:35 +0530
Message-ID: <20260616145137.578229688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 02767440e1dda9861a11ca1dbe0f19a760b1d5c2 ]

Reduce the control transfer by moving calling rtl8152_get_version() in
rtl8152_probe(). This could prevent from calling rtl8152_get_version()
for unnecessary situations. For example, after setting config #2 for the
device, there are two interfaces and rtl8152_probe() may be called
twice. However, we don't need to call rtl8152_get_version() for this
situation.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 19440600e729 ("r8152: handle the return value of usb_reset_device()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 98e30291b0500b..f730f6a797e767 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9640,20 +9640,21 @@ static int rtl8152_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 version = rtl8152_get_version(intf);
 	struct r8152 *tp;
 	struct net_device *netdev;
+	u8 version;
 	int ret;
 
-	if (version == RTL_VER_UNKNOWN)
-		return -ENODEV;
-
 	if (intf->cur_altsetting->desc.bInterfaceClass != USB_CLASS_VENDOR_SPEC)
 		return -ENODEV;
 
 	if (!rtl_check_vendor_ok(intf))
 		return -ENODEV;
 
+	version = rtl8152_get_version(intf);
+	if (version == RTL_VER_UNKNOWN)
+		return -ENODEV;
+
 	usb_reset_device(udev);
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
-- 
2.53.0



