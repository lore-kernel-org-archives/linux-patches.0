Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8451A4F12;
	Mon,  2 Jun 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875277; cv=none; b=SMCKD8bW/7+jH5ppvWQCAaNdV33FygY61juMm9NB0lwRM0eEQt6aBHqrgJzXVed5nfAvpu0Rb7sAtIoMc0HvJncDn167Mejsa1H9dDhWwBO6CeJplW6E/dHbYPY3HOhv0EhgL527fEANxXoO1LYaBhbal56eDYiJlADru8tUVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875277; c=relaxed/simple;
	bh=QzquY8Ful8g/xrjvtrIp1X9r/PffqK2x34QSbhe3Y+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPxuh+HCyglUEITr18xJxv+UxpSX239qhe30irb0RNSZjPXtLtXBNENnUSmsea8ASSSvKn14RWe8okjczfnB6SS/E7VgIgLtBvYHmBgtJGYfFwpgNRkIwWDyJpgh9708+s/Em1A9Smw++8xsR3DfDHo3i3SvNKIJ1OQAdaud7mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQZToL3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQZToL3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E98FC4CEEB;
	Mon,  2 Jun 2025 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875276;
	bh=QzquY8Ful8g/xrjvtrIp1X9r/PffqK2x34QSbhe3Y+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQZToL3mkVCRgpRDYnd3TMqEY1KaaW9WT/SoXX2fFCgGWiAKj3cAtb3UzlYr6kn9Z
	 FgWngL1R1cMbDTdCUxMkqHQUonIOjpIfnwMw1XTAfaG0b9lxcEbcA1c+2nzMskuKt9
	 egXPLe5bMrXN275uX/i8N6I2fYkpqDUjELHs3Ufc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/270] platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection
Date: Mon,  2 Jun 2025 15:46:08 +0200
Message-ID: <20250602134310.564937354@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bfcfe6d335a967f8ea0c1980960e6f0205b5de6e ]

The wlan_ctrl_by_user detection was introduced by commit a50bd128f28c
("asus-wmi: record wlan status while controlled by userapp").

Quoting from that commit's commit message:

"""
When you call WMIMethod(DSTS, 0x00010011) to get WLAN status, it may return

(1) 0x00050001 (On)
(2) 0x00050000 (Off)
(3) 0x00030001 (On)
(4) 0x00030000 (Off)
(5) 0x00000002 (Unknown)

(1), (2) means that the model has hardware GPIO for WLAN, you can call
WMIMethod(DEVS, 0x00010011, 1 or 0) to turn WLAN on/off.
(3), (4) means that the model doesn’t have hardware GPIO, you need to use
API or driver library to turn WLAN on/off, and call
WMIMethod(DEVS, 0x00010012, 1 or 0) to set WLAN LED status.
After you set WLAN LED status, you can see the WLAN status is changed with
WMIMethod(DSTS, 0x00010011). Because the status is recorded lastly
(ex: Windows), you can use it for synchronization.
(5) means that the model doesn’t have WLAN device.

WLAN is the ONLY special case with upper rule.
"""

The wlan_ctrl_by_user flag should be set on 0x0003000? ((3), (4) above)
return values, but the flag mistakenly also gets set on laptops with
0x0005000? ((1), (2)) return values. This is causing rfkill problems on
laptops where 0x0005000? is returned.

Fix the check to only set the wlan_ctrl_by_user flag for 0x0003000?
return values.

Fixes: a50bd128f28c ("asus-wmi: record wlan status while controlled by userapp")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219786
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20250501131702.103360-2-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 9316564947682..265232d1b9a86 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2739,7 +2739,8 @@ static int asus_wmi_add(struct platform_device *pdev)
 		goto fail_leds;
 
 	asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_WLAN, &result);
-	if (result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
+	if ((result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT)) ==
+	    (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
 		asus->driver->wlan_ctrl_by_user = 1;
 
 	if (!(asus->driver->wlan_ctrl_by_user && ashs_present())) {
-- 
2.39.5



