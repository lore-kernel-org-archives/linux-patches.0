Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6361E0496;
	Wed,  6 Nov 2024 12:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897138; cv=none; b=mxzJQ+rZ/vev+mz9fXuSjIT3IeIcNz5RT2ugmJAZ1ot8SyQTPaH4fOO60dvKGKrqiK5BNMO8WMvVUjlr30BYYQqulzNFahurSbvfnoMajIHNHwt6/3betrSd5kXcYEkOPZkmP9QDVrEHW9jcCtzMoIZwoZavgYKtkbPjXVl7tOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897138; c=relaxed/simple;
	bh=J9LZVQ79rDUQ8bPVtMpjZ1uawyLXK6ObflXmhSQCFeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYemlfTlkS64AYQfVN6G2c6T9653R4epCWrlJhKBo2UF1LRCc5S8veECM8G3rlbr/t9MIwIfAhtBmGtlBmF+Z7gz20hb29I6pCyQ0t0AhWXoVinkpSahS9W8DHKec/tlcfdKPjNyPwH25wl5j6LDtw5Btfp4ECyswIuxiuSTrY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xB1Zj3sQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xB1Zj3sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021F2C4CECD;
	Wed,  6 Nov 2024 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897138;
	bh=J9LZVQ79rDUQ8bPVtMpjZ1uawyLXK6ObflXmhSQCFeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xB1Zj3sQ80GxcLFVTaaJTaunHAPh+OmcGxYI91Bg3exL1XA9g0qEZh1cinn9deSlh
	 014k3w6I9X6pQFDolfwGxzaoYLomP/ABnYj9W6rztLcJTZLEZvfE7nJy0CEJGruf9v
	 PW3f0CVT2f9BDdyBtYnlYT5LP7IundyOpVzI1d9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 072/126] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:04:33 +0100
Message-ID: <20241106120308.035486282@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

commit 393b6bc174b0dd21bb2a36c13b36e62fc3474a23 upstream.

Avoid potentially crashing in the driver because of uninitialized private data

Fixes: 5b3dc42b1b0d ("mac80211: add support for driver tx power reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20241002095630.22431-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3001,7 +3001,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


