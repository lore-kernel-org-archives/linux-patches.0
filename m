Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7E515AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA315C433C8;
	Wed,  9 Aug 2023 10:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578091;
	bh=TWfC18TOqSQKmHEExYHZo4w8mBH3Jsdsl8ty1AeAUC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgGPYyonmR71NDsjL9xcq9hqIsQoAQmUrDIPpT8cdnns5eYKCxKqIQ/B42xi7RR0T
	 0g+1OLa0xM0Qa36mf82GA64cJcIctdwe/ner1+QLiKYrXWEq2GpB6yOauMA3gj5Z6w
	 zIJctWpPltjNmtVylrwXszWom03Sd34PjSCeiUe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafal Rogalski <rafalx.rogalski@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>,
	Kamil Maziarz <kamil.maziarz@intel.com>,
	Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 063/165] ice: Fix RDMA VSI removal during queue rebuild
Date: Wed,  9 Aug 2023 12:39:54 +0200
Message-ID: <20230809103644.880920642@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafal Rogalski <rafalx.rogalski@intel.com>

[ Upstream commit 4b31fd4d77ffa430d0b74ba1885ea0a41594f202 ]

During qdisc create/delete, it is necessary to rebuild the queue
of VSIs. An error occurred because the VSIs created by RDMA were
still active.

Added check if RDMA is active. If yes, it disallows qdisc changes
and writes a message in the system logs.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Rafal Rogalski <rafalx.rogalski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230728171243.2446101-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fbe70458fda27..34e8e7cb1bc54 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9055,6 +9055,7 @@ ice_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_pf *pf = np->vsi->back;
+	bool locked = false;
 	int err;
 
 	switch (type) {
@@ -9064,10 +9065,27 @@ ice_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 						  ice_setup_tc_block_cb,
 						  np, np, true);
 	case TC_SETUP_QDISC_MQPRIO:
+		if (pf->adev) {
+			mutex_lock(&pf->adev_mutex);
+			device_lock(&pf->adev->dev);
+			locked = true;
+			if (pf->adev->dev.driver) {
+				netdev_err(netdev, "Cannot change qdisc when RDMA is active\n");
+				err = -EBUSY;
+				goto adev_unlock;
+			}
+		}
+
 		/* setup traffic classifier for receive side */
 		mutex_lock(&pf->tc_mutex);
 		err = ice_setup_tc_mqprio_qdisc(netdev, type_data);
 		mutex_unlock(&pf->tc_mutex);
+
+adev_unlock:
+		if (locked) {
+			device_unlock(&pf->adev->dev);
+			mutex_unlock(&pf->adev_mutex);
+		}
 		return err;
 	default:
 		return -EOPNOTSUPP;
-- 
2.40.1



