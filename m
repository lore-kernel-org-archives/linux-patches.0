Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0F334373;
	Thu, 27 Nov 2025 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255796; cv=none; b=lfpVY/BqyhJ/hW/EekEP51jO4Jh3tesqA64aLzxiWg5L+kyRTiFQYaGd0lI59nUFNKsaqVOJwUWjghepOn+8qNWy8znsjtYIUzCG1FxUERHj/uxSFPqdesu0nBnRiOdpLVyAHn5S5BqNpYR0gVAGOf+0RkKCtZpVOu/7cbJYu50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255796; c=relaxed/simple;
	bh=iZbbENgK17ekdpLVxt5UTfm2muXQjJ74OdOcvR8qAEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpy88Z+m6539dMLIHvgerQjtdTxfJZGPAY/pXHFszMYgThv4o7q2lDUv9EDcN0tSTpJXv1alOvvdCyRFUxUhYcLTMVTUIB+pTBUW06NlSWw4n5ZB1v9XihTa7eLQNW/eFJXTg4t2ldkInjyDjBbLE570oCOXE+iSUkiERV88rEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6OLkyX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6OLkyX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B29C4CEF8;
	Thu, 27 Nov 2025 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255796;
	bh=iZbbENgK17ekdpLVxt5UTfm2muXQjJ74OdOcvR8qAEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6OLkyX19VU0GZ3Wdok6uoWlFlyuEErcbfoKyl8YOJS91lylH6IZut49IeXBQ1FyF
	 HV4ant9Zd8Q3RD8h914d4jx4Wlx6IK0/HwQMOWAzVpHleNorVazY7xC7Bqnrgr3Ryl
	 PYbf/Y2rs5XFHZ+DJCtiG5Twb7Dr7Occ/Yyjcp4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 117/175] drm/xe/irq: Handle msix vector0 interrupt
Date: Thu, 27 Nov 2025 15:46:10 +0100
Message-ID: <20251127144047.233098441@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>

[ Upstream commit 5b38c22687d9287d85dd3bef2fa708bf62cf3895 ]

Current gu2host handler registered as MSI-X vector 0 and as per bspec for
a msix vector 0 interrupt, the driver must check the legacy registers
190008(TILE_INT_REG), 190060h (GT INTR Identity Reg 0) and other registers
mentioned in "Interrupt Service Routine Pseudocode" otherwise it will block
the next interrupts. To overcome this issue replacing guc2host handler
with legacy xe_irq_handler.

Fixes: da889070be7b2 ("drm/xe/irq: Separate MSI and MSI-X flows")
Bspec: 62357
Signed-off-by: Venkata Ramana Nayana <venkata.ramana.nayana@intel.com>
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20251107083141.2080189-1-venkata.ramana.nayana@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit c34a14bce7090862ebe5a64abe8d85df75e62737)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_irq.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index 5df5b8c2a3e4d..da22f083e86a7 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -843,22 +843,6 @@ static int xe_irq_msix_init(struct xe_device *xe)
 	return 0;
 }
 
-static irqreturn_t guc2host_irq_handler(int irq, void *arg)
-{
-	struct xe_device *xe = arg;
-	struct xe_tile *tile;
-	u8 id;
-
-	if (!atomic_read(&xe->irq.enabled))
-		return IRQ_NONE;
-
-	for_each_tile(tile, xe, id)
-		xe_guc_irq_handler(&tile->primary_gt->uc.guc,
-				   GUC_INTR_GUC2HOST);
-
-	return IRQ_HANDLED;
-}
-
 static irqreturn_t xe_irq_msix_default_hwe_handler(int irq, void *arg)
 {
 	unsigned int tile_id, gt_id;
@@ -975,7 +959,7 @@ int xe_irq_msix_request_irqs(struct xe_device *xe)
 	u16 msix;
 
 	msix = GUC2HOST_MSIX;
-	err = xe_irq_msix_request_irq(xe, guc2host_irq_handler, xe,
+	err = xe_irq_msix_request_irq(xe, xe_irq_handler(xe), xe,
 				      DRIVER_NAME "-guc2host", false, &msix);
 	if (err)
 		return err;
-- 
2.51.0



