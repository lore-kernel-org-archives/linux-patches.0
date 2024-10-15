Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F841EB9F1;
	Tue, 15 Oct 2024 12:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994230; cv=none; b=r8Zn3fgM76JqymbPdo1oBrWOJbvef7WJCR5rvD4LFZp9ZXJZuMrzqvEhHtqmdIP5NaajqCYrKxBSVKp87x0eGwKBt+oF2hTmIke7BCnMHG1kW3Gj5+sesHqJ5EiJFsbRrz7XYEXoW03W60pSNt41BZ1OGRJdjALAQ5xHPZEF7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994230; c=relaxed/simple;
	bh=uWznmuF7ijsS7tmRoRUjrc4FcTCepXLgQ+pBXMDcl4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWlfayoJkh0ZqIgrQCfnOT5zDtkQtT83Fx+mZ/Gd50oXyVqamurXtIdGUmSlSd6I1Bcxdqlcw0BYY/v6AMAJB/TofkpeYHD10kPmufqjFaOEOyqG1wbNcNtCCO2I5krILFLdkN/AKJwSUvrPUPejcJ+mQit9ZYtZJGw4NiyU8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uwcu+nCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uwcu+nCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241A4C4CEC6;
	Tue, 15 Oct 2024 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994230;
	bh=uWznmuF7ijsS7tmRoRUjrc4FcTCepXLgQ+pBXMDcl4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uwcu+nCpYUfIwZTKT7nmIx45th9V2dkc/9so/EGgzPGRG2a9PuCtPrIKcMP4TkVQb
	 wns+LZ4iy1/NvuYi1m8puzwGUEMDIlRd9ObGuYCR0aBj3xCwQdkQ3ZpmzOZL/XPrPK
	 rs+8F50d/l08AeM22vczBZcc1uj8ecrroPMX/j/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 644/691] i40e: Fix macvlan leak by synchronizing access to mac_filter_hash
Date: Tue, 15 Oct 2024 13:29:52 +0200
Message-ID: <20241015112505.885956139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit dac6c7b3d33756d6ce09f00a96ea2ecd79fae9fb ]

This patch addresses a macvlan leak issue in the i40e driver caused by
concurrent access to vsi->mac_filter_hash. The leak occurs when multiple
threads attempt to modify the mac_filter_hash simultaneously, leading to
inconsistent state and potential memory leaks.

To fix this, we now wrap the calls to i40e_del_mac_filter() and zeroing
vf->default_lan_addr.addr with spin_lock/unlock_bh(&vsi->mac_filter_hash_lock),
ensuring atomic operations and preventing concurrent access.

Additionally, we add lockdep_assert_held(&vsi->mac_filter_hash_lock) in
i40e_add_mac_filter() to help catch similar issues in the future.

Reproduction steps:
1. Spawn VFs and configure port vlan on them.
2. Trigger concurrent macvlan operations (e.g., adding and deleting
	portvlan and/or mac filters).
3. Observe the potential memory leak and inconsistent state in the
	mac_filter_hash.

This synchronization ensures the integrity of the mac_filter_hash and prevents
the described leak.

Fixes: fed0d9f13266 ("i40e: Fix VF's MAC Address change on VM")
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index da4022a211f62..c1f21713ab8d1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1712,6 +1712,7 @@ struct i40e_mac_filter *i40e_add_mac_filter(struct i40e_vsi *vsi,
 	struct hlist_node *h;
 	int bkt;
 
+	lockdep_assert_held(&vsi->mac_filter_hash_lock);
 	if (vsi->info.pvid)
 		return i40e_add_filter(vsi, macaddr,
 				       le16_to_cpu(vsi->info.pvid));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index d1635df17e46f..65a29f955d9c4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2215,8 +2215,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
 		vfres->vsi_res[0].qset_handle
 					  = le16_to_cpu(vsi->info.qs_handle[0]);
 		if (!(vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO) && !vf->pf_set_mac) {
+			spin_lock_bh(&vsi->mac_filter_hash_lock);
 			i40e_del_mac_filter(vsi, vf->default_lan_addr.addr);
 			eth_zero_addr(vf->default_lan_addr.addr);
+			spin_unlock_bh(&vsi->mac_filter_hash_lock);
 		}
 		ether_addr_copy(vfres->vsi_res[0].default_mac_addr,
 				vf->default_lan_addr.addr);
-- 
2.43.0



