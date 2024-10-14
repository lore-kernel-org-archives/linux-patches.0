Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A4F9DA;
	Mon, 14 Oct 2024 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916246; cv=none; b=hx8EluJOKZ79p0QEW7ZNQlUgHN3PpxtVURb2ZL9L5WwW7/Ke0jeDx6NO6AL68AlwIAe424cGjnI8Qjp7UaJCdNuX6NLCPg+1/eYyn8a4l/9aCSlpvJW0dIM90Nn7MCwUY9jFjXf3rjz+O0u1XYEQNEOieD1HBFSjg0R35qAZQB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916246; c=relaxed/simple;
	bh=lnDTZQuIHYwXPBvgPtJZTXi0cOoGzc4nbwUKgBv24Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeLay/OdVgc+PjZS6J2PtSlPXe/S76ssj27ypCSdsEQPw5dr87u0cr86VNNI1GmQ+OE6fPrb8hJzKrJCIEF3/ZUUOBBmU8965EPeWJq5/ahi+i0WB7Phoap94IoFcIos3zibDcpT+l9+/k0xnzVHFieyFBIqCymgzR8lkfRg2vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlIqeIj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlIqeIj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91C8C4CEC3;
	Mon, 14 Oct 2024 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916246;
	bh=lnDTZQuIHYwXPBvgPtJZTXi0cOoGzc4nbwUKgBv24Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlIqeIj4k034J8sEEGkGJtg3iZV7lrRR3L5ZvNVv7gEFZ+qCPSJf3SJldanMTjEW5
	 dw1j4yBVhTAQJjbs2807yfR1bpH56OAEXg5sU/Ed6pkYYRPTeEgZqFbL06MGu2dyLA
	 sb9YmBXopQGk74H3iJB0xR3F+spNdMLPboCh/PUU=
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
Subject: [PATCH 6.11 124/214] i40e: Fix macvlan leak by synchronizing access to mac_filter_hash
Date: Mon, 14 Oct 2024 16:19:47 +0200
Message-ID: <20241014141049.828540722@linuxfoundation.org>
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
index cbcfada7b357a..f7d4b5f79422b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1734,6 +1734,7 @@ struct i40e_mac_filter *i40e_add_mac_filter(struct i40e_vsi *vsi,
 	struct hlist_node *h;
 	int bkt;
 
+	lockdep_assert_held(&vsi->mac_filter_hash_lock);
 	if (vsi->info.pvid)
 		return i40e_add_filter(vsi, macaddr,
 				       le16_to_cpu(vsi->info.pvid));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 662622f01e312..dfa785e39458d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2213,8 +2213,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
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



