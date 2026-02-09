Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665F137BE88;
	Mon,  9 Feb 2026 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648501; cv=none; b=pV4GDEbY6FT9LWwZeTZvZPS0SGc2hdvitcaZZA3BD+mhrn9T4oOby9AThwBNL4KGzUAhffH+BxafjyHKhPlVE765Mi5vFOcG3ocmDmQn4famU52SFDMp1/n+xnBNP+XiqzM7eCyfZ8jy97KYNMV6EOhFt1WUD8+Y4FsKTsLLXGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648501; c=relaxed/simple;
	bh=+GWyBkwlprg9tAakZyiA+A7YuojhDRYV3+ATB70YNqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBn+0pjtmVud6tBocmyEehsp2EImOLf9S5b4smrJMXyK5qPzlrLXPLAv7fQZA57+grS+mk/Xc+fSg0l3hMFyqvfQfmrlW0FlOHgytKLZkCzVUtcn7Fg+/jzhw4FgRAAJS1i7ChzPl8vMxGNqr/cn8f/JFbK5bvpZrGsGWB+C5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ty9tZh0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ty9tZh0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B91AC116C6;
	Mon,  9 Feb 2026 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648501;
	bh=+GWyBkwlprg9tAakZyiA+A7YuojhDRYV3+ATB70YNqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ty9tZh0z5qWpxsHOknOWCQxJ5WQ0AQ8kW+CsMu04gYTSuO9LYejwCP1qBgRLjrkm8
	 atlrQpuqsiCXXdfDkcqDGLbdoEqIcEtLTYartwkelnzVH4bD1XroV2SdUZXmY0uGub
	 /pjS7/YK2AwqKze4F65/VoNvSZ2+cP9VDRRHIgfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 55/86] wifi: mac80211: dont increment crypto_tx_tailroom_needed_cnt twice
Date: Mon,  9 Feb 2026 15:24:18 +0100
Message-ID: <20260209142306.760480777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3f3d8ff31496874a69b131866f62474eb24ed20a ]

In reconfig, in case the driver asks to disconnect during the reconfig,
all the keys of the interface are marked as tainted.
Then ieee80211_reenable_keys will loop over all the interface keys, and
for each one it will
a) increment crypto_tx_tailroom_needed_cnt
b) call ieee80211_key_enable_hw_accel, which in turn will detect that
this key is tainted, so it will mark it as "not in hardware", which is
paired with crypto_tx_tailroom_needed_cnt incrementation, so we get two
incrementations for each tainted key.
Then we get a warning in ieee80211_free_keys.

To fix it, don't increment the count in ieee80211_reenable_keys for
tainted keys

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260118092821.4ca111fddcda.Id6e554f4b1c83760aa02d5a9e4e3080edb197aa2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f5f1eb87797a4..327ae73434517 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -981,7 +981,8 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_sdata_running(sdata)) {
 		list_for_each_entry(key, &sdata->key_list, list) {
-			increment_tailroom_need_count(sdata);
+			if (!(key->flags & KEY_FLAG_TAINTED))
+				increment_tailroom_need_count(sdata);
 			ieee80211_key_enable_hw_accel(key);
 		}
 	}
-- 
2.51.0



