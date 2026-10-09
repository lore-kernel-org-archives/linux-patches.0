Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD81331EA4;
	Fri,  9 Oct 2026 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555543; cv=none; b=Ld2OWqbyzURjnECNLyabOGBOAgwJaO65S3W1vzvOjaeLg7ozwcehVSnwXvYeSoQyA7LACmKG0SXsYmmy3CUtn88AyxqAm0ad8JSzOyMzeKFo54toTQQiAh+U42J10oMcLlriH5SF1BsUw1hvT6GKahX2Jrc+YMKpPkRyJzJcoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555543; c=relaxed/simple;
	bh=iehLIMFmnPk0ZdgCDhXjYsyp4stft/AjfixwnzA0Has=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR+agCZV9I01AkwAuM+vFVWzKGm6ovFfPeGiQgLKR+xNN+ZWR0Unwg2XqpBSBFe9jHI2+TfHbLgOBomrrqATjMbdm7BNX7ljYwXF9zAXu6XrSztbdcnznCDQregrEWVLP5EqUplnE4qt38NNMj058YTWkkdSE5nc1TZ95aMRLU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNY0CDDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNY0CDDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E3D1F000FF;
	Fri,  9 Oct 2026 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555539;
	bh=+1uStr6UCrnQ5BsmAnYJWMhJW/JqyM057lIOnSa90T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNY0CDDofCLovooFyo8Gl6Pk6DOHI6OIPBcbqVY89SMA/jIg5EXUtwcd2wHsHBd6F
	 Adf77W2fYv6h/ewsGvTzTNVM3XEt3nIYVetvW/l7oidSI4A1kCe0edxdZEuuNL90iH
	 llYvJyAPFtkpG0ZUzMZ6Ktw6X1wLc3hPzZj6p+nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/403] wifi: cfg80211: preserve hidden-group beacon IE ownership
Date: Fri,  9 Oct 2026 16:07:17 +0200
Message-ID: <20261009140953.874211203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit cc45f313d85533d647ce619326302aad6f797c14 ]

A hidden-group probe-response entry borrows its beacon IEs from the
group's beacon entry. cfg80211_update_assoc_bss_entry() can pass such
an entry to cfg80211_update_known_bss() when merging scan entries
after a channel switch.

Copying the borrowed beacon_ies into the associated entry gives the
same allocation two owners. Releasing the group's beacon entry can
then leave the associated entry pointing to freed IEs, which are
freed again when that entry is released.

Skip beacon IE replacement when the source entry belongs to a hidden
group. Preserve probe-response processing, the subsequent metadata
updates, and the existing rejection path for conflicting hidden
beacon updates.

Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Reported-by: Yilin Zhang <yilinzhang@moonshot.ai>
Closes: https://lore.kernel.org/linux-wireless/20260901080427.1983015-1-yilinzhang@moonshot.ai/
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 29e150b4511f2..3d3956e4cce2f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1965,20 +1965,22 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			return false;
 		}
 
-		old = rcu_access_pointer(known->pub.beacon_ies);
+		if (!new->pub.hidden_beacon_bss) {
+			old = rcu_access_pointer(known->pub.beacon_ies);
 
-		rcu_assign_pointer(known->pub.beacon_ies, new->pub.beacon_ies);
+			rcu_assign_pointer(known->pub.beacon_ies, new->pub.beacon_ies);
 
-		/* Override IEs if they were from a beacon before */
-		if (old == rcu_access_pointer(known->pub.ies))
-			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
+			/* Override IEs if they were from a beacon before */
+			if (old == rcu_access_pointer(known->pub.ies))
+				rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		cfg80211_update_hidden_bsses(known,
-					     rcu_access_pointer(new->pub.beacon_ies),
-					     old);
+			cfg80211_update_hidden_bsses(known,
+						     rcu_access_pointer(new->pub.beacon_ies),
+						     old);
 
-		if (old)
-			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+			if (old)
+				kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+		}
 	}
 
 	known->pub.beacon_interval = new->pub.beacon_interval;
-- 
2.53.0



