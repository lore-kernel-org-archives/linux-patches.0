Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8235432D42B;
	Sat, 30 May 2026 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160870; cv=none; b=FSBv9AmGawfGijUexsVPgUjuIi8ALVeWorDGs11R6l2IVJg2gVaJa3ZBrJ7x0RlPy7iHrVxM0y+3ckfoXN8knn41oG+btLFmQ+IbPVBJnX2YYd6Xx6UTclbchBDWOfmiXStH4G5Xd3ZuRbtnKHPlcFBmcCcb1jdTmkkOrgewUgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160870; c=relaxed/simple;
	bh=yXIDfW27hLZbd/ZqxpwucJVBA6uX9egfZlHF7ykCvIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8MfE8HScGmbzEdFcUCTqq7z2K4h9d/bnuM23wupUGyGzuUQ77oHnNXVaPFWCG0UsD83iGQ9MbdzEQUSKxxC6dtAhLE5gHKuhxHlaajGK4LXFBpJD4vc+LQ+vMLZflkGd/T857JJUGw66ZLizD7Ja4qVS1ulnV6nHoMGM5gqaZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrNG5lcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrNG5lcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25901F00893;
	Sat, 30 May 2026 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160869;
	bh=dhfTgCkQ7q1zMK4X0xCjiD/lyumvKtzP5PAhKu3nE2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrNG5lcxhCrnBhZorVNOFnEoV7f5o38VP2D0AFfO+H3RHLeoi8YMxkJ6w4MKO1vpv
	 0H1OuK4SP/sQuuwteAJBG6fBUux9DW1W6VSQSR/L6eatnX2Vart3xF4KRYVK2IqqfI
	 nLGnZasFfXVhl6kyREIU5Sp8RjM/HgJWyPP6Ng5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 458/969] wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()
Date: Sat, 30 May 2026 17:59:42 +0200
Message-ID: <20260530160312.929372753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 047cddf88c611e616d49a00311d4722e46286234 ]

In the rtw89_phy_cfo_set_crystal_cap() function, for chips other than
RTL8852A/RTL8851B, the values read by rtw89_mac_read_xtal_si() are
stored into the local variables sc_xi_val and sc_xo_val. If either
read fails, these variables remain uninitialized, they are later
used to update cfo->crystal_cap and in debug print statements. This
can lead to undefined behavior.

Fix the issue by initializing sc_xi_val and sc_xo_val to zero,
like is implemented in vendor driver.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8379fa611536 ("rtw89: 8852c: add write/read crystal function in CFO tracking")
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260323140613.1615574-1-a.velichayshiy@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index f6647f9d23939..980b8079bc707 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -2148,7 +2148,7 @@ static void rtw89_phy_cfo_set_crystal_cap(struct rtw89_dev *rtwdev,
 {
 	struct rtw89_cfo_tracking_info *cfo = &rtwdev->cfo_tracking;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
-	u8 sc_xi_val, sc_xo_val;
+	u8 sc_xi_val = 0, sc_xo_val = 0;
 
 	if (!force && cfo->crystal_cap == crystal_cap)
 		return;
-- 
2.53.0



