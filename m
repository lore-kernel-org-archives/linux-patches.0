Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1771183CCD;
	Tue, 30 Jul 2024 16:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355653; cv=none; b=IhI/Yes6O6HTpljKzxeH9r2MTclKn+565AhnfDMGYzMuZ56GQD7mOTuaxez8L7H9Cnzqt7pNbU0SdlgROYhFLfXXXQrIeWORWUE+QfnbYQ0dfM8XJ7fvJWayqLW/GFA+plTWmFqWpEttVtw/pKiZ4G7CMmynemkuyRWQNg1MrrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355653; c=relaxed/simple;
	bh=B2+g8UcKr+ypbJDci9XhgHZ2tS9niw/sZoS3Fy7p038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itOSJGmvPOAv1BnZtYSgMTSrvXLVotWdWcrvVrttwtFa333FTSkDs6zzTBzf9n+9qbxJakufBYAFSpuJR+22geV7vUt//VB7S1T1dAGwZ9Nqo/lzsZh7zP2EywbswEykjpRhIhI6QqX7kH90JriL07OF/pPYvrFvMY/4FMUBl7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNyt217F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNyt217F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711E7C32782;
	Tue, 30 Jul 2024 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355652;
	bh=B2+g8UcKr+ypbJDci9XhgHZ2tS9niw/sZoS3Fy7p038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNyt217F0BLIucXJYs5Gcy7iO+tfffEPPSU2V8+feb3DbaJkvv9YMkuItsHNJ7yZo
	 tOOvqxizSWXrKvZ/GmYFAv4ZqZuyXdqRVdg4LvjaNsQXBGx2I2Dr9b5nKgcheqSlpy
	 AFIGOcfztUlKauIoJaFOlyWFXdoh7fYUSXX3iOnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/440] wifi: rtw89: Fix array index mistake in rtw89_sta_info_get_iter()
Date: Tue, 30 Jul 2024 17:45:47 +0200
Message-ID: <20240730151620.345185574@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 85099c7ce4f9e64c66aa397cd9a37473637ab891 ]

In rtw89_sta_info_get_iter() 'status->he_gi' is compared to array size.
But then 'rate->he_gi' is used as array index instead of 'status->he_gi'.
This can lead to go beyond array boundaries in case of 'rate->he_gi' is
not equal to 'status->he_gi' and is bigger than array size. Looks like
"copy-paste" mistake.

Fix this mistake by replacing 'rate->he_gi' with 'status->he_gi'.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240703210510.11089-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 3a8fe60d0bb7b..0e014d6afb842 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -2386,7 +2386,7 @@ static void rtw89_sta_info_get_iter(void *data, struct ieee80211_sta *sta)
 	case RX_ENC_HE:
 		seq_printf(m, "HE %dSS MCS-%d GI:%s", status->nss, status->rate_idx,
 			   status->he_gi <= NL80211_RATE_INFO_HE_GI_3_2 ?
-			   he_gi_str[rate->he_gi] : "N/A");
+			   he_gi_str[status->he_gi] : "N/A");
 		break;
 	}
 	seq_printf(m, "\t(hw_rate=0x%x)\n", rtwsta->rx_hw_rate);
-- 
2.43.0



