Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9ED1E87B;
	Mon, 23 Jun 2025 22:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716392; cv=none; b=cS1kziN/v9eEm3mO4unSYztgF6zYvH7TxiriU8+FPbjIizHxjrxY1XSXkmi39oahuL0SGw0wOkALReOuC7S+TesNnk63IasJATVgG85+PKtmPd0WN9A0Lc3cRGKqD1/TPpnoXcSeDX1eQ3SwDQzLTb6fgiyET3byXqyIbTG5RpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716392; c=relaxed/simple;
	bh=xLQU4+nzo/hV3WNdfTQCaz/Jgv66LEkro7RU9bR+8ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z881cY38oIabVxucgO2mDM9C37veIi3YzhXJhUL08SXK4GdiWztN1Sfb+M2newKugY31MDr+FvWq1mmYabppvHmJ8Swh+3KnUfqULlVujPOgoVT4HzeZ7vrgpsahM0H/DqNGl1hrfWkBVYwEK3Q8B8jxub/QTWT1996WyBZNcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=douem0nW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="douem0nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D630CC4CEEA;
	Mon, 23 Jun 2025 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716392;
	bh=xLQU4+nzo/hV3WNdfTQCaz/Jgv66LEkro7RU9bR+8ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=douem0nWYdJL0OSvtdPG2U3pLbKsV3bWUJUk9nZOWfGxy/fUjS8VUS5IWT0a2NnvA
	 2AVPmfOVf1nPPkiEeGd5i7qflaFV61LaliPN6GSdTUmYgK7GyvQisv3ljIDq3MWSMG
	 AP8IgixCuf3IZf2SryMByQ6g0fuZ7/l1DeyWS8nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/414] wifi: rtw89: 8922a: fix TX fail with wrong VCO setting
Date: Mon, 23 Jun 2025 15:06:25 +0200
Message-ID: <20250623130648.248785835@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 20aac091a15dc7229ef1a268253fe36bb6b2be39 ]

An incorrect Voltage Controlled Oscillator (VCO) setting
may cause Synthesizer (SYN) unlock, which may lead to a
failure in the TX authentication request.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250416081241.36138-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
index 28907df7407d5..c958d6ab24d32 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922a_rfk.c
@@ -77,11 +77,6 @@ void rtw8922a_ctl_band_ch_bw(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy,
 					     RR_CFGCH_BAND0 | RR_CFGCH_CH);
 			rf_reg[path][i] |= u32_encode_bits(central_ch, RR_CFGCH_CH);
 
-			if (band == RTW89_BAND_2G)
-				rtw89_write_rf(rtwdev, path, RR_SMD, RR_VCO2, 0x0);
-			else
-				rtw89_write_rf(rtwdev, path, RR_SMD, RR_VCO2, 0x1);
-
 			switch (band) {
 			case RTW89_BAND_2G:
 			default:
-- 
2.39.5



