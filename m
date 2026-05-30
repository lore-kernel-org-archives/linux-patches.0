Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB2529B799;
	Sat, 30 May 2026 18:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164837; cv=none; b=YO5UQWv65AnpwWiJJy9vU5JfblWtfqjB7j47oEEw6J1xyljteSqSO5u8WYtudSDfnGBQcq0CC1s+5zaeh+L6iG7X0gzHnbP/4DkpUPzVcS5OxWr5hfugYn05+2BLkmxqqSZXofnNTioKknAumErQasx0eUlYME7jufx/tniB8lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164837; c=relaxed/simple;
	bh=kIgVHe34m7UeluDIB4TJ8GAvnPNsed6nYz1nM3rEo7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxyU6YRe8MosTK89Vf9mAHUodhJTqmDUTqJwvfmccThxat4dQdOju6Jo5nPTc/kqKj+yeFisPnBYH62hkLlPr3l16eAvKy67SKclFze6RFjr3Ukr79w+hWn9uCJoAyEMrgCs0J0byhxWPpUINB0Ieg6CGNd83HXy2DGTaku1imc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scZR4DwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scZR4DwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DB41F00893;
	Sat, 30 May 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164835;
	bh=9zSd4RbMpdAI29F8E/gNT06NRA0CVwI94Ow10QK3RIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scZR4DwL1V9tkMu8OCU7y1TZ9QIqQeqahwyxCL8nWC57Sb0tnO5d24WlyKDlXyQ0S
	 vixFN06CWgI0b5l10tuLeJArnLfHYR3FkUpVX3h0nHUuhvZEIyp2yr2B/65YSa57FO
	 s/4plxrr8poE/dCDASmfAuNQyo9mWC+k7bAQZBJI=
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
Subject: [PATCH 5.15 673/776] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Sat, 30 May 2026 18:06:27 +0200
Message-ID: <20260530160257.264259282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c2d7479c119af..d25dfeb347f24 100644
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



