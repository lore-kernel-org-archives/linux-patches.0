Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C401DFE25;
	Wed,  6 Nov 2024 12:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896568; cv=none; b=qrmPUrgHjGVHxs36svBu8luX10JXQ261uXXeprRDmitMLftWQTsBxHM9mmYNgT5nWE1iu+lVEwtbir6vxZOwxyP7pyelXjcGUKTJMoVEJUeIXSCWVC5d/U/YJFrRl1FKDIWkiuHUixpc+avATo7+i5h7qPyar9HWchFEM2Zo/4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896568; c=relaxed/simple;
	bh=0SmdqOLdbx1J/FB83drLD60suDBMHSalQM4rQ6UulH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmgKUyf/u/pHZMqjBi3CeoFd05Ih2g54S0RJyrfX4dvTK5ht0IuiquNdLHWkqUxEVHI2Sxfpffn8GwTUyFk22MpJ0yLDih0VsrWeRjkY35c5ApIPcaNjKq6h4HczSIK7GhCMpyc30To+vr8GNo2RYaqxKXaAZrVMpqbILkOy2m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7eVb+9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7eVb+9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F4C4CECD;
	Wed,  6 Nov 2024 12:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896568;
	bh=0SmdqOLdbx1J/FB83drLD60suDBMHSalQM4rQ6UulH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7eVb+9RSghn62NuR/0DmxM/T/qK0BEnoBaOEd8s7lxurS9yCumK664RZzSeBXiV7
	 HjWdYIoJR/BDQLot8sK+Hhl3iQZe9PWNXJCm4BojCCgdFPFq39WZaq2IwsvhgQC2V/
	 eJCKdmGs12YKWA6JdWwZhXenyRVIegbwDkW3XS8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 6.11 236/245] drm/xe: Move enable host l2 VRAM post MCR init
Date: Wed,  6 Nov 2024 13:04:49 +0100
Message-ID: <20241106120325.075446624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

commit ab0d6ef864c5fa820e894ee1a07f861e63851664 upstream.

xe_gt_enable_host_l2_vram() is reading the XE2_GAMREQSTRM_CTRL register
that is currently missing the MCR annotation. However, just adding the
annotation doesn't work as this function is called before MCR handling
is initialized in xe_gt_mcr_init().

xe_gt_enable_host_l2_vram() is used to implement WA 16023588340 that
needs to be done as early as possible during initialization in order to
be effective since the MMIO writes impact it. In the failure scenario,
driver would simply not be able to bind successfully.

Moving xe_gt_enable_host_l2_vram() later, after MCR initialization is
done, only incurs a few additional HW accesses, particularly when
loading GuC for hwconfig. Binding/unbinding the driver 100 times in BMG
still works so it should be ok to start handling the WA a little bit
later. This is sufficient to allow adding the MCR annotation to
XE2_GAMREQSTRM_CTRL.

Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240814095614.909774-2-tejas.upadhyay@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -555,7 +555,6 @@ int xe_gt_init_hwconfig(struct xe_gt *gt
 
 	xe_gt_mcr_init_early(gt);
 	xe_pat_init(gt);
-	xe_gt_enable_host_l2_vram(gt);
 
 	err = xe_uc_init(&gt->uc);
 	if (err)
@@ -567,6 +566,7 @@ int xe_gt_init_hwconfig(struct xe_gt *gt
 
 	xe_gt_topology_init(gt);
 	xe_gt_mcr_init(gt);
+	xe_gt_enable_host_l2_vram(gt);
 
 out_fw:
 	xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);


