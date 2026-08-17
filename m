Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361423FB7FC;
	Mon, 17 Aug 2026 14:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975640; cv=none; b=X4sRaMPUxPhZ3wXy8k1mUCHSzrUB4vywTCfQZU2kYcwF9aL79Bxbjscwps0WCTHn5idy2aW43fVZVRMaRQmEJmqOKSWaVuKLJnb/ADkQ4hmdsLzuFt189v+ZIVBqOj0uRhL+kEu9DD/JS/DbtzvXBBzKBlWLOdpDkM8mmUD7Lwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975640; c=relaxed/simple;
	bh=4oqlWDCFcZE/iczRIoy3cCDglBSAgFsiu8R8Nw38BC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHBXwcVx346ondsvGSHZSaNqLVs2hDK6oZ7z3DVtVRlWHGvCYabe73jzmr5N5BTNnubbrXyvpOk4YriUffKjR7wEEPbJW/V+vtcFLZWbj8dt/ZTtft6dYDQNt46AnFag/e8d+Rw2kKHQzmnKw090/jdf3+TUzI4u0ZgVad3jJNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvO2b2Hb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvO2b2Hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7641F000E9;
	Mon, 17 Aug 2026 14:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975639;
	bh=bOiL+gqX2ht56Xr6Y9xEL5AUoaszwTY+wxTCt/18eIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvO2b2HbsZRC+AjZ0J7B9WI7RrdTumy4Nu8ftZhDDjODKo8QMFEB4ThNMeMOCkXjw
	 k1T13fHPUcU1Fjnefs4k+UoAnyM0Z6WksxUbCopopKzg0WM2ELaFglpgUGuYD6/+62
	 wuMj2ahtwNUnJSH4My//Of+HWC9ByXhMXwNil/Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/389] net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule
Date: Mon, 17 Aug 2026 15:28:55 +0200
Message-ID: <20260817132542.858299302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Yael Chemla <ychemla@nvidia.com>

[ Upstream commit d12956d083eb70f2c6d72711aebaf8c2ce21e170 ]

esw_egress_acl_vlan_create() hardcodes num_dest=0 in its
mlx5_add_flow_rules() call. When invoked from the non-bond path
fwd_dest is NULL and num_dest=0 is correct. When invoked from
esw_acl_egress_ofld_rules_create() during a bond event, fwd_dest is
non-NULL and flow_act.action carries MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
but _mlx5_add_flow_rules() rejects a non-NULL dest pointer paired with
dest_num<=0 and returns -EINVAL. The error propagates as
"configure slave vport egress fwd, err(-22)". The passive vport's egress
ACL table ends up with its flow groups allocated but no FTEs, so
prio-tagged packets are not popped and bond failover is broken on
prio_tag_required devices.

Fix by passing fwd_dest ? 1 : 0 as num_dest to match the actual number
of destinations supplied.

Fixes: bf773dc0e6d5 ("net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260717073306.1242399-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 22f4c1c280065f..e1d71e88fad4a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -67,7 +67,7 @@ int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
 	flow_act.action = flow_action;
 	vport->egress.allowed_vlan =
 		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, fwd_dest, 0);
+				    &flow_act, fwd_dest, fwd_dest ? 1 : 0);
 	if (IS_ERR(vport->egress.allowed_vlan)) {
 		err = PTR_ERR(vport->egress.allowed_vlan);
 		esw_warn(esw->dev,
-- 
2.53.0



