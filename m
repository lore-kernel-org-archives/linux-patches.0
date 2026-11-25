Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625905;
	b=fa4ULLt0EoZo2ozbDW3qnadraahkqlJZh05h6TeOK2K0JSvENUcmjQPJCJj2h3Ge1u3o
	 OT1nVqLfXBObHwKCqLBJQ5W8ZjxLbQ2LxmIP1Yjkw+Pc94A+GCT8L/u86r5DeDQsf2F3v
	 NXotUvaUV1pOMItLpsmdtspxl5NMZotG5rGjHkDiOjiqbV2qjmYMEJ+lYBkXV0YblNTvk
	 hELq/8oj2a4eST/jnlKqruwPi54hClLwoWZ79qIX/+8AtkhhGL90L6k/fKXrX+NY3KpeF
	 iw+SQ4CFHNyHregZ3/FkHdIfndIFuVzJQ8C5SpezXduRegtXmwgK+LX2eL7lOVOoVZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sjO46Oco2SiTdkrN01zb78+GygnoXD01GDdcJUeB0tE=;
	b=KsxSNCQtpgV0ol0sWhCTugeZWBFH4JOwmsGxIaLnyCYUshFmOYZ1XaRYk/m+sTBfgFER
	 Pe710LkPOpgr8Kp9bd/qngcKqE67vo8lgsBke6t0KoPLTvYuHmtMaFRsZBaL/OyeyaIY2
	 G1BbTLMRUQ3dNiQgtCnW/6cDAZmZJb/wL976trzptUnyxZp99FJDyXKNu4NTeBYvHsBBj
	 cfBkKgVn+/iOBKXiDGIhys4+wLVcLcGHGNI5UQqGucLCr5vYMw5ZgKnU2wP0XsfEqWPMn
	 Vuwd7GY2MBi3NQgFsRRCLmiHsUdbGMETe4QhRLDNfdAm/hJECPidiFrZNBmlirpfeug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgHx1zI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB2B606A31E;
	Wed, 25 Nov 2026 16:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XgHx1zI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058861F000C0;
	Wed, 25 Nov 2026 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625904;
	bh=sjO46Oco2SiTdkrN01zb78+GygnoXD01GDdcJUeB0tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XgHx1zI3HnmkRpsWo3psNjUA5+UaShdjWcrPynAVprA64xR5fttoVjWmezJjC+dlm
	 NAJHRJkWxl/X/JKxdFwSTJOSglPFXu1Phiry2fLwzZBhuW3FkuxzRKtBdYZmLB/IUi
	 GzcSh98oC1Fy01mb8IC177xBX5tS6fd9/kfHAt2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 669/816] wifi: mac80211: restore dormant links when link updates fail
Date: Wed, 25 Nov 2026 15:36:57 +0100
Message-ID: <20261125143904.662822265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit bb22f3b2d8f8a2f883944f24678cf84e18b162e8 upstream.

A failed MLO link update can leave the interface with the requested
dormant-links bitmap instead of its previous one. This can disable active
links or trigger a bitmap warning during rollback.

The error path restores the old valid-links bitmap but passes the new
dormant_links argument to ieee80211_set_vif_links_bitmaps().

Save the old dormant bitmap before changing link state and use it when
restoring the old configuration.

LLM assistance was used to find the bug and review.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142123.13072-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -281,6 +281,7 @@ static int ieee80211_vif_update_links(st
 {
 	u16 old_links = sdata->vif.valid_links;
 	u16 old_active = sdata->vif.active_links;
+	u16 old_dormant = sdata->vif.dormant_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
 	unsigned int link_id;
@@ -385,7 +386,7 @@ static int ieee80211_vif_update_links(st
 		/* restore config */
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
-		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		ieee80211_set_vif_links_bitmaps(sdata, old_links, old_dormant);
 		/* drain RCU readers before cancelling work they may queue */
 		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {


