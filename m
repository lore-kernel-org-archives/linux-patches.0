Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061545;
	b=xCbRHr7WKZ2OC36N46puYLUg7mXDALN2qhzVD660DQ1RPnT61U4UB1qJUsbitFZyxdjP
	 6seRXSXIJIHysuFXrOORtjysEiywhUu1ewEMMlKhc2pXUuMz/+PX4EBEugscpwZg0f0VF
	 cBv3TAB1t8vjEPBWf+6cBn0oLQ+O0L7rBcNkFOFX2RB+qCDfh7dWAUQQevpJXlkfyeqoj
	 kSthwukbs1OaB9ugp/ERq3/j7ZzgQvQmuC+YE/LXQ4uO3OkUQDdzrL8u9BI4QBx0Bgw1M
	 dOsHyaXgBdzsMKWWBtT6fiNSnpXsHTwhGsBckYWhqDkZJOQeMbTG4B7/ypKdZyx+XqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ozmbhzHzX+ZO7L+aJ5Wmyw+SByU4Xkd58yH74VaqqnQ=;
	b=xMrXzhS+tbLeAi8NofQY+raDnfZt+4WodlVdBzOvSWyXgJJeSjOYaR7pJ/LIOebXSlwV
	 ag/8zNvCb4zrfarxfxWyYC2WE4vxs2JRbJoVIQoN4j4IsjD1qP0ynYt/0+pftwALDv7mW
	 olmzKPMMgZpOUDEKDXBUutIJJzfVYE6ddrbUpRJAKDaccSiSnrVqvKllCi0huyF2e1LrI
	 yCd1UJLzpcQdJv9uI3QwYjR51KAWU2Iw1ciMcSLhC1YMK//YN3yvXTphPfWYPRtrAVnB3
	 eswuc6KjqJyWojChoLEcJub50WES/ifdA8q2c2wsFbV9IFCW8xkeq7/PqmrDXG/WWZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVnd6BGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF01606A332;
	Thu, 19 Nov 2026 04:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVnd6BGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129F11F000C5;
	Thu, 19 Nov 2026 04:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061545;
	bh=ozmbhzHzX+ZO7L+aJ5Wmyw+SByU4Xkd58yH74VaqqnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVnd6BGFbYS4I5LHgFYy2lim/Hb139vgwJtOhFQ1J3gd8vKau3GDnZhiVOT3ZefYd
	 AiiWnq80s7LVYic63MlJ+iZBIG3eFzkbCv7rqVwML/G4MUbrQfAuOm+4m/F0fzEbyT
	 aFoyhrftfAj27Jy5OQ1mmelBVxak3utHb3KIgmwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1554/1848] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150024.667160228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2ce8b78102e91c9d6536630cdef96491121c84d3 ]

The mesh paths walk list used under RCU, so we must use
hlist_add_head_rcu() to publish an entry. Fix one place
that didn't do that.

Assisted-by: LLM
Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Link: https://patch.msgid.link/20261005224950.e0db543145e1.Ieaf30d3546e8ff63ccf400f6fb26e027c218721f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 5581e59e87bb7..1b6f10f1c5de8 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -419,7 +419,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
 	if (!mpath)
-		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
-- 
2.53.0



