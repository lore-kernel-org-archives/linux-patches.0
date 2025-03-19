Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4071C5D57;
	Wed, 19 Mar 2025 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394836; cv=none; b=rk5Ws1BkIHRCuHxaJKE3iGsb+Cl4a+P6cE6wg4O4wq26MqmWqQBDqnOslfxkajC7CrQX16wSJPkcDEW1iq8rD3vNTpwghgFVu5hUCHwp10CP6miQVQWAC2BYqdBsobP2RevP7nteUwzbg1I0zzQ2nA/yJ75mGXzdtCvCGqMntpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394836; c=relaxed/simple;
	bh=yUHNTDehW+fyTidVHUK0cU1FDfQztc8ebXx8/B9yL4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq9gHBhwr4grhCnhZogVhjmb88PAlsKZBwApQ4V2D3dz/BgNHE0tA9/Wtxwc1uIYHURbGeSd/9W0gWXfvUbTdiFFOJPrdaYN3+PaVBlnRhJbDNmFyadgz0qKVfNhZwwgO4+SWnLnMq0hgeKJCvoOl3GW/0PR8HHeJjiJy0mCaEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3Ua0dNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3Ua0dNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238C3C4CEE4;
	Wed, 19 Mar 2025 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394836;
	bh=yUHNTDehW+fyTidVHUK0cU1FDfQztc8ebXx8/B9yL4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3Ua0dNpvpgiEhQFBib6LboX3RQq1G5us3AqrU24QqDuysVHEDVAREHVW/lUROG0V
	 nxgcf8yvAihN7/HDaegBE6xk455UNw9ZO8IEhILcCQ/Fi0K0dl9lUevAWOIxIAvo5+
	 m/EJyPfwFBRLZMc6XSCtXR8R0lmfzgA6oAO4eaBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 017/241] wifi: cfg80211: cancel wiphy_work before freeing wiphy
Date: Wed, 19 Mar 2025 07:28:07 -0700
Message-ID: <20250319143028.134546063@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index afbdc549fb4a5..8baf22758ac12 100644
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



