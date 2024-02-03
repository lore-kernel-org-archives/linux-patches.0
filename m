Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E797BFC11;
	Sat,  3 Feb 2024 04:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933397; cv=none; b=bala/xwq8HnfNC/EA0uvwC9rJMeDk0AzdRaYiYwvfq3DX6sGe68ulVQoEAW4dsNOoKH6AaA13IoTwEHpxeA+zJsu/BF7Lb4P1ArGB+EmLFj/FD2ht9LJ2NwBy+3YytSOc6VRgOArC8M4EdYvaMXdz1q7OpOI+Vev6Ia/gxpDKdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933397; c=relaxed/simple;
	bh=AQjsU0t2Ec6SSUD61nv9GLjyZXUzSTvjBnV5V+/qy0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIAgB4R5Pe6PREvlZ7udWrTesVI7Qxf8Mq/9Zj4keyB79xw0ZIHIXYLbfX4B5jDakaJx2rtZ0qzDAc6VX/jMPvmKxKoYcp+HflVxzivSrP3KZKFkujG5/uUPZG/T5Jech+n/yeF/I1gwRnESgs97JehAnnccYv7BYVp8VZclWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWE0ndnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWE0ndnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B9BC433F1;
	Sat,  3 Feb 2024 04:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933396;
	bh=AQjsU0t2Ec6SSUD61nv9GLjyZXUzSTvjBnV5V+/qy0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWE0ndnHSmtaIwPDV+bqRHNN9URcfl8B/ma95BpPanwYxhYRcIo92+WL2VUoHj7ZR
	 W1GX4cLZa5+fIn+6bX05ZmInsMvzq9EMbgm6bgznOZfWrrQm4WjPz9ag/Oa4uYP+Sd
	 bvFqAC18c3rpgk3w8ao4raf4x3inGm40OkS9ElXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/219] wifi: cfg80211: free beacon_ies when overridden from hidden BSS
Date: Fri,  2 Feb 2024 20:04:28 -0800
Message-ID: <20240203035330.603478407@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b7e1631b3d80..86906557a04e 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1810,8 +1810,12 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
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



