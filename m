Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AD198E96;
	Wed,  6 Nov 2024 12:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896304; cv=none; b=u+zSlKLBTRHWI9Uvgq7uz/wAUelFFgCy8NRoLxL7h8WnpaxknfDRYqAFDEDlBOZvIneoxxuSXhlYPPCdzt9rUI5tmRCgi/icjYyfN5B+20KqqhYgaNf7LvOblUxJjZwmpFoofsI8Lj5qtu4NzYC1WIqcTbWwISGziSBszP+6DDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896304; c=relaxed/simple;
	bh=oTHhREzhJF2B3IEdlczyzRG8Suwr6xdpGcObvjdnCY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDmx8ikIAFU63pqc1rXA0YOBaLshr4ijv/Vz60p4mUrcUImXFhZ4/AYRAZhC1Z2+sMf3dCpByNH9uiK16pkjicVlsnYVRsYgENkUxw40bCOIu7LyfiZTS6eZK3kn77Rq2q8Vp1dui171ZKDAfjPOe4w48wf3yG9JVTM396JQgS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7z+6JVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7z+6JVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F39AC4CECD;
	Wed,  6 Nov 2024 12:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896304;
	bh=oTHhREzhJF2B3IEdlczyzRG8Suwr6xdpGcObvjdnCY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7z+6JVE3OAGCZwD9HZp0CZIfoBPfmBlJPnsM8CG7u/6EZjXfLBjmrsRwQyLpFRUK
	 ehQD35xXYu32S1W/Y9x2QfQBVM9a6f1kHkRtapzwWdrlwgNi57OqmpmK6fdM8u6qIP
	 J2UPu348PsdHrpIlb5ICAK0ZSLVjNrRAcweU29Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.11 122/245] wifi: mac80211: do not pass a stopped vif to the driver in .get_txpower
Date: Wed,  6 Nov 2024 13:02:55 +0100
Message-ID: <20241106120322.225752384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3138,7 +3138,8 @@ static int ieee80211_get_tx_power(struct
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	if (local->ops->get_txpower)
+	if (local->ops->get_txpower &&
+	    (sdata->flags & IEEE80211_SDATA_IN_DRIVER))
 		return drv_get_txpower(local, sdata, dbm);
 
 	if (local->emulate_chanctx)


