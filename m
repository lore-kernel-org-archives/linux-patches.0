Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031337;
	b=4NU8G2zlwXZ0LRIYOKjA8NZ8MLLGsci2vP5FBBDTSfI0LmLkBEeqq8+eFZS4CEyB2zag
	 AVxTFeqr/9rebSZErRximG/hhl6HzmtpZ3ZwNlRO6npJUcO8cTtVtXE55eglnajw4OTC8
	 8QZSVQqSVgoIzp7J93MKspWctbuzndZZAmQWGE24H2wUku14IH5OBBUtW2O509wSxsDUq
	 AqcLcb58APXDHuwL2hgSM4Kc77LvdLqeWE7eRXe8QiBYmwWtGj5nfOaMO/L91tyh/AWCU
	 Sy7ay9D5WTxqrljtvCR2IK+Wq1MeCQUrKl3jns698UOT6vHxRwOUV3FAW9pDvSBoPEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QL/HsC3SZOF5mJIUZYNHk883qlLN25rIPdkfMjy244U=;
	b=r++INkC/EUJ3IsA4xXkBI4YzF/O+NvuAtY27DrX2HmAMLSvTu4AHAJTThIVJgsLCG2pn
	 YCgMV/Vhy+oqzml2fTmbawdz76NGz+5FW2Kvk6y4QEVwa4QlZGZEV4fvekpQmTvTj/14j
	 gwdb+Zlpx4UJS23AXRW1EgouRBCPkrSOAz7ZJYyMG7bPX0dG7HZV62lmvJGdmWE8NUZmb
	 mfnRtNqDihN86AA2kllFluLKCiF8v7F3eLKpr09RT0alVzWSZPr/SsN07DMHxWgTw5cQ3
	 JTq6ETiK+qsBsnUniidFkmxl0XqUbfygBkvGtvvnFWId9QxGcJum1aTEj70W0EYMMTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s/oHxIU+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D082A606A31C;
	Wed, 18 Nov 2026 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s/oHxIU+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585041F000C4;
	Wed, 18 Nov 2026 19:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031337;
	bh=QL/HsC3SZOF5mJIUZYNHk883qlLN25rIPdkfMjy244U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/oHxIU+Q24P6aquJwDaB9mjORoRsbCr+jynaBXqfrRvxx3OCLpTfAcHrdtQAWPA2
	 Uk+XaGcanVk3TL4PE62NKoP5fRgqczP2BCZs+Zm5+XxWQEuR6rL1xmbY94VRzejGFz
	 SzpUkuVNQ/QlCkxxyXc9AEwnr5PBV5xGUncsjCBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1024/1756] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:52:31 +0100
Message-ID: <20261118150050.862476975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 26a34458fb792..93e9699adcc2f 100644
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



