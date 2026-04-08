Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51479324B1F;
	Wed,  8 Apr 2026 18:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672865; cv=none; b=QWkVfNYgpHhg3ywmlZLru8wWRNLoMiRipr5WBBwxVChR/tjm2E2kLWPX5ovEywSaM3EsQwfCucxgNytbCEjLhdGD6RyyiHAMBsf6hvdsZxESRntpmKCMWXH1fyP7BYCH4/riaeXUhjrq2aXvBPcl+5OP6haLUP4UNcLB9flhxWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672865; c=relaxed/simple;
	bh=0r1L7yfvhikfu3Drdb38DfLFXl8FokmfIrF6v1k3eJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvSgfZEBVltzrAPJoN2hByQ6CNT0nvpdZF+ItX/XMvM9l3g5i/o+dX+o0qVTGX4mAI3QKU+qGvEW/+6d2dtJjXMnBy5TeJIplV6ljSHcxATMiNQupSIA4eOmYO4m207oNYF7xsyzNVKql8ztS2yjzu8EfbGG3vEYdxqWsHXLukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuHeKlH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuHeKlH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5DAC19421;
	Wed,  8 Apr 2026 18:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672865;
	bh=0r1L7yfvhikfu3Drdb38DfLFXl8FokmfIrF6v1k3eJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuHeKlH75O8fJ9RNKgi6mq7p3rVzOaAG6qV6Sxj36CBbRblbBSEbHAkTt2/Y1LJE7
	 OfeST3c3RWu5sBEbkOKXq3o/IBzXOJfZE3qoxB/XErWhIRKYnPVC+BJ0wwyem3anef
	 7vRhkgcUDkhZbolP909wY/fhxtjYt9p1bZa7rU0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/277] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Wed,  8 Apr 2026 19:59:48 +0200
Message-ID: <20260408175933.970903561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ba5fbacbeeda6..1536cd71878c7 100644
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



