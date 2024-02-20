Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85587151CD9;
	Tue, 20 Feb 2024 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464087; cv=none; b=gmB5yDINd+iFo344zSFAWamokAUqdHLw1LIYcRKxCjsxzXDrWb2Z3xF+YHaAoWdNMm6luwAq8zLJpYuCxdrfLCI3uE4LuPZcYA6k1HdWWz/QiCoJ4P0mU2H+SJphmgh3qg4YhedIS9Sn1bDej247B9P5p+9ALS74+QzFHLCC8fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464087; c=relaxed/simple;
	bh=4RZY93deDuhTekOS2oWVAmP/Gxd5oHCTiE5GFiGSvHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7a7bjmEskCpNkcpzz7b6Op2UVItkuJ8lmSxh94+s4sF2ip367+jaei/AhZ1YORmIxIJYbAtd16OB1fwxCHkT8o4+xDOO6WNFGoWoEJRr0GZUp8TE2HPLamZeEECk03uRnGgrEMz7YZUfY9ERiHe6AQXAkavf7CgO1VCSBwDTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCSQOMIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCSQOMIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B39C433C7;
	Tue, 20 Feb 2024 21:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464087;
	bh=4RZY93deDuhTekOS2oWVAmP/Gxd5oHCTiE5GFiGSvHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCSQOMIoVL32ajaSFmEC3ij/YKCu8bVDbXHFaAZl5ph3QNKbtvXDzTRy0FE/F3hbA
	 clkrD/fse9Uz4T9EfKx48SPWcmjygu1BioG79tgKVwW7LxTlJEYyijH2yG0FZS/2nO
	 1JQJt+R8e1X6MRE1UlHCrYeRJR+FB6t1aAMnkuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 209/331] wifi: iwlwifi: mvm: fix a crash when we run out of stations
Date: Tue, 20 Feb 2024 21:55:25 +0100
Message-ID: <20240220205644.260646751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3666,6 +3666,9 @@ iwl_mvm_sta_state_notexist_to_none(struc
 					   NL80211_TDLS_SETUP);
 	}
 
+	if (ret)
+		return ret;
+
 	for_each_sta_active_link(vif, sta, link_sta, i)
 		link_sta->agg.max_rc_amsdu_len = 1;
 
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -503,6 +503,10 @@ static bool iwl_mvm_is_dup(struct ieee80
 		return false;
 
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (WARN_ON_ONCE(!mvm_sta->dup_data))
+		return false;
+
 	dup_data = &mvm_sta->dup_data[queue];
 
 	/*


