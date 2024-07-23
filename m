Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7565942067;
	Tue, 23 Jul 2024 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759563; cv=none; b=t/2YxZwOt9mrcxqOhpl+GE9Be/PU2AJtnvGCtx0S12NBxMtuoZIMTghwKXof07UDn0BbICbPzGhgXGsMK+k8VXIk/HLnXpp/fz5aju5ZwfNKEE+XUt/TxlmJGeZ2oRNVsV42wiXRkI7VTP8M2UMnrQuTMgXcwJJLC/zPi8gM2MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759563; c=relaxed/simple;
	bh=yopVS5e5aZQz48xZUgVAX3NXG5XKsO3Dg/oTwGW0yeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7Qu743ZDIxZaq+IQjef0mjr79jQ6W28wq60uCX1M13vqu7+nl9fRfv+jCdEtoR7stbpj9M++KH+E8zkTOffIepnIXHfAKi46pFGTFmxjGQnmycqV5Jlst2U2aKJLif/w3M+zGeqDgx0D4bYOJIUppgX2UzfkpcRq9DwXcFcKeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7+62hjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7+62hjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC2EC4AF0A;
	Tue, 23 Jul 2024 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759563;
	bh=yopVS5e5aZQz48xZUgVAX3NXG5XKsO3Dg/oTwGW0yeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7+62hjJ7kIYMawednth7cCYyCPsjaLztVrI+ZXtiym1THy07APbum12betQiU9eA
	 MpVALd/VI1W4CkNgjwsgpJjD9+lnN2i2mhfNM3b9CzZNCcmqjMTIlXDRxlzEUDJ3db
	 Ps6mGppEsLZVrfcYR09jHyrSePpkBtJdRsFV5E4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/129] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Tue, 23 Jul 2024 20:23:20 +0200
Message-ID: <20240723180406.799058657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 6ef09cdc5ba0f93826c09d810c141a8d103a80fc ]

In 'cfg80211_wext_siwscan()', add extra check whether number of
channels passed via 'ioctl(sock, SIOCSIWSCAN, ...)' doesn't exceed
IW_MAX_FREQUENCIES and reject invalid request with -EINVAL otherwise.

Reported-by: syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=253cd2d2491df77c93ac
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://msgid.link/20240531032010.451295-1-dmantipov@yandex.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ab559ff0909a2..7fccb5c0e4c6a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3178,10 +3178,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	wiphy = &rdev->wiphy;
 
 	/* Determine number of channels, needed to allocate creq */
-	if (wreq && wreq->num_channels)
+	if (wreq && wreq->num_channels) {
+		/* Passed from userspace so should be checked */
+		if (unlikely(wreq->num_channels > IW_MAX_FREQUENCIES))
+			return -EINVAL;
 		n_channels = wreq->num_channels;
-	else
+	} else {
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
+	}
 
 	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
 		       n_channels * sizeof(void *),
-- 
2.43.0



