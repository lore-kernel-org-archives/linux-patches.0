Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5281D559
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoPVwriV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099B3C433C8;
	Wed,  4 Oct 2023 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443987;
	bh=t9LCSum+7LDTTkFFJnls4sP7PhZNIQ/1YCJaSigN7AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoPVwriVn4dCCkByvjzrP6Bgqe9+sm08Uz9sISWHvx2wZSXUw4GH8H4O0BT14hIVK
	 srg4Kuik6xZyynVVNIi5tevbDYrjqK/DzSGbOPpc61Ztg6/pclHbNNbc20A/x1Fq11
	 mT284UYk+AC2Rm1FHq8K6Eb/A8oGDtsL4HTtiPjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 062/321] i40e: Fix VF VLAN offloading when port VLAN is configured
Date: Wed,  4 Oct 2023 19:53:27 +0200
Message-ID: <20231004175232.049051058@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit d0d362ffa33da4acdcf7aee2116ceef8c8fef658 ]

If port VLAN is configured on a VF then any other VLANs on top of this VF
are broken.

During i40e_ndo_set_vf_port_vlan() call the i40e driver reset the VF and
iavf driver asks PF (using VIRTCHNL_OP_GET_VF_RESOURCES) for VF capabilities
but this reset occurs too early, prior setting of vf->info.pvid field
and because this field can be zero during i40e_vc_get_vf_resources_msg()
then VIRTCHNL_VF_OFFLOAD_VLAN capability is reported to iavf driver.

This is wrong because iavf driver should not report VLAN offloading
capability when port VLAN is configured as i40e does not support QinQ
offloading.

Fix the issue by moving VF reset after setting of vf->port_vlan_id
field.

Without this patch:
$ echo 1 > /sys/class/net/enp2s0f0/device/sriov_numvfs
$ ip link set enp2s0f0 vf 0 vlan 3
$ ip link set enp2s0f0v0 up
$ ip link add link enp2s0f0v0 name vlan4 type vlan id 4
$ ip link set vlan4 up
...
$ ethtool -k enp2s0f0v0 | grep vlan-offload
rx-vlan-offload: on
tx-vlan-offload: on
$ dmesg -l err | grep iavf
[1292500.742914] iavf 0000:02:02.0: Failed to add VLAN filter, error IAVF_ERR_INVALID_QP_ID

With this patch:
$ echo 1 > /sys/class/net/enp2s0f0/device/sriov_numvfs
$ ip link set enp2s0f0 vf 0 vlan 3
$ ip link set enp2s0f0v0 up
$ ip link add link enp2s0f0v0 name vlan4 type vlan id 4
$ ip link set vlan4 up
...
$ ethtool -k enp2s0f0v0 | grep vlan-offload
rx-vlan-offload: off [requested on]
tx-vlan-offload: off [requested on]
$ dmesg -l err | grep iavf

Fixes: f9b4b6278d51 ("i40e: Reset the VF upon conflicting VLAN configuration")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index be59ba3774e15..c1e1e8912350b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4464,9 +4464,7 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 		goto error_pvid;
 
 	i40e_vlan_stripping_enable(vsi);
-	i40e_vc_reset_vf(vf, true);
-	/* During reset the VF got a new VSI, so refresh a pointer. */
-	vsi = pf->vsi[vf->lan_vsi_idx];
+
 	/* Locked once because multiple functions below iterate list */
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
 
@@ -4552,6 +4550,10 @@ int i40e_ndo_set_vf_port_vlan(struct net_device *netdev, int vf_id,
 	 */
 	vf->port_vlan_id = le16_to_cpu(vsi->info.pvid);
 
+	i40e_vc_reset_vf(vf, true);
+	/* During reset the VF got a new VSI, so refresh a pointer. */
+	vsi = pf->vsi[vf->lan_vsi_idx];
+
 	ret = i40e_config_vf_promiscuous_mode(vf, vsi->id, allmulti, alluni);
 	if (ret) {
 		dev_err(&pf->pdev->dev, "Unable to config vf promiscuous mode\n");
-- 
2.40.1



