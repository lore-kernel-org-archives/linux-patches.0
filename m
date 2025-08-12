Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDC026FA77;
	Tue, 12 Aug 2025 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025891; cv=none; b=GUf/NzwmaBF98QU6IctAeb3xoMI153XKlAmTiCuKrTNsuw3hKBgqk+G3zPrcnrzXH2N/vwAFKzIHLxMVTknT53XoqsHDgjg/LG6ZHOAIxvrJBNV1Bhil+9aHklnCn4hfR6k9gypb7kGNvy/9K1LxCn9oMkV60rnDfIyaO0dAAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025891; c=relaxed/simple;
	bh=OtAcdKSpAUYbIAlvgxSK7RKBP0JGIs/5wXLzT7c56Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdnfCCKGm2GKLBS2YGFIny9ppJlU9abas9+rwp8PIL/UDKAgjlALOvPsNp2tmrJ1Q2o6ZKh0WJxVYNdhtQ15EvtqDnnQ4a8IhasJtipzXF+jKDwNHH1GaWNzTGXTqTt8zU3J+LBAU2Fk2BR7zeR7JmfYpaXn+6XS1IkL47ntzn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHiLGrYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHiLGrYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16952C4CEF0;
	Tue, 12 Aug 2025 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025889;
	bh=OtAcdKSpAUYbIAlvgxSK7RKBP0JGIs/5wXLzT7c56Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHiLGrYv3mIapCZQbyYOdHqEaKyJfI4iNJyROGw6c9gWfNUIFwt0unVelpyhXsa95
	 XgiW5XQFda7WtLBiLEQZyGoCyEc9Vw7NMvJ/5UWDA+wBjcVk3mEsV44b9jiSTiDe5s
	 h3EEWWxMdQAEpKcFpfk8YbPZS1sJOTlPILJM2CJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 174/480] wifi: mac80211: reject TDLS operations when station is not associated
Date: Tue, 12 Aug 2025 19:46:22 +0200
Message-ID: <20250812174404.687881926@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2f92e7c7f203..49c92c5d3909 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1422,7 +1422,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
 		return -EOPNOTSUPP;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION || !sdata->vif.cfg.assoc)
 		return -EINVAL;
 
 	switch (oper) {
-- 
2.39.5



