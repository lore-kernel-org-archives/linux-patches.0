Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC92388E40;
	Tue, 21 Jul 2026 19:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661043; cv=none; b=mraYlU5xvXODANoehPYII2V/R0xZrBLKAw9scysoW4SZc4r22sFCXh5yKWTzgUkJas9JvdmT5FBDggdj1zgEvE2/cJQSivb9fUbUBKqmM0UUwtHAMFU6OyQGSVCzaxRKh7TYqinOLZCAyr/tEv8UyJPtKvMdWq37Jh4UJrzPaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661043; c=relaxed/simple;
	bh=vCz7pBXUpqgwbvRvRpS3WBIZItb00HoCj6F4SpoF6dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKdStgD3yVpV1+Ez2cGu0RU1kseb+mhpPcLi/9o6GzV3kJqEr07hVu9tYhM5Mc9q6ivfZOv3Qy5MNLEeKMK49MCuaoyiq3E/whZNqhbK8IrAsZ27nVwgA66xyU8bkSl9tDQX+u/hEN/GZgEORM2foEbv7yghsdEXlNIpEr28hT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STK68FtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STK68FtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E981F000E9;
	Tue, 21 Jul 2026 19:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661041;
	bh=F7lBU1q4pqehERX0cRFWTJeK4PqVEXEqH1VyYUsBwSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STK68FtR9ta531O+Dpa9QbkvyINk9ajAUT+oYc6FBzcoemMnDdPb6BubntPB1zWnp
	 XrPIcucHVa/1ytEsLFLhBEElHgHg5Vix3Xn4ltZ7Wocc6TXm7GaUm4yNq5Zg6PjSCW
	 U8NO/86quqlVbsmsWz2ezwtWWIKENtAfWv/b9WzQ=
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
Subject: [PATCH 7.1 1210/2077] ice: call netif_keep_dst() once when entering switchdev mode
Date: Tue, 21 Jul 2026 17:14:43 +0200
Message-ID: <20260721152621.353759453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e4f0969035f77..c30e27bbfe6e25 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -117,8 +117,6 @@ static int ice_eswitch_setup_repr(struct ice_pf *pf, struct ice_repr *repr)
 	if (!repr->dst)
 		return -ENOMEM;
 
-	netif_keep_dst(uplink_vsi->netdev);
-
 	dst = repr->dst;
 	dst->u.port_info.port_id = vsi->vsi_num;
 	dst->u.port_info.lower_dev = uplink_vsi->netdev;
@@ -312,6 +310,8 @@ static int ice_eswitch_enable_switchdev(struct ice_pf *pf)
 	if (ice_eswitch_br_offloads_init(pf))
 		goto err_br_offloads;
 
+	netif_keep_dst(uplink_vsi->netdev);
+
 	pf->eswitch.is_running = true;
 
 	return 0;
-- 
2.53.0



