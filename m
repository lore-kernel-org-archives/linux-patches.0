Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB09E20A5EE;
	Thu, 12 Dec 2024 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024718; cv=none; b=qHI/Tgcf0nx/aLP7h/Mgz+Tupe55in6sUWZf0hFk1XvC0OppTYgryGEuZvioZ5d2Yg9Th+t16VMWDMq/t/E5YD/7WJV/7dWGcQZ+mP1CZHV9fXXw6clALyqFr7NVbQzrMhKBhrzb3FGRf8nv+f82dY8xjGlHIBkM2iDSfS7+Quw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024718; c=relaxed/simple;
	bh=q2LBRjYnhkgy3h0Dbew9A1r/fufdJiEDNiLmXLZH4W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CniXeMn/+3qKozKtz5GaVBJyHxsLxca0oEOXEJiiMLksWf/oOm2Dk7xSie9uKg7tFQXfCb3Mph9QQLKHXDqFugL7J8z7LbovRcLlWR7/SrTZfRpG11hjODEFwoGwrseLfVuqYh4UGD/s5DPBEy40BJb2RUfLXYuo+0oK3Hs3QvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5XKnNhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5XKnNhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E22C4CECE;
	Thu, 12 Dec 2024 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024717;
	bh=q2LBRjYnhkgy3h0Dbew9A1r/fufdJiEDNiLmXLZH4W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5XKnNhcxPw6vFlTA0WTPCbr+MOTYyV200Ip3Bi/bLdTbRX/cvKdMicb4amrVQCdz
	 D8FpPIJvQ3hxSIrJBFfls68ZmKqmBTQhR+G0JoyNzoJuqk9h1ZT9TFlYVEgNeKB4uh
	 j87F36NKyL0Xp1TyPcN7PmLqQd5jGOkOLzt+jF9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 389/459] r8169: dont apply UDP padding quirk on RTL8126A
Date: Thu, 12 Dec 2024 16:02:07 +0100
Message-ID: <20241212144309.135366313@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3aa1dda3406cd..b60add52f4497 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4155,8 +4155,8 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
 {
 	unsigned int padto = 0, len = skb->len;
 
-	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
-	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
+	if (len < 128 + RTL_MIN_PATCH_LEN && rtl_skb_is_udp(skb) &&
+	    skb_transport_header_was_set(skb)) {
 		unsigned int trans_data_len = skb_tail_pointer(skb) -
 					      skb_transport_header(skb);
 
@@ -4180,9 +4180,15 @@ static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
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



