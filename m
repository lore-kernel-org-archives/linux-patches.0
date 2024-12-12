Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89842AF0E;
	Thu, 12 Dec 2024 15:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016719; cv=none; b=bU6jAsSdv9bVOhj/jszW8WKMVO0tVfgRuOn3OiU9JEcjAknDrb3W7sLvaQMDUF50NAMhdLZsi2A/wzzLwGm8AjKBFDr4HHSLkyJPELrHESAGOfdSl8mlQQjxTYmX0dpOw0sN7+X/LSWgXQ2BQZDVcCcpd9/wvMFwOGDFQxznrPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016719; c=relaxed/simple;
	bh=SZQARzJnAXEy/6ArTDB/0VCR3HNz+kxV+qtR0nDoLTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv9+6aNfeI9WXQGb4W0/TNFaO+txkB4Uf2noO71Z0QzEG8iF1/JGOZe7B400g42qLHs093RLMqJ5oLOHi0USmrBRJzArhjyW1TBcGlvZpMYrwsTJ0mX9w3CEhdVrQMWR4JmdtdCWC4z/oKNoSlFL4uFdicBeicuBLbKdF+ld4bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNPwQRz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNPwQRz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1013C4CECE;
	Thu, 12 Dec 2024 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016719;
	bh=SZQARzJnAXEy/6ArTDB/0VCR3HNz+kxV+qtR0nDoLTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNPwQRz2zFJsAMo507cho5yrzLPRG+zRM156w4Spchc0xMa4h4+qfsra6rQsVqQ37
	 d0dJwknvxOi8Wc4gXS8jfKTqL3NY7OFJGmaqw7mqNZQHX7M4wYJnuCH2COn81yg6x1
	 eb3+IhPpyoByNM00B/uyTPfYh52uCjCYyqxgOPJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/466] r8169: dont apply UDP padding quirk on RTL8126A
Date: Thu, 12 Dec 2024 15:57:28 +0100
Message-ID: <20241212144317.806968768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 713a89bb21e93..5ed2818bac257 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4233,8 +4233,8 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
 {
 	unsigned int padto = 0, len = skb->len;
 
-	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
-	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
+	if (len < 128 + RTL_MIN_PATCH_LEN && rtl_skb_is_udp(skb) &&
+	    skb_transport_header_was_set(skb)) {
 		unsigned int trans_data_len = skb_tail_pointer(skb) -
 					      skb_transport_header(skb);
 
@@ -4258,9 +4258,15 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
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



