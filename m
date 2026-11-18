Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041159;
	b=bXfaotY1YG8pc4X25DD+HGscShnjuttUfLmlgtYLVgdwwjRLE9ohElGq5KvO8XxdXi5v
	 Q1ulsqt2JP47cJyLfeWKR6yA0dpm5bo5MF0ptwEw09jZ3C69ysPEjx0CPuSWOQmVn+ohF
	 ihf/2HuoLeGEwEiTUcRBIoHdTbTwNzjqokWRRhW7uXJn6ch/huDVIUI14RRdxaRhCY6y0
	 Wapf5MdjV/ZQQ5FP7/PIjE1ybhGL92EG1zl0mdJdyaNXU0ofQVgjbt36PzdgSsesGVb1M
	 HP/azFoXOn4wrcJ2D8sOJfe20NKGBvmv8PD2DEsbicyyR6kqzUbR151cCITtBOTFyMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aPtsnpzi8VynEd/iVWGi734Q/hmRbXAu6JkHxx2dF1g=;
	b=KGTJBhqIOEsx/gwjatLudhEXbJPrTvXO3yJkpLjmcccHy+MFtHHdmAJeEuqocez9FRby
	 T5/4h0NYVR7THCyP544HC0te/vkXQOaPBDq4JW8MDdWQnefPEh3Y8m0IhuvD+P2UuS2WA
	 5q8FGX2sX5ICVub3Nv2hh4nXkZkdgeJhyMGYY6NkR2r29CW0CTU37qkc9zcFY2jMgTU+C
	 7IX0VjULE5wydMWMC8NGRATEil4ftPnb6j+glFKHpVPVgjmsscF1RgSK2KZjcNJ7sD7nS
	 yMhVXC9u68NxgBIsUR0YXg/s9/36D6IdKam777B9I65ls4s5antAQpfIiTFw6YtEX6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIHmjxEo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784EB606A31C;
	Wed, 18 Nov 2026 22:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIHmjxEo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5BB1F000C4;
	Wed, 18 Nov 2026 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041159;
	bh=aPtsnpzi8VynEd/iVWGi734Q/hmRbXAu6JkHxx2dF1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIHmjxEolrKLG2JERUk+2ZHg3iaTwNGL+cGNy8pxxFlKzCt7czk4PLPPMECrVkcP3
	 bpHpRS2eiKJ5RmvuZko5RikB4IxeuWSb91Kks8IT3KLj5/xcdn+6S7s+4DhYrS2GTp
	 XQRRrMT1ElheGQsO/YRFq/eirxViH3+dqZz4g6IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2712/3318] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:55:34 +0100
Message-ID: <20261118150442.236346115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1b0b7707a1189..c45d5eeddb441 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -707,7 +707,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
 	if (!mpath)
-		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
-- 
2.53.0



