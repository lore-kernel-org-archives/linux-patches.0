Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890951F8660;
	Tue, 17 Dec 2024 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456847; cv=none; b=lW7IYLgQHHzIHEZqhPnRlbSD6VG9aQhB1OTKgs2ljdUnGMS0QgkZwnATyYABX1PyeLbyrlXXCdZTryC9eFH4TF00PHRrBgZFFNW8OhaM9Vj7FmuOCjXHW6p5oe8QW22/72t99WHFRAera0BDTXuZATfurH8oZI3sPC1zX4PmIaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456847; c=relaxed/simple;
	bh=LrBWuFpWS2fAF3ybZIkfCkZGt7+HuXYgZRXjWb4k+N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpQOeN0h82RV+X5JThwU2QowFGjTmA0oHLUG9AamtQsQdyjsD69F9lX0jBYP/DPT2FJC6lTX2xq0mwABybG2V+3jKGlf8WAVhGMBDJmrhNXTNraTbjgpH1h6t2g2CdouNOKCnwUCgzyO9SZUQc8mhSxrmPWB0a9HW3rW5pBHG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DD4ZKf0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DD4ZKf0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9F5C4CED3;
	Tue, 17 Dec 2024 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456847;
	bh=LrBWuFpWS2fAF3ybZIkfCkZGt7+HuXYgZRXjWb4k+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DD4ZKf0cE07WqTQzvudPtj6WWmQVEw06L7z1m1ob8EQcRQsVEGMmXOwxEg7XDL8yt
	 8Ilymm+2uwxQKxRmselo915KaFY3DGucW745fQD22WUpYhDQbEcHTIpO+GMcwq0AmZ
	 6RVo8uYpkqLNiRXvIPA8roi15vmNZFXW2I0h6ydc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/172] bonding: Fix initial {vlan,mpls}_feature set in bond_compute_features
Date: Tue, 17 Dec 2024 18:08:17 +0100
Message-ID: <20241217170552.186094737@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

[ Upstream commit d064ea7fe2a24938997b5e88e6b61cbb0a4bb906 ]

If a bonding device has slave devices, then the current logic to derive
the feature set for the master bond device is limited in that flags which
are fully supported by the underlying slave devices cannot be propagated
up to vlan devices which sit on top of bond devices. Instead, these get
blindly masked out via current NETIF_F_ALL_FOR_ALL logic.

vlan_features and mpls_features should reuse netdev_base_features() in
order derive the set in the same way as ndo_fix_features before iterating
through the slave devices to refine the feature set.

Fixes: a9b3ace44c7d ("bonding: fix vlan_features computing")
Fixes: 2e770b507ccd ("net: bonding: Inherit MPLS features from slave devices")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-2-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 166910693fd7..dfad7b6f9f35 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1562,8 +1562,9 @@ static void bond_compute_features(struct bonding *bond)
 
 	if (!bond_has_slaves(bond))
 		goto done;
-	vlan_features &= NETIF_F_ALL_FOR_ALL;
-	mpls_features &= NETIF_F_ALL_FOR_ALL;
+
+	vlan_features = netdev_base_features(vlan_features);
+	mpls_features = netdev_base_features(mpls_features);
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
-- 
2.39.5



