Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4746F391832;
	Wed, 23 Sep 2026 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174235; cv=none; b=n3zsy8IOAve+KdJVhmJPR7dtpsM2oxvWW4UiBu68/u04F1JUnC5HcSNKtpgn9MotMprUJeglmao6q3HJi9dpN0+0ZZzPj32I6vuOQX01Pdy7XC0LudY8t0aaPTk0lUNNy+MxRV/Sq7Aklr2/vVNGAJf6PUOJgF/oGJNmB+CMQTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174235; c=relaxed/simple;
	bh=PPDEbF4+Dq1/26C8DPXXfkEU7Ci3PrDTqEms1ny/qFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0SM3aXwYDZDx3qECGZpuTte5o5ILrYHjYkBSdWq+OA2j6alpJQjYIIDOSmEQcDgyLCmVQRioUBRIhNjKX49caMIxAhd1yP7FIivvwAFI5y6AmrD2uKQXuShv9TPQZ9VJ0u51qTGu23EtlPd+Soj6BRMOzTIpXXcOYa6mXMFrEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKDqoRpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKDqoRpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9811F00893;
	Wed, 23 Sep 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174234;
	bh=hGNxrrT/bkUeZLpbMwDrxqfjt3Bum8rVmaDNhJVEcSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKDqoRpTb6QBvmo9fVis9SSQCe5vRLwJLDu7N7q1uNGIFSZD29YDVgG31CQxnOu17
	 UmGVSIeGSQM/jpRyVjmObkh+iEx3LgQZDcect4IsARe6mSXVeRDGlDrtlO5zywoyvS
	 LxJnfSzBjPOJYUDcsiU3AOkv3I2RGTH1bH6iRDLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/398] wifi: cfg80211: dont get the radio mask for netdev-less wdevs
Date: Wed, 23 Sep 2026 16:02:05 +0200
Message-ID: <20260923140644.743432942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7783e585360ee05dfe21d3173dbbe985c94f29e ]

cfg80211_calculate_bi_data() calls rdev_get_radio_mask() with
wdev->netdev, which can be NULL and then crashes in mac80211.

To avoid that, invert the order of checks since wdev->netdev
is always valid for beaconing interfaces.

Assisted-by: LLM
Fixes: abb4cfe3661a ("wifi: cfg80211: extend interface combination check for multi-radio")
Reported-by: syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abff43d2d045e37c0bb2
Link: https://patch.msgid.link/20260904165614.2056a8b7dc91.I7412c5062d8166ad6c81ee7252cec49dea19a60f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 918d8f8468bdb..3a60dfca77236 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2385,16 +2385,15 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
 		if (wdev->valid_links)
 			continue;
 
+		wdev_bi = cfg80211_wdev_bi(wdev);
+		if (!wdev_bi)
+			continue;
+
 		/* skip wdevs not active on the given wiphy radio */
 		if (radio_idx >= 0 &&
 		    !(rdev_get_radio_mask(rdev, wdev->netdev) & BIT(radio_idx)))
 			continue;
 
-		wdev_bi = cfg80211_wdev_bi(wdev);
-
-		if (!wdev_bi)
-			continue;
-
 		if (!*beacon_int_gcd) {
 			*beacon_int_gcd = wdev_bi;
 			continue;
-- 
2.53.0



