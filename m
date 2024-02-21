Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C76A8D6;
	Wed, 21 Feb 2024 13:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521379; cv=none; b=bYOpiUXOhZ3XtHRRKGIGT9ibIwDf0ZBTK0K7ZJeGlM2Q+Sng9SnPLMYwfp1eZOoC2EatkyxDo4e59n1bN5fGuzbqtE77VmTBtp6uD0b2d9c2V5R0yaIbPN8NdpuvOqCSONKbwV2GigqGV4zXqXIfRPiY6TTV9JdOKkA7iZS08Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521379; c=relaxed/simple;
	bh=+gt1Sir5llkhnWls5OgBSQ5sLZrcR3PboPxu0n5o/0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcdm5iK3NZ6As6qWP7N4DwXyDCTRMl5KMad7U3xexSKAO3YLnjJu1xXc5jDc0jBi/mCbGAClsl8zNJoQpEKq7BT330kMUwXNW0+gAuI+uP6f9yGVZxc8aRPtCAzMEPmBG+zkPiBikciCBOO8OjMFMnsJ2I6c66afUQlObKFzwX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WE+o9HZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WE+o9HZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF61C433C7;
	Wed, 21 Feb 2024 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521379;
	bh=+gt1Sir5llkhnWls5OgBSQ5sLZrcR3PboPxu0n5o/0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WE+o9HZDumpOn/BwWdakekfYh8Ritmg/+Mnno1TBTdoQeCcekexHiK5KtQ8r2DdtY
	 PTQZR3+oChdGD2HUVOVHAT7s5TJ6cdDjsJYNz0hBKMYxoSyUi+OvKP8TvUPaddL7UT
	 vcGNhB0zOZVBwyhQLEBKyVDkcZQ7Uw7bceR9my3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/202] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Wed, 21 Feb 2024 14:06:36 +0100
Message-ID: <20240221125934.853305452@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 32af9a9e1069e55bc02741fb00ac9d0ca1a2eaef ]

This is a more of a cosmetic fix. The branch will only be taken if
proberesp_ies is set, which implies that beacon_ies is not set unless we
are connected to an AP that just did a channel switch. And, in that case
we should have found the BSS in the internal storage to begin with.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.b898e22dadff.Id8c4c10aedd176ef2e18a4cad747b299f150f9df@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d871349036a5..7f1a4ba975dd 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1018,8 +1018,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 				list_add(&new->hidden_list,
 					 &hidden->hidden_list);
 				hidden->refcount++;
+
+				ies = (void *)rcu_dereference(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
+				if (ies)
+					kfree_rcu(ies, rcu_head);
 			}
 		} else {
 			/*
-- 
2.43.0



