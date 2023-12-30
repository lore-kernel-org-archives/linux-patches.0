Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC7C8F55;
	Sat, 30 Dec 2023 12:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzHV6fEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06575C433C7;
	Sat, 30 Dec 2023 12:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937839;
	bh=GRIuuNiK9rQk63pVio2dMlXUDrY8WQT6e3A5bfF6DFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzHV6fEZNoYo3mwEJcjRdBGoyhOrVjuDJngbM08RreQUB5m3XxQrPuqHkpnzxUpQt
	 rn94+woy/0/kyP6GvJqWZj/kQp68O6qsr+7jkr03KN+dqw8uYYIQvsidhiDcRRdCio
	 JgC4I8pVfYDGwi8BkrdZqXjjo30gUvMOC2oWmGbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 058/156] ice: alter feature support check for SRIOV and LAG
Date: Sat, 30 Dec 2023 11:58:32 +0000
Message-ID: <20231230115814.237070301@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 4d50fcdc2476eef94c14c6761073af5667bb43b6 ]

Previously, the ice driver had support for using a handler for bonding
netdev events to ensure that conflicting features were not allowed to be
activated at the same time.  While this was still in place, additional
support was added to specifically support SRIOV and LAG together.  These
both utilized the netdev event handler, but the SRIOV and LAG feature was
behind a capabilities feature check to make sure the current NVM has
support.

The exclusion part of the event handler should be removed since there are
users who have custom made solutions that depend on the non-exclusion of
features.

Wrap the creation/registration and cleanup of the event handler and
associated structs in the probe flow with a feature check so that the
only systems that support the full implementation of LAG features will
initialize support.  This will leave other systems unhindered with
functionality as it existed before any LAG code was added.

Fixes: bb52f42acef6 ("ice: Add driver support for firmware changes for LAG")
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index d86e2460b5a4d..23e197c3d02a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -1963,6 +1963,8 @@ int ice_init_lag(struct ice_pf *pf)
 	int n, err;
 
 	ice_lag_init_feature_support_flag(pf);
+	if (!ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
+		return 0;
 
 	pf->lag = kzalloc(sizeof(*lag), GFP_KERNEL);
 	if (!pf->lag)
-- 
2.43.0



