Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FA11AE018;
	Mon, 14 Oct 2024 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917199; cv=none; b=qvphe5t9yHoU2dHRvQVR2sGgGvZNYLAh7dfHswTbgiYDF6IHjChsDLFz/L5aAlVkJ+m29TIWAgVVNv6gsD592JSHeB10e9cpUgWOmJSJhOSdl59yLkgDDKW0QHOQ9lQCbuRga+Nnoz3V31bh9H5dFG1OyEvL/g/OgoNn4/XsRQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917199; c=relaxed/simple;
	bh=gb13GpWfB4qxwXZIuvv/3aOANRUEEwzeo6IgmGOLv7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPfbnYb4A/2bCR7gQ2i2IOxg9f8GPVcS5R95TYjS/tsPv36KqcBTG46UdGAfDRs25GJgHdFwv3Y0bdQ7PrG+8ZuGR+dAR0cTnOeI6Xrz8kNyg2Zrsc9Eszgf2hwT6BD3NkgIWYjKCtWS0RgqlbPlv+UC2rjf/NSiPGanJ/KJiOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkXYnImF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkXYnImF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C375C4CEC3;
	Mon, 14 Oct 2024 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917199;
	bh=gb13GpWfB4qxwXZIuvv/3aOANRUEEwzeo6IgmGOLv7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkXYnImFikdmn5Dh8UFALAaVk18QdMMfsQ5VAwzzniBHS20eA1uCB9OJ2bJY5aHyK
	 km0I+Ub5giLYvWDoSE9yltxRcmzcH/NSBmcX6f3sRTiYajFm5mWCXyo+VcmnDsr7JZ
	 Lmxu7JhpwkixCAK8DtsT8jlGC+6SqgexJffhw5n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/213] ice: Fix netif_is_ice() in Safe Mode
Date: Mon, 14 Oct 2024 16:20:45 +0200
Message-ID: <20241014141048.395544068@linuxfoundation.org>
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

From: Marcin Szycik <marcin.szycik@linux.intel.com>

[ Upstream commit 8e60dbcbaaa177dacef55a61501790e201bf8c88 ]

netif_is_ice() works by checking the pointer to netdev ops. However, it
only checks for the default ice_netdev_ops, not ice_netdev_safe_mode_ops,
so in Safe Mode it always returns false, which is unintuitive. While it
doesn't look like netif_is_ice() is currently being called anywhere in Safe
Mode, this could change and potentially lead to unexpected behaviour.

Fixes: df006dd4b1dc ("ice: Add initial support framework for LAG")
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4d3a9fc79a6c1..511064ab3fe3b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -84,7 +84,8 @@ ice_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch,
 
 bool netif_is_ice(const struct net_device *dev)
 {
-	return dev && (dev->netdev_ops == &ice_netdev_ops);
+	return dev && (dev->netdev_ops == &ice_netdev_ops ||
+		       dev->netdev_ops == &ice_netdev_safe_mode_ops);
 }
 
 /**
-- 
2.43.0



