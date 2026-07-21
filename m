Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BC0470119;
	Tue, 21 Jul 2026 19:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662926; cv=none; b=t9tyj+3xCHu4BHMoERdgPO5w2XKqQX3l/n/FfA8BSBkaji3xTJMMT5i2/opj14aAmyZaEKn/XREVJsWMiaceUmYYQ7ifOBsF2wYHFNvKbGDZUWCKgB9UFsEs47sI8y8LpsbEkPfTzd3APKOeLaSP98nfhigF1nDphzDdezdsg2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662926; c=relaxed/simple;
	bh=KVOnduxtOqmPuV9l+Iq03BvLXKCJmUDGXH4KAw9WirA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBO7SLFalU3thqthdvpqiQryEF3J0ao9lmB4pNqrsoKC0SSzdY4zmtkoDsy7ObvZhh9yrAmVBA4otDVH1bJOlPgNMHqX0/BL8HM2IMmiEs77Kkk74BbZa40bqTCeINIteXHHmdCDFCD7rpPWxjOvoG7pkAFJR/RPvTnHkm4yIu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLpWEzv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLpWEzv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71771F000E9;
	Tue, 21 Jul 2026 19:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662925;
	bh=XHVXcY+Y/Jzl0724r4xq/EIjPVuj9sQtikOKIdIgq20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLpWEzv0yigrloKK+j364s1BcexEeudnXcd59AGTszbfgsth0U6pABupTqCZZ3Hrc
	 R++Tfd8u5dGVSpN4beV6Z/FpOP231JBu5pkuXwFDcVMp0OBY3oRjocHGGJAP12r1v7
	 RA5YUaMD+FYJ6wjhkSio0IKX8zyAsrutZ0UO20IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0628/1276] ice: call netif_keep_dst() once when entering switchdev mode
Date: Tue, 21 Jul 2026 17:17:51 +0200
Message-ID: <20260721152500.162788999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcin Szycik <marcin.szycik@intel.com>

[ Upstream commit c0d00c882bc432990d57052a659f9a8bd1f60687 ]

netif_keep_dst() only needs to be called once for the uplink VSI, not
once for each port representor.  Move it from ice_eswitch_setup_repr()
to ice_eswitch_enable_switchdev().

Fixes: defd52455aee ("ice: do Tx through PF netdev in slow-path")
Signed-off-by: Marcin Szycik <marcin.szycik@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 5b9a7ee278f17b..32b52ecff04ffb 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -116,8 +116,6 @@ static int ice_eswitch_setup_repr(struct ice_pf *pf, struct ice_repr *repr)
 	if (!repr->dst)
 		return -ENOMEM;
 
-	netif_keep_dst(uplink_vsi->netdev);
-
 	dst = repr->dst;
 	dst->u.port_info.port_id = vsi->vsi_num;
 	dst->u.port_info.lower_dev = uplink_vsi->netdev;
@@ -306,6 +304,8 @@ static int ice_eswitch_enable_switchdev(struct ice_pf *pf)
 	if (ice_eswitch_br_offloads_init(pf))
 		goto err_br_offloads;
 
+	netif_keep_dst(uplink_vsi->netdev);
+
 	pf->eswitch.is_running = true;
 
 	return 0;
-- 
2.53.0



