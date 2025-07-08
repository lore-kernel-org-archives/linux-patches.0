Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78D82DAFA3;
	Tue,  8 Jul 2025 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993640; cv=none; b=kZuyzC8MvW5svUURa8nrASHk6Hzus713NimcURbl6bcdUv9iwsATiRoudi3ix6uKIrP3ztgXwfiUV+svmOi+kv2BWSk3htYr3Jx42OFknPVojcEyrmLGONw+P1RsjEaaFppc3aBGHLyZKVqLg/W1WM6cldHOiRa5pBs5HdsYQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993640; c=relaxed/simple;
	bh=0wZ2vreWAhGymFsym2k0cVHxMWvZV5s+9KUCd1O9SwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkCmkdFQ2BOmBVE0FIDcYtMoU/QnrG/6hW5p0m7h7IZb28EgMhwXdx8+5BrHPvzMRKhvMdATJNRDw3oka8x6NgS9ZTAsRTkq0oZleQJLL/zROR8KCZl3UtR5HGbAat6eYbkLYKPEJjytCK8+DdSSHd/nujMTGN2jbf4fji7YT24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+4Vj4ZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+4Vj4ZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A31C4CEED;
	Tue,  8 Jul 2025 16:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993640;
	bh=0wZ2vreWAhGymFsym2k0cVHxMWvZV5s+9KUCd1O9SwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+4Vj4ZRETZSkEdHsdY8xMGikZSP2becN1Y4CaV8NGzkg5lfryRs3m/Kh643WbqLg
	 CT9iy2neZ7UajnhaAYzCtcMmZD/MBNK48Zh+T7MXFUmTgJdC6T27hcJ9J5xtk+Ukxo
	 8XT0CE4toIgopTyUru6jjAD3jl0MZQibsyB1hPJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/178] wifi: mac80211: drop invalid source address OCB frames
Date: Tue,  8 Jul 2025 18:22:53 +0200
Message-ID: <20250708162240.106184157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 09beb65d6108b..e73431549ce77 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4432,6 +4432,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
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



