Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D1C5F54E;
	Tue, 13 Feb 2024 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845725; cv=none; b=hMzNmO05P632IAmbba4FtFYzIoCMThtEKWvyxAnYPFUZUHpgzUSu9dFbW68eivC66guAoK6rHf+NA3kagKevU7g9NgXQlto0yHOEHO7BuJwpgxbCWlgdMUiG4op/IvdXCspk2fMM0MtFUajEZytxGFjVVcyohIfQTHNpBcWqBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845725; c=relaxed/simple;
	bh=lVGp/9fYjcHUUZGUO3WtPLcFjOS35ul9iacUwcNHI3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XV3uUMuSK13heKsZqVaDVlvW3hSHgD2DaY7JPK/tpT5G3EHEEphSWXI2bDUa36fFpiA2QBuKdDcbOx0CzH69LaCIV7sPCcVwxK0EdE/+enXrEJzRmMdzi/1J1BJMlBTRLCyUf2+k+QVo9gphXAJ5aoF9N151L/Bh5sK8yK8Ke8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKeX5PDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKeX5PDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED5EC433C7;
	Tue, 13 Feb 2024 17:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845725;
	bh=lVGp/9fYjcHUUZGUO3WtPLcFjOS35ul9iacUwcNHI3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKeX5PDQ1lWiCk25p1UzSumJP6scHB2KQLfqjXKNoj4doxbfiYQWBreBpiB9LJgcV
	 QuXKoCu6jDcfcD1Eqla0GLs7okaP38rDndU/nCK1GY4SMnCfLAVQwSBd76v7Koi/F2
	 ZvVktMtmRx8NCqOwDJ4jbM9RKF1rpqYjRuHrEouc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/124] wifi: cfg80211: consume both probe response and beacon IEs
Date: Tue, 13 Feb 2024 18:20:45 +0100
Message-ID: <20240213171854.407964909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit f510bcc21ed97911b811c5bf36ed43a0e94ab702 ]

When doing a channel switch, cfg80211_update_known_bss may be called
with a BSS where both proberesp_ies and beacon_ies is set. If that
happens, both need to be consumed.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231211085121.07a88656d7df.I0fe9fc599382de0eccf96455617e377d9c231966@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 177fbbcb4ed6 ("wifi: cfg80211: detect stuck ECSA element in probe resp")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b9da6f5152cb..f819ca3891fc 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1746,7 +1746,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 				   new->pub.proberesp_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
-	} else if (rcu_access_pointer(new->pub.beacon_ies)) {
+	}
+
+	if (rcu_access_pointer(new->pub.beacon_ies)) {
 		const struct cfg80211_bss_ies *old;
 
 		if (known->pub.hidden_beacon_bss &&
-- 
2.43.0



