Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D791359FAC;
	Fri,  9 Jan 2026 12:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962456; cv=none; b=n36gyj9sT7O8L3aFm5z1eXvPtRMH0sfzHnP4yyUY3r5n97rBfgqyVIawAvxb8Gm/E8F0qP6aiXVcwEnHumr5VK0nGKp+qKEsWFvEUARvCKjowxp8Rpj4u9I/0spuPR6GiMmNWSfo7I5YylO4rzpjJPGFs1b5ZuBPELKRYqk59W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962456; c=relaxed/simple;
	bh=m9sP8eXpZW5fntpkDbnFhpWJ3M/JL1mI5rXWor4nSGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PL0V5PG7PMHvDgTy2po0MH8DF6BsSE2xQhaWFpp9SIoBJM8XLH1I2UW6slnMDxjsTeYV4XAnyumb4hstOgeUMutoOVcIyEQhUp+sqy5t9gHa8S7JCcUxOq2/JaNEdc44kyX/B1ul7HFyEbN8IDvQnI1bAFuO7bSpLnDwXvzXI5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAzQXxaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAzQXxaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7F5C4CEF1;
	Fri,  9 Jan 2026 12:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962456;
	bh=m9sP8eXpZW5fntpkDbnFhpWJ3M/JL1mI5rXWor4nSGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAzQXxaJQ7wAIyPW4mSxtHGehVDb0tRzDEbyqj4ujudNAqspsIFe12WjwfbDmT7hk
	 4U4tDEhMnrhsDhLH1IwmVim315jvwQaQHZwU6lnudzDWWYR+xPx4VfhcfY5qIK+dUL
	 VcugMKDHDFYwqWcF4ZUEXCc12zwMjQiYdwZDoR/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 371/634] r8169: fix RTL8117 Wake-on-Lan in DASH mode
Date: Fri,  9 Jan 2026 12:40:49 +0100
Message-ID: <20260109112131.490799302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2565,9 +2565,6 @@ static void rtl_wol_enable_rx(struct rtl
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
-	if (tp->dash_enabled)
-		return;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_33)
 		rtl_ephy_write(tp, 0x19, 0xff64);
@@ -4752,7 +4749,7 @@ static void rtl8169_down(struct rtl8169_
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 
-	if (tp->dash_type != RTL_DASH_NONE)
+	if (tp->dash_type != RTL_DASH_NONE && !tp->saved_wolopts)
 		rtl8168_driver_stop(tp);
 }
 


