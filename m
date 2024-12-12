Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592A15696E;
	Thu, 12 Dec 2024 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025066; cv=none; b=VRbfaHj7PB9ViT6lfiw6wXgh4gNshtGwJ9MKpTnkC0ElswGt+VkavaZMHkTzwm1V/cOPtjv9rX84oFnPtBqH1/e9j163AnIMXZ+PJL7HojxuJEPV+sq3fdbmraV/EgpZISaJTNxE9AufEOoX4lRVcl7ffk5KrCavnQYccOiXD5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025066; c=relaxed/simple;
	bh=44fa8i/KS/LQShYipazYmxt9ok3yGZl9dE/PsOym9eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGB7JVPnG1q8j7e+b3m/4FIOs4zeUSj3K2e3nysRLmGW4Z2IJVC6FCRYNGEpTcDO8BCKTvjDF1nWn0WjPcjMhTDe2HE94ChhNIkbGYm2ycCLGfYoAnikBUMv5x+5hw8KAq6yvfF4oHAHAzumJm0fRONm/8bkDIeENM+ztwVnNx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfJ7TUfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfJ7TUfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBEBC4CECE;
	Thu, 12 Dec 2024 17:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025065;
	bh=44fa8i/KS/LQShYipazYmxt9ok3yGZl9dE/PsOym9eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfJ7TUfhm65VVHnenWANFCUAb2P+8foygFW/NTnkkFlfuL642PRk6Oc4WjdiBvfaG
	 /RSDW89jxK6+4QKmENzsZfLMyRHRNlMCc4r8mp0xPl2XzC6PRGt29R4tutBr61HKFH
	 HONu6gtBc5jajMmKQ+gd2Sa0UuaDQ5eKB2TUO6aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/321] mac80211: fix user-power when emulating chanctx
Date: Thu, 12 Dec 2024 15:58:52 +0100
Message-ID: <20241212144230.211064508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index fa2ac02063cf4..266250e9f0330 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -139,6 +139,8 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



