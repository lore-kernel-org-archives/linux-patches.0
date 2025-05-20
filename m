Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120DD24113A;
	Tue, 20 May 2025 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749137; cv=none; b=rrIeX9hgJTGxr7NOwBPK386A87oa1HrTuCNx76pxJztdUcl3cZExT5rJbeG2C92w76mTk0d62rxc7wKgAvylFPiyGtK4EuKeqzPhqhIT5QM6WTaJ6lNVPVbdLFLQejhswzL71ZWMCCY+GFW4HsVMPp8dYBrBS4JqsNbf8cWnRt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749137; c=relaxed/simple;
	bh=31XfD1SuJdp8JAWQ6AGxuR97FuEbQeuuarJ3GZ5D07I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GvqSXM9Lx+csZCuBeCtbciXblC+CezlBz5UbwMfpUHm+J9cdqvHab0s7WUKP97598MMKjRWARUYWHGAJh22I/ok7F6syLcvOTqKg7hCOh/5mYX3jVPpOFMGcku7CLNJzCLCCVd3PhDuaiyC/wVQNRu+3tULrcpIAuAUWkjJ/kvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1whUkYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1whUkYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABD9C4CEE9;
	Tue, 20 May 2025 13:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749135;
	bh=31XfD1SuJdp8JAWQ6AGxuR97FuEbQeuuarJ3GZ5D07I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1whUkYdhPSLWF9NiUbG1DL+b5uhrZgrAMMPtC3hnV+S30i/J2Jq4WsCVFo5WuVS6
	 ypF3wTXYgWEmM2RzJTflFOVJNGFHrVIfJLKJQYUMr+xtNitpJi1XSbXCtqzK9WEAE9
	 N3xAoYOWWheMdphkvX4JmRzT+V58kswLrsmhFwEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/59] platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection
Date: Tue, 20 May 2025 15:49:52 +0200
Message-ID: <20250520125753.898302666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a34d0f53ad16f..d9933d3718129 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3052,7 +3052,8 @@ static int asus_wmi_add(struct platform_device *pdev)
 		goto fail_leds;
 
 	asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_WLAN, &result);
-	if (result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
+	if ((result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT)) ==
+	    (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
 		asus->driver->wlan_ctrl_by_user = 1;
 
 	if (!(asus->driver->wlan_ctrl_by_user && ashs_present())) {
-- 
2.39.5



