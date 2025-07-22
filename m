Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19D12EE5E6;
	Tue, 22 Jul 2025 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193553; cv=none; b=U21Km+1m/Mbe8eSuGALt+yr4tig4tBVMCZ3R6u0SdFYF46UQnH2n6ZN6GWz4bVFYzjUngnl9ACRT+UK5avBfWMyXpVWu6AFVKhfHy0OJeJePa7eO88IatRXSkhcqVdaeqhfoAPveoOw00ojq5W0zMZw43XD+6ybYPIrpnWL02kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193553; c=relaxed/simple;
	bh=rYGhSvSWjxtFsnMHwl2ldYobkDzG/yiqFmB7+xBbssE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/Xjv2jomiACdajTJOQBGPkKthBj0XzipMMGejNNd2qejwCPbC0vaLOQuahf7ADegsVEFS7fELTyKhjEeOGmrgAutRz1xmkgWjHBMJcy0xd2xlFsP3B5xR7MJ0hbsbcndM3X/Jgjk3Ly7F2Zn4NSORY4HIfooqJDafCrBMc4xSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp/R0Fb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp/R0Fb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D04C4CEEB;
	Tue, 22 Jul 2025 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193553;
	bh=rYGhSvSWjxtFsnMHwl2ldYobkDzG/yiqFmB7+xBbssE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp/R0Fb4iNXG9Nvj1IQfF/wMDB/wzgj7NYlKipdqoQZ2rfBqZ14v/xd9Bn2qxxILC
	 IoMqm5adh4UgvVjMPQBpylcx+fJjbpXeMiRL147dEHQka+Jsi05SC2pzM6TXqulzz+
	 2YSYOa7ZxOoVvnfUUSH0aPcKV2qws3WsUu/QiFpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Ertman <david.m.ertman@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/187] ice: add NULL check in eswitch lag check
Date: Tue, 22 Jul 2025 15:44:57 +0200
Message-ID: <20250722134350.477526298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2410aee59fb2d..d132eb4775513 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -2226,7 +2226,8 @@ bool ice_lag_is_switchdev_running(struct ice_pf *pf)
 	struct ice_lag *lag = pf->lag;
 	struct net_device *tmp_nd;
 
-	if (!ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) || !lag)
+	if (!ice_is_feature_supported(pf, ICE_F_SRIOV_LAG) ||
+	    !lag || !lag->upper_netdev)
 		return false;
 
 	rcu_read_lock();
-- 
2.39.5



