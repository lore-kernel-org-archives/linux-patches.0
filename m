Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211419;
	b=onQ30xlbhAoDAqA4ELzbbANrjrYNlyIG40l8sPoMCdTV1PdaamAm2M0SPGwxPbiqsNdA
	 dWY1AcemdKgZesM1faMg/VZnXPKXK15HkHxUnjp72OOd7mZuHANRtCEqC6Q9TTY5Iopwb
	 zD01GyYvJKtNLer8XfJetnuJ/ijfXAMMNT9usHIo5cs0ypriKtH8IAYaDUNeKDNNxb6cV
	 5OwvQCg/oDvHV8DFCVKYbdV8aJ9rHLZBpX3SfujUs8RsDSSH9HvWCKFpgd9t9LjcJeJqA
	 FpCQc3g+7J7Bh1oFzPhRwMGSNsReRqJxb1MjNqteBwBVo3plU7hHuqqsXydNPfi3BiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZlet4hY4UuAM6biN6t4+d2TG661zWnPR0afrul9MuM=;
	b=ZriIerAG3myJ2b5gQ4yozNqGfOMXo5SROGoojszPsUThbqaACpzvznxSGG134gmdgYIT
	 hytbrNCSLD1rOcj8u0Ljx6xnm5JuDNROJk3mjO+kPqEZB0JxcGg5LpknRz7Ms3ENDNkJX
	 wxWzq471bTQitUwPkhsv6CWtnB65jXQQldA7jsHHKgVvbToX7MDaIqNbRNz5u+cyWL7o+
	 o9xyn4TR9Ju6Sr6Oi6SLzocoQLNOcuh/g12J9LojgjET+/w/VRfvDhhhn34K6wgWEgLvl
	 0jItvGN7kKLIxtZH21NHgpAskSwPpGh7DBHNa1JS51Sx+E7NLwXQIbsa8069zIKr7Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwbsV624;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079E0606A31D;
	Wed, 28 Oct 2026 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwbsV624
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577AE1F01828;
	Wed, 28 Oct 2026 18:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211418;
	bh=PZlet4hY4UuAM6biN6t4+d2TG661zWnPR0afrul9MuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwbsV6242/N+vgo4ddPJ5HVJ5vrT42gKJNERItbEftl7/JD+LyiykbsTEG1jW93Kq
	 WrdgULNJPMrr8DaDA47WXtxZJOiEAtLIJLSC9V1pdBfNRjcp6EI2sYUJGvYxxWtsAz
	 MseV/RdE+291di2gtJltGGvYbNg3A75BM/lrXDVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 325/571] wifi: mac80211: account proxy paths against the mesh path limit
Date: Wed, 28 Oct 2026 17:57:52 +0100
Message-ID: <20261028170015.716375903@linuxfoundation.org>
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
[ sashal: Adjusted error-handling braces to accommodate the missing mesh_fast_tx_flush_addr() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a0ef296e3e4f3..f2970f33f96c5 100644
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



