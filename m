Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C2914B080;
	Wed,  5 Feb 2025 13:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763911; cv=none; b=AyfliswJSrCm6/Df8fOjH5d7lpRY/z/0ufTpxW6tGFA9SyeYGL/6v4WKRpyb7A1qAqAwBPFaYKKdZm16cMsbk7C6DOdUCL13I58uxcM5J8qC/xHFAzO/e48R9Xgr7vzOADiFOA9wQWJ3PS17Sbw/eX2V9ZJBASNgAKZku+aR0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763911; c=relaxed/simple;
	bh=TtiaqVKjXHRiAwHW6cts3BvdqSnyRvVKzw2Nzs0EQJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjqFy3f95/bq1ALucBU3Yw7A0sZ7O4T2jDD9/PWJ9cUdfqPaETG1G4c6vxOcoOxSLtzINisw+m7eCtdV9ZbzQ7thyMJcdVmQl7D5BHDEBCBHIVPQb6YeLiYwHyqM5FyGuKjQ/Pju+AO3Kzd0adp7PUvWUSmqCJNWx9lnbB98D60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ER6VN9iz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ER6VN9iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2D5C4CED1;
	Wed,  5 Feb 2025 13:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763910;
	bh=TtiaqVKjXHRiAwHW6cts3BvdqSnyRvVKzw2Nzs0EQJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER6VN9izV+Ka8EhbMFbfaQBBL9p5OcJss82FHa42rSdBVoyAQE4lCi50WwzsyQIOK
	 c+IjtOl/GjpeIjAERORrwT8+hycGVc/Wm4c56VktG2Rr3R5uVy/8uyHbejd9TFOI1A
	 moGhVyUUPM9HF28AQa/5S+Wq7lmvlV2Ya78F/GGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/393] wifi: mac80211: prohibit deactivating all links
Date: Wed,  5 Feb 2025 14:40:28 +0100
Message-ID: <20250205134424.467752359@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7553477cbfd784b128297f9ed43751688415bbaa ]

In the internal API this calls this is a WARN_ON, but that
should remain since internally we want to know about bugs
that may cause this. Prevent deactivating all links in the
debugfs write directly.

Reported-by: syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20241230091408.505bd125c35a.Ic3c1f9572b980a952a444cad62b09b9c6721732b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 63250286dc8b7..d6938ffd764ca 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -616,7 +616,7 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 {
 	u16 active_links;
 
-	if (kstrtou16(buf, 0, &active_links))
+	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
-- 
2.39.5



