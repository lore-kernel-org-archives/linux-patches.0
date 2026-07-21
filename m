Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01FA375AC3;
	Tue, 21 Jul 2026 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654702; cv=none; b=q91JizVWHjH4KPvSVnN61X2PC+D/uP0Mg6nSZvg/UAJJJ3baGsRDR854difBdsHCEVi3vJuXp/pBMbcidaTiXA7AlZQ89jHhlEmJAu7hyLvesZcxYqBNxUv4XpSPfeotLXDtn/ikIEaO1UMm/t0Wwd/Sp6unLKJd8qgJ5AT2oWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654702; c=relaxed/simple;
	bh=9olSUilN1wYqzegiUF8pFJgEoIKl9tiiFolfS2y1g64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foKpZjONS2pSLaf+CFQc1hkS+E0oRsBIAQ4UevKAOxHmxUaR3TMiiP1HM143pjre+7s5jAaSkdM2LQyXW5A2Pp/AHLTQwQxFtyjKQwmGPjOVXFrzcvwYTHZiVik/UtyYtD+dUUUw2N+XjPSVcbS+lIyz/DcS4yF70YVzjVgrDAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A89YCnep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A89YCnep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9501F000E9;
	Tue, 21 Jul 2026 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654701;
	bh=UQ67SWuFBXD/jBWNgxNSem2LwBCd+XDjWx/dzRRW9WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A89YCnepmJD6XstmYrE1qiEci5c/vc+o94+5/udo+2bPQ2juv79AxDsphdnxwiIMH
	 9Ue0l0sJ8g/jChAC5A3AuVTs96ci9vfF5ipqL0MJI9S81YmtJWxiFVeMOxWxrMaBBi
	 wOhm5X6Ii1oIvgm491GMJNzYHYf6ceUJOY/HmDUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 7.1 1798/2077] ice: fix ice_init_link() error return preventing probe
Date: Tue, 21 Jul 2026 17:24:31 +0200
Message-ID: <20260721152635.156091989@linuxfoundation.org>
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

From: Paul Greenwalt <paul.greenwalt@intel.com>

commit eb509638686b0f8a98a0dd9c809f6a8db4d73a45 upstream.

ice_init_link() can return an error status from ice_update_link_info()
or ice_init_phy_user_cfg(), causing probe to fail.

An incorrect NVM update procedure can result in link/PHY errors, and
the recommended resolution is to update the NVM using the correct
procedure. If the driver fails probe due to link errors, the user
cannot update the NVM to recover. The link/PHY errors logged are
non-fatal: they are already annotated as 'not a fatal error if this
fails'.

Since none of the errors inside ice_init_link() should prevent probe
from completing, convert it to void and remove the error check in the
caller. All failures are already logged; callers have no meaningful
recovery path for link init errors.

Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4789,16 +4789,14 @@ static void ice_init_wakeup(struct ice_p
 	device_set_wakeup_enable(ice_pf_to_dev(pf), false);
 }
 
-static int ice_init_link(struct ice_pf *pf)
+static void ice_init_link(struct ice_pf *pf)
 {
 	struct device *dev = ice_pf_to_dev(pf);
 	int err;
 
 	err = ice_init_link_events(pf->hw.port_info);
-	if (err) {
+	if (err)
 		dev_err(dev, "ice_init_link_events failed: %d\n", err);
-		return err;
-	}
 
 	/* not a fatal error if this fails */
 	err = ice_init_nvm_phy_type(pf->hw.port_info);
@@ -4838,8 +4836,6 @@ static int ice_init_link(struct ice_pf *
 	} else {
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 	}
-
-	return err;
 }
 
 static int ice_init_pf_sw(struct ice_pf *pf)
@@ -4982,13 +4978,11 @@ static int ice_init(struct ice_pf *pf)
 
 	ice_init_wakeup(pf);
 
-	err = ice_init_link(pf);
-	if (err)
-		goto err_init_link;
+	ice_init_link(pf);
 
 	err = ice_send_version(pf);
 	if (err)
-		goto err_init_link;
+		goto err_deinit_pf_sw;
 
 	ice_verify_cacheline_size(pf);
 
@@ -5007,7 +5001,7 @@ static int ice_init(struct ice_pf *pf)
 
 	return 0;
 
-err_init_link:
+err_deinit_pf_sw:
 	ice_deinit_pf_sw(pf);
 err_init_pf_sw:
 	ice_dealloc_vsis(pf);


