Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76706221FAC;
	Tue, 12 Aug 2025 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021237; cv=none; b=TL6t4IPL4ynS3wLU6PQG4lqIA0tT9UiPZizAH4fM0v2CQYvus8uC2eqwUu1r3Sr3DypCT5gvB7MuQpRQgZzuVtOEaA6mT0n10ArK/JKhKyl0kMEwqEm82TAUM23sjFoeDUOMTYunIkg+7cKQOJgb7Oi5RkGC8n/EZWfdPOmfCaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021237; c=relaxed/simple;
	bh=e7pOyeJ+qA8zKyrIKSt5EhbyAWanMQx27K94LKwf6z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef/iVZ0QpfGVWLzKmjlBmrcqLe/NNoxVmPTjxjzCFNNrPvRl0UXUOQqtWvtLlGeMjWa6PMo16spFtL+IyphDMmGFpsCMd6DOGJifcYQ+QayfHAemVzUqRnKikO/NWOhg9elRU9sE8+V9N9WH2ac6HFbO2Qd8kykGtCH7fVN41Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zK3DQU1C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK3DQU1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C0EC4CEF0;
	Tue, 12 Aug 2025 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021237;
	bh=e7pOyeJ+qA8zKyrIKSt5EhbyAWanMQx27K94LKwf6z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zK3DQU1CpfJSWcA3gMN/TD9wTLA1/X56jATWc/OrthRZ5gPydVPJlPSfddCCVAxGS
	 9bE5GkpTJPXyrsaQm4OtfDBaeVxaHpOR9rrj0EAka5JRJI9CQqxsZ4rGfaUqOtIl/j
	 OplZ+AJjwmWlUmqUO0NnQKIiHscTjBjMMklnPlTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/262] wifi: mac80211: reject TDLS operations when station is not associated
Date: Tue, 12 Aug 2025 19:27:50 +0200
Message-ID: <20250812172956.536254838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 16ecdab5446f15a61ec88eb0d23d25d009821db0 ]

syzbot triggered a WARN in ieee80211_tdls_oper() by sending
NL80211_TDLS_ENABLE_LINK immediately after NL80211_CMD_CONNECT,
before association completed and without prior TDLS setup.

This left internal state like sdata->u.mgd.tdls_peer uninitialized,
leading to a WARN_ON() in code paths that assumed it was valid.

Reject the operation early if not in station mode or not associated.

Reported-by: syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f73f203f8c9b19037380
Fixes: 81dd2b882241 ("mac80211: move TDLS data to mgd private part")
Tested-by: syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20250715230904.661092-2-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index a4af3b7675ef..f3cdbd2133f6 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1450,7 +1450,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
 		return -ENOTSUPP;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION || !sdata->vif.cfg.assoc)
 		return -EINVAL;
 
 	switch (oper) {
-- 
2.39.5



