Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8DD329396;
	Thu, 28 May 2026 20:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001163; cv=none; b=Lfof4QOe7XHV3jlYPwa2mDczsc8UA9KzId/nZWIl4eonBuFXyHqUQxykEWvHUp9UqKbmJnUbe0AWq0JAu0qlu9w5vEUs91vZXFIPUDqbNcAvRWbLbDYq5s1lqdez6E1kewmqjH0gsVGWo4SI4QZcZpBRuBajwAVbF74dDX7q48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001163; c=relaxed/simple;
	bh=+pnl8gWNipPDj94bFopiT+L0L8WbiYMiZRRgJVRwQLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsEpB7JacxjfavHO8Ydj4Sy9abyS5RgCnDHiyPbN/Ijus2eTZQBfuOHuWyb/uCTpdJ2rEwaFbGNW3Gdj3fs0369vKDcs9SvAhRrqAcSnpFToM+gy0kAYWRSTHSPjdMwxqV5/09I7/vLEvWuToPc7zzJffzqKvnC/3/a77vdLWQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUhsjvLr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUhsjvLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8508A1F000E9;
	Thu, 28 May 2026 20:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001162;
	bh=ijH5aBh08Ap4bop8xV0c9XVlkVmxiBXPkOCnSuUciIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUhsjvLrWqN6k3h5qLAdcxwaxQ7j7yFOwG+LyOFBPyCUWKFeEm8lSSIAi6J93BAtd
	 KT/XdCFHEiE8nqWZgMEXe1VlnEAW1ixFH6JlynF9VNPTQUIMN+UK3bDneYe3LfZJqp
	 gEcCJSeeLxnmfo69HTWoyWplpQshVI4sEuogo7p4=
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
Subject: [PATCH 6.6 009/186] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Thu, 28 May 2026 21:48:09 +0200
Message-ID: <20260528194929.202881705@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index 0fd353fec9fc6..c3622f779d120 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1481,7 +1481,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
-		if (!sta) {
+		if (!sta || !sta->sta.tdls) {
 			mutex_unlock(&local->sta_mtx);
 			ret = -ENOLINK;
 			break;
-- 
2.53.0



