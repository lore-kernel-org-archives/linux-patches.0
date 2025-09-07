Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83AB15C158;
	Sun,  7 Sep 2025 20:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277079; cv=none; b=X+Cikc/5/0AMRSVuMTntBt62URZ6PUG24DGexWVQmrOol34FMh6B7hdnJ91FUT4V3RSnoI0NHrQoVIHMSRSTTs+FzxqG3/IqJTWcEbB3oB0oWNnjM/3sm2yoN4KYkjNTaWWe+qUwyUhwnYfuZ3rd85wWe+vJvGRqUsKVMaVapWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277079; c=relaxed/simple;
	bh=B+Ii3YGmTPOTvVknve90yo3k93GiW0MBg2q2egjA200=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOwclRr9UqAH8tDKvj8O1bCMaZ0dD+cRj3w7NJRGmGBRz5FMGF+jKh07a/MAh44Qh+9gSF0S26wKTc0zp2ShD62ZoYcsxoMCRo0VJUaVsHi/t7FMSVJ2ktfO019hz37LyvbNNHttoCTdRS+wcwMfvzt4Qnz7sDhl+vR4dxtvfTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xD8znbPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xD8znbPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E80DC4CEF0;
	Sun,  7 Sep 2025 20:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277079;
	bh=B+Ii3YGmTPOTvVknve90yo3k93GiW0MBg2q2egjA200=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xD8znbPCo/gE5c4CpnEsLHrkMC2xJo+YxavX4ueJmF57aeLZoftoIJLjx/emZcTJ6
	 F3LLI0rh3M6krSTHEiFxUJcY7LHtqX0F9KtNr2oqdsqPocROP/akBukRErrrq92l1e
	 DL/cFLrf9mDIaGprsQQgtCSIzWnOKcer1V6MM0mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/175] wifi: cw1200: cap SSID length in cw1200_do_join()
Date: Sun,  7 Sep 2025 21:57:52 +0200
Message-ID: <20250907195616.657276479@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f8f15f6742b8874e59c9c715d0af3474608310ad ]

If the ssidie[1] length is more that 32 it leads to memory corruption.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/e91fb43fcedc4893b604dfb973131661510901a7.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index c259da8161e4d..2bce867dd4acf 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1290,7 +1290,7 @@ static void cw1200_do_join(struct cw1200_common *priv)
 		rcu_read_lock();
 		ssidie = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
 		if (ssidie) {
-			join.ssid_len = ssidie[1];
+			join.ssid_len = min(ssidie[1], IEEE80211_MAX_SSID_LEN);
 			memcpy(join.ssid, &ssidie[2], join.ssid_len);
 		}
 		rcu_read_unlock();
-- 
2.50.1



