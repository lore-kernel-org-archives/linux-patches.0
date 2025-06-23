Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94848252906;
	Mon, 23 Jun 2025 13:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684784; cv=none; b=KEHOOpsHcyXw+Dxw3joibpEK3Gsv+59FAIW2bHxI+qeck2BQWs56l0TgEaCkHCtZBHwAJX+62GRwxXXrVIiy6BRGnPsWfLwyoVfaZdl24mhFzrVaovVjFqZa4OB+NfQsHJpMMSTwEJthdxhIQkl0vQiOgTzK+oZor4h6LnyMZPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684784; c=relaxed/simple;
	bh=G8qIyFR45xZRLon4zjj6so7QARSXy+iNlF/N6SZ//qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hALdz/o1N+80gchTuQ8eTabmBGvqXLJJdIvOKVPnev8OropdMwP1fgxq1Q10ryvAfqLjxk9vKF8jWU4OzNNhUp+1us7kx4iHvgmq7tSofyAJMfZwvFw4qpjPtEd+67GbROZRAosC1Da5faG/jZBNvV9S7OgAN/jwx2Yslj+kARg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTTcWlLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTTcWlLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A59C4CEF0;
	Mon, 23 Jun 2025 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684784;
	bh=G8qIyFR45xZRLon4zjj6so7QARSXy+iNlF/N6SZ//qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTTcWlLrfoQQYzICNvocO7cOXElR978QxqI9cYlpV4alGjUXliJgYFtyFYaFgjYvW
	 7p2GmFK3dSeQeFsOe5sbRK0FACtQW/3xCGvSO+uIa8hUCbR5QuWb/GoukL7D1R1QjS
	 xsxDBzwme1aU7MiPHsrNWhQMc38lrOLoYnPIoBzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/222] wifi: rtw88: do not ignore hardware read error during DPK
Date: Mon, 23 Jun 2025 15:06:03 +0200
Message-ID: <20250623130612.743008530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 72d711a62b07b..0cc8d507165af 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -2857,7 +2857,8 @@ void rtw8822c_dpk_cal_coef1(struct rtw_dev *rtwdev)
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001148);
 	rtw_write32(rtwdev, REG_NCTL0, 0x00001149);
 
-	check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55);
+	if (!check_hw_ready(rtwdev, 0x2d9c, MASKBYTE0, 0x55))
+		rtw_warn(rtwdev, "DPK stuck, performance may be suboptimal");
 
 	rtw_write8(rtwdev, 0x1b10, 0x0);
 	rtw_write32_mask(rtwdev, REG_NCTL0, BIT_SUBPAGE, 0x0000000c);
-- 
2.39.5



