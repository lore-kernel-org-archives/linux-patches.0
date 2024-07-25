Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0AFC19;
	Thu, 25 Jul 2024 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918905; cv=none; b=MeaXGGEh1yQxYNRrW3c3umNayoCFonyR4AiVF+JStWAYPWqSrP3cOaPSQhL0XlxSVrLQJ1pjIAK2AnXW7/qMvQuTU3MB9iP/BT/Iq54EEm01SzMqwwzH5BR/MO6C9b7e5Dy+cci3cHePj4wP7ouGk3JQ4UZ9z6RYR7eqevevrgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918905; c=relaxed/simple;
	bh=9ocjONUo9r6P4NnCYLcO028zjHvOJ4g7pjsdb23FeLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKkKjZjr4Yp4aS8q4nC5Pnj9oximcVSI66jA0ZBOnsHpj6Xw4/Z5siCNZHRCoP36HwgpYWDOX7fKWOOTqZIWwEfdtZtJgPJNOO8Yh9kuQhPKXqrbjK5RuAj9j4ZKMYF4eLinuhP3bRGsoE1NRn9Os0sW7Q5zA7LalvqYKUrGoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7bLlNU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7bLlNU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38426C116B1;
	Thu, 25 Jul 2024 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918905;
	bh=9ocjONUo9r6P4NnCYLcO028zjHvOJ4g7pjsdb23FeLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7bLlNU1PNNQe5uonkjwrnDJscKKV9ejxTRyxdxDfgPuZTW9QvDT0TODF29NqOkMw
	 yQNr+HaL+6j+jBYpMRsehb1+DSx4vzEiDc989CQaptzK0dqESKsbWISY0+NA1Oup8Y
	 +SGnbxosikXwAvSPdqvTtCp3VaXJg6lrWHjdRO+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/59] wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata
Date: Thu, 25 Jul 2024 16:36:56 +0200
Message-ID: <20240725142733.505392197@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ce5825d6f1d1c..d3a9ce1f8e53f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1584,6 +1584,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	ifmsh->last_preq = jiffies;
 	ifmsh->next_perr = jiffies;
 	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-- 
2.43.0



