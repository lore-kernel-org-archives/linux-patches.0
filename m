Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790221E895;
	Thu, 25 Jul 2024 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918883; cv=none; b=dfs4cKF+hYjcqfCv1cUuVUPU19Eis6AWEFjTR2qpjHbMzOy3xG92DOJFFsw2nDRV1jiNKP+1XAuXzgUPiuXGJ6K9vmjxdlB5LkEaZkddywJM5K9rWNQEoFVDunIdhKC9GZOWcGDZNjgWCgHu/XTVNWT0SHtBEVn4k/3H8cwVOO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918883; c=relaxed/simple;
	bh=N8o6B+n0icmMuQdhX3GdBhNy/+haXmedepCAg5DR3XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9SwNva1fnavxR+w3XtubD5OBwU+lmQLzVVdeCXvTgET8olSJ9cHIvolc/Nz458iFtM4ZPjrd41d4Ew3s9vKZqna3GV+mMS3Ec1WHCAXPsNQzM/bMJBD1+uKobtjwtOoIlxlbud0tzUIZv8WojtV8Kyser8eO8rcGcwgjKz2Opk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft5o+yEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft5o+yEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA3C116B1;
	Thu, 25 Jul 2024 14:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918883;
	bh=N8o6B+n0icmMuQdhX3GdBhNy/+haXmedepCAg5DR3XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft5o+yEaPgba46YCR38U5C0SQ4+zpDWitzHZ3kQLvxPet1FqBgypA5YONP9kKf389
	 NexaxygaOOn6lSwgB3hhZjx6ww0/m3Se1uTrQyNSNZEftJgMZ6D8GSVMaIUtEZiFKD
	 dbuMi61XL8pM+9InyCxGSlQInOYfrcN27QW/KrqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/59] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Thu, 25 Jul 2024 16:37:08 +0200
Message-ID: <20240725142733.952032153@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a6c289a61d30c..76a27b6d45d28 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2772,10 +2772,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



