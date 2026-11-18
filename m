Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019327;
	b=axHXUbOs4TIMMlBmjwRFJN1ULhauc5IZJzZ5fBHLfsC+gVxKSKbho/t9dKMSKXEsJh1w
	 F3p8b2BBttI4OlWNF2xk1Ar45vsgo23FSEfnXyLgTy0wW2EBcF85NerQl+62ZKeTzj7aD
	 RvDcBz+b5VkcV75zDfgelZxsno7MUOPxhcrVdSsB2Yd+J0NBQvCoHongFiJb5qRNVTpUW
	 V1PiDdERuFVsmv1Q4qa8f993fn+Rd1CTfEwbmwQ7IRiBIn2vq3o/4fDvk2ffU/GK4Jus9
	 zTsI1/2L/L53sqX4q7/0auqSaGsSxIW9meR3GKQk7j5fjO2+AKQtFCMBu7mD5MeIVEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p4xYkSELqT1kx3wsbHlFwXo5QTmQC4YlQf/BzNTSEKM=;
	b=WCOGvVCt6Rja1rRNAu7scfrrK64qhsWwWlnRsZ4AJYN+DgHDoRKftXHsZ23pTRDTLAOp
	 9L78VjMOLE2Vric7hUzAhEitKa8kY8erga5vpbr0fxR/j24Kiy+m76V3R3OTxh0OcEi1c
	 y/mZs6+iC+lzvm5wcX5O3wYF87RCScBBwl1JH9un5+NpZOCrG7dVnXHCHtKIUtYldk1bo
	 dXUOc2Jvmv7Z1ULHtMzKF81Qukks8h2YY7BwP2PHprgRVJ133KyARiEshvsa+oTZgph5C
	 Bi2eibjBZfAg/BkTGFEF7ENDRE/gNOP7S5L6/pVTXve//mhLyf76oMrlwxkItAhRBvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWvyWH7Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BDA60A2620;
	Wed, 18 Nov 2026 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWvyWH7Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666BF1F000C4;
	Wed, 18 Nov 2026 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019326;
	bh=p4xYkSELqT1kx3wsbHlFwXo5QTmQC4YlQf/BzNTSEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWvyWH7YcSNP1H9hJht60fpKA11/HMELsRPugRqx9gaMdJ7LgeMwqQ6j9tzss97q1
	 QLRmjF2kF2AsCi8jlSW2ozGVUOn+4s3zFcbSdmx7iq41IAM70nyUQb10xZsQn0TAbx
	 gKKNurcmwxws8nUyWoK/CiN3nmrKypZ3HGwOdzpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1555/2651] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:46:35 +0100
Message-ID: <20261118150343.934153880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7b2f71186dfbd..0485a979b3c22 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -712,7 +712,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
 	if (!mpath)
-		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
-- 
2.53.0



