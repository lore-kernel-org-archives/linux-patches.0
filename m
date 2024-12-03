Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE051F7070;
	Tue,  3 Dec 2024 14:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237578; cv=none; b=BZY0hLQHxyN4quqEnqD4p5WK0lhKZCgi/XKCUwBKHjBKsqM5pkNhTWQQC6BXhlqlI035clwwDS5PCEyRjYRxfUgsoPdj9xeTEf+nFZZme5tU9iIsWRQvSgGmdm10LroRhdPPwuQ29er7hmDdoTwTc/Eo69B5stRHfTSD2O81Lio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237578; c=relaxed/simple;
	bh=EkNlMjDSEX+DluIiCufjT/CnDIaEntpU4lR1yC7E+qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU5GnTpMmh5KX7ZwtyfWuiKP4pe3uFNH3ELYbPD2J+wRKKXc9UL2ptOWfCQoHTbskW3D6b+1fGZLClaPxASGA3nSfPpjEnAk6o3KDpSSt/EzDZIpPquMGwsIWmhxQyHkf6YbIGCCxlDyCq2fFiphYwY+0RpS3Jf+uPVAyvGoT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gz+Rh7Sd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gz+Rh7Sd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6EBC4CEDD;
	Tue,  3 Dec 2024 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237578;
	bh=EkNlMjDSEX+DluIiCufjT/CnDIaEntpU4lR1yC7E+qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gz+Rh7SdexIh7wAg4OGM7C172g06MUxsTBbYkcuMyLv92rai79gYMk7H/kbyElNrw
	 yMfikQt4EJMl9pQYqxtn40gIfRS5gXoeHiykt9E4JvM5HLxXPztKX2K2qP1+Ss3kMv
	 FdkEHfi5XIChbzneKcdA98iF+BpAa/Bprdefl6jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 012/817] mac80211: fix user-power when emulating chanctx
Date: Tue,  3 Dec 2024 15:33:04 +0100
Message-ID: <20241203143956.114604885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a3104b6ea6f0b..9ce942f3a4a4e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -167,6 +167,8 @@ static u32 ieee80211_calc_hw_conf_chan(struct ieee80211_local *local,
 	}
 
 	power = ieee80211_chandef_max_power(&chandef);
+	if (local->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(local->user_power_level, power);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-- 
2.43.0



