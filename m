Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4BE224D6;
	Sat, 17 Oct 2026 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253132; cv=none; b=VijRxxZGRh0WqpCyB0+xiY7W/EcocKOwBQW/9FH7e72Am9vwIsr+N2pZIKMiM5BRe4JwUW3V8coK7jqUjlPaVru/+rW/NW/xNB+DrgkLVvl0LeajAqx9Ch9IFGd1/KP47K3fuz94US/wgjie+OHFQ/B+uCxfsHlco8qu3h9+f5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253132; c=relaxed/simple;
	bh=vmB68MiGEsec9JNvt+EankOi1Z4t4zdBWCS5rpB8wa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncxLlbKVmfPvr1cgUhVoSTgn/U27cl9mu9ygVR5edzkTa/FzfAd4x6jeVcaC9X/d6DCcw2ghNE8cSOfkgupMqPZk29xl+WKC8li6mKzbioeQ9R91JzdtVeScGl4JgALljgJwDO3zqzEAuKV+gjt5CT6Hmy43L0QmILLVjsH7XDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhwEo/8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhwEo/8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0837D1F000C4;
	Sat, 17 Oct 2026 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253131;
	bh=6+DDdXmDpbPk/OD8RotROTgBQMQMUDOXkZujwUdtdN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhwEo/8V7+oXKTv8kgJh0O8fxnJglTSR4ZKpEfMH9yQ0qLRJbyan5H3wIvMZ5Oqj7
	 uyRqin/Y5uoKo7KJBVai2JIgjfNTkkpf2tbZQTYFnmmXn/PquUHWNPtq9XH8xWkTs/
	 X3JC84FvJUhLdt32Hh/LxtaWTxkfBtW0iKmfA8f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/869] ice: fix use-after-free in dynamic port cleanup
Date: Sat, 17 Oct 2026 17:47:26 +0200
Message-ID: <20261017160037.133462381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 1402fc67d2f4e2e1fc7bf8ee0825b8ad994557ff ]

ice_dealloc_dynamic_port() uses dyn_port->vsi->idx to erase the dynamic
port from pf->dyn_ports. However, it frees the VSI before reading the
index for the erase, resulting in a use-after-free.

Follow the reverse of the allocation order in ice_alloc_dynamic_port()
by erasing the xarray entry before freeing the VSI.

Fixes: eda69d654c7e ("ice: add basic devlink subfunctions support")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260928230429.495442-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/devlink/devlink_port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/devlink/devlink_port.c b/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
index c6779d9dffffd..a5859fcc10e68 100644
--- a/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
+++ b/drivers/net/ethernet/intel/ice/devlink/devlink_port.c
@@ -588,8 +588,8 @@ static void ice_dealloc_dynamic_port(struct ice_dynamic_port *dyn_port)
 
 	xa_erase(&pf->sf_nums, devlink_port->attrs.pci_sf.sf);
 	ice_eswitch_detach_sf(pf, dyn_port);
-	ice_vsi_free(dyn_port->vsi);
 	xa_erase(&pf->dyn_ports, dyn_port->vsi->idx);
+	ice_vsi_free(dyn_port->vsi);
 	kfree(dyn_port);
 }
 
-- 
2.53.0



