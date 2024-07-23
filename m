Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89F01586E7;
	Tue, 23 Jul 2024 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759240; cv=none; b=JUiwPFPwTz1Yt68dNGJHMrmultA5hfqmPlhBpJFK5igNOYNjzgI0bRuVGHc67hyPHJUuEiUUK7Q8b999d6XjfOCXpx63tkSXg6CTGf1rSpl6tvm/3W8/p2q58iosGqo420EtalMtvVcUKtYxyigqG+nYhPbAAQJUJGL0tsrjel8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759240; c=relaxed/simple;
	bh=zluv2H2WVPBThD+aCIRuHKqubch4M5vXhRL2nfFYhb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tustBw+K/Km99C25wlq7cq1fv3zik1yE9XZq0hyd/BvGdyWwubQxK6Zw2U+amzwt7k530MUCLCXF/XAFcF+gM2/aIK1EYZiTAY5VWYzXeGtCvbIt2RXdkIFyX5FleoXMVMS6ZuSGt3TE8pQG66Z4yF/ZmBHsfQBBAEs8h3byXcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwHsfKzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwHsfKzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA13C4AF09;
	Tue, 23 Jul 2024 18:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759240;
	bh=zluv2H2WVPBThD+aCIRuHKqubch4M5vXhRL2nfFYhb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwHsfKzBxkFO/ZMfCA6GMWUlAotpYYLsvnvM3b/VycyQsTRJl3urhe166weiG0sk+
	 cUpT6x6bwvOr02UKa1zdAGaN3cVhYNTJXGQOkzR6OP/fDl5/9Z21VvH0vbK4tIc01G
	 D+K/ycY1ZzYUcPqc81r1UucF2DyImHxVIjj7R1kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+253cd2d2491df77c93ac@syzkaller.appspotmail.com,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/105] wifi: cfg80211: wext: add extra SIOCSIWSCAN data check
Date: Tue, 23 Jul 2024 20:23:26 +0200
Message-ID: <20240723180405.141009722@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ee4ef32f39b37..af1d6f628c10c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2719,10 +2719,14 @@ int cfg80211_wext_siwscan(struct net_device *dev,
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



