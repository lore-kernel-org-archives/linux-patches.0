Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F731408615;
	Tue, 21 Jul 2026 18:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658881; cv=none; b=MHbdKllr3wDpS/x/A0OZ6jTfWBXOHaHRoP0RJojNQYWs5M2S9edmtaG8fc+LVDfDZsIEZA9GeAi3RR5jnnA2BXyZfxSuOaKn00qpksQ+bw57KlO2B8+QXTvLKd98+Z33BpOVbNe8kQDh90P2YnPMXOgLQ1D9SLJfRc0v02Owr+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658881; c=relaxed/simple;
	bh=vAumwinzJ00RWed7cZtpeFXieiHzVGNP181Lt4gtfRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmzCXtAcP9U0lXOB+o5EIXx9U2M2C5fiEs4quh5KHYL7dcN8+ci95h9nuf7K/k2Hts8sYAZz/daaI51Mh2mpDGDrzlbmQ0sZMa2gFnOFrqiZitGADaXAfKh2R90hTX8or4PUtqZrd+9kfMkoq+25QhStAcMajepJJxezKDG7tZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6a+eDv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6a+eDv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1095A1F000E9;
	Tue, 21 Jul 2026 18:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658880;
	bh=GHDcUFptOg7OkWmgAYthxMRfOCbN9SobfXVVrE8e31Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6a+eDv6UDlV2lJ0axfkoSTZ0ThWNGr2djm6LFHu12uocm+GUS14/0HRTL4rhN+ea
	 jsXyBz4iuotop1bubJDt8UOaZIsseu3KnAh8uuA8eJzIvBSReKxZdfXUVp8PsWgkpl
	 4OLrufFS0Yrrp4qpsxv3eav4LNRRm0GkW84mi2M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.18 1312/1611] ice: fix ice_init_link() error return preventing probe
Date: Tue, 21 Jul 2026 17:23:48 +0200
Message-ID: <20260721152544.965723347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -4871,16 +4871,14 @@ static void ice_init_wakeup(struct ice_p
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
@@ -4914,8 +4912,6 @@ static int ice_init_link(struct ice_pf *
 	} else {
 		set_bit(ICE_FLAG_NO_MEDIA, pf->flags);
 	}
-
-	return err;
 }
 
 static int ice_init_pf_sw(struct ice_pf *pf)
@@ -5058,13 +5054,11 @@ static int ice_init(struct ice_pf *pf)
 
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
 
@@ -5083,7 +5077,7 @@ static int ice_init(struct ice_pf *pf)
 
 	return 0;
 
-err_init_link:
+err_deinit_pf_sw:
 	ice_deinit_pf_sw(pf);
 err_init_pf_sw:
 	ice_dealloc_vsis(pf);


