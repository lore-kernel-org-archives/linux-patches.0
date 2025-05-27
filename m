Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF321FB3;
	Tue, 27 May 2025 17:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367958; cv=none; b=knuLaOi8GY1ZWUNME4QXojQSS2SbuEQGwwVUzkZdTgEDGCpCwO8FBXSOCyF75msGiMAlZckgTOzfjuJx08XXGGHEJ/n9mVLMLhg/E9EpY5kfWxJCvQdu+ONknWtXuj+EgbHhg077NmPnCWnGuNKnKD2l31zbTc3s7W6xJ4I/D9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367958; c=relaxed/simple;
	bh=Ukd3+8aRRhS8NDW279GGksvSzxgUBXbFxJj/sqIvoBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP6LIkbQjeytHuUlIqguxtlA47nfWf2UA9FaQoxlpb7w70KcKEs3BFuLTTJH1K3/Or1Mc70OT6qkRA5Q+idJDmHlrdpbMzRDMtiakJeTySHO4kLTCp62HNIJ/f/K/etPjsij4fJbu43BRxyggV9H4RdTMZmmUryfMn1VznrIlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd+iedZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd+iedZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB289C4CEE9;
	Tue, 27 May 2025 17:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367958;
	bh=Ukd3+8aRRhS8NDW279GGksvSzxgUBXbFxJj/sqIvoBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vd+iedZybTawFvSK+i6Qlm6i8gO5neKgb2hO+ahShZuQP3apqZm0uv0Jsfs6jsPrK
	 98zMPYHwlmcc3IT+9BChE67BmhY4mI1zqznjbOU0VJfHj1gluF7FUuyjfhohEP177d
	 t1+6/1wQcgi0hUAvLqFpALSLsh8A9f+veOJVgl2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 554/783] drm/xe: Fix PVC RPe and RPa information
Date: Tue, 27 May 2025 18:25:51 +0200
Message-ID: <20250527162535.708369627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@intel.com>

[ Upstream commit 8a734b9359cfa1bdb805f5ca23e20bd99dd18a0a ]

A simple lazy buggy copy and paste of the PVC comment has brought
the attention to the incorrect masks of the PVC register for RPa
and RPe. So, let's fix them all.

Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250109195219.658557-1-rodrigo.vivi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index f382f5d53ca8b..2276d85926fcb 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -371,16 +371,17 @@ static void tgl_update_rpa_value(struct xe_guc_pc *pc)
 	u32 reg;
 
 	/*
-	 * For PVC we still need to use fused RP1 as the approximation for RPe
-	 * For other platforms than PVC we get the resolved RPe directly from
+	 * For PVC we still need to use fused RP0 as the approximation for RPa
+	 * For other platforms than PVC we get the resolved RPa directly from
 	 * PCODE at a different register
 	 */
-	if (xe->info.platform == XE_PVC)
+	if (xe->info.platform == XE_PVC) {
 		reg = xe_mmio_read32(&gt->mmio, PVC_RP_STATE_CAP);
-	else
+		pc->rpa_freq = REG_FIELD_GET(RP0_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+	} else {
 		reg = xe_mmio_read32(&gt->mmio, FREQ_INFO_REC);
-
-	pc->rpa_freq = REG_FIELD_GET(RPA_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+		pc->rpa_freq = REG_FIELD_GET(RPA_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+	}
 }
 
 static void tgl_update_rpe_value(struct xe_guc_pc *pc)
@@ -394,12 +395,13 @@ static void tgl_update_rpe_value(struct xe_guc_pc *pc)
 	 * For other platforms than PVC we get the resolved RPe directly from
 	 * PCODE at a different register
 	 */
-	if (xe->info.platform == XE_PVC)
+	if (xe->info.platform == XE_PVC) {
 		reg = xe_mmio_read32(&gt->mmio, PVC_RP_STATE_CAP);
-	else
+		pc->rpe_freq = REG_FIELD_GET(RP1_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+	} else {
 		reg = xe_mmio_read32(&gt->mmio, FREQ_INFO_REC);
-
-	pc->rpe_freq = REG_FIELD_GET(RPE_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+		pc->rpe_freq = REG_FIELD_GET(RPE_MASK, reg) * GT_FREQUENCY_MULTIPLIER;
+	}
 }
 
 static void pc_update_rp_values(struct xe_guc_pc *pc)
-- 
2.39.5



