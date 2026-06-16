Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108343CC303;
	Tue, 16 Jun 2026 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636014; cv=none; b=MnM9z0QgeZkBksp6dhxNwozGaLMT+7uV5yzRwy1qVmmib152ny66CvLcmFimDYTdr33pWHVskur0J6mRUJl9oXrFELs82FmEPj7C30tTkbsj75/7n4DbF/LsHZN9UHAtJGUmrk0EhL5M0OUCXMOXToCX5KVc7B23WsF9/dFYoHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636014; c=relaxed/simple;
	bh=XQ0pJ+Imm5g4ju0Z47urXtXvaFJSghh8ZPd0OQp7jOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0DRUrMO+4NUVWd1+AJweyXKp1mASy3VlJxR0i4SxbytsVaewPXY46i6VGVHZbrnDjPGe2I/kCqKKnBv+H1iREHFph3d8pfZY0wokgYIRGKBN4LJ6MTLfoFJ/w+ZjIR2FL7SwylQe3t51vMCNgpmzW/IrTWo00B+MjrlID2SVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4rLY5lf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4rLY5lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139191F000E9;
	Tue, 16 Jun 2026 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636013;
	bh=NwR3JxvQov6b6MmvwGPWdaClpTZXbpTAtVn14b/di78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4rLY5lfKf6WUjQuKyO7yPSa5klTdkQ8/SeztwJnV/c0z4OTthjnN/XWgMOOaeb/Y
	 DDAr1tf3TWboP5bqBOF8guoclCoGYaHZRgsbSOcFhmHjS64yxScT0jINEElcy7NgGp
	 RpN4UXhZ+8acFObBO1JKy5T7BlIMK1qUCXTi0DWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Alexey Panov <apanov@astralinux.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/342] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Tue, 16 Jun 2026 20:27:33 +0530
Message-ID: <20260616145055.483655243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b upstream.

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
[ Alexey: Adapted to the older sta_mtx locking and error-handling flow. ]
Signed-off-by: Alexey Panov <apanov@astralinux.ru>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index e01e4daeb8cd31..66e32f1d0a989a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1380,7 +1380,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
-		if (!sta) {
+		if (!sta || !sta->sta.tdls) {
 			mutex_unlock(&local->sta_mtx);
 			ret = -ENOLINK;
 			break;
-- 
2.53.0



