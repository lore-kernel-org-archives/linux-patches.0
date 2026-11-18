Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055987;
	b=vs6GtGh+fsKgkWvUGdIxYuW3XGuz9PYVW+o3Jh8Yp0F5ucnzSA7n9Hju9v8jcQ1rN5ym
	 wBQqba6807WF39HiZNFo3BfGkxOaQovjA6DcDTSwAReMwak0zc8guFh98nYhS+tO9MtVB
	 RvWrE5ZOx5AmtqXJh6slVPFJNwEXI+feT70kJ9FOBXZUrTQSA4B2WHWz0FMsMr/nZ1VJA
	 m8x5M/YctluBwG7ewhGelZljiuhpIihXsSqxI6UsAE/K3eF3EtL7G5Pao63wagMRTE+HV
	 X/To/AVAaCDczLDgMCEsnloDixaN8TVdmmW+qBAPmSSM4FwPaoF+TiXKzhgzU7vM0SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LXinwO3oZqVYZYjj3rQA98+b9CxPiJqP/KSQ/76z/6g=;
	b=2KwcmZk+ZfFcpVyM5zDLlJmH8yF8VMV5KR5awVtNPfX89Y0wZStO7pVBASL34ggibvS7
	 cwAMT9ap4kiuLPZHmVnvOp6kNt42ceBdGieOZpyvEzt0cwcjc/293W1rfGNcRX57bVDP8
	 2RRP5aXpSyictSpt8caL5sRQzI+YQK0luxTK3zg6SKtEab6eg2uh3sVy75A19rF42RAiE
	 ZVPnEwFuH/cCxKzj/roxIIWos9xYr18+v72I4iWNcOPaFAG+KQ/PpzJLB/b+SSNHgz1FQ
	 xeqif84Jt3f1g77/YeXdDG2GyaQMBvc1/7PG2jAiN91LH+mSnFcfg5F6DwkWfm86o0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bI0EE3az;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01E7606A325;
	Thu, 19 Nov 2026 02:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bI0EE3az
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5E61F000C4;
	Thu, 19 Nov 2026 02:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055987;
	bh=LXinwO3oZqVYZYjj3rQA98+b9CxPiJqP/KSQ/76z/6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI0EE3azV3nfE8VlUMkVkAq+2qoePCrAsdihTbE1ahEiSU8QXoxjEb/raKEHQ0rJ2
	 nKUpyIGAn++dQ8EoWcd2y3s/5ErsYD0GJk3zYk3dXJFdHPj03kPy4IzshXXiBbkfma
	 JPYm6tTujq5RhrhWAtKgH2ZozjwUPWvCGNxTrHRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1828/2214] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150124.568262649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index a5ea7bc2065b9..bdbe2f9b83b7b 100644
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



