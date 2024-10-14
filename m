Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C50B1AE01D;
	Mon, 14 Oct 2024 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919928; cv=none; b=YLWzfe4CHObnM4wOBd7CjNUIFKWoQMbB3UQCZawgQ4pVThqzWnmxEAc8IXdAideIlYWWPD/7EJmPxNedhTfQU55ucLdXa7CQVVZX0WlBBaA3e3DwOZLoWW0qp6eZY/VUfw7lMvjbht/GT84XtbyzV8UlwjetY6ME6Umwd3TdcOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919928; c=relaxed/simple;
	bh=ulEfzWUxA47QbKdHCOF3Xlznbp2GHMCnQIEtjw6Hb7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCierIkDQVlq6OyP6KRJPcwqvKWpLzYwH3EWjazdiH0iLaDRbvkyDspAdFPtf4YOpAnyVUdFwCmSQyDkUw8nPFaOF6tbxfcjz+uT2TCpoEEQ5QaKb+KIiCJuootHG1dONAwpU8oK8GJqW/Urm+DjhbphJ6aV0C4eeMGHHEPMPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpPzunw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpPzunw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C39C4CEC3;
	Mon, 14 Oct 2024 15:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919928;
	bh=ulEfzWUxA47QbKdHCOF3Xlznbp2GHMCnQIEtjw6Hb7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpPzunw0svHEbKBK3CbSMtgB6Lg278PAdqKlGA3F8sylnTHFxIvcquZ8KIUjKU7J6
	 2iGJ9Pax/2kDgOWsASuGX2/Uqj0p+xk8sCrAHDA2G8hbIkWV+f0izSA5/Mox5w4Qqp
	 fD0uU6Oe5zZHbrvHC56qyEvWcqlTAlxn1WBWEpeI=
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
Subject: [PATCH 6.1 749/798] ice: Fix netif_is_ice() in Safe Mode
Date: Mon, 14 Oct 2024 16:21:43 +0200
Message-ID: <20241014141247.494325553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f01942e4982d..9be88820b77c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -82,7 +82,8 @@ ice_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch,
 
 bool netif_is_ice(struct net_device *dev)
 {
-	return dev && (dev->netdev_ops == &ice_netdev_ops);
+	return dev && (dev->netdev_ops == &ice_netdev_ops ||
+		       dev->netdev_ops == &ice_netdev_safe_mode_ops);
 }
 
 /**
-- 
2.43.0



