Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C275F1EE019;
	Mon, 23 Jun 2025 21:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712807; cv=none; b=D4Sfw6vInR9Y14OpUZkJRytvt7PZdxSMi0UmNggRHn0RD3YKfb8NJh0K7lPG32HwXQLdccYAbAanaiuD74zJ0Qbq+axiY9BUvk3+/nQxM500w/8+ELq3bckEgqqM40j35gNEQ2AYBnSSJHk50GCYDx/LBmDsgvF/hpxg92goYsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712807; c=relaxed/simple;
	bh=HyN59UinQvZSEG6xkZ9NcJfA1zvoDpFADlg/K7h93ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSzkvsMTbGsJKfFzZktoImj8vzkBaAKo0LNYB42xLhQMVQ5X3bVYsBnK2muDd8AxuBSbllNlNmgG/thlST6pvxyeCJJTINRDWIQyGg7fNpVhweuJ24nDL3JcGPmicwSnRYdlpKwQ9+pQ8JFv+1xr7Tj9xK9wprkOd9fih5wnq7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWEFPp7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWEFPp7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF48C4CEEA;
	Mon, 23 Jun 2025 21:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712807;
	bh=HyN59UinQvZSEG6xkZ9NcJfA1zvoDpFADlg/K7h93ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWEFPp7+vGAM/uENac/CfB/bKYM5Ky4QBnLdZqSGljmrbQXa8IBq4s6Djkk6OC/M9
	 ylo2P8GOVTrou1zaFgklj28zDJbwEikTf5pknYon2X8F1EBNDrLTQCNsVdMxKGYnih
	 iR53CHLUUh1seGg8Z0rmM9A/8m9W7nPLDpbyHlY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/508] wifi: rtw88: do not ignore hardware read error during DPK
Date: Mon, 23 Jun 2025 15:01:46 +0200
Message-ID: <20250623130646.743626961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 20d3c19bd8f9b498173c198eadf54580c8caa336 ]

In 'rtw8822c_dpk_cal_coef1()', do not ignore error returned
by 'check_hw_ready()' but issue a warning to denote possible
DPK issue. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 5227c2ee453d ("rtw88: 8822c: add SW DPK support")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250415090720.194048-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index c6dacfde92005..d1b9031536496 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3973,7 +3973,8 @@ static void rtw8822c_dpk_cal_coef1(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001148);
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001149);
 
-	check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55);
+	if (!check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55))
+		rtw_warn(rtwdev, "DPK stuck, performance may be suboptimal");
 
 	rtw_write8(rtwdev, 0x1b10, 0x0);
 	rtw_write32_mask(rtwdev, REG_NCTL0, BIT_SUBPAGE, 0x0000000c);
-- 
2.39.5



