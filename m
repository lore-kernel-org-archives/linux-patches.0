Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E036744E648;
	Thu, 30 Jul 2026 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427532; cv=none; b=fcJhCXFIyXOnHVsrZsCOywBDi4JbCLuuMNa1jwFiaStAxSQyA3mQQ+eMrnLzRTOxPBgllBXBWwnwyw/XmqRV95nPp1km9Z2Cn6k7yaul9kD+ZPm5+bHqsUIRQd2Z4MNT+lX9d8DTVMOg/bjbwOBMWbkGzikIVvqLLak6yVHad9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427532; c=relaxed/simple;
	bh=UVZinw9tK2bv/48PJWm+PBNsm5L6w7kkLC855+0r0ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EDT3yAXGlzXfsObe4PAWO3OmZuoFdNGxqkkJYLwIkiV0+NltW2r0TZIqC5NIZKolUORYxxqj1eYJfgaZaqTLJSwvWRv67NFBsFRsJo2LNhAuImzu4cFTiaLy0HcQh/+sseZvfSrIuUH1vONMb9b0FZgGDqhxJyTV4/EdXVHjLqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJbfVYED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJbfVYED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC6A1F00A3E;
	Thu, 30 Jul 2026 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427530;
	bh=32YAvL2RRbPzIWVdWQGL30Aa9YoIIfwr8m0jxYsT4y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJbfVYEDeK1WGxjzv4A8+0eQyEcMCKG0oxh9DssJ1SZ9aGMEZUYM+0pTwehp6+OVV
	 1A5v6tPSriucjFfw/yAggwP3RyNHNjOjhp7uUcrASaCmQhXqYO4zIeYI95XqOLcav6
	 CJOnW3s6v4QPaJ5ISyWvH/ExT9XUwovvuDVJKkuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Dave Ertman <david.m.ertman@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.6 203/484] ice: fix LAG recipe to profile association
Date: Thu, 30 Jul 2026 16:11:40 +0200
Message-ID: <20260730141427.878117854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit d6da9b7d48599db078aea6144997a381f8d90d45 ]

ice_init_lag() associates recipes to profiles, assuming that Link
Aggregation-related profiles will always have profile ID lower than 70
(ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER). This value seems arbitrary and
might not always be valid for some versions of DDP package, i.e. LAG
profiles may have profile ID greater than 70. This would lead to
misconfigured switch and LAG not working properly.

Fix it by checking up to maximum profile ID.

Fixes: 1e0f9881ef79 ("ice: Flesh out implementation of support for SRIOV on bonded interface")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Dave Ertman <david.m.ertman@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-7-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 8ed9918ea4e894..dcd4148dff4b0b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -2004,7 +2004,7 @@ int ice_init_lag(struct ice_pf *pf)
 		goto lag_error;
 
 	/* associate recipes to profiles */
-	for (n = 0; n < ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER; n++) {
+	for (n = 0; n < ICE_MAX_NUM_PROFILES; n++) {
 		err = ice_aq_get_recipe_to_profile(&pf->hw, n,
 						   &recipe_bits, NULL);
 		if (err)
-- 
2.53.0



