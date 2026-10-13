Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74338282F2A;
	Tue, 13 Oct 2026 12:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895238; cv=none; b=XC2P0RGRi4yc1xv1qL0MfRgIVArQZP3NBfBlMmcgo4BwptyLt6/fQE6sZ5vA9xAooXkQGwFOmiLC/5qMMuZt+0Pkg50/c2r3bPXnGKTV0eT7HIHfAFPcXJCRndBK4pCufAEwdFab7DdnUcfMmeAOEvczymYjj+Vbq9WwB8TCDUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895238; c=relaxed/simple;
	bh=ssJUe8y7xTkshVius6v66U/m8xTwG/rF88TpTUywWfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVg5soz1bPRrKAC0m+3H3AnRxu1+Yx+1Nsgk3VXTrBLQvqaZa2hImTvhFTjzxa9mrRhmA/XboIUznRbhlYqoOCzwRZ86XgnIlZ4pKwkGdmMTCCZWur9aPOjK9Wx0rfSWjLEkX7nrlvPxKtd3EXE3xP1F0sV9vQpv+O1ctGThR4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkdJytxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkdJytxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38981F000FF;
	Tue, 13 Oct 2026 12:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895237;
	bh=Lqt1o0NYC8yEJ+/fc4BymFLKTM3Pbn8G8dRD85RmReo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkdJytxyF5e/ZxG4IGXHK77Y09+6BbL+U7/imFYj0T7L6BrmcJdXjeofCumcmp7cD
	 d8K6DtLeFBkTdLvGGudebomgTo9zP614FKAHDaem/Y38aeSTQnzbReuuphJS4jErIB
	 6a7WUmzewy8AQzTNI+DXyq2Yn9gBFhyPRgBFghUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 207/497] wifi: mac80211: account proxy paths against the mesh path limit
Date: Tue, 13 Oct 2026 13:36:14 +0200
Message-ID: <20261013112912.803238491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit a5f35d4b112af1415ff06bd501c8cc26cc08aa8b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -733,10 +733,15 @@ int mpp_path_add(struct ieee80211_sub_if
 	if (is_multicast_ether_addr(dst))
 		return -EOPNOTSUPP;
 
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
@@ -749,10 +754,12 @@ int mpp_path_add(struct ieee80211_sub_if
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret)
+	if (ret) {
 		kfree(new_mpath);
-	else
+		atomic_dec(&sdata->u.mesh.mpaths);
+	} else {
 		mesh_fast_tx_flush_addr(sdata, dst);
+	}
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;


