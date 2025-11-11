Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FAC265CA8;
	Tue, 11 Nov 2025 01:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823137; cv=none; b=gu/bo++835QJONYXScKqXrdMwGfA4QnSmgzgsh4IkEjKn7s7DkzydZywAWWXu9E1EPZS3P6JYNqRqf9l6nczRrSBDE+lTbtQzHxPFMCZezw2+QQ8nKbPX5QwDiYslHHXyNuUMWwZ+eX7EZKV6v5VPEwn1LCsCZw9EL08EEx6qDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823137; c=relaxed/simple;
	bh=R4PYAyzt/uZpCS/EM9hwwEnvzhkIYQquisVOXvRLtww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EiuojT0BUTCGzjFXYPE4vQyHH8XSG5sf+iX77xQjF3SG81wGaEtSGAbvRNnBVfhdrEFaW/ekkg1xwXZcHTq3vszxTE2jR2N7qfYVFIye2B3Q0L71VSB8bT+Hjo944int/DRx6iRtduWW5C3UkSmzKQ1PlCilhq6v5Ut4aMZp1tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrQsQW87; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrQsQW87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B8BC113D0;
	Tue, 11 Nov 2025 01:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823137;
	bh=R4PYAyzt/uZpCS/EM9hwwEnvzhkIYQquisVOXvRLtww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrQsQW87yP561oJEWklDIpTA6pFEAeGfPr/0dRWgietuwXr359PG2YMvxkINnoQT1
	 DYLlyOV5sucdwoVZFzLagg6uYGpAvBFBLUSljjrN890SjP+4yXbLlqQzL4mFaAHCxT
	 86U998bNstzcbvqi0hH+56jkQMyHvXFwidsciSQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/565] drm/xe/guc: Add more GuC load error status codes
Date: Tue, 11 Nov 2025 09:40:34 +0900
Message-ID: <20251111004530.937229479@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 45fbb51050e72723c2bdcedc1ce32305256c70ed ]

The GuC load process will abort if certain status codes (which are
indicative of a fatal error) are reported. Otherwise, it keeps waiting
until the 'success' code is returned. New error codes have been added
in recent GuC releases, so add support for aborting on those as well.

v2: Shuffle HWCONFIG_START to the front of the switch to keep the
ordering as per the enum define for clarity (review feedback by
Jonathan). Also add a description for the basic 'invalid init data'
code which was missing.

Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250726024337.4056272-1-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/abi/guc_errors_abi.h |  3 +++
 drivers/gpu/drm/xe/xe_guc.c             | 19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/abi/guc_errors_abi.h b/drivers/gpu/drm/xe/abi/guc_errors_abi.h
index 2c627a21648f7..9260f4a1997d9 100644
--- a/drivers/gpu/drm/xe/abi/guc_errors_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_errors_abi.h
@@ -55,6 +55,7 @@ enum xe_guc_load_status {
 	XE_GUC_LOAD_STATUS_HWCONFIG_START                   = 0x05,
 	XE_GUC_LOAD_STATUS_HWCONFIG_DONE                    = 0x06,
 	XE_GUC_LOAD_STATUS_HWCONFIG_ERROR                   = 0x07,
+	XE_GUC_LOAD_STATUS_BOOTROM_VERSION_MISMATCH         = 0x08,
 	XE_GUC_LOAD_STATUS_GDT_DONE                         = 0x10,
 	XE_GUC_LOAD_STATUS_IDT_DONE                         = 0x20,
 	XE_GUC_LOAD_STATUS_LAPIC_DONE                       = 0x30,
@@ -67,6 +68,8 @@ enum xe_guc_load_status {
 	XE_GUC_LOAD_STATUS_INVALID_INIT_DATA_RANGE_START,
 	XE_GUC_LOAD_STATUS_MPU_DATA_INVALID                 = 0x73,
 	XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID   = 0x74,
+	XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR        = 0x75,
+	XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG                 = 0x76,
 	XE_GUC_LOAD_STATUS_INVALID_INIT_DATA_RANGE_END,
 
 	XE_GUC_LOAD_STATUS_READY                            = 0xF0,
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 96373cdb366be..907a458c9eff5 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -527,11 +527,14 @@ static int guc_load_done(u32 status)
 	case XE_GUC_LOAD_STATUS_GUC_PREPROD_BUILD_MISMATCH:
 	case XE_GUC_LOAD_STATUS_ERROR_DEVID_INVALID_GUCTYPE:
 	case XE_GUC_LOAD_STATUS_HWCONFIG_ERROR:
+	case XE_GUC_LOAD_STATUS_BOOTROM_VERSION_MISMATCH:
 	case XE_GUC_LOAD_STATUS_DPC_ERROR:
 	case XE_GUC_LOAD_STATUS_EXCEPTION:
 	case XE_GUC_LOAD_STATUS_INIT_DATA_INVALID:
 	case XE_GUC_LOAD_STATUS_MPU_DATA_INVALID:
 	case XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID:
+	case XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR:
+	case XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG:
 		return -1;
 	}
 
@@ -670,17 +673,29 @@ static void guc_wait_ucode(struct xe_guc *guc)
 		}
 
 		switch (ukernel) {
+		case XE_GUC_LOAD_STATUS_HWCONFIG_START:
+			xe_gt_err(gt, "still extracting hwconfig table.\n");
+			break;
+
 		case XE_GUC_LOAD_STATUS_EXCEPTION:
 			xe_gt_err(gt, "firmware exception. EIP: %#x\n",
 				  xe_mmio_read32(gt, SOFT_SCRATCH(13)));
 			break;
 
+		case XE_GUC_LOAD_STATUS_INIT_DATA_INVALID:
+			xe_gt_err(gt, "illegal init/ADS data\n");
+			break;
+
 		case XE_GUC_LOAD_STATUS_INIT_MMIO_SAVE_RESTORE_INVALID:
 			xe_gt_err(gt, "illegal register in save/restore workaround list\n");
 			break;
 
-		case XE_GUC_LOAD_STATUS_HWCONFIG_START:
-			xe_gt_err(gt, "still extracting hwconfig table.\n");
+		case XE_GUC_LOAD_STATUS_KLV_WORKAROUND_INIT_ERROR:
+			xe_gt_err(gt, "illegal workaround KLV data\n");
+			break;
+
+		case XE_GUC_LOAD_STATUS_INVALID_FTR_FLAG:
+			xe_gt_err(gt, "illegal feature flag specified\n");
 			break;
 		}
 
-- 
2.51.0



