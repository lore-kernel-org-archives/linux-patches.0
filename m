Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97213C8C65;
	Sat, 17 Oct 2026 17:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258443; cv=none; b=ashDmIe+ejEcR9Wca/zHUMj7AE00f++iINIiWgQT4/N+DDHlNGbOS7gdhyIOAZ4Dj76mfN4XNIHl7QFePCnsYfogY3WqcREc30JQzFn0JtTh2t7nyRu+QTiHBjgC/6JsvpN7GpKO5qqE3VR1iTC+5C6RRMkGOFExP1eZbWhj2AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258443; c=relaxed/simple;
	bh=bjv1QLQO4cmojpVXlJbXexhwRyfnqxDZwBbUEHnl6J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8QmWfxxhBGeWR0wC6a8HW+Vg/b8KgpcEXjn5Has0t0yj02ixxzMKx+Ta5rWxeVptSSpvvXovJZ7z+H9xN8xHkyyYXyy6M9DMb0VgYqI5i1lPrdvMlhrrEInJtm9BxN8K/ngCOZuiFzx//HIGlnFkDeMDa68XiI6VFY1V2HBF2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iF4rqIYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iF4rqIYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A31D1F000C5;
	Sat, 17 Oct 2026 17:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258442;
	bh=fUPMSwx9tc4h2/vKko1tvjphbSS+xrpaaWnqmiNivQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iF4rqIYvbGk8s1Tk1iJ4xdjAzirHbNggxakvDogMyfAoKzHNxoNNxhEJsv08Rn+C4
	 5SwODpY9YPIGtd01I6C7cNAMLWkd/nSptqRHWni3gffVOn8vHSrZKLwBm855gCAhi6
	 /XXlZEXkAP2wgcfYN2pjXqhMbJhx0k85x14Th1EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0846/1674] wifi: mac80211: dont WARN for connections on invalid channels
Date: Sat, 17 Oct 2026 17:51:58 +0200
Message-ID: <20261017160452.840549467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 99067b58a408a384d2a45c105eb3dce980a862ce ]

It's not clear (to me) how exactly syzbot managed to hit this,
but it seems conceivable that e.g. regulatory changed and has
disabled a channel between scanning (channel is checked to be
usable by cfg80211_get_ies_channel_number) and connecting on
the channel later.

With one scenario that isn't covered elsewhere described above,
the warning isn't good, replace it with a (more informative)
error message.

Reported-by: syzbot+639af5aa411f2581ad38@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20251202102511.5a8fb5184fa3.I961ee41b8f10538a54b8565dbf03ec1696e80e03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9f67290e7fe58..c085cfa5273eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -452,7 +452,10 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
 					tracking ? 0 :
 						   IEEE80211_CHAN_DISABLED)) {
-		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
+		if (chandef->width == NL80211_CHAN_WIDTH_20_NOHT) {
+			sdata_info(sdata,
+				   "unusable channel (%d MHz) for connection\n",
+				   chandef->chan->center_freq);
 			ret = IEEE80211_CONN_DISABLE_HT |
 			      IEEE80211_CONN_DISABLE_VHT |
 			      IEEE80211_CONN_DISABLE_HE |
-- 
2.53.0



