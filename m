Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208730;
	b=BAbZSMy07b79utSpIr7bG+k1HIx10LxPQyOCYRnhQs9lJMgXTaBF6QpqdT/+Fqy20Rrm
	 E2eUB8MP/lOD1BpF5DRF9fsVR1udMrkxYckB0t1nuipGAmpFVaUXUmd/49WjEo4Uq0grQ
	 IlDip8gYVBx6Co7/d/hI1kG2nSTSVktkquv+DP0QvveQUEcBQ/yO3LhpJ1aaS2CKkcN2e
	 f89pk25KMns5ccHWFyUe+d21f5kgZZiHK4VEW/VCpF3twNwpLn7spbI5TU6T1YjmraY0e
	 DIDEMmarZ+SyELdhycYrGkXnPUAxiG1roRGl/CbYNYSDFE/zytcTLnUUNBNMt9DBy9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ev2v7ahk3vfhzmdl7G1g5dvkApkD4n36F04tQNX0IsM=;
	b=Mj9riQkRtCDSP6aTDa/XQVFz7ZO4eH+xAjGJgba0v6XNsA/ZCtHqlPR7p/UN1msHEHgd
	 leey2riCY9HYymqi/YFHoZQHBCtpv9eC9qS5EFeiGGgIGPIsL484FBLmkV2Y9zNvfhOaf
	 tnGqYSdOXvQxncKd68qX6wrltX2kl5EHBzYFMDZmrCK8Hf61bVW9vqhQYgnZ2CWTtgVbk
	 RzHNoGPU6RaRrtVjAfQpSXELv97cN3pkVDR4FpC7eypyaFWEa2aOLSFP58QqRYVqRSmts
	 R8UQzGZtwDvljStpi4tk+zy6qiueftzmTpNvRC7r5+c0bUS9qsD2S+68AeTD56tZuzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPFnTmFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56299606A31C;
	Wed, 28 Oct 2026 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VPFnTmFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CDE1F01825;
	Wed, 28 Oct 2026 17:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208730;
	bh=Ev2v7ahk3vfhzmdl7G1g5dvkApkD4n36F04tQNX0IsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPFnTmFNJJwNpYz8X6GZa8yIf1f0ap3HmeTK+0BvvQcVGBHA6APj1go2f6uBcP8Ng
	 XLHtD5wp+Tn7zhazNcKOklqyb4t18y98cvQVlh9xDnXq00Hd9+b0JZzZQQ1azdzSoK
	 t2QERETMqfs1eAt+B/ku5WeMKFLRNrvHqGxqmdRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 221/516] wifi: mac80211: release mesh path quota on failed additions
Date: Wed, 28 Oct 2026 17:56:13 +0100
Message-ID: <20261028170008.736015795@linuxfoundation.org>
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


