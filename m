Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026135;
	b=PinDYedsvY6rnHw8vaYDwy6tTLrdzGa9XEVFDGpXcFBzNgSkb8ij5l8N850XcmGwwkoh
	 520d4YKnenJfjTR0hvD5EbZUFAb1/qEff9NkyrCzgzTYNu3oSqJnympPS4HlvPs5Xlpxw
	 jG4mJTcvPsgz6gJMkzHoHjVKvi++3oW8Z77sY1Vdrsc2ZD77FvqBAMBJrDhIywUeBW6CS
	 TqJO6sgd6QZ8VfKQ1gRDEvuQpY7L2WU+rjyvG7+KNcJMz1V5+S3PltAjaIF1iezFOe3M2
	 C4IEFglPR50JAEZvBfZBrPzGPxubCooTTVkB5felEyWvz2kSnV6DG3vu6PAdL3/oJRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6JzlPi0zzn6l+HwzldrMfE9vgwOAMv1vqB7DcZ3AQF4=;
	b=SqBih98b8qMO+g65ASd8jq8qa/mUcR3q8davEaa+cSF8Rk3r4YtKaXkAu5y3EuKOQrGd
	 G4hIyIp+EAVRHPOxZomq/iTs4SCQz18eVGOaNud4YpE8aFVGlAL4PLeAvq85Jb+Q4trYC
	 EMIZlnCYkgFPEinqQlBRVnivx6J4UMnewyEjrmHInkoo19UL/NXmucQw6N1bhNppGfkVX
	 zVpFFPFg+8ig+7hUz5JjjDUIXTW72U46q2shLbjWh5iezrJxW+ZDGvD21OT4XN4MwZJDO
	 bhAyYb1fX9JatmIM5mqRYTT3vNGqlarOOlvdDRpHeHkF40JRtC5K2U1RfDviDE3yNCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQXNlNN2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9191606A320;
	Wed, 18 Nov 2026 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQXNlNN2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279751F000C5;
	Wed, 18 Nov 2026 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026135;
	bh=6JzlPi0zzn6l+HwzldrMfE9vgwOAMv1vqB7DcZ3AQF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQXNlNN21CvW/BjXrG/0j3cGyBS2XIyBZbC8sK79xldtyKG4Iesf8RmiX2a66Honj
	 2TcBA+51gfh/NCGdFLN06FiSFVWFn+NQu2FHPn2yujNC2XhPL4fPqrvpfS/GD9tpRN
	 fp2pYrh2pKEZM+iZ8+lNQQPP8VKzIAtMPRHU+BUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1290/2151] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:50:25 +0100
Message-ID: <20261118150209.117823885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33a0ef5285e10..f3caea8107c3e 100644
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



