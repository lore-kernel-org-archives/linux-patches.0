Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8971D016E;
	Wed,  2 Oct 2024 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877442; cv=none; b=LAcMKFXO8sQl77iAfMNOV8SVIjn7Y5Db4Ow4whMDfH95e8Uu1ZWB78clq/kkII9vyl3vx6YV3FucQZ3QZZNIdfgMCI3q/HGHGMxlnsN9aZxHuOWUxJ25lEg7JxXDVfqgWQzvVcpYfDF1vJDdHTCh20vEMTdF+rT3Osqu5SOBFuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877442; c=relaxed/simple;
	bh=t0zQRryQr7lV7gX/QMwkBBlLytaOsjqQ/oTO5YXL+/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfmHaM7aIooHeRyAO+aTx3g8MT/NllXpDev8jgssjWb0df3uPVmx4grafTCxOvBC4gH+P/d8Fsm1w8VYThA+r+NpauR6xjzX1tG8hRSM8SqwpIzxF867joCTbcaLqI04VMNU1tE/2T1K1zTVzm4JGADa+UVoOjlPU0AIRMbeJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zs86X5Vb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zs86X5Vb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F9C4CECF;
	Wed,  2 Oct 2024 13:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877441;
	bh=t0zQRryQr7lV7gX/QMwkBBlLytaOsjqQ/oTO5YXL+/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs86X5VbYNCeRIW0luPCrYVNB8ikxyKpHHrscgc4uybMYVcNzPzEDflb4dLUBNjMD
	 Qik1VCzzMv+aA+0A12EfmN6EPozk+FYaD50HP/9vs4pvcXYiK2FOJPP6kk1BxCIcsr
	 tADhIykzRIVs7VKlH1QMTmCItAiwqKtXPpjmCJKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 080/634] wifi: mt76: mt7915: fix rx filter setting for bfee functionality
Date: Wed,  2 Oct 2024 14:53:00 +0200
Message-ID: <20241002125814.269084797@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit 6ac80fce713e875a316a58975b830720a3e27721 ]

Fix rx filter setting to prevent dropping NDPA frames. Without this
change, bfee functionality may behave abnormally.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Link: https://patch.msgid.link/20240827093011.18621-21-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 2624edbb59a1a..eea41b29f0967 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -564,8 +564,7 @@ static void mt7915_configure_filter(struct ieee80211_hw *hw,
 
 	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
 			     MT_WF_RFCR_DROP_RTS |
-			     MT_WF_RFCR_DROP_CTL_RSV |
-			     MT_WF_RFCR_DROP_NDPA);
+			     MT_WF_RFCR_DROP_CTL_RSV);
 
 	*total_flags = flags;
 	rxfilter = phy->rxfilter;
-- 
2.43.0



