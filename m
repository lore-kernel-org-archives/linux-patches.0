Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2118307D;
	Wed,  3 Jul 2024 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004837; cv=none; b=BX1kNNIVKTlx99HCmxD5aeZa4/+7s6mc/y4mr9VYhLKIuJyzOrKoLybWe1fX7vJWuxB8FsCeOMHqeyjLxZudCSOfxMGHvgr/TkLyjaPtxukRAPA4cc+vyE4XkIn1zc5udCrcSk4EufZk9agUFnF3UagV00XG06P5jBARxrAaSGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004837; c=relaxed/simple;
	bh=InpOw+QoC6zi4C6S7rhdSO6HfQPnUfy0q+8bIgo2GFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWzwTX9FC8LWTBQCp21ZbX0ZM0nQdQPoP2AM2+uf/wN5ao+/rOQPPadShvtssttnzOT1cRZ1AL+rK8zOtwPFeAwAjjA8KNVI1k2nRscQv5kKanKGv5iITriSLgMOVsctI5/ePIWrFsQn04D+1gvsk+q3BQ+q8D0EOY+60Jpmqqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRSs7Ijp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRSs7Ijp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA4AC2BD10;
	Wed,  3 Jul 2024 11:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004837;
	bh=InpOw+QoC6zi4C6S7rhdSO6HfQPnUfy0q+8bIgo2GFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRSs7IjpptMAVnZlx5mktkXcu+apT39naywc4IVWcleIllDY6MBg1Pn1o/75ksW/w
	 7U7ckWlpS9bWfPMHYHKZqtLsmgbilcE6F89Nl2IotimABQVybBBMMa7/HiGclip5hE
	 kVShueToiHjExuyZBypGp/5CwePy7Hi0VyypsPf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/290] wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power
Date: Wed,  3 Jul 2024 12:39:16 +0200
Message-ID: <20240703102910.784034594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit de4d4be4fa64ed7b4aa1c613061015bd8fa98b24 ]

Different channels have different TX power settings. rtl8192de is using
the TX power setting from the wrong channel in the 5 GHz band because
_rtl92c_phy_get_rightchnlplace expects an array which includes all the
channel numbers, but it's using an array which includes only the 5 GHz
channel numbers.

Use the array channel_all (defined in rtl8192de/phy.c) instead of
the incorrect channel5g (defined in core.c).

Tested only with rtl8192du, which will use the same TX power code.

Cc: stable@vger.kernel.org
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/c7653517-cf88-4f57-b79a-8edb0a8b32f0@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index da9acebbe237a..ffe6d243c7649 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -892,8 +892,8 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
-			if (channel5g[place] == chnl) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
+			if (channel_all[place] == chnl) {
 				place++;
 				break;
 			}
-- 
2.43.0



