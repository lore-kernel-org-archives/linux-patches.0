Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288DA19B5BE;
	Thu, 25 Jul 2024 14:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918416; cv=none; b=YTbU8ge0tzeXhytvgLswQmVpAoTwS6A241C1AgO8+SNczXohADc13zZwK8YPzXmvTqWPmlX9XjV8BEy0kIcfiXg9+Ygg7c7cEabemAUht/0XCIVa0YowO6q322XFDfdqmhNlJYaqHn2BuQMOxI9Z0WQ+Upxabiyq+AxLr17Mw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918416; c=relaxed/simple;
	bh=TawK+cl/P3o17roWmffj/iNXZY5cTDG+id9vAn6+zi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VejKsk7QVzBQwRhLSYDB7ot5F7AONQPrMXfqzR+/LNOtDgIvZvKLxW62+7jjFAsIK80DSgi/iH/ByGfynyE7JMqi07czZ8PmcbAvQGO7hZ34OEAr7HpS2BGPUcTbArGA+GRvAbkcNGvxCW3uDEX2nWugDHyb17tojKMLTlYmNyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyO5jJe0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyO5jJe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F1FC116B1;
	Thu, 25 Jul 2024 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918415;
	bh=TawK+cl/P3o17roWmffj/iNXZY5cTDG+id9vAn6+zi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyO5jJe04OFszyoE/yvOSm8NUKIohqySow928P0XTGH4FePtX4Dl8QTSu4JCnljZX
	 bbf7QLzNK6EkCsQViCreP3pGVOEbPeIOEqWc0cLchQdh3qqrQ9U2Yll81URuXNOTJw
	 zzvjjmdJpYvQqrIkrkIm5ID8xulwDgTN4VzHAnak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/33] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Thu, 25 Jul 2024 16:36:36 +0200
Message-ID: <20240725142729.022210563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index dacb9ceee3efd..0dc27703443c8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1405,10 +1405,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



