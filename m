Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D56C1DF738;
	Wed,  6 Nov 2024 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896583; cv=none; b=P28UqjympPFSMIdJFLDAKAjagb0Fdb1oRxQ8Var2HMuABWPhtn1gW13SzwHbETRkqzLldMtkvB8D07vsbu0Ew2pw4mjcXg2MXRoGI4BPQnSTtw25eWRJg5JoXK6ZjDpIfFch6yDYequFoYbsLw0p1Q+fhDI6cNm4/CpGGNUke/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896583; c=relaxed/simple;
	bh=IA/rbFDTpveoxA5vd7a4CiGeROb/F29HBkNNYedYMyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8Z03TD/Tg1dfuirnYMNuyTBH9NR2ts/JJ85kAediIOTJcCn4ATU4D0llrBdDaRWj4KFbm1duA1rFBw8pQ7H6RVvR4gSXYOl88uFg8yTiKEjmE+m4H9rnA6KmMMPs3CD7MX48xX+t4cnWf8321iqS2Hnoa20ntOsidAdii7CWZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuRaX15f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuRaX15f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E6BC4CED4;
	Wed,  6 Nov 2024 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896583;
	bh=IA/rbFDTpveoxA5vd7a4CiGeROb/F29HBkNNYedYMyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuRaX15fgArxMV6diSrHpef2iyh0LfdQtSdK/xefy1/OcHwQgDIb61HPizR0JocxC
	 KCRokiin9dAmamaATpxIIrtpNZE6QYBnHSIsznEyCAw9SAFDUhBTM8geF0qXHQ3PME
	 dMqSLQUwPA9toJIOJ6n3/kF2DIvThf8qwYWYOlrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 241/245] drm/xe: Write all slices if its mcr register
Date: Wed,  6 Nov 2024 13:04:54 +0100
Message-ID: <20241106120325.202884482@linuxfoundation.org>
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

commit f0ffa657e9f3913c7921cbd4d876343401f15f52 upstream.

Register GAMREQSTRM_CTRL should be considered mcr register
which should write to all slices as per documentation.

Bspec: 71185
Fixes: 01570b446939 ("drm/xe/bmg: implement Wa_16023588340")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240814095614.909774-3-tejas.upadhyay@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    2 +-
 drivers/gpu/drm/xe/xe_gt.c           |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -83,7 +83,7 @@
 #define STATELESS_COMPRESSION_CTRL		XE_REG_MCR(0x4148)
 #define   UNIFIED_COMPRESSION_FORMAT		REG_GENMASK(3, 0)
 
-#define XE2_GAMREQSTRM_CTRL			XE_REG(0x4194)
+#define XE2_GAMREQSTRM_CTRL			XE_REG_MCR(0x4194)
 #define   CG_DIS_CNTLBUS			REG_BIT(6)
 
 #define CCS_AUX_INV				XE_REG(0x4208)
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -109,9 +109,9 @@ static void xe_gt_enable_host_l2_vram(st
 
 	if (!xe_gt_is_media_type(gt)) {
 		xe_mmio_write32(gt, SCRATCH1LPFC, EN_L3_RW_CCS_CACHE_FLUSH);
-		reg = xe_mmio_read32(gt, XE2_GAMREQSTRM_CTRL);
+		reg = xe_gt_mcr_unicast_read_any(gt, XE2_GAMREQSTRM_CTRL);
 		reg |= CG_DIS_CNTLBUS;
-		xe_mmio_write32(gt, XE2_GAMREQSTRM_CTRL, reg);
+		xe_gt_mcr_multicast_write(gt, XE2_GAMREQSTRM_CTRL, reg);
 	}
 
 	xe_gt_mcr_multicast_write(gt, XEHPC_L3CLOS_MASK(3), 0x3);
@@ -133,9 +133,9 @@ static void xe_gt_disable_host_l2_vram(s
 	if (WARN_ON(err))
 		return;
 
-	reg = xe_mmio_read32(gt, XE2_GAMREQSTRM_CTRL);
+	reg = xe_gt_mcr_unicast_read_any(gt, XE2_GAMREQSTRM_CTRL);
 	reg &= ~CG_DIS_CNTLBUS;
-	xe_mmio_write32(gt, XE2_GAMREQSTRM_CTRL, reg);
+	xe_gt_mcr_multicast_write(gt, XE2_GAMREQSTRM_CTRL, reg);
 
 	xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
 }


