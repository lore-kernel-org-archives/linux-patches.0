Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BD53B298;
	Mon, 14 Oct 2024 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917163; cv=none; b=Hhw5qtHUlsly/Q7wb+ui7r6fHyYAsPAByq+5E5kO5HlIgjHKAPFB1bItQKIxtK2o8cQ6rhRkEYSVWVrATkoxRLs+7oZJ5Ko1k6PnFZqDTm4EU+HIiWBs0sf8UtJQS7B7YuHGhJCybjuxaHWKlVprFeubzF+Df7ECqgjIERY1QEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917163; c=relaxed/simple;
	bh=adJhLk8/aGEiGaIpw7Fh8nmsJbqe4194LHU7+Cne3ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJrd5IIxzPAHrekIhS76d+pydvUxZ3eOpB03LngVn7sxgp/m/H1lq+EddwESUEB2qqfq9Wsp7nBKfrYdrMyl/jeckxVrBmN3y2TRyDLSG2i06rolgh6HgTk+Bq0Mu3DpZ0yjKqKxmGrzJiq9hVQKQlG2qbNL8dm2jzvt88DCYsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOUrKkXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOUrKkXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D546C4CEC3;
	Mon, 14 Oct 2024 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917162;
	bh=adJhLk8/aGEiGaIpw7Fh8nmsJbqe4194LHU7+Cne3ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOUrKkXrauiUCcRX6hP1ltbT69CSv2kujwf6J7Oqv16QgcLVdWWZJDGGo3OygigPW
	 SMHRTiIRsWdAeSLFrZOJPiQUpvSyuvN4tygE61gSs+Z/6ZAtho3Gf7BUErjVUtmmXx
	 DfrXxC16v3nXm+YEsjRO5u0NNNSb8jYMQR/BC2pE=
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
Subject: [PATCH 6.6 142/213] i40e: Fix macvlan leak by synchronizing access to mac_filter_hash
Date: Mon, 14 Oct 2024 16:20:48 +0200
Message-ID: <20241014141048.509615336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1d241ebd04ec7..80472aa1deba4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1744,6 +1744,7 @@ struct i40e_mac_filter *i40e_add_mac_filter(struct i40e_vsi *vsi,
 	struct hlist_node *h;
 	int bkt;
 
+	lockdep_assert_held(&vsi->mac_filter_hash_lock);
 	if (vsi->info.pvid)
 		return i40e_add_filter(vsi, macaddr,
 				       le16_to_cpu(vsi->info.pvid));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 7d47a05274548..d5509bc16d0d5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2219,8 +2219,10 @@ static int i40e_vc_get_vf_resources_msg(struct i40e_vf *vf, u8 *msg)
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



