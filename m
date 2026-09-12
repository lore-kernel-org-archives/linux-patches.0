Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A9F47C107;
	Sat, 12 Sep 2026 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216811; cv=none; b=RR31z7UBG5dFy3j+FenRnEHPmIjxZH6veHCP/Ypzmzk+U/4P7B+CXhz+IsO4PO2JVs3U16gPNFX9XTkKeijeI4T9EfJsM1M/+WEUJRVvFig9HmwwpeftYtelL2Bg9zZugcA1M80K+tCeeHAu/k5S22QdmMNV7qzRgN5rvJLk6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216811; c=relaxed/simple;
	bh=BLWoJEaYJyehOuC63/yp5mZ5do3oBjNzhRFZV9QBj2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZz0f479bQSk5pQJblzFUhBWxecJR101G1kpNl5u8yhF6ZeZpVvbsJqSN5CPMkT+xL4GgSm02Io6/9BrTQrEh6zMeOMsP34CisoTZC/PrrDmsgNnyzdnuB7p1/i5LYoRB+mn62Gnmb3BtxwG+IDBlGWg9TVNruJAMEz1nbE5Wp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjb7Tolo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjb7Tolo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFB91F000FF;
	Sat, 12 Sep 2026 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216808;
	bh=b9TZGtGgW6PxCry5DhS2GpeuEuPubqEeqiBsso69iKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjb7ToloV2VduI3+m/r2hPnu4dflIVKQXckNM8tOsingoP4lz2Wv0RcZNSLvHCBDb
	 EKEyge2701Jqnf1SCZAbL24f3o2JdrCIpx7EI2S9cKR/7C/TZ713Ldhm4FSsv+4BoC
	 TPAzshDBEYMlRd14CJiAuYKXloamY2XoHkZG6UJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0812/1376] wifi: mt76: mt7996: dont report a zero TX bitrate
Date: Sat, 12 Sep 2026 08:53:58 +0200
Message-ID: <20260912065625.639433531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d4d92ccded678c92c390003926097ddbb6516bc7 ]

mt7996_sta_statistics() set NL80211_STA_INFO_TX_BITRATE unconditionally
after the block that already sets it, so a station with no rate info yet
was reported to userspace with a valid-but-zero TX rate. Drop the
redundant unconditional assignments; the in-block ones are sufficient.

Fixes: b34f346b917e ("wifi: mt76: mt7996: drop return in mt7996_sta_statistics")
Link: https://patch.msgid.link/20260722082610.2699628-10-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 4d11083b86c09..bdb5e82d9f4e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1014,8 +1014,6 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
-	sinfo->txrate.flags = txrate->flags;
-	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	sinfo->tx_failed = msta->wcid.stats.tx_failed;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
-- 
2.53.0



