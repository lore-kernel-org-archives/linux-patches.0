Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBB71F470B;
	Tue,  3 Dec 2024 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236408; cv=none; b=pdA5gGJEnG5A/BW9+zhRlCfuJV20vzXwzeo8JD7EoncN2BBylCLq4n2ACq9ouhBAe/i17DsBOetA7FfxDaYVKx+sncHDVTrLfavBOrTTKvJoQYitYcBle8o9y1aTAGrN4QKNHMpMCsFTUYFZVzCNfsJK489z8Sv9XVKfYw+K4Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236408; c=relaxed/simple;
	bh=Mq8jK9szGMq5tPpRdayk7czjMaG8DYlA/HaTfUIqop4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKsrzavdl3T5hGTJ4jjzj11I36/dUBYygqtswYS7IofJt3FreX7lZmswGZagNPjfDA0ZIKM1pSr88cGnF4FmeO3Ac8kFs9Fz8uUE07NCOGha+R15EaOiVIpKYZ204GF561a0hixGwwKaw9jNCvdhslhBfYfkL0TIywGiXQ7vElU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xE2kFPn2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xE2kFPn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A53C4CECF;
	Tue,  3 Dec 2024 14:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236408;
	bh=Mq8jK9szGMq5tPpRdayk7czjMaG8DYlA/HaTfUIqop4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xE2kFPn2eEneUW/ZVbB19CeIwz26a38xBRs6YEo+DJw7sIDPBfkXTu4E2ky4pSWCq
	 db/WUBEBBM2Cj7kRdQxzuSATHHrMDPePeRXA0k/n6Xa02HrBaQOrIwSVAAxHbKcDtv
	 utNQSJuhlQ2Zqg+5QhjRSyoQ9JVh40S+48o5K+cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/138] mac80211: fix user-power when emulating chanctx
Date: Tue,  3 Dec 2024 15:30:40 +0100
Message-ID: <20241203141923.972570527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e8c4e9c0c5a09..71d10bdee4309 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -140,6 +140,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



