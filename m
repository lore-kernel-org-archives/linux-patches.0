Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76413328FC;
	Mon, 29 Dec 2025 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025862; cv=none; b=Hxo4M/v6Yvnh6hDZyTpXi84bjoSJ9Iyi1H3/u7d9lKZbCTgohAUFM/wHqU9Bap2d2Gus4jBZpqQkLcVmyZ1wqNW3ToYdUmNQGFOYI+Su1jG+5iv9P4GKJRqbm+Hox9bNDHpgEjeU5anCJcqAtICJABPzoWinQ0NHaRF1uY5eWLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025862; c=relaxed/simple;
	bh=mocyFMxobc6Ox/1/D/6GgWvHJ1uP7RHUih7dOU4BGdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uTNJHeyp/df9XQHtyGipWHGpXFdTUCfplDIaab8RhDFiPt+lTMwg1zdG9frXZChl51W4rnJ87DgOS6msRJcXmnVeP1qV5YT3ZxctJA4xTfUowKgWMF9wGk6UnY+jAG4uVP31DMk8q7anpQx+dIHG2ReAhM9GjHRMxEdBPcQAM/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXUnIzka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXUnIzka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F05C4CEF7;
	Mon, 29 Dec 2025 16:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025862;
	bh=mocyFMxobc6Ox/1/D/6GgWvHJ1uP7RHUih7dOU4BGdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXUnIzkazMj/JniLMAtZT33bqLnExoRoK3j3WzIPjCz8Xe1fH/go4w2OmAmU8EGqW
	 bO9Lj644GZa7giis+P6KK0l25OAp8848oCj2kM5SlFjL2pz9q2zH1bGfyT3LIn94RL
	 +tkk3IhRPRm6MKOhea2A5C4oH6iVOAMBUMIWKFgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 363/430] r8169: fix RTL8117 Wake-on-Lan in DASH mode
Date: Mon, 29 Dec 2025 17:12:45 +0100
Message-ID: <20251229160737.688259502@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2669,9 +2669,6 @@ static void rtl_wol_enable_rx(struct rtl
 
 static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
-	if (tp->dash_enabled)
-		return;
-
 	if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
 	    tp->mac_version == RTL_GIGA_MAC_VER_33)
 		rtl_ephy_write(tp, 0x19, 0xff64);
@@ -4807,7 +4804,7 @@ static void rtl8169_down(struct rtl8169_
 	rtl_disable_exit_l1(tp);
 	rtl_prepare_power_down(tp);
 
-	if (tp->dash_type != RTL_DASH_NONE)
+	if (tp->dash_type != RTL_DASH_NONE && !tp->saved_wolopts)
 		rtl8168_driver_stop(tp);
 }
 


