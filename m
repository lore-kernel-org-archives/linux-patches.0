Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9AB334369;
	Thu, 27 Nov 2025 14:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255287; cv=none; b=WLXbC3qENvRTl7PpWARMi6EFByv+jNbsnoDkA1wjh/v2okYanDoZ6cJyo6bW3LLrv4hPfYoWjT5Bpzycfvy/WWs0RrIcvcvu+ZqQzsRb0iZA7ydURgA9XAqt6mkLgAcIvb4QkJucIvdbw/ylayWBD87TCg7rfymjGTSr5b4xeRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255287; c=relaxed/simple;
	bh=yqD9T75hEqDpyVZ2VKJu3UO+hyUyJp3gBOHHHj0vhcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBPkmpvJtOSmVPUDlQZztUOXBKUCL0Sddul983Sdw/4Tr6srSXy+QzqOcoUcDNJIlZBoLhgclGYy2fRjFqAH+rwZxZ0+wOql+GKalPTE1Fcoc+kG+XNppWdxXAMy65k8ba3h5aXGTtnLWvM8BlRgcPjiF3hI/x+JZ9hv8d7uZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrYXQM4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrYXQM4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B36C4CEF8;
	Thu, 27 Nov 2025 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255286;
	bh=yqD9T75hEqDpyVZ2VKJu3UO+hyUyJp3gBOHHHj0vhcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrYXQM4mMT1Em1y9KMsgq5NO6v1tL3kzkaamm6I7bIEct2IcvJWmBqlKqtL9c9iRr
	 ETNFLfBNzVtqgt7CCOXJQSL3yu/3O/TPnKBGaMWXmGVIhw1mC+wwHx8khYdeJSHDcW
	 +2D0o8KIDIm+NmlJub5fcT/fVsCJFlZvYzucTcc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.12 073/112] ice: fix PTP cleanup on driver removal in error path
Date: Thu, 27 Nov 2025 15:46:15 +0100
Message-ID: <20251127144035.512776721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit 23a5b9b12de9dcd15ebae4f1abc8814ec1c51ab0 ]

Improve the cleanup on releasing PTP resources in error path.
The error case might happen either at the driver probe and PTP
feature initialization or on PTP restart (errors in reset handling, NVM
update etc). In both cases, calls to PF PTP cleanup (ice_ptp_cleanup_pf
function) and 'ps_lock' mutex deinitialization were missed.
Additionally, ptp clock was not unregistered in the latter case.

Keep PTP state as 'uninitialized' on init to distinguish between error
scenarios and to avoid resource release duplication at driver removal.

The consequence of missing ice_ptp_cleanup_pf call is the following call
trace dumped when ice_adapter object is freed (port list is not empty,
as it is required at this stage):

[  T93022] ------------[ cut here ]------------
[  T93022] WARNING: CPU: 10 PID: 93022 at
ice/ice_adapter.c:67 ice_adapter_put+0xef/0x100 [ice]
...
[  T93022] RIP: 0010:ice_adapter_put+0xef/0x100 [ice]
...
[  T93022] Call Trace:
[  T93022]  <TASK>
[  T93022]  ? ice_adapter_put+0xef/0x100 [ice
33d2647ad4f6d866d41eefff1806df37c68aef0c]
[  T93022]  ? __warn.cold+0xb0/0x10e
[  T93022]  ? ice_adapter_put+0xef/0x100 [ice
33d2647ad4f6d866d41eefff1806df37c68aef0c]
[  T93022]  ? report_bug+0xd8/0x150
[  T93022]  ? handle_bug+0xe9/0x110
[  T93022]  ? exc_invalid_op+0x17/0x70
[  T93022]  ? asm_exc_invalid_op+0x1a/0x20
[  T93022]  ? ice_adapter_put+0xef/0x100 [ice
33d2647ad4f6d866d41eefff1806df37c68aef0c]
[  T93022]  pci_device_remove+0x42/0xb0
[  T93022]  device_release_driver_internal+0x19f/0x200
[  T93022]  driver_detach+0x48/0x90
[  T93022]  bus_remove_driver+0x70/0xf0
[  T93022]  pci_unregister_driver+0x42/0xb0
[  T93022]  ice_module_exit+0x10/0xdb0 [ice
33d2647ad4f6d866d41eefff1806df37c68aef0c]
...
[  T93022] ---[ end trace 0000000000000000 ]---
[  T93022] ice: module unloaded

Fixes: e800654e85b5 ("ice: Use ice_adapter for PTP shared data instead of auxdev")
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 369c968a0117d..4e6006991e8fd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -3409,7 +3409,7 @@ void ice_ptp_init(struct ice_pf *pf)
 
 	err = ice_ptp_init_port(pf, &ptp->port);
 	if (err)
-		goto err_exit;
+		goto err_clean_pf;
 
 	/* Start the PHY timestamping block */
 	ice_ptp_reset_phy_timestamping(pf);
@@ -3426,13 +3426,19 @@ void ice_ptp_init(struct ice_pf *pf)
 	dev_info(ice_pf_to_dev(pf), "PTP init successful\n");
 	return;
 
+err_clean_pf:
+	mutex_destroy(&ptp->port.ps_lock);
+	ice_ptp_cleanup_pf(pf);
 err_exit:
 	/* If we registered a PTP clock, release it */
 	if (pf->ptp.clock) {
 		ptp_clock_unregister(ptp->clock);
 		pf->ptp.clock = NULL;
 	}
-	ptp->state = ICE_PTP_ERROR;
+	/* Keep ICE_PTP_UNINIT state to avoid ambiguity at driver unload
+	 * and to avoid duplicated resources release.
+	 */
+	ptp->state = ICE_PTP_UNINIT;
 	dev_err(ice_pf_to_dev(pf), "PTP failed %d\n", err);
 }
 
@@ -3445,9 +3451,19 @@ void ice_ptp_init(struct ice_pf *pf)
  */
 void ice_ptp_release(struct ice_pf *pf)
 {
-	if (pf->ptp.state != ICE_PTP_READY)
+	if (pf->ptp.state == ICE_PTP_UNINIT)
 		return;
 
+	if (pf->ptp.state != ICE_PTP_READY) {
+		mutex_destroy(&pf->ptp.port.ps_lock);
+		ice_ptp_cleanup_pf(pf);
+		if (pf->ptp.clock) {
+			ptp_clock_unregister(pf->ptp.clock);
+			pf->ptp.clock = NULL;
+		}
+		return;
+	}
+
 	pf->ptp.state = ICE_PTP_UNINIT;
 
 	/* Disable timestamping for both Tx and Rx */
-- 
2.51.0



