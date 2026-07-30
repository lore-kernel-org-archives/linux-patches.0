Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2667A434E2C;
	Thu, 30 Jul 2026 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424203; cv=none; b=kOWTHPG6K/zTfM1MW+CI1biE3KiULR/RgK/eKYf2emepsJzMpm6cIRE3uz966fqPxgOH1OGVGwuAJAS2tFq1EfjCf5ABM/YXalL6o4/xutHXAa7UwP4W99abyGCzFpGCORffAYkM2jrjyb5O4c2PzZJ+/dxKecXwZ9QS+gfl+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424203; c=relaxed/simple;
	bh=4NxlQgUtQMLdZ+e9ED+Qdnu14hByG1lJ3HJHX9Ez2+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0wHq84JOmD3faA1zcY9QLYRx09GTOcVwcDy+p7AJt10kvUmC1UVbqoM1djVLJBDLRh6YDqRpMMrXYhwjIbeDjXm1SU7g1q1J/+32QRoX27BL8RI75g4dg9S42ve77F5TUSvI+PonwQ0JSI53DUr3ucT5rAUiWvOt153eT1n078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBJRHepU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBJRHepU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6470A1F000E9;
	Thu, 30 Jul 2026 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424201;
	bh=V+rg8tPHGZR/jzCI3vW9UjPvIwJpYEarzwSCW5ILWPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBJRHepUclHAPN6AhWEJnGe1Zd+259RtKX5q4P/dHhyFbYrLo/OV6PGDilQ258VzB
	 pYOmH6NU/KHd5gB79a3WIEkCKM/XESCjnSU+zlPxzWknKzh1eNkPN/AC0OSZkZ9yl3
	 3/T+DTYBqF9Y+esDTqAXwzTKHl9LQRh21bVvVGSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Chen <vincent.chen@sifive.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/675] ice: allow creating VFs when !CONFIG_ICE_SWITCHDEV
Date: Thu, 30 Jul 2026 16:10:39 +0200
Message-ID: <20260730141451.691933530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Chen <vincent.chen@sifive.com>

[ Upstream commit 99d0f42b0e5c57e4c02070a908aaff082881293a ]

Currently ice_eswitch_attach_vf() is called unconditionally in
ice_start_vfs(), which causes VF creation to fail when CONFIG_ICE_SWITCHDEV
is not defined.

Fix this by adding switchdev mode checks at the call sites before
calling ice_eswitch_attach_vf(), consistent with how
ice_eswitch_attach_sf() is already handled in ice_devlink_port_new().
This is similar to commit aacca7a83b97 ("ice: allow creating VFs for
!CONFIG_NET_SWITCHDEV") which fixed the same issue for the previous
ice_eswitch_configure() API.

Fixes: 415db8399d06 ("ice: make representor code generic")
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-2-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  3 ---
 drivers/net/ethernet/intel/ice/ice_sriov.c   | 14 ++++++++------
 drivers/net/ethernet/intel/ice/ice_vf_lib.c  |  3 ++-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index c30e27bbfe6e25..b069e6c514fb12 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -512,9 +512,6 @@ int ice_eswitch_attach_vf(struct ice_pf *pf, struct ice_vf *vf)
 	struct ice_repr *repr;
 	int err;
 
-	if (!ice_is_eswitch_mode_switchdev(pf))
-		return 0;
-
 	repr = ice_repr_create_vf(vf);
 	if (IS_ERR(repr))
 		return PTR_ERR(repr);
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 843e82fd3bf936..6a0b724e46f9ac 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -484,12 +484,14 @@ static int ice_start_vfs(struct ice_pf *pf)
 			goto teardown;
 		}
 
-		retval = ice_eswitch_attach_vf(pf, vf);
-		if (retval) {
-			dev_err(ice_pf_to_dev(pf), "Failed to attach VF %d to eswitch, error %d",
-				vf->vf_id, retval);
-			ice_vf_vsi_release(vf);
-			goto teardown;
+		if (ice_is_eswitch_mode_switchdev(pf)) {
+			retval = ice_eswitch_attach_vf(pf, vf);
+			if (retval) {
+				dev_err(ice_pf_to_dev(pf), "Failed to attach VF %d to eswitch, error %d",
+					vf->vf_id, retval);
+				ice_vf_vsi_release(vf);
+				goto teardown;
+			}
 		}
 
 		set_bit(ICE_VF_STATE_INIT, vf->vf_states);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 4f86412a9c0c3a..bab968b05540b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -812,7 +812,8 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 		}
 		ice_vf_post_vsi_rebuild(vf);
 
-		ice_eswitch_attach_vf(pf, vf);
+		if (ice_is_eswitch_mode_switchdev(pf))
+			ice_eswitch_attach_vf(pf, vf);
 
 		mutex_unlock(&vf->cfg_lock);
 	}
-- 
2.53.0



