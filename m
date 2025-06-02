Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172D0221FB8;
	Mon,  2 Jun 2025 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874151; cv=none; b=sdLCs+6TQhUzYzL4g1AfCmVq1wfciE8RXXYeopuE1KJhXlwU8B/JEf7ihl+x0i9g15p1Y9v7Ru8kbl0ppiiptCeJpthNyrZxE+t5R15N2TqEjVG4UQro8HD2Ik1bql1Y3fgQiFmrh2dPYw+uDLsx1oeJNTJFj19FzkyiUP32oIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874151; c=relaxed/simple;
	bh=rXUfYBNr4cBtxrpP0+GrMoWYOqxbaPT3VvnqEMo9rxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpfShwxjW6NJLCfCVf2/TS0s4THG51bN4sPFBPMSmWJFmGKKtt3NDotF9bGRSWXMyn1T2Is+vQMrorErvijtB2vFwKPizEYm7n3O4e98lQaeuDUgpNSHSr+voJTXHdPVb1kbe9/iWls8CTnOCknjvUQjUInU7Tsf9veO3jnyP/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPnblJ7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPnblJ7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3CBC4CEEB;
	Mon,  2 Jun 2025 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874150;
	bh=rXUfYBNr4cBtxrpP0+GrMoWYOqxbaPT3VvnqEMo9rxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nPnblJ7+Iv+Tf6bQAddBm0kw8PZ+8Li1QD/k8xBfseZfzsw0Eb11JU7lvlaXA/SVu
	 TH/C9sRjZRjctH9mkQQbKpSWuTAtDwBjzDUAncem82i1eNooFYqO4YJ/3ZNCn59JRo
	 c6FBja8DOwvRWA02SBxFeaGMnkjkihAwcoG9lLkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/444] ice: Fix LACP bonds without SRIOV environment
Date: Mon,  2 Jun 2025 15:46:48 +0200
Message-ID: <20250602134354.899816304@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 6c778f1b839b63525b30046c9d1899424a62be0a ]

If an aggregate has the following conditions:
- The SRIOV LAG DDP package has been enabled
- The bond is in 802.3ad LACP mode
- The bond is disqualified from supporting SRIOV VF LAG
- Both interfaces were added simultaneously to the bond (same command)

Then there is a chance that the two interfaces will be assigned different
LACP Aggregator ID's.  This will cause a failure of the LACP control over
the bond.

To fix this, we can detect if the primary interface for the bond (as
defined by the driver) is not in switchdev mode, and exit the setup flow
if so.

Reproduction steps:

%> ip link add bond0 type bond mode 802.3ad miimon 100
%> ip link set bond0 up
%> ifenslave bond0 eth0 eth1
%> cat /proc/net/bonding/bond0 | grep Agg

Check for Aggregator IDs that differ.

Fixes: ec5a6c5f79ed ("ice: process events created by lag netdev event handler")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 4e675c7c199fa..4db0b770420e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -1229,12 +1229,18 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
 		 */
 		if (!primary_lag) {
 			lag->primary = true;
+			if (!ice_is_switchdev_running(lag->pf))
+				return;
+
 			/* Configure primary's SWID to be shared */
 			ice_lag_primary_swid(lag, true);
 			primary_lag = lag;
 		} else {
 			u16 swid;
 
+			if (!ice_is_switchdev_running(primary_lag->pf))
+				return;
+
 			swid = primary_lag->pf->hw.port_info->sw_id;
 			ice_lag_set_swid(swid, lag, true);
 			ice_lag_add_prune_list(primary_lag, lag->pf);
-- 
2.39.5



