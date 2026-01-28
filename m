Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9149C2FF178;
	Wed, 28 Jan 2026 15:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615482; cv=none; b=E5O/eNrp+9HX/lDDhE4UVGnkOaJxG0EPVXnlBwPxBlHttSGk2PSroscwKTAU7wsa/JhdS3hagDsIam10c56at8VFjnEVi7GALDjY7IcXxKSSi//5Q0/iiOo8fTeyUSaSMp5G/Hhp2qSYVaPtRhF9qDt30nFSznniGaqTMzfCb3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615482; c=relaxed/simple;
	bh=DBEiV5vtjLuTG031YEWCLkXQeqqD4fNV6MkoWtoTTlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RW3oVDr3sT8CPhL5CRJPMQWTTOBAgHWAWRb+1SMJB95tDQiuzi37J2neZEY5r6kox6uR8psXYizMqb98nOoe3ApTnPSjWOvZJPmDjYHs2r/IluaYgtvyJLPD8DEPVpQ07rCnzLyDRVRrraCuNH0o9eHmvxjU+2JdWr1cIiRqnDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enCD3KpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enCD3KpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED06C4CEF7;
	Wed, 28 Jan 2026 15:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615482;
	bh=DBEiV5vtjLuTG031YEWCLkXQeqqD4fNV6MkoWtoTTlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enCD3KpEP1WD8kfjwBQF6x5ipKF/CsHh4j1CQGRz+4/gwE1e1XYPmYK+cwbVu551s
	 2R42U6A7Lgi+hUpsQz81yiq2bBbBnvk11I5+rWzReQpmeE8wEGYaUkLi7mEd7Aa0rW
	 L1Rykm5deW/qLt1V/iwdZmnDuPv9U5H5YjYlXM9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 022/227] ice: Avoid detrimental cleanup for bond during interface stop
Date: Wed, 28 Jan 2026 16:21:07 +0100
Message-ID: <20260128145345.142820618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit a9d45c22ed120cdd15ff56d0a6e4700c46451901 ]

When the user issues an administrative down to an interface that is the
primary for an aggregate bond, the prune lists are being purged. This
breaks communication to the secondary interface, which shares a prune
list on the main switch block while bonded together.

For the primary interface of an aggregate, avoid deleting these prune
lists during stop, and since they are hardcoded to specific values for
the default vlan and QinQ vlans, the attempt to re-add them during the
up phase will quietly fail without any additional problem.

Fixes: 1e0f9881ef79 ("ice: Flesh out implementation of support for SRIOV on bonded interface")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 25 ++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index c0d221d4b4f47..5a3e7d6697325 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3810,22 +3810,31 @@ int ice_vsi_add_vlan_zero(struct ice_vsi *vsi)
 int ice_vsi_del_vlan_zero(struct ice_vsi *vsi)
 {
 	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
+	struct ice_pf *pf = vsi->back;
 	struct ice_vlan vlan;
 	int err;
 
-	vlan = ICE_VLAN(0, 0, 0);
-	err = vlan_ops->del_vlan(vsi, &vlan);
-	if (err && err != -EEXIST)
-		return err;
+	if (pf->lag && pf->lag->primary) {
+		dev_dbg(ice_pf_to_dev(pf), "Interface is primary in aggregate - not deleting prune list\n");
+	} else {
+		vlan = ICE_VLAN(0, 0, 0);
+		err = vlan_ops->del_vlan(vsi, &vlan);
+		if (err && err != -EEXIST)
+			return err;
+	}
 
 	/* in SVM both VLAN 0 filters are identical */
 	if (!ice_is_dvm_ena(&vsi->back->hw))
 		return 0;
 
-	vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
-	err = vlan_ops->del_vlan(vsi, &vlan);
-	if (err && err != -EEXIST)
-		return err;
+	if (pf->lag && pf->lag->primary) {
+		dev_dbg(ice_pf_to_dev(pf), "Interface is primary in aggregate - not deleting QinQ prune list\n");
+	} else {
+		vlan = ICE_VLAN(ETH_P_8021Q, 0, 0);
+		err = vlan_ops->del_vlan(vsi, &vlan);
+		if (err && err != -EEXIST)
+			return err;
+	}
 
 	/* when deleting the last VLAN filter, make sure to disable the VLAN
 	 * promisc mode so the filter isn't left by accident
-- 
2.51.0



