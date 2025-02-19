Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA7F1BD9D3;
	Wed, 19 Feb 2025 09:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956235; cv=none; b=nt1DxNd5X0YtOMLXglO8I29fWoxsV8W1C/n3QSTVyBk212BdQOGaB+mdIi2RiIYY9RD0givvV9X/twkrpj2Em2jrGrbn3UCbN2PwhIVKznZiDhHdg8XYpAMF1P2c8XvCSwP3DV4pFwaNlBVOf4M+crSBasGznUywd2iy4rTWRDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956235; c=relaxed/simple;
	bh=pjw5HlXW7Qc6Csf2SKg9S1XuCW9VHGCZBCWRf/0mSsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh3Um342AKMquGw56sXcJN67v9QAHCCAEpzAmNWB8byCRMWQI0hXuaBQ98HMp3iDKIxKm7+qkeyKB2drh+2e9PUvv3UKgN0+xmWoTW4QiIvMIhEaTtQj1nmKmwHOLpyvg+xmW1CZIoelmgnRuHMmuIFjwoUOj2N/v9LkHQ3WZzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sb2AAFl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sb2AAFl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652B4C4CED1;
	Wed, 19 Feb 2025 09:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956234;
	bh=pjw5HlXW7Qc6Csf2SKg9S1XuCW9VHGCZBCWRf/0mSsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sb2AAFl3gdHFNxBS0zo6tspAhHqlti/lU89fqIvZuDxS/mwz+yvyX3/CVgHtqJlYA
	 ekI7QXdKdutbVbKWbnO/eM45J3oelcPcT3z/EAlhgOXc+JxLfIMU8ccxK1PAdxaQ5h
	 kiSGBG+487mD3S6VBpZHYaYverolT2lJ2hdA2lU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c5d8e65f23569a8ffec@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/578] wifi: mac80211: prohibit deactivating all links
Date: Wed, 19 Feb 2025 09:21:23 +0100
Message-ID: <20250219082656.064756394@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8ced615add712..f8416965c2198 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -588,7 +588,7 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 {
 	u16 active_links;
 
-	if (kstrtou16(buf, 0, &active_links))
+	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
-- 
2.39.5



