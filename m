Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2761C0DE7;
	Mon,  1 Apr 2024 16:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989122; cv=none; b=dghxYjBaWMcCfNf8QUXsFepI7MZhm7eaYwxJF1oUiyQCRSLLjQBWqazjdIj2L7tZVHxz/ZZqYxzR52D0YPMhOwlRCnzAneHz9k+NdIEdoPAtjd2E1JfTQ9szQnAmJHX4nhVn1iKFS6lz9f5epZfRQhxFtcf0GYMzFQn77FXZE7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989122; c=relaxed/simple;
	bh=m9zxYOGxmpgPGZKUsTV1mKyjlNi2QCzxJVV/dol+YbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRTmvNdX+bZlYuX2ii3Cqgy6ulpg5hiIpks/a3Z6VR7TRuKcOdaopX347FrgndaC6wvhNyQwG+KSyH8uNC0aCKboUXTFeRMASA7NmXaGbOjUHLoU7NL7Suqn4iGNAYXlQ55E3T52xw6+Idthdrwh4Y+ceDl5eMAvNJLi5tSj+RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojTOq/BI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojTOq/BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA64C433F1;
	Mon,  1 Apr 2024 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989122;
	bh=m9zxYOGxmpgPGZKUsTV1mKyjlNi2QCzxJVV/dol+YbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojTOq/BIlTm0iiSvr5HxlRdASBjVPF/UlXd/A/BwKgtFWZIcgRnFuvsre2ivmIcoM
	 l/EhXH/IywsiMpklKJQ2rR96kw0ahD1eqdacUJgFR9h7I+9S5eDdf7jkxaNu4I36Kt
	 9aYk0Vf7RTmGrSRKyD6IPNYHNc0pxcgR+Ln0kTDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.7 349/432] wifi: iwlwifi: mvm: handle debugfs names more carefully
Date: Mon,  1 Apr 2024 17:45:36 +0200
Message-ID: <20240401152603.654356102@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 19d82bdedaf2db0bfb3762dda714ea803065eed5 upstream.

With debugfs=off, we can get here with the dbgfs_dir being
an ERR_PTR(). Instead of checking for all this, which is
often flagged as a mistake, simply handle the names here
more carefully by printing them, then we don't need extra
checks.

Also, while checking, I noticed theoretically 'buf' is too
small, so fix that size as well.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218422
Fixes: c36235acb34f ("wifi: iwlwifi: mvm: rework debugfs handling")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320232419.4dc1eb3dd015.I32f308b0356ef5bcf8d188dd98ce9b210e3ab9fd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -735,7 +735,9 @@ void iwl_mvm_vif_dbgfs_add_link(struct i
 {
 	struct dentry *dbgfs_dir = vif->debugfs_dir;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	char buf[100];
+	char buf[3 * 3 + 11 + (NL80211_WIPHY_NAME_MAXLEN + 1) +
+		 (7 + IFNAMSIZ + 1) + 6 + 1];
+	char name[7 + IFNAMSIZ + 1];
 
 	/* this will happen in monitor mode */
 	if (!dbgfs_dir)
@@ -748,10 +750,11 @@ void iwl_mvm_vif_dbgfs_add_link(struct i
 	 * find
 	 * netdev:wlan0 -> ../../../ieee80211/phy0/netdev:wlan0/iwlmvm/
 	 */
-	snprintf(buf, 100, "../../../%pd3/iwlmvm", dbgfs_dir);
+	snprintf(name, sizeof(name), "%pd", dbgfs_dir);
+	snprintf(buf, sizeof(buf), "../../../%pd3/iwlmvm", dbgfs_dir);
 
-	mvmvif->dbgfs_slink = debugfs_create_symlink(dbgfs_dir->d_name.name,
-						     mvm->debugfs_dir, buf);
+	mvmvif->dbgfs_slink =
+		debugfs_create_symlink(name, mvm->debugfs_dir, buf);
 }
 
 void iwl_mvm_vif_dbgfs_rm_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif)


