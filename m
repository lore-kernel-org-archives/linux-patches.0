Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110CA2B9A5;
	Tue, 22 Jul 2025 14:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193065; cv=none; b=l2zV125luTOlr7lG81l4G245q/eluk24IMi5zYIiCNLfl3KD3tarwMMadFxmrzhBo3R3WO0x4mK06oXJ3fITxRVFu9JmUl1pLk43APZwkUNCdXGyOEiK1TfZt7l0AaPmr46aHLmsgsiAgdo616uZCDSAjhoz6zVgAyOhcCmyjjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193065; c=relaxed/simple;
	bh=BOYRw+jzwC9QyT/Gt65dBP0W3tgTvSxtr4+hFZ5L6T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8XY+CMbEDgxjmseu6gpQh6NSwrd0Wd9Wgst9+g0t1pnLZ++lvOoSXdGkLa1hnRa4ssugZauvpWlgNK9PtS2JXxK5BRR35UX2pMf4Q9xsP5SvJrX3L/6Tq5nfEMc4vsvhmNKF36N2fJ/kECxs1N9hw0gQOXrApn3HJIIkk7lNcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iuBtVZBN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iuBtVZBN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EDCC4CEEB;
	Tue, 22 Jul 2025 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193064;
	bh=BOYRw+jzwC9QyT/Gt65dBP0W3tgTvSxtr4+hFZ5L6T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iuBtVZBNuNTioo4csCXzQLCj/ucLc+U72vmd+TgIhD89I5N5T2lIXlFCP7cZFlYLl
	 NL3G+EZMcus9Kpus52u5TUGog/pdktF78RruvWyzwHFiM2XU+nbnYb7kDVBP6PvQFX
	 d+Z/jMyrjFqnrzQnPwqBH1fAJWDRr3y4kaLXVmVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Ertman <david.m.ertman@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/158] ice: add NULL check in eswitch lag check
Date: Tue, 22 Jul 2025 15:44:51 +0200
Message-ID: <20250722134344.738813117@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



