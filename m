Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAC4267731;
	Tue,  8 Apr 2025 12:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115078; cv=none; b=ZXigXCgPXHvQJeO4lP+1Yf3VQ1nruQvw71JNnC5d1jHSsrv8ZNc3RZoH9nyv3cj4y0MGtb0z3nSF3lIfK1WsSVrtT6K/Ncu6Kpfnk9vnFGx+IAqBjV05jeV2ztiot1XqehVm3S0kF9l7euymY0PJhGaoAVUlNBmgE6ENdGPuJ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115078; c=relaxed/simple;
	bh=sKJyOS9pBsfeeCX64xYu5ItD5R1Ec/QbVfmkLAImncc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIIKBVF7jgokI/uRa/rb3fvOBHhKwi0EeLKkLtpX9sjQTpLOngNZiQj1Nv1hgWIb/j8fQbTToG8d8qz7HmSgiF6DzAVw5d6c+ym5FD1IFYS53FlpdaLTKsyn2Fqhz499hfcPiaZrRS+ltXgnV6oTbGs+oX/FkBH5htRSjTbmPec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4Q4XDUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4Q4XDUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BF2C4CEE5;
	Tue,  8 Apr 2025 12:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115078;
	bh=sKJyOS9pBsfeeCX64xYu5ItD5R1Ec/QbVfmkLAImncc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4Q4XDUABYQGXgJ0SKYKNbbTwE5HUx3ydG/NRf3MMM7xmdKVgdVwQ9uu0fQ6z3CuS
	 /E+ahD57vyqxiLA9eMs1MKJ3+iJVeCPS6wxOJJu0UpNP5L43XSTcGZUMzCzSjbZgj4
	 hJhbE163hqquBTjwS1O6j3TdtXqtNimtZyT00np8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 301/499] wifi: mac80211: remove debugfs dir for virtual monitor
Date: Tue,  8 Apr 2025 12:48:33 +0200
Message-ID: <20250408104858.723713436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit 646262c71aca87bb66945933abe4e620796d6c5a ]

Don't call ieee80211_debugfs_recreate_netdev() for virtual monitor
interface when deleting it.

The virtual monitor interface shouldn't have debugfs entries and trying
to update them will *create* them on deletion.

And when the virtual monitor interface is created/destroyed multiple
times we'll get warnings about debugfs name conflicts.

Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://patch.msgid.link/20250204164240.370153-1-Alexander@wetzel-home.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 10 ++++++++--
 net/mac80211/iface.c      | 11 ++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 299d38e9e8630..2fc60e1e77a55 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -116,8 +116,14 @@ void drv_remove_interface(struct ieee80211_local *local,
 
 	sdata->flags &= ~IEEE80211_SDATA_IN_DRIVER;
 
-	/* Remove driver debugfs entries */
-	ieee80211_debugfs_recreate_netdev(sdata, sdata->vif.valid_links);
+	/*
+	 * Remove driver debugfs entries.
+	 * The virtual monitor interface doesn't get a debugfs
+	 * entry, so it's exempt here.
+	 */
+	if (sdata != local->monitor_sdata)
+		ieee80211_debugfs_recreate_netdev(sdata,
+						  sdata->vif.valid_links);
 
 	trace_drv_remove_interface(local, sdata);
 	local->ops->remove_interface(&local->hw, &sdata->vif);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 806dffa48ef92..04b3626387309 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1212,16 +1212,17 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 		return;
 	}
 
-	RCU_INIT_POINTER(local->monitor_sdata, NULL);
-	mutex_unlock(&local->iflist_mtx);
-
-	synchronize_net();
-
+	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	ieee80211_link_release_channel(&sdata->deflink);
 
 	if (ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
 		drv_remove_interface(local, sdata);
 
+	RCU_INIT_POINTER(local->monitor_sdata, NULL);
+	mutex_unlock(&local->iflist_mtx);
+
+	synchronize_net();
+
 	kfree(sdata);
 }
 
-- 
2.39.5



