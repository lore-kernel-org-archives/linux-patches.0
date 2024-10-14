Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017EC20EB;
	Mon, 14 Oct 2024 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916243; cv=none; b=cPELNUCDRiWHes9rIiTxLto98mCEzY+Q4+5oOquT15hkK/1E0C7iepnFJcyJ5cCTitd+oFRL73v5jSoxQqYYGnjsqaxyDazpPufjjOnqrZTc9V9850DXtLIGo1hxbW+326OTLpl6zcdImpMGDSAU5EggFiknBlJPDcNtUad2K4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916243; c=relaxed/simple;
	bh=T38LbNz8LZtBQkF/15rxVTpk+gCF9Zj8Njm4a/OYIB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD9VSRFKdh7I1npjJvJR9+mC30zvfJHeJv2T7c8LZbZ38oOh/BDJk9yBdsnNu/TOJ4rl3IjPw9cVXIn/c3Un0rxN1yhzkQAADJ1UAcpRwRjF6l0uWnVj1C0gNwfXY7N+diFJ5dtRv/nVJCL0udsrKpIJHX+FCOyt4ahffjGmUtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uO6CV4xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uO6CV4xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35238C4CEC3;
	Mon, 14 Oct 2024 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916242;
	bh=T38LbNz8LZtBQkF/15rxVTpk+gCF9Zj8Njm4a/OYIB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO6CV4xk6pAU9ta2SubTNfiIb8ogRumYLtNec3s72ANC2D66XnvkR352JmZTjiDwS
	 ZHLtRRqLRg0nzmPspKvf3WLimPqGXdeUSpV9FPu7nPtocOw+Z/WoktO9IovtIcjE0S
	 Y1XY44ZUneqJ+Jyf3DTrWkBasF8JmlKBas3lQRJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 123/214] ice: Fix increasing MSI-X on VF
Date: Mon, 14 Oct 2024 16:19:46 +0200
Message-ID: <20241014141049.789226326@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit bce9af1b030bf59d51bbabf909a3ef164787e44e ]

Increasing MSI-X value on a VF leads to invalid memory operations. This
is caused by not reallocating some arrays.

Reproducer:
  modprobe ice
  echo 0 > /sys/bus/pci/devices/$PF_PCI/sriov_drivers_autoprobe
  echo 1 > /sys/bus/pci/devices/$PF_PCI/sriov_numvfs
  echo 17 > /sys/bus/pci/devices/$VF0_PCI/sriov_vf_msix_count

Default MSI-X is 16, so 17 and above triggers this issue.

KASAN reports:

  BUG: KASAN: slab-out-of-bounds in ice_vsi_alloc_ring_stats+0x38d/0x4b0 [ice]
  Read of size 8 at addr ffff8888b937d180 by task bash/28433
  (...)

  Call Trace:
   (...)
   ? ice_vsi_alloc_ring_stats+0x38d/0x4b0 [ice]
   kasan_report+0xed/0x120
   ? ice_vsi_alloc_ring_stats+0x38d/0x4b0 [ice]
   ice_vsi_alloc_ring_stats+0x38d/0x4b0 [ice]
   ice_vsi_cfg_def+0x3360/0x4770 [ice]
   ? mutex_unlock+0x83/0xd0
   ? __pfx_ice_vsi_cfg_def+0x10/0x10 [ice]
   ? __pfx_ice_remove_vsi_lkup_fltr+0x10/0x10 [ice]
   ice_vsi_cfg+0x7f/0x3b0 [ice]
   ice_vf_reconfig_vsi+0x114/0x210 [ice]
   ice_sriov_set_msix_vec_count+0x3d0/0x960 [ice]
   sriov_vf_msix_count_store+0x21c/0x300
   (...)

  Allocated by task 28201:
   (...)
   ice_vsi_cfg_def+0x1c8e/0x4770 [ice]
   ice_vsi_cfg+0x7f/0x3b0 [ice]
   ice_vsi_setup+0x179/0xa30 [ice]
   ice_sriov_configure+0xcaa/0x1520 [ice]
   sriov_numvfs_store+0x212/0x390
   (...)

To fix it, use ice_vsi_rebuild() instead of ice_vf_reconfig_vsi(). This
causes the required arrays to be reallocated taking the new queue count
into account (ice_vsi_realloc_stat_arrays()). Set req_txq and req_rxq
before ice_vsi_rebuild(), so that realloc uses the newly set queue
count.

Additionally, ice_vsi_rebuild() does not remove VSI filters
(ice_fltr_remove_all()), so ice_vf_init_host_cfg() is no longer
necessary.

Reported-by: Jacob Keller <jacob.e.keller@intel.com>
Fixes: 2a2cb4c6c181 ("ice: replace ice_vf_recreate_vsi() with ice_vf_reconfig_vsi()")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c          | 11 ++++++++---
 drivers/net/ethernet/intel/ice/ice_vf_lib.c         |  2 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h |  1 -
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 55ef33208456a..78ca6ddc3d03f 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1119,7 +1119,10 @@ int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
 	if (vf->first_vector_idx < 0)
 		goto unroll;
 
-	if (ice_vf_reconfig_vsi(vf) || ice_vf_init_host_cfg(vf, vsi)) {
+	vsi->req_txq = queues;
+	vsi->req_rxq = queues;
+
+	if (ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT)) {
 		/* Try to rebuild with previous values */
 		needs_rebuild = true;
 		goto unroll;
@@ -1146,8 +1149,10 @@ int ice_sriov_set_msix_vec_count(struct pci_dev *vf_dev, int msix_vec_count)
 		return -EINVAL;
 
 	if (needs_rebuild) {
-		ice_vf_reconfig_vsi(vf);
-		ice_vf_init_host_cfg(vf, vsi);
+		vsi->req_txq = prev_queues;
+		vsi->req_rxq = prev_queues;
+
+		ice_vsi_rebuild(vsi, ICE_VSI_FLAG_NO_INIT);
 	}
 
 	ice_ena_vf_mappings(vf);
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.c b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
index 9fe2a309c5ffa..f8fbd49e23105 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.c
@@ -256,7 +256,7 @@ static void ice_vf_pre_vsi_rebuild(struct ice_vf *vf)
  *
  * It brings the VSI down and then reconfigures it with the hardware.
  */
-int ice_vf_reconfig_vsi(struct ice_vf *vf)
+static int ice_vf_reconfig_vsi(struct ice_vf *vf)
 {
 	struct ice_vsi *vsi = ice_get_vf_vsi(vf);
 	struct ice_pf *pf = vf->pf;
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
index 91ba7fe0eaee1..0c7e77c0a09fa 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
@@ -23,7 +23,6 @@
 #warning "Only include ice_vf_lib_private.h in CONFIG_PCI_IOV virtualization files"
 #endif
 
-int ice_vf_reconfig_vsi(struct ice_vf *vf);
 void ice_initialize_vf_entry(struct ice_vf *vf);
 void ice_dis_vf_qs(struct ice_vf *vf);
 int ice_check_vf_init(struct ice_vf *vf);
-- 
2.43.0



