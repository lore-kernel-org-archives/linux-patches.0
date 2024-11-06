Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC981DFE13;
	Wed,  6 Nov 2024 13:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899067; cv=none; b=CcUbkpGSHn/BBx/IL/QQDd1qaJWhy7v8sJvgCL+p9+F2aMrX+W+Td3bc5pBkJr9KcfYsTBn/wtlF6oeym2cYrVhFik4LCz+gaSqgpOD1eTCKODZaprctnYKI6dLUOQ81XkIpw0jpWPbR99/YCpEYvTQ89m9e21NWzf2ROF6fYhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899067; c=relaxed/simple;
	bh=mntZOBvvmWjbYK+WXnb4LkPeZYQnYlSEdWi9UBfvwYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/is9d0QVXQCfcltCzzqhijZuOgI49j/96dEhGzxt1vYo8QD2tD1h9vApkdX1tatPrBI8iz7bWLwHAC0vfwnC9FGILI/dkUO4eSy37FzGQI1Vfvb92iELLvPYXBn2eW1KyvXnt96SZb62DiXrDxcb5CVzNy/tkVfFgJixDNbdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HFyfw1yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HFyfw1yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47297C4CECD;
	Wed,  6 Nov 2024 13:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899067;
	bh=mntZOBvvmWjbYK+WXnb4LkPeZYQnYlSEdWi9UBfvwYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HFyfw1yo9+iqFyIo26JsN105yq9477l3LIxmYE227hVCUTX+dPkvzCZEe5+8IdOVq
	 IAgg3CZkgghiFabGfyRkXkIBNzVnPNUQBSSgEJW3eycUc/eFKPkoP+9L8eHKoNlzwE
	 sFLDJoN4HE8r16dCv9X2+Eyx9Yo5WcfeUkqJU6Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 450/462] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:05:43 +0100
Message-ID: <20241106120342.621507443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2575,7 +2575,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


