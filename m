Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6141014EC4D;
	Tue,  9 Jul 2024 11:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523915; cv=none; b=kWoxpRQM/87gwvtatuYLb8eF319rXwSfTG2IkIdRiMikicrIT6YJujuxzFrRYWVwC/CY9F6Ic+70Arcj5M3djGVSM0k8j/tS/4cDNkC61J+yo6udiDMLt5LLZwYMRn6T48VPkEjMFaAJ8nj/MYiawt6e8K75j5wqJSSPsgKyAdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523915; c=relaxed/simple;
	bh=VIuloyV22y5iu5+ai3pZ6xiUPhDRxmZVcJM9e6Ek0aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ0nR+gOPKinCZbKLBKM+z5nn1PHQwMFR97npbJGsSYJjgJfuOuSaTVX1Jo6lG9GGGKG0ecuv5+3nhrbEpMrJdFZUn0Z+4kKhlpaUS7CHGwR5FLUVYVG5JhDd+nEE3wExXSk+BJiBzoBC/lVKaoF9hhZcMNWQJ+G6szzzA7gfcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwdwDCRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwdwDCRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4DDC3277B;
	Tue,  9 Jul 2024 11:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523915;
	bh=VIuloyV22y5iu5+ai3pZ6xiUPhDRxmZVcJM9e6Ek0aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwdwDCRGu1H1DRF0lPnsMeZmyN8AxBuYOjbbJ7YxM69jow9ZBnrnAdVKkjXV+XR1N
	 njkXcTN5WE22yjaKJ9Fwzlh6acNRNFn43kmS30qxyZuNe6LjWWK2ozOYw0GftgCRQ5
	 DWZUgIlFUz4sSLQ7VlLHL2roBhbPRIXQADZlmn7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 011/197] wifi: rtw89: fw: scan offload prohibit all 6 GHz channel if no 6 GHz sband
Date: Tue,  9 Jul 2024 13:07:45 +0200
Message-ID: <20240709110709.349971574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit bb38626f3f97e16e6d368a9ff6daf320f3fe31d9 ]

We have some policy via BIOS to block uses of 6 GHz. In this case, 6 GHz
sband will be NULL even if it is WiFi 7 chip. So, add NULL handling here
to avoid crash.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240412115729.8316-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 6c75ebbb21caa..ef86389545ffb 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -4646,6 +4646,10 @@ static void rtw89_scan_get_6g_disabled_chan(struct rtw89_dev *rtwdev,
 	u8 i, idx;
 
 	sband = rtwdev->hw->wiphy->bands[NL80211_BAND_6GHZ];
+	if (!sband) {
+		option->prohib_chan = U64_MAX;
+		return;
+	}
 
 	for (i = 0; i < sband->n_channels; i++) {
 		chan = &sband->channels[i];
-- 
2.43.0



