Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D21E1335;
	Wed,  6 Nov 2024 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895809; cv=none; b=kwQ/6ZHfN3aJ+12heu0mNPd7EdYNqZ4cyCTWCSvH9yMGDLRSuOnxH7wNCZlMTtgDAF2fbHyq3uoWl2iD2f2dMm4dBcDWcDMSS5eq3hRpR4j1xjcTtGKtDWunzKopIcxzQtt+M8VzaL9aZmNOGJPxN8B6z3OO8na+L89kR3JagsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895809; c=relaxed/simple;
	bh=pUEDvzTWGkwAxZTbalL4vJlZhJ8YohlS933FiEplwss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRY1jpCYxo2hAD/yyg3Z4edXFY7eeLjnWDm5x2KotPOAhz0Tvkr0X1RehmcJrEyJne6/GQ3QXh5iG18yX0FNv6vpbVQCdEBzQsyjEUR0+qPrN+V51ZqP7NIjYUTX3QW3f3X6Y10XGGPDgCyuwsXZWvhvihtWys4mFRCq+dMDDoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLZtt2x5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLZtt2x5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6DCC4CED4;
	Wed,  6 Nov 2024 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895809;
	bh=pUEDvzTWGkwAxZTbalL4vJlZhJ8YohlS933FiEplwss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLZtt2x5Z2zRZncJlVi3xjUaRlf1TW+iXB9Dym9GxLyXgfydBLFtBsZmuzN68EOAw
	 IXOgjyf+kWHECpQHPa0xUHfcIsY8cuadblC2v4+YEJ5ShBYGoEGdwGXt992eht2h1B
	 w0MOkMwI894oCcyEHf0bfaGQxEin6pV0+t30zVN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 343/350] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:04:31 +0100
Message-ID: <20241106120329.166470892@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2443,7 +2443,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


