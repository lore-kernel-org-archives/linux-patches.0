Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9871B37F738;
	Wed, 30 Sep 2026 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783400; cv=none; b=MXpb3TSnTDxIm61CRwAoPjeCikv9Auiqg6Mx5gqRsbKQLY8tSf0WoXdD3izUu5vWxiReH6jAS/irTFBQeF6AjSKXYau8x0rQzIK1Cnnmn1WCdJw0GSDvHD5cEfskFK2cykOdeRmVJwwPy5T2UX1N1KIld7DJB2YRU8k+wQ81EGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783400; c=relaxed/simple;
	bh=YDouUCDT6nr8p1SLfnkevg7u2ZdEW05ROE0Yq/htcr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrFPHQUK6GE4ZmnU40T558R6Cfgi3jQPgCbXYIUqXDjTgRoFwRz1eQZjLc2MnlqSYZ1Qv2TyLBA0+GFN3oFTeQwFf7HdURhhEp1tkHNFYzP93j/vEdMi1OHnICL/BMcqDuWU3NuHCuwZeGp7SFB562ckVVQGU/uypn8FPXpfDso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VT7e9j3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VT7e9j3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DF51F00898;
	Wed, 30 Sep 2026 15:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783396;
	bh=bFB67yn4+8vUpYgb/fihKxfbFYvb269r2Ek0lHJmsas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VT7e9j3K5CkdvtoOYKheVzEx40qFmbZmRplFQj6bPWf3/bZt0dpKygk7JjQvB0Caz
	 l/oxXs6zT7SsJ2cWadLi1w+56Plb2jnyk0lKUlOOqvEhpu6IDbsbTxZ5XkRqYKBqM/
	 rXsENCReIQkgpqBTx7O1suqCkzyOw1FpVyFZXZ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/595] wifi: cfg80211: dont filter by BSS type when removing stale entries
Date: Wed, 30 Sep 2026 17:24:36 +0200
Message-ID: <20260930152355.913965992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b377e1000d963e7182a987082b4b06580bd7ac84 ]

When an assoc AP switches to a channel that already has a BSS entry,
cfg80211_update_assoc_bss_entry() removes that entry before rehashing
the real one, since the two would otherwise collide in the BSS rbtree.

The lookup for that entry also required it to match the connection's BSS
type, so an entry advertising e.g. the IBSS capability bit was left in
place, and the following cfg80211_rehash_bss() then ran into it:

  WARN_ON(!cmp)

Changing the type shouldn't really happen, but can be triggered by a
rogue AP/device, so drop the check and remove any entries matching
the comparison.

Assisted-by: LLM
Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
Link: https://patch.msgid.link/20260904165614.1f05dae1c546.Ib52d57b57caa912efee020f9d4a033a5160617ce@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a277c6ddf94ea..058f3c1f87914 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2740,11 +2740,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 	cbss->pub.channel = chan;
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if (!cfg80211_bss_type_match(bss->pub.capability,
-					     bss->pub.channel->band,
-					     wdev->conn_bss_type))
-			continue;
-
 		if (bss == cbss)
 			continue;
 
-- 
2.53.0



