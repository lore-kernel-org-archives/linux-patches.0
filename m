Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB73337F8C2;
	Fri,  7 Aug 2026 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117759; cv=none; b=jzp0kZUz9vKPQOMSdDX3y7lruYKVXh7LULmwFA6EP0dQ7qu57N3E6/pOq165LzXKabm+qSWjCRITooyj/S+MbXLrTXJgdfMb/8a/gKPsSTRbuhfc8Dcoo/1IPW8WyY2GOBnhxEqPGQusrqmx8D74PmCQSItCVRazBoNGCd6wpcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117759; c=relaxed/simple;
	bh=y7IlxGhLQmANZl+4XTZRao61yTanRpOsVJTUjT5bs24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YozyDuumVSsrf9NLSaDFO0iVKy086htfBlDxdJLzzvowr2Pqi65Ap/JmskLiGuiHdq/zaJxGeB86iZXwy7qTQzUzsQqwpdKr5XGqObjTXjjDBm7CrHvDEkf7PR3cBFtgyWj4zbPTOhpDR3x4DgJZ1Lqf12NeWcDDtvVFDbCLuDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0vcw/RE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0vcw/RE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81491F000E9;
	Fri,  7 Aug 2026 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117757;
	bh=vm14hpktb+WALnEw47dAL2tq7dSl/ngUHZwNJHsdeCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0vcw/REowSlmbblPFJKX00q/2hHcdxkDHKIfdzYLmWot1gRcvCJetoFeVXP7gQmN
	 NEqqEniUWOdrDJOWWSv1Mr5STvA2oHqS1r/D6Tw9q+NWSas7tX3EudhUYdjiE0kTYs
	 8qEcb0MVzLsezd+PucVRbWhvWb1BMuN0rqVVpLsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 430/438] drm/xe: Move xe->info.devid|revid initialization
Date: Fri,  7 Aug 2026 16:40:26 +0200
Message-ID: <20260807143437.136134371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit c03d9fbe77ec5002a2345b9be464683e0b157709 ]

The xe_info_init_early() is a place where we initialize those of
the xe->info fields that do not require any additional hardware
probes. Move the initialization of the devid/revid also there, but
to avoid breaking the kunit helper, which also calls this function,
keep their initialization separate in sub-function so we can easily
stub it when running the kunit test.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20260526195452.20545-5-michal.wajdeczko@intel.com
Stable-dep-of: ba7fd1634228 ("drm/xe: Set TTM device beneficial_order to 9 (2M)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/tests/xe_pci.c |    6 ++++++
 drivers/gpu/drm/xe/xe_device.c    |    2 --
 drivers/gpu/drm/xe/xe_pci.c       |   12 ++++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/tests/xe_pci.c
+++ b/drivers/gpu/drm/xe/tests/xe_pci.c
@@ -310,6 +310,11 @@ const void *xe_pci_id_gen_param(struct k
 }
 EXPORT_SYMBOL_IF_KUNIT(xe_pci_id_gen_param);
 
+static void fake_init_devid(struct xe_device *xe)
+{
+	/* Nothing to do, just keep zero. */
+}
+
 static int fake_read_gmdid(struct xe_device *xe, enum xe_gmdid_type type,
 			   u32 *ver, u32 *revid)
 {
@@ -368,6 +373,7 @@ done:
 	xe->sriov.__mode = data && data->sriov_mode ?
 			   data->sriov_mode : XE_SRIOV_MODE_NONE;
 
+	kunit_activate_static_stub(test, init_devid, fake_init_devid);
 	kunit_activate_static_stub(test, read_gmdid, fake_read_gmdid);
 	kunit_activate_static_stub(test, xe_info_probe_tile_count,
 				   fake_xe_info_probe_tile_count);
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -473,8 +473,6 @@ struct xe_device *xe_device_create(struc
 	if (err)
 		return ERR_PTR(err);
 
-	xe->info.devid = pdev->device;
-	xe->info.revid = pdev->revision;
 	xe->atomic_svm_timeslice_ms = 5;
 	xe->min_run_period_lr_ms = 5;
 
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -723,6 +723,16 @@ static int handle_gmdid(struct xe_device
 	return 0;
 }
 
+static void init_devid(struct xe_device *xe)
+{
+	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+
+	KUNIT_STATIC_STUB_REDIRECT(init_devid, xe);
+
+	xe->info.devid = pdev->device;
+	xe->info.revid = pdev->revision;
+}
+
 /*
  * Initialize device info content that only depends on static driver_data
  * passed to the driver at probe time from PCI ID table.
@@ -738,6 +748,8 @@ static int xe_info_init_early(struct xe_
 	xe->info.subplatform = subplatform_desc ?
 		subplatform_desc->subplatform : XE_SUBPLATFORM_NONE;
 
+	init_devid(xe);
+
 	xe->info.dma_mask_size = desc->dma_mask_size;
 	xe->info.va_bits = desc->va_bits;
 	xe->info.vm_max_level = desc->vm_max_level;


