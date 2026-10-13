Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC2950AC1C;
	Tue, 13 Oct 2026 12:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893001; cv=none; b=HBAQl7VLUTi4tUJNXML4pQfUSaITaocpE/p/HnWsgx7XsPN8HIcHElyvSV0RrFnyJoL0GO10kOjmFEHGHYoKOX6kEtBPrUpSDf7NG5Tsrxua/veL9zpUnqpVXOxCZycD5W1R8wJupZ4/84MbEf+UefBfvwfrdbKz1zdSXViaxRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893001; c=relaxed/simple;
	bh=CZU/70TEoKacqnBJ85gmTVIa5Vjm2zLc2/2iJoo2DhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Db4zGKyDp1wgHNo+iMcLtJgim6Auzu6y9e5ZP4Mlcnlusmk/cQLh2S2m1oslWe091vuF5MlSnSabdTyxw1qKQK0jQ+xgxD4gSKHuhcVpveAlrTVcNkiHP/uPMcTXZKy2+HJpoQ0+DfB2kRok2YTOGTUxl5jwQL70sv8aYvSeK3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+kPwg37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+kPwg37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C2B1F000FF;
	Tue, 13 Oct 2026 12:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892999;
	bh=nbv3+ev18Td1T/zSlRkoT7/D6wzplblevF2LOMm670s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+kPwg37H6CnBfJX6w+XnRtHKSCBxsi4srGJO7v8q+o9DjO3hzcwa7C0TT0+0sciV
	 XeNOcbomkYcTfhBPiR9lsZ3jmqJOuIsjGFki/jpNeuxSOg/xDX9DowwqVBRhfjOjes
	 hm/ktc2/RJV3SkbKY1gED3vrxs7neztP7fKJ8m0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 062/621] ice: fix use-after-free in dynamic port cleanup
Date: Tue, 13 Oct 2026 13:30:57 +0200
Message-ID: <20261013112922.333760827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 1402fc67d2f4e2e1fc7bf8ee0825b8ad994557ff upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/devlink/port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/devlink/port.c
+++ b/drivers/net/ethernet/intel/ice/devlink/port.c
@@ -590,8 +590,8 @@ static void ice_dealloc_dynamic_port(str
 
 	xa_erase(&pf->sf_nums, devlink_port->attrs.pci_sf.sf);
 	ice_eswitch_detach_sf(pf, dyn_port);
-	ice_vsi_free(dyn_port->vsi);
 	xa_erase(&pf->dyn_ports, dyn_port->vsi->idx);
+	ice_vsi_free(dyn_port->vsi);
 	kfree(dyn_port);
 }
 


