Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2042EAE6;
	Mon, 23 Dec 2024 16:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969872; cv=none; b=DAzH/yGGLk6eRorxsCt2U+NIGdwcCtu3TtorYvWywakdJW85k/wZewfJhlfonXHEDM0ALYqauZ6eR6r+MlcYtvjNomqCzTKy80aGzsK5Zo8ixyNSNXsDqwmg4v8bFCeKGYFdsaU4zaMWiw2lIrhoM6S/rp3OdHZXtse5J9GMJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969872; c=relaxed/simple;
	bh=ezXPhQH5bXEmrkd64IfhExtC+vPiUWcfucS0oYR1f+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7MZvUKn5eKOVrruQtMdgO/hrZWpTcfv6b2c5v2tbo78otJqmAeQrwikvuU553YwG8beYvPcrBLEU58uYvwDCUsAQbSPbC38AOxsKsQduAVoBNqolSV7hU/vlKtcUthifh0EUTcrwoaxz4ZPTUTy/1sInlk2nqhTpEgDfeLVDME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13adsQe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13adsQe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB7BC4CED3;
	Mon, 23 Dec 2024 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969871;
	bh=ezXPhQH5bXEmrkd64IfhExtC+vPiUWcfucS0oYR1f+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13adsQe4AVAq9RgUKxiaO79pUu8gQWujnd/dBGI0OtS1fpAG1W99fd0vENIfAnser
	 oIbzaTuzW/izP11qGJD7GkanTPr69drDVyxu+VrClH8jAuOS9jJ6AdK23mgyTLVUuO
	 OSOC4no3S7gsSmDMRyfOJIiWBtZR5JFiox4COyz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/160] team: Fix feature exposure when no ports are present
Date: Mon, 23 Dec 2024 16:57:39 +0100
Message-ID: <20241223155410.543549167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e78c20f327bd94dabac68b98218dff069a8780f0 ]

Small follow-up to align this to an equivalent behavior as the bond driver.
The change in 3625920b62c3 ("teaming: fix vlan_features computing") removed
the netdevice vlan_features when there is no team port attached, yet it
leaves the full set of enc_features intact.

Instead, leave the default features as pre 3625920b62c3, and recompute once
we do have ports attached. Also, similarly as in bonding case, call the
netdev_base_features() helper on the enc_features.

Fixes: 3625920b62c3 ("teaming: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20241213123657.401868-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 6ace5a74cddb..1c85dda83825 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -998,9 +998,13 @@ static void __team_compute_features(struct team *team)
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 
+	rcu_read_lock();
+	if (list_empty(&team->port_list))
+		goto done;
+
 	vlan_features = netdev_base_features(vlan_features);
+	enc_features = netdev_base_features(enc_features);
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
 		vlan_features = netdev_increment_features(vlan_features,
 					port->dev->vlan_features,
@@ -1010,11 +1014,11 @@ static void __team_compute_features(struct team *team)
 						  port->dev->hw_enc_features,
 						  TEAM_ENC_FEATURES);
 
-
 		dst_release_flag &= port->dev->priv_flags;
 		if (port->dev->hard_header_len > max_hard_header_len)
 			max_hard_header_len = port->dev->hard_header_len;
 	}
+done:
 	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
-- 
2.39.5



