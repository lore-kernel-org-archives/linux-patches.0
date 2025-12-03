Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E45330B3E;
	Wed,  3 Dec 2025 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777147; cv=none; b=gY54E5i/OH9lK2PkzlupClq/TrTE6UP6wAL0IiEjNEafCq8Ww3pD5ZsX8SrlLthgp7aPXzbDEAhBdAYAxPl56JuoriON9Z8kdK36R9hL0yUUGEyiPM4Q1nVsyTiQQ59tx4izO4X1idSiFbKHacz2+1HW/p8pfGyrL8eXF0ACbLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777147; c=relaxed/simple;
	bh=TbzA0ruhYb9VMERzG/iTko1QfygU8FiA4aLImsSagDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgdyyixbFnbKMn3dyBz+G2wLhMjmYsr/UgT3y+rMZq5LdRpDZPCW3A8io1iIbp7wScMovgHOvkZZ6bkPVjpoADGERdRWWF3qGkwSw8nEk6rpbu/xPHikSDSIbLW9SYKZPBLielOozobwIxC4yzu2ysHaAJdblTly6Q6nrTQ75jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVceDS3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVceDS3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEE0C4CEF5;
	Wed,  3 Dec 2025 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777147;
	bh=TbzA0ruhYb9VMERzG/iTko1QfygU8FiA4aLImsSagDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVceDS3wh5LhXSgWGMC3TLsjvqQFVodwfN4cPOCDQy8wnGrXjO4nrho1VlGvCmD7q
	 I7q1arF8iIYuAEzXjq0SuP5J+BOjdvF1bTtETjpErUf3R1EQ9BsgHp9FNtmoC6MMYP
	 lxa2W5l9BMIbAxevv6DBzpPXGToGcS0z/iMZZcy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Baltieri <fabio.baltieri@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 096/146] r8169: fix RTL8127 hang on suspend/shutdown
Date: Wed,  3 Dec 2025 16:27:54 +0100
Message-ID: <20251203152349.973679195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit ae1737e7339b513f8c2fc21b500a0fc215d155c3 upstream.

There have been reports that RTL8127 hangs on suspend and shutdown,
partially disappearing from lspci until power-cycling.
According to Realtek disabling PLL's when switching to D3 should be
avoided on that chip version. Fix this by aligning disabling PLL's
with the vendor drivers, what in addition results in PLL's not being
disabled when switching to D3hot on other chip versions.

Fixes: f24f7b2f3af9 ("r8169: add support for RTL8127A")
Tested-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/d7faae7e-66bc-404a-a432-3a496600575f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d18734fe12e4..853aabedb128 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1514,11 +1514,20 @@ static enum rtl_dash_type rtl_get_dash_type(struct rtl8169_private *tp)
 
 static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
 {
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_25 &&
-	    tp->mac_version != RTL_GIGA_MAC_VER_28 &&
-	    tp->mac_version != RTL_GIGA_MAC_VER_31 &&
-	    tp->mac_version != RTL_GIGA_MAC_VER_38)
-		r8169_mod_reg8_cond(tp, PMCH, D3_NO_PLL_DOWN, !enable);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_24:
+	case RTL_GIGA_MAC_VER_28:
+	case RTL_GIGA_MAC_VER_31:
+	case RTL_GIGA_MAC_VER_38:
+		break;
+	case RTL_GIGA_MAC_VER_80:
+		r8169_mod_reg8_cond(tp, PMCH, D3_NO_PLL_DOWN, true);
+		break;
+	default:
+		r8169_mod_reg8_cond(tp, PMCH, D3HOT_NO_PLL_DOWN, true);
+		r8169_mod_reg8_cond(tp, PMCH, D3COLD_NO_PLL_DOWN, !enable);
+		break;
+	}
 }
 
 static void rtl_reset_packet_filter(struct rtl8169_private *tp)
-- 
2.52.0



