Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C21A1E32B5;
	Wed,  6 Nov 2024 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896842; cv=none; b=oNMwCNO/NQbo60gS+JPF1q2Wh97qYUJySnvneWWFp7PTS6JUwFXryE3uYi3BoRhS2LVMyxgHGfp/ZBxyMIHfKJpqtvfD1GBZG45uHBz7VvbEwfLT9+sdePtU4bZsOkVaWTx/vN6IV0loV8YZND3sI7aLmP4TjbBbZNfsYiMxofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896842; c=relaxed/simple;
	bh=qm8dsRWcQZC3C+M91xi+yK7pkkrye+yWhsaOL7s+3gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDdWh5snij10En/hB77Bc/hYiGzWWzyCyoFphLubU5A2fBARdGcHP8xhrvVIvFj0/gmTUAEPt2T6Apy9gP726HZfiJ7hP39FFCHO1glwI2G7utGG+IepAWVno3zqFV/GXqHXVOostdDi6D+9drsHqwGkEyLhhLR48KP0K2br79g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGOThfno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGOThfno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B500DC4CECD;
	Wed,  6 Nov 2024 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896842;
	bh=qm8dsRWcQZC3C+M91xi+yK7pkkrye+yWhsaOL7s+3gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGOThfno5MVUsigVNarTpwW1eJ55VpYY9i+a0s3DKPpms0pMofgzY/CyF6UTz9AMm
	 qmGssf1L8+8y6uMpF+CULJv3OvLDvalmPolPlTVuCyd06Scpr1cu67No+kvzuv9B7S
	 VLeDtPGgtnN5Q4p4XfbozSf78xUjfYvYaHMDI9HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 090/110] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:04:56 +0100
Message-ID: <20241106120305.672293727@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
@@ -2720,7 +2720,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (!local->use_chanctx)


