Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E91A619E;
	Tue, 30 Jul 2024 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357168; cv=none; b=jZzyJr2aTS/Ozbj0qisgXWG8pmm/3bMZJcsDi+GfAuEV6MgV92LWaCjncD0gWkP38fqREIKWzxnydj6897IEWhOw0Vwh+r/FXD9bFSoHNQfnX3xg70XgBhVJ1fva3ajr0fa3erDw3oJ6tXzHTi4i61VDF1eOFZ3IOoB/GMXwMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357168; c=relaxed/simple;
	bh=vIwZvFOsCeSBw44X6za6+aqUXvCgUlW7vCumqSYmr5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qOtFTH5pmdCc5DAEe4y4fxBKMQDixebC9sVUiccirZ31nfbzl58w0ZAwsOulJOQ0ga5A1YUQt7lnMd+IZ30DebjLqxEFD8IRR8W6zu43RlmOP4qIW/vPDmxcz/MBPTgyVk+yXzGA3e25BCZedF3Diwhe+5LX67SHvJm5F/qeBiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJ6kHD94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJ6kHD94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26F1C32782;
	Tue, 30 Jul 2024 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357168;
	bh=vIwZvFOsCeSBw44X6za6+aqUXvCgUlW7vCumqSYmr5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJ6kHD94RbhCqAJ9te/qGixSToXz4rzaGdUWqouEfPyoP+TB9gZNSvcotGr20ebjR
	 kUFYdhkw9zBEakWuKTGrU/qzYsPJtwQPKHDizPG6EnW01zwzSJDkGC1MBPw5eSYqX3
	 1wxnOwMDGvuh+0uz+S+u5Gq5gm7QrBtiQSFssEFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 229/809] wifi: rtw89: Fix array index mistake in rtw89_sta_info_get_iter()
Date: Tue, 30 Jul 2024 17:41:45 +0200
Message-ID: <20240730151733.653617789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index affffc4092ba3..5b4077c9fd286 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -3531,7 +3531,7 @@ static void rtw89_sta_info_get_iter(void *data, struct ieee80211_sta *sta)
 	case RX_ENC_HE:
 		seq_printf(m, "HE %dSS MCS-%d GI:%s", status->nss, status->rate_idx,
 			   status->he_gi <= NL80211_RATE_INFO_HE_GI_3_2 ?
-			   he_gi_str[rate->he_gi] : "N/A");
+			   he_gi_str[status->he_gi] : "N/A");
 		break;
 	case RX_ENC_EHT:
 		seq_printf(m, "EHT %dSS MCS-%d GI:%s", status->nss, status->rate_idx,
-- 
2.43.0



