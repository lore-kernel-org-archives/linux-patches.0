Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC7DDC1;
	Tue, 27 Aug 2024 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770087; cv=none; b=EQOylDid/fDE+cgJ94L1intIv6QdNz5iKMLssVpSrypvjJi8HoQFPKClbz239Kj2xOOc0nLV+WYLmobXNyIjGcY6HApYOdrOZbjzvCj5feFVVjjjan9TwGBpUpWnAmb5UIWuI7daAW/uQqzRJmJIzX0tsPdUfkK+RaQNjh5Nepw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770087; c=relaxed/simple;
	bh=G2jv5jc705zai/WJ+gVSV6W4NhsbFL1Fx0hwE8FHkbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GueNA4/cwd0s/CrGd3LFRnuhcLdTQ63u1RIdXJ1Egk35O8o3djSgzudtPRXfLYFHDNk8rQ1DyXinO6kO7AbLHRkLrV0lMmAlPj1otSFcihWRk+26bKJn55NO+rOd0S66KTPtkNpdQIeYvyZ4TGNUU6bOaiic8UNZinsn24e2PpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBGo4neY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBGo4neY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4984EC61046;
	Tue, 27 Aug 2024 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770086;
	bh=G2jv5jc705zai/WJ+gVSV6W4NhsbFL1Fx0hwE8FHkbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBGo4neYLBQuxZxVkmfRhqmfOlwo/RFic/P1DyAwoe5GTE+xnWeVzkXKPCJbOSnxz
	 mC6trGubGlbZQu5AdkYC0kcuDYBB/7Mf1U44YiA+dHARtjq/jsrI1NnxXBDKBZeOYv
	 3AJ04XbraQlv0OEzQafBtBDkB5e96jhthjfKmp5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/341] wifi: iwlwifi: mvm: fix recovery flow in CSA
Date: Tue, 27 Aug 2024 16:35:22 +0200
Message-ID: <20240827143846.870033792@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

[ Upstream commit 828c79d9feb000acbd9c15bd1ed7e0914473b363 ]

If the firmware crashes in the de-activation / re-activation
of the link during CSA, we will not have a valid phy_ctxt
pointer in mvmvif. This is a legit case, but when mac80211
removes the station to cleanup our state during the
re-configuration, we need to make sure we clear ap_sta
otherwise we won't re-add the station after the firmware has
been restarted. Later on, we'd activate the link, try to send
a TLC command crash again on ASSERT 3508.

Fix this by properly cleaning up our state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230913145231.2651e6f6a55a.I4cd50e88ee5c23c1c8dd5b157a800e4b4c96f236@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8f49de1206e03..f973efbbc3795 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1035,6 +1035,7 @@ static void iwl_mvm_cleanup_iterator(void *data, u8 *mac,
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	memset(&mvmvif->bf_data, 0, sizeof(mvmvif->bf_data));
+	mvmvif->ap_sta = NULL;
 
 	for_each_mvm_vif_valid_link(mvmvif, link_id) {
 		mvmvif->link[link_id]->ap_sta_id = IWL_MVM_INVALID_STA;
@@ -3934,7 +3935,11 @@ int iwl_mvm_mac_sta_state_common(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
-	/* this would be a mac80211 bug ... but don't crash */
+	/* this would be a mac80211 bug ... but don't crash, unless we had a
+	 * firmware crash while we were activating a link, in which case it is
+	 * legit to have phy_ctxt = NULL. Don't bother not to WARN if we are in
+	 * recovery flow since we spit tons of error messages anyway.
+	 */
 	for_each_sta_active_link(vif, sta, link_sta, link_id) {
 		if (WARN_ON_ONCE(!mvmvif->link[link_id]->phy_ctxt)) {
 			mutex_unlock(&mvm->mutex);
-- 
2.43.0



