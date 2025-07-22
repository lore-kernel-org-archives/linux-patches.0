Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19AA2EA478;
	Tue, 22 Jul 2025 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192574; cv=none; b=U0Kco5znjaRSTQ/kQm8xKCYRaE0BqebKkyhq6j2LjTQiX7ejl7niRcDX0ip23jW4vcTyf1+Ms5otq/QWwUUmPT8WnlaYgjDpqQF6r74a6BLkH1/gspeiyLu0SLJr4G/H44CEywfSTVbsoxC8BYxGkwE2j/BCSVBZfJ79UPwMG2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192574; c=relaxed/simple;
	bh=DSKQ1KAOsAcPdaNociJCVwe22JvnQLzGw9/6Lt+g7j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVA2OR1bpUNtdNDeWafgyVGnrqRDCz0So65fG4pTG7DPDsRvzRoSQW6VIQ7sxyBt3TIjZOWfVN3Hg6DvIYG83EmpABitNsFaAl79mJALH3lXyd2EsLhDK/Z2H4qKBobxdkj/92vvS5r+X76p4nnAGiZXgU9lKONis+lP9JC11zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAzO8mpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAzO8mpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA7C4CEEB;
	Tue, 22 Jul 2025 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192574;
	bh=DSKQ1KAOsAcPdaNociJCVwe22JvnQLzGw9/6Lt+g7j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAzO8mpMy4+1NmwHHY9lfl1BujFUZIFerrco4EOrJSvM4Vpm+fETH6Fu27HrBC5PT
	 DC59rCvr6S1AvO41W7eZohZXU0ZkHxFXcw3OkCz8+tAwDy7ilcgLIgx23JsBY5kWl5
	 tVFO5zx6XYp1fOQhbbEnE8XuEr/wHohn46Allr+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Ertman <david.m.ertman@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/111] ice: add NULL check in eswitch lag check
Date: Tue, 22 Jul 2025 15:44:49 +0200
Message-ID: <20250722134336.142465073@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

[ Upstream commit 3ce58b01ada408b372f15b7c992ed0519840e3cf ]

The function ice_lag_is_switchdev_running() is being called from outside of
the LAG event handler code.  This results in the lag->upper_netdev being
NULL sometimes.  To avoid a NULL-pointer dereference, there needs to be a
check before it is dereferenced.

Fixes: 776fe19953b0 ("ice: block default rule setting on LAG interface")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 4db0b770420e6..8ed9918ea4e89 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -2129,7 +2129,8 @@ bool ice_lag_is_switchdev_running(struct ice_pf *pf)
 	struct ice_lag *lag = pf->lag;
 	struct net_device *tmp_nd;
 
-	if (!ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) || !lag)
+	if (!ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) ||
+	    !lag || !lag->upper_netdev)
 		return false;
 
 	rcu_read_lock();
-- 
2.39.5



