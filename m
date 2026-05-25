Received: from n169-114.mail.139.com (n169-114.mail.139.com [120.232.169.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2E125AA
	for <patches@lists.linux.dev>; Mon, 25 May 2026 05:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688131; cv=none; b=UPjULdi+RM66THDjCvBAprEJTWfQgDsjhbx4SrAYEeH7lh0nbq63UTOEi3pBMxfRvhqJG50HlCbWjf+lS94SLLvRUCN8VHK/+hicm6xX6BgqQlwzmzXOc3AnWTQRAtQ+09lHrxhSXPll+kdBXFVlSjdpZmhYWDPuz487FTfaWGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688131; c=relaxed/simple;
	bh=sBdeIIbu9Ngax4MVo+D791EZCg+rVSGe/Srj3TD7kuo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EHc1I98Esh43ASR2gxRCSJzUd8tr5QwIdepA627nzNJmsyJojLdbPauE42miGzdEzffD5z7qfs6nLwdyWWEfgHPPWbrTLKD5pSyB4AICXFK6IxMvPhCnIGBRGMmAdJUgWIzhnMi3Xr8H94D6jYTwp0qhmuBCCjIR73TgcLSdfbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=Zr6xHTJc; arc=none smtp.client-ip=120.232.169.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="Zr6xHTJc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Zr6xHTJctM3T5X6FnR3PVXAQa6FwBV6vZNP71JVP+H6NUmi+BIof4YMWiUpTaZI0ksXunAs1v1pc6
	 EedaPIyO82HpWEYqaKUpkDpW9mY+rYtkDW3OWK6FUgXuEh29j0khbQt6E81VqCaud9fsfiRjRYwdXY
	 VdG0liEA01XAE5tg=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-39-12053 (RichMail) with SMTP id 2f156a13e2b3d55-01d96;
	Mon, 25 May 2026 13:48:37 +0800 (CST)
X-RM-TRANSID:2f156a13e2b3d55-01d96
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	johannes.berg@intel.com
Subject: [PATCH 6.6.y] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Mon, 25 May 2026 13:48:35 +0800
Message-Id: <20260525054835.2457749-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 0fd353fec9fc..c3622f779d12 100644
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
2.34.1


