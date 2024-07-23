Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A3D157A55;
	Tue, 23 Jul 2024 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759834; cv=none; b=RbBtGBZCxeJJ7AKouNKn5cWbXpLlFTpTDpLmfbQJW7M66KxLLVog0mCItRgbK2fw6X81FdZzgunQDxR3zwmUQwys/9TWXc5Ln9g39RiXGKzxMn5urUMboaCZYsYiHHilebAZwjZPq+AU+w6+ZAckzZCYuI+kcNxbswr61uFLygU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759834; c=relaxed/simple;
	bh=R4rTMVHRQPXsUuWSbo6dcw+AbsoxjmdOJyUmyaT3okI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdUwPVUXPGAgp3ovLCX/tltNt6bfPkS8SQc9ynAJXlmvwH25ZVp/J9C94xTP7vFdQD7lhMbsKo9HEgh1sUGA0hTnq4AHbWIxI18UGLkzEmJhzrqYHRB/VX2hX0Da0OSrs/RAuD9gBKh1gq67jPZvz9WJ+MuBA5cVDkVmoG9PDW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKwtWkIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKwtWkIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF2C4AF0A;
	Tue, 23 Jul 2024 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759834;
	bh=R4rTMVHRQPXsUuWSbo6dcw+AbsoxjmdOJyUmyaT3okI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKwtWkIQMrSCImHcZi1TnbDRbLh/Qzg0wzh+J/z7sfxeXpBiSNgdpUvwuHjKUO6yM
	 YGnyJCywiF4mcPGK2KKGnrI6p3Dc7kfGNw4+KXjzu3N8dvkCmymkuBD53aiVvY+Aip
	 7Y+8slKfNadH8Mw+BZK9ZguZEHx1mrZf3gKndj0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/163] wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata
Date: Tue, 23 Jul 2024 20:22:23 +0200
Message-ID: <20240723180144.021508753@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit 6f6291f09a322c1c1578badac8072d049363f4e6 ]

With a ath9k device I can see that:
	iw phy phy0 interface add mesh0 type mp
	ip link set mesh0 up
	iw dev mesh0 scan

Will start a scan with the Power Management bit set in the Frame Control Field.
This is because we set this bit depending on the nonpeer_pm variable of the mesh
iface sdata and when there are no active links on the interface it remains to
NL80211_MESH_POWER_UNKNOWN.

As soon as links starts to be established, it wil switch to
NL80211_MESH_POWER_ACTIVE as it is the value set by befault on the per sta
nonpeer_pm field.
As we want no power save by default, (as expressed with the per sta ini values),
lets init it to the expected default value of NL80211_MESH_POWER_ACTIVE.

Also please note that we cannot change the default value from userspace prior to
establishing a link as using NL80211_CMD_SET_MESH_CONFIG will not work before
NL80211_CMD_JOIN_MESH has been issued. So too late for our initial scan.

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://msgid.link/20240527141759.299411-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index cbc9b5e40cb35..6d4510221c98e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1776,6 +1776,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-- 
2.43.0



