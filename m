Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691C1F09BD;
	Wed, 19 Mar 2025 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395165; cv=none; b=TZUEphnPrHXRjGi3a9JTAlgRR24z4AonfDgedHxsg4wcGsBO7ouCDjTSl2yNnHOFKR/4za9YzJEpD79Gs5IY/9yLqw7wSEWWIEWRy5d8oZpQwlvXtu0yUhv6VyzZOoWxI+PFnshRtF6LkhSbBXCEW3vUvMOTW4GS+Nje4hiCZ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395165; c=relaxed/simple;
	bh=GoAwHghT1E+Mt2PnG1gDlvkQZsp+OyG28FcDvrBGGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBGOeuhv4bGwZTJJgmYXYwp9oKXQx1wUt4KtLQCPXKVOC0IUecyUWHFj9syUWHixPHOxT1BIiTAaPmRp3Y7MaKe/20z8OiR5DwdmXYfEdiIq1m9nr7+ypjWlBowbixDITlvDn/yZ35KPK+g/0IPNoI0Cte8fC2EWRKteHrpV5HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIjeG29G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIjeG29G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B09BC4CEE4;
	Wed, 19 Mar 2025 14:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395165;
	bh=GoAwHghT1E+Mt2PnG1gDlvkQZsp+OyG28FcDvrBGGMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIjeG29Gfs5UNrrH55sgFuo3uIJAf/opG8VJCSURRtILnt/tUxRacUylFF/lntAW9
	 Gc6E12OdeUtFjXDesniacnpHntGE+UP3EpU/4bZRqMuenAlBQNnPXNeVkn6mz4swxT
	 ns0NJR41LN383upau0BcAU/GJ4alCKKQmecWrZOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/166] wifi: cfg80211: cancel wiphy_work before freeing wiphy
Date: Wed, 19 Mar 2025 07:29:45 -0700
Message-ID: <20250319143020.369687543@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 72d520476a2fab6f3489e8388ab524985d6c4b90 ]

A wiphy_work can be queued from the moment the wiphy is allocated and
initialized (i.e. wiphy_new_nm). When a wiphy_work is queued, the
rdev::wiphy_work is getting queued.

If wiphy_free is called before the rdev::wiphy_work had a chance to run,
the wiphy memory will be freed, and then when it eventally gets to run
it'll use invalid memory.

Fix this by canceling the work before freeing the wiphy.

Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20250306123626.efd1d19f6e07.I48229f96f4067ef73f5b87302335e2fd750136c9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3c1247933ae92..a2b15349324b6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1151,6 +1151,13 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 {
 	struct cfg80211_internal_bss *scan, *tmp;
 	struct cfg80211_beacon_registration *reg, *treg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rdev->wiphy_work_lock, flags);
+	WARN_ON(!list_empty(&rdev->wiphy_work_list));
+	spin_unlock_irqrestore(&rdev->wiphy_work_lock, flags);
+	cancel_work_sync(&rdev->wiphy_work);
+
 	rfkill_destroy(rdev->wiphy.rfkill);
 	list_for_each_entry_safe(reg, treg, &rdev->beacon_registrations, list) {
 		list_del(&reg->list);
-- 
2.39.5



