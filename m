Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DAA242D73;
	Tue, 20 May 2025 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750501; cv=none; b=mI00pm3onDId7rUTdniyKXb5KcpM6gTcfr7ZNm+0akEfX4osxg42cu/phVuXM5VMegCUxuOBhybkmb41J1MgJmophV7kmoviVt2Wt0nK7JoGzqsD/hFRzWCXCkeL3A/Zq4g3m8SGNA3F+VwkrreWxAv1JFh+aPJ2tNMFOeUCtX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750501; c=relaxed/simple;
	bh=wif6lSBP6qvGIoBTfFp1Cl7oKKuOIUfJTOcmcE/A7hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RkWEMpYI/CTD18f+DCVZuc0qVqUFCTIW76pAkPUeKIoiAxtPCI9ewWBCK4yUdRog9PTOjRFlHujnBmEWlXbW1BxoudOEhMSgd6dLHy3yfYEEk1YtBQIghNQDsSugcVEoyFsY/HZqUddHRoaDSd4ZvJexE/5JAfkgN3fwST6EZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szlpVEdU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szlpVEdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F63C4CEE9;
	Tue, 20 May 2025 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750501;
	bh=wif6lSBP6qvGIoBTfFp1Cl7oKKuOIUfJTOcmcE/A7hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szlpVEdUnwqeHAaolinmr9tgKd88JtAO7CdR4ymw9K0wHJH3Oh+rU8myHbK1Tfmz3
	 biRoFijuYdCYrLhQ0uw+E0DIQyevt6GZQVyFFug+3bSt85CmM7xi5hffZO8+eu5qNM
	 MSFI42iW46BYRlMC3yRzZ2LqJ82y+aFFui8CDXP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 011/145] platform/x86: asus-wmi: Fix wlan_ctrl_by_user detection
Date: Tue, 20 May 2025 15:49:41 +0200
Message-ID: <20250520125810.988813961@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 38ef778e8c19b..f66d152e265da 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4777,7 +4777,8 @@ static int asus_wmi_add(struct platform_device *pdev)
 		goto fail_leds;
 
 	asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_WLAN, &result);
-	if (result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
+	if ((result & (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT)) ==
+	    (ASUS_WMI_DSTS_PRESENCE_BIT | ASUS_WMI_DSTS_USER_BIT))
 		asus->driver->wlan_ctrl_by_user = 1;
 
 	if (!(asus->driver->wlan_ctrl_by_user && ashs_present())) {
-- 
2.39.5



