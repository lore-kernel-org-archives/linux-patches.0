Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E92580E1;
	Tue, 25 Mar 2025 12:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905561; cv=none; b=ryV/78gQ8r/AlbXMWQTCR3L5Oxv7E+vTFgYh5imrQQKY5cjLDHVus6x37jJc+zQfNzcjkYQyisVQLkOwWh8S5FPJVRLNidIe1V5PEc+2SAgmWBwUdo59Hm4BXZnfTugkVIwfvu4M3QGNqRNDcx7LqvXc/VD+qqMltrivA0oDGFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905561; c=relaxed/simple;
	bh=3SITf3WbWLixWPOS7UOdV/m+v0rFwTa79Ndflc5+1HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEEFCct/Md3hp1KEojgtZHBUVG/YZ52h6Oe3rJo4r7rZCCLtfi7yXrJ4GKycOL+7T4Z9Z2QaPp8nQU1pjW3awKqwkF6XhgoZJmLpCFmEw0NzvmfzZSz4kN0nTV48+g/dqsPWpj3rvfUKd7Rlx8/JMR19wk5B7wVyHA4hEZbErG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8O/CW8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8O/CW8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EF3C4CEE4;
	Tue, 25 Mar 2025 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905561;
	bh=3SITf3WbWLixWPOS7UOdV/m+v0rFwTa79Ndflc5+1HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8O/CW8s7jtfe9vCoJx9SKjrShMEdati6VktWGEWBP2qO7iiQjmDIk0vahfmQjTBO
	 gXMsHZh4y+VjJHEOHbaX0onyauuel+mRT3N6N1RT1LanFgywlRbOMrZAlkAHmGj0uV
	 hm43rKM7ti+MCA7nKkHeUJPu9S91fiwmK8Ay/MWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/198] wifi: cfg80211: cancel wiphy_work before freeing wiphy
Date: Tue, 25 Mar 2025 08:19:33 -0400
Message-ID: <20250325122156.936969972@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2bed30621fa6e..74904f88edfab 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1146,6 +1146,13 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
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



