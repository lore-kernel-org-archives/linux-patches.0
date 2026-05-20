Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156673C3458;
	Wed, 20 May 2026 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294691; cv=none; b=Qlvz5d1Cu7Y7N6/MSqbS9Pv2XdrrnUCVjypjnB92ZjBSYdlViM0wSPSsY4SwyeoIgx7+VU7TGejsXVQyB0dJUz2EO8a2gZ8P7sVZi38aKQyBSCax360mVaWjTzXLFlgZR13wW8O7aG/3gPMaAGv86pGK2ZuqDnmn/VFFq9EKl1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294691; c=relaxed/simple;
	bh=94SsAv1wgWq4+4UedkjYmkyUvkYRsPzrY2C6yX07FuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gu+uDhswfpyIrXszyHmqZtx2pIQY2QNYWCd35N2FKWGvw2tZfZrtPUTlLjB03hWQrMxWk4NfU/tdnv2gS/Qi1p+Uhs63cywN1/A09oJrNQsTnw0V0G8+6xWq9jJ1t66vXQcqClUSgyBh4S2dJzJzAJKeJprShr0K6gtsOmVDWQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i65jBWqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i65jBWqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8293F1F000E9;
	Wed, 20 May 2026 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294690;
	bh=QI/gtCyQQyBde1GztBxFnc3WKD5UcPreJgy2PxgtgP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i65jBWqNJ0hd5ObcHHjmL0Ghj01qVbutZ5GGlGhMT47Uyign2n/4o7Hru5V8M36it
	 PFTeeX8Z5/ReuwCn5qYIMsqrWFAKqX6lOQuzjOLcQ6/RTLW2+3ef+GM7pXG4aM0Fev
	 N7HxJ/l4Bzydfh9LFevg5e3C9czWYqGwcAosR+4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Jesse Chick <jessechick@os.amperecomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0136/1146] arm_mpam: Reset when feature configuration bit unset
Date: Wed, 20 May 2026 18:06:26 +0200
Message-ID: <20260520162151.397665962@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit a1cb6577f575ba5ec2583caf4f791a86754dbf69 ]

To indicate that the configuration, of the controls used by resctrl, in a
RIS need resetting to driver defaults the reset flags in mpam_config are
set. However, these flags are only ever set temporarily at RIS scope in
mpam_reset_ris() and hence mpam_cpu_online() will never reset these
controls to default. As the hardware reset is unknown this leads to unknown
configuration when the control values haven't been configured away from the
defaults.

Use the policy that an unset feature configuration bit means reset. In this
way the mpam_config in the component can encode that it should be in reset
state and mpam_reprogram_msc() will reset controls as needed.

Fixes: 09b89d2a72f3 ("arm_mpam: Allow configuration to be applied and restored during cpu online")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Jesse Chick <jessechick@os.amperecomputing.com>
[ morse: Removed unused reset flags from config structure ]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c  | 40 ++++++++++-----------------------
 drivers/resctrl/mpam_internal.h |  4 ----
 2 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 3c7e69de753ef..740d99dc847eb 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1364,17 +1364,15 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 		__mpam_intpart_sel(ris->ris_idx, partid, msc);
 	}
 
-	if (mpam_has_feature(mpam_feat_cpor_part, rprops) &&
-	    mpam_has_feature(mpam_feat_cpor_part, cfg)) {
-		if (cfg->reset_cpbm)
-			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
-		else
+	if (mpam_has_feature(mpam_feat_cpor_part, rprops)) {
+		if (mpam_has_feature(mpam_feat_cpor_part, cfg))
 			mpam_write_partsel_reg(msc, CPBM, cfg->cpbm);
+		else
+			mpam_reset_msc_bitmap(msc, MPAMCFG_CPBM, rprops->cpbm_wd);
 	}
 
-	if (mpam_has_feature(mpam_feat_mbw_part, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_part, cfg)) {
-		if (cfg->reset_mbw_pbm)
+	if (mpam_has_feature(mpam_feat_mbw_part, rprops)) {
+		if (mpam_has_feature(mpam_feat_mbw_part, cfg))
 			mpam_reset_msc_bitmap(msc, MPAMCFG_MBW_PBM, rprops->mbw_pbm_bits);
 		else
 			mpam_write_partsel_reg(msc, MBW_PBM, cfg->mbw_pbm);
@@ -1384,16 +1382,14 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 	    mpam_has_feature(mpam_feat_mbw_min, cfg))
 		mpam_write_partsel_reg(msc, MBW_MIN, 0);
 
-	if (mpam_has_feature(mpam_feat_mbw_max, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_max, cfg)) {
-		if (cfg->reset_mbw_max)
-			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
-		else
+	if (mpam_has_feature(mpam_feat_mbw_max, rprops)) {
+		if (mpam_has_feature(mpam_feat_mbw_max, cfg))
 			mpam_write_partsel_reg(msc, MBW_MAX, cfg->mbw_max);
+		else
+			mpam_write_partsel_reg(msc, MBW_MAX, MPAMCFG_MBW_MAX_MAX);
 	}
 
-	if (mpam_has_feature(mpam_feat_mbw_prop, rprops) &&
-	    mpam_has_feature(mpam_feat_mbw_prop, cfg))
+	if (mpam_has_feature(mpam_feat_mbw_prop, rprops))
 		mpam_write_partsel_reg(msc, MBW_PROP, 0);
 
 	if (mpam_has_feature(mpam_feat_cmax_cmax, rprops))
@@ -1493,16 +1489,6 @@ static int mpam_save_mbwu_state(void *arg)
 	return 0;
 }
 
-static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
-{
-	*reset_cfg = (struct mpam_config) {
-		.reset_cpbm = true,
-		.reset_mbw_pbm = true,
-		.reset_mbw_max = true,
-	};
-	bitmap_fill(reset_cfg->features, MPAM_FEATURE_LAST);
-}
-
 /*
  * Called via smp_call_on_cpu() to prevent migration, while still being
  * pre-emptible. Caller must hold mpam_srcu.
@@ -1510,14 +1496,12 @@ static void mpam_init_reset_cfg(struct mpam_config *reset_cfg)
 static int mpam_reset_ris(void *arg)
 {
 	u16 partid, partid_max;
-	struct mpam_config reset_cfg;
+	struct mpam_config reset_cfg = {};
 	struct mpam_msc_ris *ris = arg;
 
 	if (ris->in_reset_state)
 		return 0;
 
-	mpam_init_reset_cfg(&reset_cfg);
-
 	spin_lock(&partid_max_lock);
 	partid_max = mpam_partid_max;
 	spin_unlock(&partid_max_lock);
diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
index e8971842b124f..7af762c98efc4 100644
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -266,10 +266,6 @@ struct mpam_config {
 	u32	mbw_pbm;
 	u16	mbw_max;
 
-	bool	reset_cpbm;
-	bool	reset_mbw_pbm;
-	bool	reset_mbw_max;
-
 	struct mpam_garbage	garbage;
 };
 
-- 
2.53.0



