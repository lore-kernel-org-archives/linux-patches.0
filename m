Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494953A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ByOAQCLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A20C433C8;
	Wed, 15 Nov 2023 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077859;
	bh=8kfVT+65imBQo7tW8K1SeSpTQGzPfUVKwcDp3TbdpKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ByOAQCLxSSV5u+2cxAQVG9WYWjQY3Z4tpzFbo1hOBm9Thq0PqhAnOkIYORQkPbA3+
	 cSAlsbkEdSX+mQszW3efuDi5vxYpr3vWCtHJdGtEObOX18F8QMAIDot2VoPhc1y3Ih
	 y4fj8OQBcrMBpZ6D3oUGp0/cIY3Wg72UZ6aKa3Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 563/603] ice: lag: in RCU, use atomic allocation
Date: Wed, 15 Nov 2023 14:18:28 -0500
Message-ID: <20231115191650.563015026@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit e1db8c2a01d7e12bd566106fbeefa3c5cccd2003 ]

Sleeping is not allowed in RCU read-side critical sections.
Use atomic allocations under rcu_read_lock.

Fixes: 1e0f9881ef79 ("ice: Flesh out implementation of support for SRIOV on bonded interface")
Fixes: 41ccedf5ca8f ("ice: implement lag netdev event handler")
Fixes: 3579aa86fb40 ("ice: update reset path for SRIOV LAG support")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index a8da5f8374451..fb40ad98e6aad 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -595,7 +595,7 @@ void ice_lag_move_new_vf_nodes(struct ice_vf *vf)
 		INIT_LIST_HEAD(&ndlist.node);
 		rcu_read_lock();
 		for_each_netdev_in_bond_rcu(lag->upper_netdev, tmp_nd) {
-			nl = kzalloc(sizeof(*nl), GFP_KERNEL);
+			nl = kzalloc(sizeof(*nl), GFP_ATOMIC);
 			if (!nl)
 				break;
 
@@ -1666,7 +1666,7 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
 
 		rcu_read_lock();
 		for_each_netdev_in_bond_rcu(upper_netdev, tmp_nd) {
-			nd_list = kzalloc(sizeof(*nd_list), GFP_KERNEL);
+			nd_list = kzalloc(sizeof(*nd_list), GFP_ATOMIC);
 			if (!nd_list)
 				break;
 
@@ -2040,7 +2040,7 @@ void ice_lag_rebuild(struct ice_pf *pf)
 		INIT_LIST_HEAD(&ndlist.node);
 		rcu_read_lock();
 		for_each_netdev_in_bond_rcu(lag->upper_netdev, tmp_nd) {
-			nl = kzalloc(sizeof(*nl), GFP_KERNEL);
+			nl = kzalloc(sizeof(*nl), GFP_ATOMIC);
 			if (!nl)
 				break;
 
-- 
2.42.0



