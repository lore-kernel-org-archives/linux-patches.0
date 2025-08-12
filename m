Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626642FE571;
	Tue, 12 Aug 2025 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023971; cv=none; b=CKpsJgPrEEzJXpD7X+bK+R4t8BgR7RrpveO801RqM+eoHZkWWKXNp2lFfEH4w3n1DiFQeV98T5C+gcWVj1CQcbSuDU6iWCqMvyAMGQZfhqnAKvKsHlyP5TZGwnCJEd2XJOdhN6rCc2A1K6XUutfQ+GUhgQ64oQWKZzRls0F4p6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023971; c=relaxed/simple;
	bh=8EFW6m/KEGmwdkJqXQpdc9r9DWvqBQHVmH4g2i4xyik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITul+Q6fbSkwBxZa6oHNH+o0c9d2t/PxL1kY7KuMgeLDomPIHIlG+CyzOrxmMRvESgBGDfRszaOoWMJ7mQlNxASIfxXnnFJj2KejdAd8ttdNBQ/ZwTQkq3fgkEckdYVB9X5Co21yLy0HBSyhexOSN7Ml2/vLzbL6//+KaEDmsSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zW+K5AvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zW+K5AvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5080C4CEF0;
	Tue, 12 Aug 2025 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023971;
	bh=8EFW6m/KEGmwdkJqXQpdc9r9DWvqBQHVmH4g2i4xyik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zW+K5AvRgsAKB9a/ngmnrRmpwTcOpbCcLzjNnHs7zLn9ISi8bfY1tZpDVisoxRrOy
	 +nT8ho2Ro7u+dsseCYOV6CFzjUG4m7/4Aj4mErYyDcKwWggbdBkcIRQo1xfFBYNhpg
	 AaoDdqMIw6EL1a6Bxx2x1cALa6iboUcUwpxQeBDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f73f203f8c9b19037380@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 234/627] wifi: mac80211: reject TDLS operations when station is not associated
Date: Tue, 12 Aug 2025 19:28:49 +0200
Message-ID: <20250812173428.201672961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 94714f8ffd22..ba5fbacbeeda 100644
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



