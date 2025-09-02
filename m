Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D7A30DEBB;
	Tue,  2 Sep 2025 13:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819521; cv=none; b=CKzXCqPFHkI0Tr/VIZV+jjO9epCG1lTpOEYbCbOTXLWrDLVTTDyUmYmcS2FsI5qflQjceJKOXb3PmvsKsV84ujjY7Qt1b4jj18k83qAUrpcrj2CFP8y/QE8JUNmBzYCnpYnztpyvCLHn3/hbmUy2I0Ee00aiy0tCyR3nS4z0pKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819521; c=relaxed/simple;
	bh=BxWV1hRzsWUg/LpaJTZQAPm+PuiIqi3eIk1o27dI5CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq55uDiH77kXP7rFWqWBbz7ZpOp/DrYcoCd+vnLYKToWhCPzKgfW+NOpyUm/PYFRJHbdoI1pr7lPNPqi1OjIblUtdFbQaOPsM2Hl0OJlNtgd425aDMFVx8JPFS33OSNJ9Q8MyYfvvAB2x7Az3n17rYPCDKVP9S8TSHX/nY9A00M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kj4F+rjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kj4F+rjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BBCC4CEF4;
	Tue,  2 Sep 2025 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819520;
	bh=BxWV1hRzsWUg/LpaJTZQAPm+PuiIqi3eIk1o27dI5CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kj4F+rjfOpH6Fak78SLThc7lfynJjEzAb6Cc9IykL1zAU/pqn7wqDQi9VcRDcQsdA
	 SOHrHgZBCKP93HUTTtuPCDeKx13aReexI52SVBGm8spoP6c17gFKjGKDutWFf2ZNct
	 NrsVbyeJlhPamV47NI/P8PHSgwArt6+EUsHrAlSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 057/142] ice: fix NULL pointer dereference in ice_unplug_aux_dev() on reset
Date: Tue,  2 Sep 2025 15:19:19 +0200
Message-ID: <20250902131950.435893807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit 60dfe2434eed13082f26eb7409665dfafb38fa51 ]

Issuing a reset when the driver is loaded without RDMA support, will
results in a crash as it attempts to remove RDMA's non-existent auxbus
device:
echo 1 > /sys/class/net/<if>/device/reset

BUG: kernel NULL pointer dereference, address: 0000000000000008
...
RIP: 0010:ice_unplug_aux_dev+0x29/0x70 [ice]
...
Call Trace:
<TASK>
ice_prepare_for_reset+0x77/0x260 [ice]
pci_dev_save_and_disable+0x2c/0x70
pci_reset_function+0x88/0x130
reset_store+0x5a/0xa0
kernfs_fop_write_iter+0x15e/0x210
vfs_write+0x273/0x520
ksys_write+0x6b/0xe0
do_syscall_64+0x79/0x3b0
entry_SYSCALL_64_after_hwframe+0x76/0x7e

ice_unplug_aux_dev() checks pf->cdev_info->adev for NULL pointer, but
pf->cdev_info will also be NULL, leading to the deref in the trace above.

Introduce a flag to be set when the creation of the auxbus device is
successful, to avoid multiple NULL pointer checks in ice_unplug_aux_dev().

Fixes: c24a65b6a27c7 ("iidc/ice/irdma: Update IDC to support multiple consumers")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h     |  1 +
 drivers/net/ethernet/intel/ice/ice_idc.c | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index ddd0ad68185b4..0ef11b7ab477e 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -509,6 +509,7 @@ enum ice_pf_flags {
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_UNPLUG_AUX_DEV,
+	ICE_FLAG_AUX_DEV_CREATED,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
 	ICE_FLAG_DPLL,			/* SyncE/PTP dplls initialized */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index 6ab53e430f912..420d45c2558b6 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -336,6 +336,7 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 	mutex_lock(&pf->adev_mutex);
 	cdev->adev = adev;
 	mutex_unlock(&pf->adev_mutex);
+	set_bit(ICE_FLAG_AUX_DEV_CREATED, pf->flags);
 
 	return 0;
 }
@@ -347,15 +348,16 @@ void ice_unplug_aux_dev(struct ice_pf *pf)
 {
 	struct auxiliary_device *adev;
 
+	if (!test_and_clear_bit(ICE_FLAG_AUX_DEV_CREATED, pf->flags))
+		return;
+
 	mutex_lock(&pf->adev_mutex);
 	adev = pf->cdev_info->adev;
 	pf->cdev_info->adev = NULL;
 	mutex_unlock(&pf->adev_mutex);
 
-	if (adev) {
-		auxiliary_device_delete(adev);
-		auxiliary_device_uninit(adev);
-	}
+	auxiliary_device_delete(adev);
+	auxiliary_device_uninit(adev);
 }
 
 /**
-- 
2.50.1



