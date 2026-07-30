Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9E439359;
	Thu, 30 Jul 2026 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424206; cv=none; b=rOFUfgnH0NY4ZHf50KrO/uKQF/s+ltEm0vL+Oyl3qdKXDC6GJ1om/+hydSdNjZcjdNi8g6ybvUSEOjis7i4gCmRPprZR/hBzkJPOG1Z1jz6kW4RfJuQt3mBnYl0bd1iBftPNGgNrw22r+2r4Mg18tZCpzZ/zlUbsOmshkfrjXiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424206; c=relaxed/simple;
	bh=FTBCMXURr24F/lOMb+BdbJ/Ik5RjCMciDeoiNQNbHOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6dhW25Zhbmq0eP1uWTX/G3pompgNnZCVlEx6bSomnpJoeRQs2m8VfAwezebG4AfZ4o5GgUaExt9ahm7Am/Mha4UW3QDV1KfLaKNXa5LeGs3c0HNsFEi8gTMNTxLQw7CyGIKawhE8YrTPXeDtv5s+GtHBzq2toccTXgP5Z/2p6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsWUG5lM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsWUG5lM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527541F000E9;
	Thu, 30 Jul 2026 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424204;
	bh=dMSBqAa8OMUm75cKV+y1K3zcBKqtRd8d0+N+6Cjg/r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsWUG5lMnunyE65QbyDVjlNVd3zPclSwOmvg/YfF0WFcTrQ+SjZDTQ9tXgZ9C1/Ca
	 /j/sdpRTMsQfEhkQ+a6hczNRfMTTlo5AfqUNe8CcLqa0Blu7T/LU21ekGRmuEoBi7F
	 p2xnHI3unGZG53kRotIeK9+ditSh1SD0n/0KWcD4=
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
Subject: [PATCH 6.18 310/675] ice: fix LAG recipe to profile association
Date: Thu, 30 Jul 2026 16:10:40 +0200
Message-ID: <20260730141451.713230865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index aebf8e08a297be..e8ab36d0f11d82 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -2624,7 +2624,7 @@ int ice_init_lag(struct ice_pf *pf)
 		goto  free_lport_res;
 
 	/* associate recipes to profiles */
-	for (n = 0; n < ICE_PROFID_IPV6_GTPU_IPV6_TCP_INNER; n++) {
+	for (n = 0; n < ICE_MAX_NUM_PROFILES; n++) {
 		err = ice_aq_get_recipe_to_profile(&pf->hw, n,
 						   &recipe_bits, NULL);
 		if (err)
-- 
2.53.0



