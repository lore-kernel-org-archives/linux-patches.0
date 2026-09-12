Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84A306D2A;
	Sat, 12 Sep 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224348; cv=none; b=X+g4qYGGPnWE5X5Q3Q0IFgooHnuQuM5IxTA0GcY++ljj6YiPY5jBZbBpkeS6JSx5Q9pFrdgug/RG5hjdgprMZ22/CfdKLsb+KXi0yF9vU/FN5PEA9pZrBBT9y8OVx35PgnEPJe79aIMMDz+qelSfRv6PwRQI+lj+9bp+9/epCjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224348; c=relaxed/simple;
	bh=IZVbF7ouuqj6pWz4xdGTpUHOcYBmCHdjTMA5+TN/O4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1ArI3Y4SqqN5qpResvBUsCSD29W3PFQjnbggcQPUcctZLUHsUFeQ3q+xuoi4/lb9XOmL5jyk35GKJn/y6nFxWYhQIpsYIDGdfBiO23sIFi0yiHeTxPLzLzXjSB3aC+eUWv9kCLanaVIEW5i39cDY+yTtItIhxkpCDF1TCtrjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fsB5FMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fsB5FMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6B81F000FF;
	Sat, 12 Sep 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224347;
	bh=U5yZZ8m4VDrkiKQHZ2MHBUwlO+wUGSLUxKT2cu53Qgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fsB5FMWDs5Aj0im/2XYDZ0rsDlIfJbYBDdKRezUm/tJiUIlZ5DfQXI1ytH+sQ0a/
	 Vw1SEcMV1z7x2quXcdmyNWRnAHHB8+QVdhcWXJKq3+kXLo2MzTphwG2/Vxn/yOhD3Y
	 9tOdVX72sRkzbCA5i3kp5+021OX/XDRkXCJrvdgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0975/1424] wifi: mt76: mt7996: dont report a zero TX bitrate
Date: Sat, 12 Sep 2026 08:56:47 +0200
Message-ID: <20260912065629.148461245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c559212ea86a7..dd00a0fb5df0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -998,8 +998,6 @@ static void mt7996_sta_statistics(struct ieee80211_hw *hw,
 		sinfo->txrate.flags = txrate->flags;
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 	}
-	sinfo->txrate.flags = txrate->flags;
-	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 	sinfo->ack_signal = (s8)msta->ack_signal;
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
-- 
2.53.0



