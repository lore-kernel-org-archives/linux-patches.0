Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303E047141D;
	Fri,  9 Oct 2026 14:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556675; cv=none; b=ThTthIk0gCZbp//XZ2Ue4vZaVDcECTMgwnk9vXKIZtVQ7XdosXVRoLZo1IonWpl0R4auQGSv8tym9sLjvaPBG42U+TMFMPpKwbjmEus/Tvzz+H1M/5B+C6AuAQJAXCqrhyRCgSpwlfep2Q9fE7aVCaFnv9cqB/BtYVOidRs1WmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556675; c=relaxed/simple;
	bh=RUJpLCC4R3ps36uiZskP+beyvPL3OqORZQmOlXp+Xys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1wN2XYAxV1zBOzMmBNFPljyKOx96Zh0YJbtOUwvW94R/aDEVRBDnqu+32KuhGJ2+C4WkBGpRdkge1V6znPUkkrjriFOBZs2c4XmmVQ/qdvz4R7Muro8ZXRXV+bEbmVayW+jWOgIyi6nN2R+d2Rg77jz6jefGu0xirkBX+XAf5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdKaICnO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdKaICnO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB941F000FF;
	Fri,  9 Oct 2026 14:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556674;
	bh=ezi1t4aBXS/OvoyTcO6r0vInCNawXA/CYzK9JMb5Qec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TdKaICnOLVtIn59iDLXL1G2z3JYp1MOeP+s6xtclrsGScRayBeyu0ca1Bm7cQQqWe
	 IGKp3PQbsQy7iJwaKlfgcTJkTCm/8xaOx4kNaEKSgFWEKDkk8XyChP0oWtfAKmV5DP
	 U7bGU9fKy4C7eWqCuCfZuA8PM+K8Wr/qiK9CswHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 273/403] wifi: mac80211: release mesh path quota on failed additions
Date: Fri,  9 Oct 2026 16:10:34 +0200
Message-ID: <20261009140958.570204759@linuxfoundation.org>
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

commit 7325a44474f20c1393a1c114c6811abce6ddfaf4 upstream.

Repeated failed or duplicate mesh path additions can exhaust
MESH_MAX_MPATHS while the path table holds fewer paths, which stops new
paths to reachable destinations from being created.

mesh_path_add() reserves a slot before allocating and inserting a path.
If allocation fails, the function returns without releasing the slot. If
the rhashtable insertion reports an error or an existing destination, the
function discards its candidate but retains the reservation. No new path
is installed in any of these cases.

Release the reservation whenever the candidate is not installed.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113649.28315-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -694,8 +694,10 @@ struct mesh_path *mesh_path_add(struct i
 		return ERR_PTR(-ENOSPC);
 
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
@@ -708,6 +710,7 @@ struct mesh_path *mesh_path_add(struct i
 
 	if (mpath) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
 
 		if (IS_ERR(mpath))
 			return mpath;


