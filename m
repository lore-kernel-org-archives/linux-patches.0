Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB9C20C03A;
	Wed, 19 Mar 2025 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395007; cv=none; b=hRxdbPGCGo1Ll6CIJWuQXUnSDbPFpbRB4brqKKqKe21jQ0bb83EWqYh1dinwj1waUaslrijtW6mKpJjKrYEKB2pmPvFNxTFk43mSW3/UAnx6TeALg/7CX0MCZIDd5+Xejuz+rlamlgy9tR3g38Z0qygaUICDaPqc4201kB+Eaq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395007; c=relaxed/simple;
	bh=mrJepoMsQXB9dzvFsWU15hfv117krLKJEerRbrmIqT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGSBV9ZPx/pdX+mPx71+5eQ/AV7cslVAyy82OeVIDxjUje2oyYTBBmF7YOmkIFz9zgoxzFvvgsOh7hrC+NFRtZrPTQBh80vbda3rSlfg9Ltuv7wR4VvazX7pFHlpqC9E5F4CEbOZncJcUjwAtcjNKpT2BG0JGWyzMbTykBEepZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffNAwsYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffNAwsYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B8C4CEE4;
	Wed, 19 Mar 2025 14:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395007;
	bh=mrJepoMsQXB9dzvFsWU15hfv117krLKJEerRbrmIqT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffNAwsYa3Am5252Nkfnh30P0Nsgf3cZngbM0kKpCxRJOEuWVCgh3BweMx8bqDbXB5
	 b7fKWo6r/uL+0eoN1Wdop+6lgRbLzqqlS9OzR6mHegxd/BPWcP1AYrx+KvQLoCykCu
	 MedDf9g2C2afs7Mzb3o7kltp4nJcnkv4dHHKVf/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/231] wifi: cfg80211: cancel wiphy_work before freeing wiphy
Date: Wed, 19 Mar 2025 07:28:29 -0700
Message-ID: <20250319143027.250777369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7d313fb66d76b..1ce8fff2a28a4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1198,6 +1198,13 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
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



