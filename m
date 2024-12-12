Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6C3217F40;
	Thu, 12 Dec 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018774; cv=none; b=ktB2FQqcwwX6RCGHp5Gx3u6Spgq+Ql9yFzmisOWDqvVRMMH7WjTqTBfxzsrOIOF9zV72liIXBYLhCwBix81cIXw3Lq3PWP+41htCG7ld5nrbW/8EYYCAkjEbRjoA2+qLS7dgwk4NSXKb9F+BxNc0Gydho77Ff5AnBLYustZdonw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018774; c=relaxed/simple;
	bh=6SW18GJJC5SkmNOx6KSEl5aqm6/0XMS2fFuKMl8fOAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u49dnLycOoRt4uEodGeUaZiC+mDpkTwv4lHPEp2FEEn6Mu59lqcuBGufzpU9pflexQNhpBjhXPqt+O8DQbxvaZWU6IjLOxTaV/USdeb6SpupokfJIyEwauQHzpelO239kgwXKXDJYoEOtAyikGlYbX4pki6aV/GLoyQLqSrMRCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+Lp/54J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+Lp/54J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF937C4CED0;
	Thu, 12 Dec 2024 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018774;
	bh=6SW18GJJC5SkmNOx6KSEl5aqm6/0XMS2fFuKMl8fOAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+Lp/54J+dPfebC4jbnsPpA1VncZlulkrnfU2l/iJin15B5E6eVCQTAFamzsNFja6
	 GUburP8CqM4/GS5NxU7al8A763covKSx4iwZXYOTBcjSS4PV3DMO8EZZVQBsOJHPCl
	 dvzw9UQg8HAqDlMgsLbF4EAeXe0asYaVoKBECx14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/772] mac80211: fix user-power when emulating chanctx
Date: Thu, 12 Dec 2024 15:49:10 +0100
Message-ID: <20241212144350.035489119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1eec4e2eb74cc..683301d9f5084 100644
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



