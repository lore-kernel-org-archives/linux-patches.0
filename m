Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2EC3346AF;
	Fri,  9 Jan 2026 12:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960640; cv=none; b=Fb3dNDjSnBFjXAt3D21+LDzJ/3pv53HjMnHgxPPi3dG1kJ/HhP55GpjD8Inc5eTSOxfhOm7LomObAzIuIlt28j/LqnCS6EALBOvJ8YA1fTSeDDfWkarU20xDOuY/wBT4VDOACe7D2GgoaIjLyXAF8MSiGjUHJijGzN/dz87wgsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960640; c=relaxed/simple;
	bh=bnRFepEBO2WP0OmhYO+MXFyoY/NNa67tLLwjgGC/mek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dvC594Wm/VKFREaqbf4Aaahw9LUfGDl8lZpAcCxohxH6lw9T8xwgmNOncINl4c/emgtOt8Y4JmrzaMUU3f0Jei8AIhH8oECxJ++RwkVreun3CMLIu8HiAgKdXmr+vjfklHKydNFXiiutPOXivg+lMNiwy63hfF/JS2lLOg+9IEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwTnvrDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwTnvrDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C170C4CEF1;
	Fri,  9 Jan 2026 12:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960640;
	bh=bnRFepEBO2WP0OmhYO+MXFyoY/NNa67tLLwjgGC/mek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwTnvrDbDMgsHMSW2vvOB9x/H4pVZwdZw5PxU2+tJMbKoRsg4DfPuWo4KvWzFZqcQ
	 6OH77Xd/0dZDmQI1N0+e/cMgmelY6WUOcV3zyFhFpdIfu/WXbdvwX4ChT9ijgnksU2
	 NKBaqhnDCue84+iIA3C8SLSB0/XDw2N9DgOxaRVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 474/737] r8169: fix RTL8117 Wake-on-Lan in DASH mode
Date: Fri,  9 Jan 2026 12:40:13 +0100
Message-ID: <20260109112151.818194324@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: René Rebe <rene@exactco.de>

commit dd75c723ef566f7f009c047f47e0eee95fe348ab upstream.

Wake-on-Lan does currently not work for r8169 in DASH mode, e.g. the
ASUS Pro WS X570-ACE with RTL8168fp/RTL8117.

Fix by not returning early in rtl_prepare_power_down when dash_enabled.
While this fixes WoL, it still kills the OOB RTL8117 remote management
BMC connection. Fix by not calling rtl8168_driver_stop if WoL is enabled.

Fixes: 065c27c184d6 ("r8169: phy power ops")
Signed-off-by: René Rebe <rene@exactco.de>
Cc: stable@vger.kernel.org
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20251202.194137.1647877804487085954.rene@exactco.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2581,9 +2581,6 @@ static void rtl_wol_enable_rx(struct rtl
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
-	if (tp->dash_enabled)
-		return;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_33)
 		rtl_ephy_write(tp, 0x19, 0xff64);
@@ -4721,7 +4718,7 @@ static void rtl8169_down(struct rtl8169_
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 
-	if (tp->dash_type != RTL_DASH_NONE)
+	if (tp->dash_type != RTL_DASH_NONE && !tp->saved_wolopts)
 		rtl8168_driver_stop(tp);
 }
 


