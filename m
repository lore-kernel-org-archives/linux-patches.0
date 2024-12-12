Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91242221D93;
	Thu, 12 Dec 2024 15:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018180; cv=none; b=O0ejdbpzzBc3SFchDt9quaE7wlF3nbVndVgxPu8hqlFK+bT6OlCrS77GIfRPerEpP5T+JB6yuw5wqc/626DRqFwuxRR6/80Kq3pzee7yao+R7U/moqR4RWp4U/Hymvw1ju+o16m520ESEs2AwiX20PaVLoL2rc4GkMasHrCj2m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018180; c=relaxed/simple;
	bh=0fSlRO3GV7lnWJ+MaHCiSBrE3kC21jq83RJurqxGbak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYFwsX9nK+XKtu8y34vI63EwDxK4J3NSVWnovZ9I+mPOLs6J/K1oPjGkoEoMOs8/oAgydLVb7xmJjZhbddmy1zsCz/pUGIEPW88hol6Nqa4NuUKdOdlgszimfWfG4itkzSPs+NSG5ZoInpChLWiTeWSLD5EJtfVnUF3uEOkk684=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjtIP3c1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjtIP3c1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB317C4CECE;
	Thu, 12 Dec 2024 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018180;
	bh=0fSlRO3GV7lnWJ+MaHCiSBrE3kC21jq83RJurqxGbak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjtIP3c1mVjCImDKDPumf+DDLYhAiQBnq9t9wS+Tr1HsgUrtZWY8a+lccp6T4R8UG
	 ysT4XN+aMf2X8eO2pS6Mn1PUWcY01db6bwX98iLnpu54NGIMZ6SA1UTaz1WAyXweEC
	 O5ccers+XGUoNjYiPHZ6VeNTkpMgGc6+yDhlV9FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/356] r8169: dont apply UDP padding quirk on RTL8126A
Date: Thu, 12 Dec 2024 15:58:58 +0100
Message-ID: <20241212144253.270378286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 87e26448dbda4523b73a894d96f0f788506d3795 ]

Vendor drivers r8125/r8126 indicate that this quirk isn't needed
any longer for RTL8126A. Mimic this in r8169.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/d1317187-aa81-4a69-b831-678436e4de62@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6856eb602f826..7e5258b2c4290 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4126,8 +4126,8 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
 {
 	unsigned int padto = 0, len = skb->len;
 
-	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
-	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
+	if (len < 128 + RTL_MIN_PATCH_LEN && rtl_skb_is_udp(skb) &&
+	    skb_transport_header_was_set(skb)) {
 		unsigned int trans_data_len = skb_tail_pointer(skb) -
 					      skb_transport_header(skb);
 
@@ -4151,9 +4151,15 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
 static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
 					   struct sk_buff *skb)
 {
-	unsigned int padto;
+	unsigned int padto = 0;
 
-	padto = rtl8125_quirk_udp_padto(tp, skb);
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_61 ... RTL_GIGA_MAC_VER_63:
+		padto = rtl8125_quirk_udp_padto(tp, skb);
+		break;
+	default:
+		break;
+	}
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
-- 
2.43.0



