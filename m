Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0F813DDB8;
	Thu, 25 Jul 2024 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918637; cv=none; b=nvaF9Lb+wCW4feHNaC/t+LsyEIb1P23IcwP0oxprmXnDUGoF5a0CxOv0vxS+eZIV6C3KJN0PjIulQEdZ6KbxJUxnJ4Upx3Sj0DuAtuMk/JkJO00bPAj6vFZvq1b1KwkPigVFqrEnywBKyARqq484+BnYwecE132jMzyulweqYL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918637; c=relaxed/simple;
	bh=QVmeDQdY/ZZRtSV074e2DsSQbeG+ptc7rPVwlw1E2L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4fGvJn83Al5OUzwcitMnnFNBWJV0hvt9Mo91tICDJX2EjyVBCeqODlUVlax0KEtONFVUR7JtONjp2lrvjpxB+A1/UX3Dn2nN1efA3WuU7w/YFgFnmXdaGLKxUREUbjV0C2shQ12rAnE/sa9/VVcozh9bl59MhiP4/srwp/PjFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFpE7fZ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFpE7fZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8A5C116B1;
	Thu, 25 Jul 2024 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918637;
	bh=QVmeDQdY/ZZRtSV074e2DsSQbeG+ptc7rPVwlw1E2L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFpE7fZ28vqCIieebFpW1UBi8lK5AFffzlZXSb3mQAFhOywWWuWa52Oo3m3VF4eXK
	 /763Ew60RC76X4N52i+1UwvggtCIS1vcFHI0SnjH+KBHy6d7ARdfQeeojUMkQm122r
	 pf7gf2Fgs6Yc2IRCFQxZz486TT/jDA3fnV6NuK8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/43] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Thu, 25 Jul 2024 16:36:37 +0200
Message-ID: <20240725142731.012032239@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a1c53d4b6711b..c74882e3c3096 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2212,10 +2212,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



