Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4E21F1303;
	Tue, 15 Oct 2024 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994227; cv=none; b=ST/jquTmDHU/VJ4z23TdJeYI2aOphOxk9jD10hyjS81uidQFRV+6We0zyVP4uxFBUwBqQu8tWfV1USBfK0v389RMpnFGmpyc7A7FGbcNktm4NnG0UzcrCALEtregje2TWOcHlTXEb0oWD97AUNHrvcW2eCzU9jka2x2fa/UrEkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994227; c=relaxed/simple;
	bh=3R5CURJ8YupyUx0fu9o6aMTiqvFUb4C+vGKCpbAflKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQXdgirwe/NqmDDdiAFbq7GVYeAsRKZcwx+d5LitfTshdqrvAsWbGHr0qjEIEe5e734XaYepQai6VASju4lMBpQMzcG1C2Cj2v7NvIYKbvp0kbW36rWuIBCUKJgmcMVrAuf2U3ZW0iQBTk+fvowp+RcOpJ5IsQNcaFx4Hlz6JC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb8H7UnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb8H7UnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCD7C4CECE;
	Tue, 15 Oct 2024 12:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994227;
	bh=3R5CURJ8YupyUx0fu9o6aMTiqvFUb4C+vGKCpbAflKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kb8H7UnKo0kPgiOmp3JbbBlRoXUtaw2W/i4n420YewH0Z8B05AeeUCRApTf5UajhQ
	 XZw9c4UR6WknB2jzRm6V1NpO/sIUkADUnJH4ueyTxFPudy1MhZiHWaY5hf85xD7HB3
	 VYxcNZlW7arexabYGQDnc3s1gGQL77/BhndGzvt0=
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
Subject: [PATCH 5.15 643/691] ice: Fix netif_is_ice() in Safe Mode
Date: Tue, 15 Oct 2024 13:29:51 +0200
Message-ID: <20241015112505.846840995@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3cc344d5228b6..329bf24a3f0e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -55,7 +55,8 @@ static void ice_vsi_release_all(struct ice_pf *pf);
 
 bool netif_is_ice(struct net_device *dev)
 {
-	return dev && (dev->netdev_ops == &ice_netdev_ops);
+	return dev && (dev->netdev_ops == &ice_netdev_ops ||
+		       dev->netdev_ops == &ice_netdev_safe_mode_ops);
 }
 
 /**
-- 
2.43.0



