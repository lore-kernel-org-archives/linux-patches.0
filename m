Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16713398C;
	Tue, 23 Jan 2024 00:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969297; cv=none; b=KDWUOu/4NSLwXCuoPC65ahtUSGF+hCmMxjgXYQI7rmLufcAu04BKpk01F1Zrmzt+hUJTWIOsPtH+UaLQ43SmOBm5THQFuC5n9iwYEGmUOFaigG42QW0XVRRRpSbE5qK/ybWxvC3GsxWhXk+VC9DwKuFhHfkIBx7wTgY+UK02Ig0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969297; c=relaxed/simple;
	bh=8Mj7bNhQYmHpXBo+0Nb6bj0seg6tu0bb4r2vER/lq7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBnrIBPxtUwrn3JCKVKW996gj1W89w8gINVy4Q8oTmcKO6f/FBv26SJ+qVezaJMRMXwzgVYCpaQXkxIWYWZ+t3MCkljjM5e14JDSA39lLFVu2jeyxbWlctqEBxPRs5XfvULHHGPuYGBDmc5bt2EMQZh3mcojjwbGLQZxk9TcvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLHmKBlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLHmKBlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D047C43399;
	Tue, 23 Jan 2024 00:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969297;
	bh=8Mj7bNhQYmHpXBo+0Nb6bj0seg6tu0bb4r2vER/lq7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLHmKBlNK1UE3g6V77wIp2paxBNsxhmieuCwkTF11MyDo1F9nwZsfadxMkSD4mx1u
	 pLjPAIqP0Nsma5aHY8UEb+/sQ0l26wuPqR9cU3HVVyn3AXndkL09XinK4I6YTKBtb6
	 MpbxSnm18Wl8bP1SvvKuVy8+qe2zSBqya0Tj1W8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 154/641] wifi: mt76: mt7996: fix mt7996_mcu_all_sta_info_event struct packing
Date: Mon, 22 Jan 2024 15:50:58 -0800
Message-ID: <20240122235822.852499908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 2ee1c40daeb9a33e25c460bf87feca58e91af879 ]

The internal struct and union inside mt7996_mcu_all_sta_info_event is
marked as being aligned, which conflicts with it being unaligned
within that structure:

drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:165:2: error: field  within 'struct mt7996_mcu_all_sta_info_event' is less aligned than 'union mt7996_mcu_all_sta_info_event::(anonymous at ../drivers/net/wireless/mediatek/mt76/mt7996/mcu.h:165:2)' and is usually due to 'struct mt7996_mcu_all_sta_info_event' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]

Mark all three as being packed as well to ensure byte packing for
the entire thing.

Fixes: adde3eed4a75 ("wifi: mt76: mt7996: Add mcu commands for getting sta tx statistic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 14c0dd31387a..9300cd8eeb76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -168,15 +168,15 @@ struct mt7996_mcu_all_sta_info_event {
 			u8 rsv[2];
 			__le32 tx_bytes[IEEE80211_NUM_ACS];
 			__le32 rx_bytes[IEEE80211_NUM_ACS];
-		} adm_stat[0];
+		} adm_stat[0] __packed;
 
 		struct {
 			__le16 wlan_idx;
 			u8 rsv[2];
 			__le32 tx_msdu_cnt;
 			__le32 rx_msdu_cnt;
-		} msdu_cnt[0];
-	};
+		} msdu_cnt[0] __packed;
+	} __packed;
 } __packed;
 
 enum mt7996_chan_mib_offs {
-- 
2.43.0



