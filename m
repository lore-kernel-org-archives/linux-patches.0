Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBFE3B3C0A;
	Tue, 21 Jul 2026 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666658; cv=none; b=LVWDOiEzsEb90Dkqh+ZyOe8Q524uHOP7GXC5idc2u+FIy+Jgu6co4dJpm5R+nc/JFHSPOJWaWaaO1j/nGA4D0IBGNWDUK3Ee2FqzXQL4fAeFf5nAzq4vD5lF+D2ajF9Fx5krKVhf8A6RX0HO9Hlm+gOUjDt3z7j3afukSqpqQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666658; c=relaxed/simple;
	bh=EBqvSE96C3XXF97CBhyDJ+Scs8eiKgALZS7ZeJYC5Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isQwhnKQ8RI8JMnNkbNZsSriaqYDf2OwHGJJ2QcyMPBg6paAfb9ydO8aOFT0jm65ClRotxh3N9RhPj7rV9Jga+agMgCx1VuRMSL3EPN/gyslFCIScD5kTIejFjsaBPI8zX4vLhKb5hmZ/5qgV3DH+dZOJ3FxP7WcnTRxZ/FeKN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2K9+XGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2K9+XGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB11F00A3A;
	Tue, 21 Jul 2026 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666657;
	bh=cq1+sz1EODmpQ4K6GzHNjz9bXVOs0TIUlgIoKsf7utc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2K9+XGhSSzY8At7oXSKh+7oBe9BfoZfjMVflCRCZSnvZ4gYAYY87C/bX500gBqAb
	 hLX5Oy7B/dt70j0r3r3IiVyM7NhnH47+LcGO+wVj6MEXjlW5z6K9xcq7Nds4jLLgrW
	 +rUP0cb+AwBJPVNn8FXhVGiEcyyNtKDax8rnm+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0765/1266] ice: fix FDIR CTRL VSI resource leak in ice_reset_all_vfs()
Date: Tue, 21 Jul 2026 17:20:02 +0200
Message-ID: <20260721152458.981058313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>

[ Upstream commit ebbe8868cf473f698e0fbaf436d2618b2bcda806 ]

Resetting all VFs causes resource leak on VFs with FDIR filters
enabled as CTRL VSIs are only invalidated and not freed. Fix by using
ice_vf_ctrl_vsi_release() instead of ice_vf_ctrl_invalidate_vsi() which
aligns behavior with the ice_reset_vf() function.

Reproduction:
  echo 1 > /sys/class/net/$pf/device/sriov_numvfs
  ethtool -N $vf flow-type ether proto 0x9000 action 0
  echo 1 > /sys/class/net/$pf/device/reset

Fixes: da62c5ff9dcd ("ice: Add support for per VF ctrl VSI enabling")
Signed-off-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 1463fee451efcc..fe4a641ce70dca 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -784,7 +784,7 @@ void ice_reset_all_vfs(struct ice_pf *pf)
 		 * setup only when VF creates its first FDIR rule.
 		 */
 		if (vf->ctrl_vsi_idx != ICE_NO_VSI)
-			ice_vf_ctrl_invalidate_vsi(vf);
+			ice_vf_ctrl_vsi_release(vf);
 
 		ice_vf_pre_vsi_rebuild(vf);
 		if (ice_vf_rebuild_vsi(vf)) {
-- 
2.53.0



