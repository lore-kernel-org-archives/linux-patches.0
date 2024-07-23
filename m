Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3B7156F37;
	Tue, 23 Jul 2024 18:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759146; cv=none; b=ZqoNOLgwzgbMFSvnE8FYlhQ14H/JdzxTtWdNr81R8QBIJI1sSy4Ee5LSSUjFaB4YTgv+u13it8HCjdc3iTDtQKgd+Y0xGVlZxuHoz8F0seJrWMInxzek0PmECXXcALuUp51BJ1um0Ife170zBPKm+HuCYZv/L/rGjppyl8uHkx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759146; c=relaxed/simple;
	bh=WPsgS43AEmgRXpiIPAo7KEEIMA9pH7hZuqSJcAnWbrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udlss+Xq09a0I7e6FPFDvrfEo3+m9zEkamZAP9QTmJaq2+NKobILerNHFwAAvgasc8qjRR4LqME4FXxPa+/UN1OZAReZB0kziceZk6CCKp+DkGRU7JZ7L1unls9i9x8K6VOI2cTvwLgUT5UP3EmILtDmIYnEBUyZR/nNi3cIHRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scENhZqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scENhZqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E96C4AF09;
	Tue, 23 Jul 2024 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759146;
	bh=WPsgS43AEmgRXpiIPAo7KEEIMA9pH7hZuqSJcAnWbrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scENhZqOST3J1evelDvnS0MPSdIUcwOKLDnw+xJ5TliVJCLTOpdlyXpjrMbTXGVIj
	 vvgbDuRBiTjB4FBoSx7q0Pz3g27E7/a7jEtAdBurFvgG9HrAS7TlgedLHyO0NeWMZW
	 Hg8x2V4eRNORd1TSQgUaO3lir64jHQaJdL1lLmIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/105] wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata
Date: Tue, 23 Jul 2024 20:22:55 +0200
Message-ID: <20240723180403.595234119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a99b8f6e465f..9c9b47d153c28 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1625,6 +1625,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-- 
2.43.0



