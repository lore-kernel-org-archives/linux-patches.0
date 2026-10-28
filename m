Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208943;
	b=fWenO8+HWfgWHggXGI9RIA7qDs097Q+wgdz8jGiHY25rdfefxtQgMdXsjTD3a+L/hitD
	 +8CheiGpPvgJ8MqkPEX71j+HWMuBaW2T7KVaXX7OvXFkq+Kgd+SEAt4FNebitkX1Z/Gis
	 fjRoAF7YASmlfAwdzWD65iqKi1zvb0CXTBHXD1lkIf2eXbZB1HGbMZ4wzZW5ky1Eplv8G
	 o0oErgvu9jJ3ab0dDRQV3Z7reUsDMn3rpQ14lzFWMwk5gzKCfvV+twc/9VOetBILDZNs+
	 e4KWPNQXRwm9DZbPY3WWwytgw1Eu90QRI5XLXmSzdVledmlMiSgS9Oo0jZoODNBO1GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZBhAkBz2l6eYTFGAS9avKDq+q7VTAgYeN9MR9AgdAr4=;
	b=AgOpgISPzLmps1zoCOPfGTWHDbxaxIXpr2U5splKaBHCK8uz3jT2NcJ4QXP3LWgiUBjF
	 sRLEcUglv5zjlyh3ppSA0BGjII4Qly/We6wo0xirIFPzye0GyxtEsVdz1PctJz8czOLLE
	 uWR6hVmzkQPlIMBszVPSycfOvC2HeBk7jzoVT/4ZZV4bKOvw1BBGUw7xkFe8W7cF+eDnL
	 04rgODqWoHwkXfEyqCIE0xNmy+ywNqY8Jri01RfynX6sKA5+O3NDUheQ34DBE+6M9ulX/
	 18l4RG1nBMPhESIgOvCyfdSDfaeJBV/JEf5K/3VWfdoe+jjrPiTtWuQJN4Fv1ZRiv8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MPh830np;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C560A2630;
	Wed, 28 Oct 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MPh830np
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBB61F031EF;
	Wed, 28 Oct 2026 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208943;
	bh=ZBhAkBz2l6eYTFGAS9avKDq+q7VTAgYeN9MR9AgdAr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPh830nplrA+mU+Ubm2e3QnHqCoymext4nf7dNB8jcj9W3wA6saFvrcWyCunNC1fF
	 NL8iMaYrHRYtExe0i3KiBn5lnZhw/V6R/BjO3ir8j6so/FB2E95gkLpwqW2gyGCoNl
	 SVjhxTrRNU+Aoeauz4UO7ms/ioGd7YieMFOVPJwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/516] wifi: mac80211: account proxy paths against the mesh path limit
Date: Wed, 28 Oct 2026 17:57:30 +0100
Message-ID: <20261028170010.552018773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit a5f35d4b112af1415ff06bd501c8cc26cc08aa8b ]

Proxy-path churn can drive the interface path counter negative and let
later mesh path additions exceed MESH_MAX_MPATHS.

mesh_path_free_rcu() decrements the interface mpaths counter for entries
from both the mesh and proxy path tables, but mpp_path_add() never
reserves a slot in that counter. Removing or expiring a proxy path
therefore returns a slot that was never charged.

mesh_path_add() uses the same counter to enforce MESH_MAX_MPATHS, so once
it falls below the number of installed paths the limit no longer holds.

Reserve the shared quota before allocating a proxy path and release it on
every unsuccessful addition. Mesh and proxy paths now share one
1024-entry budget, so mpp_path_add() can return -ENOSPC at that limit.

Fixes: ece1a2e7e860 ("mac80211: Remove mesh paths when an interface is removed")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113649.28315-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: adapted error handling to the absence of mesh_fast_tx_flush_addr() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 9482b49b7f333..7478ea5786299 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -449,10 +449,15 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(dst))
 		return -ENOTSUPP;
 
+	if (!atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS))
+		return -ENOSPC;
+
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
 
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return -ENOMEM;
+	}
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
 	tbl = &sdata->u.mesh.mpp_paths;
@@ -465,8 +470,10 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret)
+	if (ret) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
+	}
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
-- 
2.53.0



