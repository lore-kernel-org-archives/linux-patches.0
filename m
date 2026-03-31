Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E42EE262;
	Tue, 31 Mar 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974974; cv=none; b=ubWNQ/vO3NFrmoFQqZbbuZ08/BHq1BrtM6uhCDWW9WdFtON/z1U/KxFvIw0Q/GYoiv1ORHRo/vjwTFnU9wnxNMndVam6y2J1ba4OdV8dPsARvWpqyHfB8lcCEURxyG16dXtvPKDdxE9b3B/N7g6AVOOT75Bs3ENMrIFwt8tKUh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974974; c=relaxed/simple;
	bh=k+C+PKY5QYCHyGEWcUs/pburMEmUATq2zRNOiUflXmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf+AbIx7C+J4Q5ObVo0Foj+iQP5J5lWN+R5TNNKCgjZHnTYkM3ZYWt6xW7iYhG3HC0KEoihbg9HYVHWxvCDr504SSZgeHs5FHQr26siIPM+dkAYmTen9xRkYOu6v1Z7M24cwdYvRPZ3pvFyB64FhpZC0dBTKq5uVjxC4GqALR14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAqEVNmt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAqEVNmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5497C19423;
	Tue, 31 Mar 2026 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974974;
	bh=k+C+PKY5QYCHyGEWcUs/pburMEmUATq2zRNOiUflXmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAqEVNmtWjeOrywyJ9tFFkcVIhOySQOX6b2YNIKgjiRxYZpGqrMzySVUHuVVvbl6O
	 f5E0fFMoRZhcbug5L5dAh/0AClsR05dw1Hm/a7l6bpDKHI5DXB+Up+p9ENDiEVNUdl
	 0EHuMA99odKNNOkWycYEZMtgGB9xZ5LkGMojzLMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 115/342] ice: fix inverted ready check for VF representors
Date: Tue, 31 Mar 2026 18:19:08 +0200
Message-ID: <20260331161803.243264070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit ad85de0fc09eb3236e73df5acb2bc257625103f5 ]

Commit 0f00a897c9fcbd ("ice: check if SF is ready in ethtool ops")
refactored the VF readiness check into a generic repr->ops.ready()
callback but implemented ice_repr_ready_vf() with inverted logic:

  return !ice_check_vf_ready_for_cfg(repr->vf);

ice_check_vf_ready_for_cfg() returns 0 on success, so the negation
makes ready() return non-zero when the VF is ready. All callers treat
non-zero as "not ready, skip", causing ndo_get_stats64, get_drvinfo,
get_strings and get_ethtool_stats to always bail out in switchdev mode.

Remove the erroneous negation. The SF variant ice_repr_ready_sf() is
already correct (returns !active, i.e. non-zero when not active).

Fixes: 0f00a897c9fcbd ("ice: check if SF is ready in ethtool ops")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_repr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index cb08746556a67..2a84f65640582 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -315,7 +315,7 @@ ice_repr_reg_netdev(struct net_device *netdev, const struct net_device_ops *ops)
 
 static int ice_repr_ready_vf(struct ice_repr *repr)
 {
-	return !ice_check_vf_ready_for_cfg(repr->vf);
+	return ice_check_vf_ready_for_cfg(repr->vf);
 }
 
 static int ice_repr_ready_sf(struct ice_repr *repr)
-- 
2.51.0



