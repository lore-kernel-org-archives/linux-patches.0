Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F696F2FE;
	Thu, 12 Dec 2024 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023650; cv=none; b=bNLtopq8ER5JPVQI7rbEYIpMgCBVGgNTygfmQDVJjZKZTSFrKChlWtgZTylAPldGozo+2t1xP5cAY9I23ismL6xPNveVTWAqBB6Gmxz9CyiEuw/1NwHY7ZbGBCdLmVbG5QRI1urNkYGf3se35rxbs3tMfBN9+njb2sq3coUnkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023650; c=relaxed/simple;
	bh=B7qybUifTJbwOyVKSVzgM4/kt+Y/kZJV1SOsNjYaskE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qI6Xo6bth2/aPgrFvNNYImCXp+1VSyhx63OqmACBGql19GMsjV6OLWx+d3vRF1+xc8TCEcMfTUUDe2oFytg88GoQfj6ZVYUoNK72MWzNsA+99dQbuk+6NMO0R3PkYidQiSW6+1y+bDSZVpP77L9Qlu4SwJ0VWhgDP9dTM7rr2y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqskVf6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqskVf6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2328C4CECE;
	Thu, 12 Dec 2024 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023650;
	bh=B7qybUifTJbwOyVKSVzgM4/kt+Y/kZJV1SOsNjYaskE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqskVf6ZQRs/m2uVKr43nxOS6OwEeUF0KhpuC3BW9GGcZwstgQWLXRytPVhDDQBdd
	 0N77CGlMsaNw5zka7MvV+ii9y+un6WoKiEQJTu47RPqR2ZazsuwspDTNi0rC3IHp6Z
	 RQX/b6ZOtAV1R0nidL+f5Ku2nwcP6KWwKwWa3P9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/459] mac80211: fix user-power when emulating chanctx
Date: Thu, 12 Dec 2024 15:56:15 +0100
Message-ID: <20241212144254.992760153@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 9b15c6cf8d2e82c8427cd06f535d8de93b5b995c ]

ieee80211_calc_hw_conf_chan was ignoring the configured
user_txpower.  If it is set, use it to potentially decrease
txpower as requested.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20241010203954.1219686-1-greearb@candelatech.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ae90ac3be59aa..8b3eead8989dd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -144,6 +144,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



