Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20B37AA97;
	Sat, 12 Sep 2026 08:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200892; cv=none; b=HTF80hFOPT6yHZyna1293SUi29v3gID+/qfL9j5hOrRNf8Sqie9Y7wGltINHaWQJxwE4svfveywmHZqPcObqBm1Ps/uyLu8SRafnvCkgPZmDFFS55tLgMygw2GPUO0/ZAd7gNcXiZ3ehPN6tak0T73yaS4jlJ79WrXxehu/BJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200892; c=relaxed/simple;
	bh=d1oFEYPTW+cj6aJMP7hzGim1i+Q9NH+zVgbDiipTSH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d75wjJMbDNF7EmEjUtPAlCCn9ZZtq56LlBWQoDv0KOu1Y8VsZ4O6yf8Dyqk5AcuJi4u+v7CShnIWi69t8sJ9yI07n0qVp7ee5s9208mS2eKPntC8vetpZC0wdY6iNdfSaBNO0auG218Ebz6OpPJZEMO9S3mHVUR8b9U9KGZpKAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+a7+1fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+a7+1fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CE31F000FF;
	Sat, 12 Sep 2026 08:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200888;
	bh=2aYvxL1UzIpFE4FkkcM7uviDmFdRdWuU99x3HAIgaZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+a7+1frH3rUm1brJXXx7ttWXvfrkYYzC1eoZPTij3xmWjM6o7hINbhyVP06hBAWo
	 12CF1YbjkSVzVhzhgejbz1QA9ivdhJOmHlERzHu4ppjun1C075yXWDSGSFw+e5HqyW
	 n6JMq3wi3zQuC8T2RyYelbd8MD8Uci/bj3pzwJYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0884/1815] wifi: mt76: mt7996: dont report a zero TX bitrate
Date: Sat, 12 Sep 2026 08:43:54 +0200
Message-ID: <20260912065709.672944975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f291560ae93cb..2487b00c37904 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1883,8 +1883,6 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
-	sinfo->txrate.flags = txrate->flags;
-	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	sinfo->tx_failed = msta_link->wcid.stats.tx_failed;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
-- 
2.53.0



