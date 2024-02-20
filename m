Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99B152DF4;
	Tue, 20 Feb 2024 21:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465157; cv=none; b=PSFip0SKxK2js5Nfe0aFxwzCxqFkGESawtHoOtGHyUvcTapOk3p3Azcl4LI/XRwUdnUIebeGrSzRO0Z77BqxU69IpBbDhDQ86ulHe1YYb/nvMqbx8YEb/Hxqv7EeLTSXaR2QVkZPRiunOIHB4QgdNscsw0v4aw2h34R7mV03bLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465157; c=relaxed/simple;
	bh=yUx0B+EyJTpurDIS3NjvAL13wjl4/u6u8vYroWyinqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3774VlR18MjIwKurHI7IE2Ty45+44Flks0AIRQIEVZexHw4jVN7yTy+BYHyoqBduIRarsz3bsVg4eGzGzoSRG3f/BrQALzJJdQupZYKjCNySRmSmLiDQh1Yxei9i7dHg/e3BBugeBD7kqa/mnr9nFTTuXdA+Zrmi7aWjjeXZ88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsUUNtRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsUUNtRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFD5C433F1;
	Tue, 20 Feb 2024 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465157;
	bh=yUx0B+EyJTpurDIS3NjvAL13wjl4/u6u8vYroWyinqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FsUUNtRWNb5GgimmcVFZZQ30IFahA04EDcFGOl+yaROwG1OF3CtnEtqYmWzEboFym
	 IR8ElpqEj7RXYHj758vKzCdKf/OYubsX1eKl0X5PLOpjg7UQSbA1jc8hj6g2NZ4igB
	 F2FC+HMRZr7BzwMG5XoA7UR9thohEcdkaC491/4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 253/309] wifi: iwlwifi: mvm: fix a crash when we run out of stations
Date: Tue, 20 Feb 2024 21:56:52 +0100
Message-ID: <20240220205641.083597578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit b7198383ef2debe748118996f627452281cf27d7 upstream.

A DoS tool that injects loads of authentication frames made our AP
crash. The iwl_mvm_is_dup() function couldn't find the per-queue
dup_data which was not allocated.

The root cause for that is that we ran out of stations in the firmware
and we didn't really add the station to the firmware, yet we didn't
return an error to mac80211.
Mac80211 was thinking that we have the station and because of that,
sta_info::uploaded was set to 1. This allowed
ieee80211_find_sta_by_ifaddr() to return a valid station object, but
that ieee80211_sta didn't have any iwl_mvm_sta object initialized and
that caused the crash mentioned earlier when we got Rx on that station.

Cc: stable@vger.kernel.org
Fixes: 57974a55d995 ("wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240206175739.1f76c44b2486.I6a00955e2842f15f0a089db2f834adb9d10fbe35@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |    3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3673,6 +3673,9 @@ iwl_mvm_sta_state_notexist_to_none(struc
 					   NL80211_TDLS_SETUP);
 	}
 
+	if (ret)
+		return ret;
+
 	for_each_sta_active_link(vif, sta, link_sta, i)
 		link_sta->agg.max_rc_amsdu_len = 1;
 
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -505,6 +505,10 @@ static bool iwl_mvm_is_dup(struct ieee80
 		return false;
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (WARN_ON_ONCE(!mvm_sta->dup_data))
+		return false;
+
 	dup_data = &mvm_sta->dup_data[queue];
 
 	/*


