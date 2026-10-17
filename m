Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DDF3B2FCA;
	Sat, 17 Oct 2026 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256326; cv=none; b=NZR4qZf/qYP7J6O6ROhU/8LqvkgDVSE8+7+6MWkbAnbB7EkmbO52uSoEk110FZdDgPY9hJxEgj5CrAxyN7qKV7CgTaBzZjDUvEOaFUqrSmTnpdDV7vFmV1HFr8rAf4ZAjaow1+lOAmTceuPRAc9DVnuw3tOEcpgaDmFJ3F7SYS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256326; c=relaxed/simple;
	bh=c2x8d6Su5NvdGFz72TrjtNF2aEQY3cnZzTao5A4ZM30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+PJ9A9Aq39W7eo3/SKAZab1BJFZQ0dbbbqjhytRMzaCmhr1Zh7M9kBBHpjcfIkSGhIg/inIc7SLObrRhikSwNPe7XcbuY48YD+bSgE1NyF04rO3j77GFxRhFq5ZnQXn1l5tr3zJ+DRjvQZ42PpcfpUcfdtoGG1JAN+GmaFRra8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3myvXFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3myvXFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA3A1F000C4;
	Sat, 17 Oct 2026 16:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256325;
	bh=vj85fudh2/cI1bEFJH0u+pRPhjS9vf7/dMCFvrDvApA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3myvXFqxF30jG9sPpdsgtdSSf+BQijP70Yh73sPIaiTy4tM5FrFpcoJUcXBJWOsw
	 yBfg10bYrERY/sqiw8raKSArIUwYV64P+raXElbK7AgpQpz+iSI67MA/lZ1P/acm9L
	 oGqSfNXeXDwc1cF40hYNJw88Wrx0/sx35GQp99dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0198/1674] wifi: cfg80211: preserve hidden-group beacon IE ownership
Date: Sat, 17 Oct 2026 17:41:10 +0200
Message-ID: <20261017160436.234809498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4f4a77b1e7ac7..c215c82f399e7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1812,20 +1812,22 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
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



