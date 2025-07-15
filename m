Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750E12E49AC;
	Tue, 15 Jul 2025 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586547; cv=none; b=pfEFkZiUcfhaGrLTSLagRcYXXNphdgW9Oq+bq7WwpLHLHqyf+7cQOuBSvwvuHoq0Fd7mvoQs6RR9ZnANKA8XMZjpCu3W0k5LOhq9Riw48Fp4AeNd5TIcJSv2T1PHYN5hM1s1lxS7OMMlttRTPKAtQFr2rcf2HJ9vPLNb9fPXcTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586547; c=relaxed/simple;
	bh=h4icVeQJYDJn/pAkQ8l4s78yomGMq784o1j/tIwGDKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk6upWqqD/ExhuOhOCaljYG0/8kBZtU6hXXtiTTKhj/R07KdeIBE2TExEpPsqfkQn/kwlcjYlZRk0yFDh042BjlRQp6SApDIAmKDNzSzEoj3lsegWxhWqhP8qTjiZfwbtXJCNnvHbGmgPRfS7+Mdd8pQ+SpYGy3NP+ZV68b9AC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gq9JiCwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gq9JiCwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB880C4CEE3;
	Tue, 15 Jul 2025 13:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586547;
	bh=h4icVeQJYDJn/pAkQ8l4s78yomGMq784o1j/tIwGDKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gq9JiCwQ6En9fKjt1WnhIBfez3aXDXyzkfSZobYVta83c1ajPN75VUZJN9k/C3iIa
	 CHns3acTYSAX8rFipC/rOcCY2xYHqcNhOXLJzSDcTTyJuePITmfsq9M7jUjbsm7OMr
	 yKp3fhYtVmJ8PfZJQi3p4iZtBLy+gu87zkjal0mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8b512026a7ec10dcbdd9@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/148] wifi: mac80211: drop invalid source address OCB frames
Date: Tue, 15 Jul 2025 15:13:17 +0200
Message-ID: <20250715130803.324868176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 99d5f8b58e92e..4c805530edfb6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3982,6 +3982,10 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
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



