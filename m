Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09572A1BA;
	Tue,  8 Jul 2025 16:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992449; cv=none; b=XF7ZUL6oxU0SKCgERLZTtlGCCBOGlQXInaitHEb0ITi+Z3jcoxhY+7DAh/WfX8E5tSago78m4cLnyRhOajKGMMAIR+vYBl4Aacb82UAqInYaJ+qxXaeXI6OJ6OSw5P1K2jEHkKP4XZGRbWdaNljDrNKuuQdKn3V4+QoSjMP7rsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992449; c=relaxed/simple;
	bh=vxktG16dM5cLJPMSja3YDtkwgR2wcI3Mfgp0BphAf1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ue+soAL60srchXfEEKqOSjPu2yu9KYDx7i/Z5k3j2Z1E6+l7Z1ajqRwt6EWrdyKUpcTuGFAmJrywrAvNhnDjJ57WNbos8HGup7rdxVn5Lq5kcGS5WMxjkgEod+l13Gg5wzD3w1vxKd5lNX+/cml5rjZ69ChXNpSdsCvRAhh+xyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFJ8MoNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFJ8MoNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291D9C4CEED;
	Tue,  8 Jul 2025 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992448;
	bh=vxktG16dM5cLJPMSja3YDtkwgR2wcI3Mfgp0BphAf1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFJ8MoNOX10rZYvidC0Iyg5KTieaf1rAc3EDgV5Z/Ht8jmHAMiPjBKhgYT/twYY7w
	 a9+9e5zd7RsjLWBBfpp2yTlcFBjaaEiYDCzN0jbJhGkSvXE+28qq/mmhHY8SmYr2sL
	 M8mtd9X5hY3hLjEs0kSwqx9jFA2aT9RZdiPC1hNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/132] wifi: mac80211: drop invalid source address OCB frames
Date: Tue,  8 Jul 2025 18:23:26 +0200
Message-ID: <20250708162233.394446411@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

[ Upstream commit d1b1a5eb27c4948e8811cf4dbb05aaf3eb10700c ]

In OCB, don't accept frames from invalid source addresses
(and in particular don't try to create stations for them),
drop the frames instead.

Reported-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6788d2d9.050a0220.20d369.0028.GAE@google.com/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20250616171838.7433379cab5d.I47444d63c72a0bd58d2e2b67bb99e1fea37eec6f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5eb233f619817..58665b6ae6354 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4419,6 +4419,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (!multicast &&
 		    !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1))
 			return false;
+		/* reject invalid/our STA address */
+		if (!is_valid_ether_addr(hdr->addr2) ||
+		    ether_addr_equal(sdata->dev->dev_addr, hdr->addr2))
+			return false;
 		if (!rx->sta) {
 			int rate_idx;
 			if (status->encoding != RX_ENC_LEGACY)
-- 
2.39.5



