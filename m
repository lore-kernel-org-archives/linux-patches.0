Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3BB34AB12;
	Mon, 18 Aug 2025 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525712; cv=none; b=pPsTjqHY1vzLJ01QOhNBSR3xtsMZ+qIWzle5L3/wi7qfL/5wVyfijfdE12Z9H5kiXs2QlDtSncigzszGkbrYSb7gQuJyKlLGqIvqIUch+JYT+WMh4ZSauLJB+Un9cgi3ZylTA/ywCmRYj7ajQ4cD/Z/sKJnVFSXA5NMDJRdunTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525712; c=relaxed/simple;
	bh=qpNr2lYUgwdV5L9OphLOosRdQYAZIyjdBaA7RFGG9ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlAg91qNyS4XJJjCEKrnHqGsmaJvqd4ACYojKO6DJCKt+2xoqbW5fHYDY5Lpgv25YiHUjo6nbOYG0AF+A9mDauek7I9khvUOTyM7BrMujOXSBOhyKEudxiJd3sG7N4IW1aXXUCgudrBBuZAMVLr9d/QMiOM9ph4i4hBZWmfSKuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyuZ4aVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyuZ4aVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AB6C4CEEB;
	Mon, 18 Aug 2025 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525712;
	bh=qpNr2lYUgwdV5L9OphLOosRdQYAZIyjdBaA7RFGG9ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyuZ4aVUyCy52nUgH/Sk+mj4kzIk0iO9iCwIAS+gt+sh/g7Pen+6eP6BhHaMxnlX9
	 Zt/Bn8TQ2YzmqJbny3ZRRZnaagVfOLOulsmIn4JF0elwL+Au/3tg5dmUIgb6OPXRmV
	 sooFFHgHxwQzPiJLNM4VeSHfyU96ey5LBC5VsVkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>,
	Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 312/570] wifi: mac80211: update radar_required in channel context after channel switch
Date: Mon, 18 Aug 2025 14:44:59 +0200
Message-ID: <20250818124517.886332648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>

[ Upstream commit 140c6a61d83cbd85adba769b5ef8d61acfa5b392 ]

Currently, when a non-DFS channel is brought up and the bandwidth is
expanded from 80 MHz to 160 MHz, where the primary 80 MHz is non-DFS
and the secondary 80 MHz consists of DFS channels, radar detection
fails if radar occurs in the secondary 80 MHz.

When the channel is switched from 80 MHz to 160 MHz, with the primary
80 MHz being non-DFS and the secondary 80 MHz consisting of DFS
channels, the radar required flag in the channel switch parameters
is set to true. However, when using a reserved channel context,
it is not updated in sdata, which disables radar detection in the
secondary 80 MHz DFS channels.

Update the radar required flag in sdata to fix this issue when using
a reserved channel context.

Signed-off-by: Ramya Gnanasekar <ramya.gnanasekar@oss.qualcomm.com>
Signed-off-by: Ramasamy Kaliappan <ramasamy.kaliappan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250608140324.1687117-1-ramasamy.kaliappan@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3aaf5abf1acc..e0fdeaafc489 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1381,6 +1381,7 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 		goto out;
 	}
 
+	link->radar_required = link->reserved_radar_required;
 	list_move(&link->assigned_chanctx_list, &new_ctx->assigned_links);
 	rcu_assign_pointer(link_conf->chanctx_conf, &new_ctx->conf);
 
-- 
2.39.5



