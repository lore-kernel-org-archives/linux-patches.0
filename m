Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902772E49AF;
	Tue,  8 Jul 2025 17:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994125; cv=none; b=epUFY3d5xgJUQOnRHTqRejOaAQit12vHk3HccreFzN8C06vmZ8DDZMYfGaxHYuYGq5il4rPrFT0CBh4Ni5AKvLTZgObID8Re+10wAGZ18TJKz8oUry4rUON4PeB+rgox7XwyT4YqRjLr0+9PX8hNx+DyqY5X9vEBCqX7SbFBd6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994125; c=relaxed/simple;
	bh=qvZmaN+jD/kcPfMLTFtPBm2MAH92EYjRxxkArfIN2uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGEMnAXml+T87Amh7lhaqixXysRP8NjxQUcZ2YMhGFR3Z3OThdpxi9GM0UQxoVG9JDCYTJ26I1UZBOnJf7M9aVtMMrVPLjkgtC1OF3g42bq3tF5UTNok5jA6ofjsNpJ6Ay5h5nOEweNcYH8Mgm/8ZRYWWchIYvAexwZIZ1yr910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLZbcCEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLZbcCEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D130C4CEED;
	Tue,  8 Jul 2025 17:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994125;
	bh=qvZmaN+jD/kcPfMLTFtPBm2MAH92EYjRxxkArfIN2uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLZbcCELESdeY2zxYM/5lq/81NWwPLNcEPDZYuUuJubyTiftJAoEgbjvSt+Wb0a1k
	 GFxjEoFkqJlSdpldNqZiJdLLdAZmBMlsk7S+9ehxtE82dt810ULtSwrE8SQ20JdpDp
	 OV1s1ceibtY3qFcOCE9/5kuV5dPUIY+UwhcbmflQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/160] wifi: mac80211: drop invalid source address OCB frames
Date: Tue,  8 Jul 2025 18:22:49 +0200
Message-ID: <20250708162235.057989099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 26943c93f14c4..6c160ff2aab90 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4168,6 +4168,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
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



