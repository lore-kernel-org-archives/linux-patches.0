Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C03235358;
	Sat, 12 Sep 2026 07:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198190; cv=none; b=oeWR7Sif8bmmfY6k0DlUx2douM7TP3uKWML5DvIILtGR7gpmlPYFZ1rkkpJPcb1ZiK43zlv4h7Ys9vOXIfymS/ylZLvytRqqr3wDKsrmVsfspxQAqUndBCHKKAFW6uvRohtBDp52NirB+EmTdeAhR0tuvqvGHYHA67Ldi4B+txw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198190; c=relaxed/simple;
	bh=u0Ghql24XDvnxzldj1zPP9uYPA+qNmNwEv7ge4OQRcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9ZmzaIzhsHClJBWEHraDErxgim9ZjmjI7koELBYXwUbQK2/z7u4BKz5qWeSgINWctbElEat/rgELEdEohMG/vUd3itJKjZeiob9HE0tMDJaCCqyJKDoNL+51fWvucOGsmNW5x4u9Oddkh02PNEP0ECMs/5VsnvGD4qLMRYz7Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWQOeHjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWQOeHjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0C91F000FF;
	Sat, 12 Sep 2026 07:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198187;
	bh=jTdcncJ45TvCYwO4pEAe91EIa5BNYfYiB4uc3sRqtjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWQOeHjEXb1jrgreUWooFYaE0mt0ejjIx9/izDsYkuiRh7eADNSuiStb6MhFQ9aPZ
	 ULn8oPhm/CmOeTf9XYR5mO3ZY01i6JCr+GbWv3UT6frv0D5N2ymTtsS8RWK2h1fiK5
	 OHaNslwmFyYtFmhagrxb4L6nwrNpPG/aYSLwhWvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0330/1815] usb: mtu3: allow system suspend during active gadget connection
Date: Sat, 12 Sep 2026 08:34:40 +0200
Message-ID: <20260912065656.674213323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit e69027c25361b6044c7928715667586cc5469063 ]

When operating in gadget mode connected to a USB host, system suspend
fails with -EBUSY because active peripheral connections block suspend
entry.

Fix this by restricting the -EBUSY check to runtime autosuspend
(PMSG_IS_AUTO). For system suspend (!PMSG_IS_AUTO), perform soft
disconnect to disconnect from the bus and allow MAC sleep.

Fixes: 427c66422e14 ("usb: mtu3: support suspend/resume for device mode")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://patch.msgid.link/20260626082218.2750459-2-fshao@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index 66dbfe1705d57..a40bf5bad2d5d 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -1037,9 +1037,14 @@ int ssusb_gadget_suspend(struct ssusb_mtk *ssusb, pm_message_t msg)
 	if (!mtu->gadget_driver)
 		return 0;
 
-	if (mtu->connected)
+	/* Prevent runtime suspend when active connection exists */
+	if (mtu->connected && PMSG_IS_AUTO(msg))
 		return -EBUSY;
 
+	/* Perform soft disconnect for system suspend */
+	if (mtu->softconnect && !PMSG_IS_AUTO(msg))
+		mtu3_dev_on_off(mtu, 0);
+
 	mtu3_dev_suspend(mtu);
 	synchronize_irq(mtu->irq);
 
@@ -1055,5 +1060,9 @@ int ssusb_gadget_resume(struct ssusb_mtk *ssusb, pm_message_t msg)
 
 	mtu3_dev_resume(mtu);
 
+	/* Restore soft connect for system resume */
+	if (mtu->softconnect && !PMSG_IS_AUTO(msg))
+		mtu3_dev_on_off(mtu, 1);
+
 	return 0;
 }
-- 
2.53.0



