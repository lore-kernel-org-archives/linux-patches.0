Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060453D75C9;
	Wed,  8 Apr 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674214; cv=none; b=pB5DdSati5F76QV+8J2SkNDh7bnENt9y41PLoVB2BhlmWMkVBHbc6XCYQEEBAkMvtdQfJSuD7YfsgoJt2oeUy3bwptwD0qf5ZKUrfMul9pVGotAANyrAdPcJ4Z1eaU06H+MKWssULFbEwHgQWDMEHFc6LjPBUTfbKeALE85/+pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674214; c=relaxed/simple;
	bh=qS03sR4Woma7CdGVuO+FLZwqwZRguUEqg0eW3xTTNO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS3nog3Soi61RfhGX2l9XY1sbZIEX9LtMj8XaBdR975f0kRDVJPo17WVuvMxJe3LoDnmNu+9lisdJo/nRg5TQo3K8tLSCQ2P/mQa3kG94d0A+yGBPp1mRAr1S7y93j13Z4bQW+j7s4lUWU+eTRw9Hu9OerUAQHHB80C06NiBH6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TFArMHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TFArMHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9180DC19421;
	Wed,  8 Apr 2026 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674213;
	bh=qS03sR4Woma7CdGVuO+FLZwqwZRguUEqg0eW3xTTNO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TFArMHCF7nGEBmaLfZujFmjF0fP0+R+aXBvFBmrbxNgxJt/0unA2vmY6nvcHUxwI
	 +N23x4tgpB/Qaaraig27GBxnFyGwrZP7ySBfAAf9ujyOEutCvWVqJizf5Jgm9z3cgl
	 QxdWLAL6+87COxxAD97SkU8aILGVeCC+RytbAtdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 011/311] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Wed,  8 Apr 2026 20:00:11 +0200
Message-ID: <20260408175939.833584360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index dbbfe2d6842fb..1dca2fae05a52 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1449,7 +1449,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		sta = sta_info_get(sdata, peer);
-		if (!sta)
+		if (!sta || !sta->sta.tdls)
 			return -ENOLINK;
 
 		iee80211_tdls_recalc_chanctx(sdata, sta);
-- 
2.53.0



