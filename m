Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211041;
	b=oyqSP6KpCg/vmkPPJ4Bx1Wrgrup2J8EHcCWExE2Hb7S2gvaJdFAvZY6tKTd/5SSTJE4B
	 4wgs0eNSpIsROuE8E920pjeRtAC+QmSm5hVBzeEQQ2PVRDdcSYBd3bwlf4cMxgmEKE6HL
	 YRAVZK6MGQT+s3fsefJTVXNqLNvhQW5ffkohAz8CYSv2JEV0uRH4OTA4RFaOQttiRFIV0
	 5/WSf9v5zCNV2y4Ql48AZBv4uVDglp3NJUhwLkcEu5J9zviGv78XZ0RRvBShj46YvSljQ
	 xl2DI84jLHgr2f2l8My/drWyh1EUN8BZLv8jv4iTDaWqc8DnHqZoO0qxX7AFeB3ZNzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7bwtYdK7ERYgoevN9Y8kCA5IM1zsNtg2pehD12Et4/M=;
	b=0xQNhI8BAabh0TrANIwL2dyjVrEvswxJnth222zswnoKCT2aOOC1YzhV5KYCIxNttWhh
	 4lZ4SrNF716MFhBLYZmoNUSo0KD1B4zCj5bT+BmHKwnoYfxub1g0pXGt2lmO6HzHRRbuc
	 D8IGwn7oz47rdi/0XB52HY24Gs01Dm1Aiti2mJAzXFySm9wtVrRKT0ywFWwplgDRLBQtg
	 34vGZ0ZrftOBrZeEoCp38P9YKNWUvuUb3KCGsAh/aBzFpw8idu7Mxm5vdXUadwhVjDMpF
	 gX3443fojEdKXWFpeEv1SCLqJa1Tc+pyhseyMAQ1KSyI1HtkWkajO3XtMY3f2tYEyqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xto4MXdZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926C460A3826;
	Wed, 28 Oct 2026 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xto4MXdZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29B91F01825;
	Wed, 28 Oct 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211041;
	bh=7bwtYdK7ERYgoevN9Y8kCA5IM1zsNtg2pehD12Et4/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xto4MXdZ9hJqAUMUkb7qeOigzRb+Ms4F9hYwhu6OOAz3JGoIw9d5PGjfiDh0DjXye
	 RL2KU1LuLsBJubJSVmHw12PwU3o75lfldG3DMo1ZH5R/vVe6HuVFFUGG2MNfOX/OSx
	 00ncKm7+qSW2eWI2whSkGtJJQ2JNqMEO2QFhzQEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 239/571] wifi: mac80211: release mesh path quota on failed additions
Date: Wed, 28 Oct 2026 17:56:26 +0100
Message-ID: <20261028170013.678145294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -407,8 +407,10 @@ struct mesh_path *mesh_path_add(struct i
 		return ERR_PTR(-ENOSPC);
 
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
@@ -421,6 +423,7 @@ struct mesh_path *mesh_path_add(struct i
 
 	if (mpath) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
 
 		if (IS_ERR(mpath))
 			return mpath;


