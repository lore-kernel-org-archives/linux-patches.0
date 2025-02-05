Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7321014A630;
	Wed,  5 Feb 2025 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763839; cv=none; b=gsqQYsQ3PTwcV+zOcEx6RjouZ9tqHHUraAV9kMHy0bMRYTswiatLEvQK365MBd/2IGWT4R62ynGQz483BsmvnqNOIEj4E52jdTr5mBysi6zeKWz4y0tkj9PqF2GNLqWabJ5Lymp49Jdx8NIXtu4G6kCxTYbUpdrzoiQclw/8H5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763839; c=relaxed/simple;
	bh=JZuVZtlxZeKpI/r1iJp18kiSUubaW6/d6Y8L/ZJPv8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ1K3JXRMJcD2ybHlrK9eYqa3SkwVBJ5lWp95Qi3ujtnvOfHknVI/yPVXW90gfc+qz9LqISAhYg1D3z3D0wSsYAXyuRE7fhccPPWDi/o+0X7YRTHi96HJQbaXzzV6Zm7b5Mbh8woZDtLWW9+/qa1X3+qlz3IW6N9j//RGP47mv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlFsiikb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlFsiikb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D369EC4CED1;
	Wed,  5 Feb 2025 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763839;
	bh=JZuVZtlxZeKpI/r1iJp18kiSUubaW6/d6Y8L/ZJPv8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlFsiikbGDpsMMw7EQpxpvaBKxDjTXpK+nIyIWXioZzAAXs8fe/c/jpUy8T5AL6Ft
	 Hh9F6SGKwj0oL5xWidHTL1eOu+lDjLd2W6k4WWBNsf1xBGhr5+i0Red6xOUwPAGJVz
	 eAPOIHJdxPYWoAAOVD9o/17Cvc3UcWybjoLk6y1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/393] wifi: mac80211: dont flush non-uploaded STAs
Date: Wed,  5 Feb 2025 14:40:31 +0100
Message-ID: <20250205134424.578763921@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit aa3ce3f8fafa0b8fb062f28024855ea8cb3f3450 ]

If STA state is pre-moved to AUTHORIZED (such as in IBSS
scenarios) and insertion fails, the station is freed.
In this case, the driver never knew about the station,
so trying to flush it is unexpected and may crash.

Check if the sta was uploaded to the driver before and
fix this.

Fixes: d00800a289c9 ("wifi: mac80211: add flush_sta method")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250102161730.e3d10970a7c7.I491bbcccc46f835ade07df0640a75f6ed92f20a3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 2bc2fbe58f944..78aa3bc51586e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -665,6 +665,9 @@ static inline void drv_flush_sta(struct ieee80211_local *local,
 	if (sdata && !check_sdata_in_driver(sdata))
 		return;
 
+	if (!sta->uploaded)
+		return;
+
 	trace_drv_flush_sta(local, sdata, &sta->sta);
 	if (local->ops->flush_sta)
 		local->ops->flush_sta(&local->hw, &sdata->vif, &sta->sta);
-- 
2.39.5



