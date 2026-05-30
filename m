Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E58325701;
	Sat, 30 May 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162244; cv=none; b=lkspGYVqSI2XV15pImxifMB60rN6P4sluwwE0k5BcUrbuoIft9YPeIaIakwZebB7zGGDkVZ+OxRdLQEFdVLv458MJIK6cSy8yLQWOTiX7ZjrZvBM0dPmO0onhbGwR0sO+X6I8XV7m2aTXA2GbPl9ZxJr+KkUwGqHtqCgFxsboPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162244; c=relaxed/simple;
	bh=4D2cis7DMzFVrmuRg6qhWp3qzZ+P9v7E9ggIYvg53bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASoCm1Yad0vdO3Df7xtiL1aHrf5MjK4ltYw8fpw2lnOBMyCVUxfRf5HSnDaduY//5bzCv5RVP+ZSFx3HTY1xC2xjPS2qyDXyDdSA89egh8wdrD8pDp1s2gSwRxVBeJURBFQzDp+Aw8f+l7Bwtf3PDTCynXVL/VmlVjPSKur1iDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQImMuTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQImMuTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A81F00893;
	Sat, 30 May 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162242;
	bh=2GMPJsj+y5M6GNrLyaoP+PI7R9PUTZ5J6Hpv6XIc5Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQImMuTY5IRpE/6tXUlhYausUwGBemBhyv1boRKJlYT4Aor6n2L1lCIyCfHBCPj4U
	 7p2UmM5jMqB1sicTVEPKwOGfSz6vr5OedmrpehBAvtI+T7KO1495G52TM1zg9Tg7L1
	 DwYuzUz466Lw/KJdjsuIxgRGGvYjxZBsIMlqRtJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 834/969] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Sat, 30 May 2026 18:05:58 +0200
Message-ID: <20260530160323.676297249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b ]

When NL80211_TDLS_ENABLE_LINK is called, the code only checks if the
station exists but not whether it is actually a TDLS station. This
allows the operation to proceed for non-TDLS stations, causing
unintended side effects like modifying channel context and HT
protection before failing.

Add a check for sta->sta.tdls early in the ENABLE_LINK case, before
any side effects occur, to ensure the operation is only allowed for
actual TDLS peers.

Reported-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56b6a844a4ea74487b7b
Tested-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260313092417.520807-1-kartikey406@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1f07b598a6a17..57bd4fc8d2375 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1382,7 +1382,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
-		if (!sta) {
+		if (!sta || !sta->sta.tdls) {
 			mutex_unlock(&local->sta_mtx);
 			ret = -ENOLINK;
 			break;
-- 
2.53.0



