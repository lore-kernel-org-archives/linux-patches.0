Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C63403F4;
	Wed, 20 May 2026 17:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297363; cv=none; b=vDOupNluHflfiQqzpdPayb/GxbGjE5ilKd+fHlDDKmiIn8sOGHIILaAKExQexWMHFvsXDxOKLhmZ/yyth0rvvgkBYGmLVdy6SbJBP4Roeg1TU1kH7s4nbS1tJq6q08B7F3OyOSlc2HcvwzpUfoR8L2A3Ds6N3SqBgAXfxheS0OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297363; c=relaxed/simple;
	bh=G4wAl3WnJsZr401/KP2eKV0YuTU5CUbUqHxiRw5Opvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQjGz+p5R+nXWXTImUHrUwCIAHhiU0a9l4/Kw3uVN+eirUMKMJSJ0xiMj7tfaFz3IEWiSDN1aSEz343/BsIccaVQgKVF+zd262LmuLma0QlqKZDj3RXRqlc6/AiJrzOk2KEwCMA7iQnUobf7BNgO7/vDR2zCp+UAzAXRKhLjAEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nPFWexVv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nPFWexVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E466C1F00893;
	Wed, 20 May 2026 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297362;
	bh=fUMk6SAn0I47liXss3PZ+mxajIOBfv9EdsNRldcDx1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPFWexVvOC+ANdb0SxJI38fh6SL5WAwiqkWtjm0+tMjolA11cDBI3gpq06iOy4KNQ
	 2uVPBD04WjcRTrrgAwdS9K0P0TGkH53CTy79eTAXSk8pk9ByPbg+kVpNwOfQE+4Yjy
	 8Znx/2bGBPuYYNRTQIv2iUm9xEfUo3vEJaCQxd3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 1138/1146] arm_mpam: Pretend that NRDY is always hardware managed
Date: Wed, 20 May 2026 18:23:08 +0200
Message-ID: <20260520162214.008487833@linuxfoundation.org>
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

commit 4387970bbd84fd14e0c49c3089c5061ccd86b98a upstream.

Rule ZTXDS of the MPAM specification, IHI009 version B.b, states: "If a
monitor does not support automatic updates of NRDY, software can use that
bit for any purpose."

As software is not reliably informed whether or not the monitor supports
automatic updates of NRDY always assume that hardware may manage NRDY but
don't rely on it. When NRDY is truly untouched by hardware then, as it is
written to 0 on configuration, it will always read 0.

At probe it's checked if MSMON_CSU.NRDY and MSMON_MBWU.NRDY are hardware
managed but not MSMON_MBWU_L.NDRY. Specialize the checking for hardware
managed NRDY to CSU counters as this is the only case where hardware
management makes sense. Continue to inform the user if MSMON_CSU.NRDY
appears to be hardware managed but the firmware doesn't provide the
associated time limit for the automatic clearing of NRDY. Remove the NRDY
feature flags as they are now unused.

Fixes: 8c90dc68a5de ("arm_mpam: Probe the hardware features resctrl supports")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/resctrl/mpam_devices.c  |   53 ++++++++++++----------------------------
 drivers/resctrl/mpam_internal.h |    2 -
 2 files changed, 17 insertions(+), 38 deletions(-)

--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -632,7 +632,7 @@ static struct mpam_msc_ris *mpam_get_or_
  * Try and see what values stick in this bit. If we can write either value,
  * its probably not implemented by hardware.
  */
-static bool _mpam_ris_hw_probe_hw_nrdy(struct mpam_msc_ris *ris, u32 mon_reg)
+static bool mpam_ris_hw_probe_csu_nrdy(struct mpam_msc_ris *ris)
 {
 	u32 now;
 	u32 mon_sel;
@@ -646,21 +646,18 @@ static bool _mpam_ris_hw_probe_hw_nrdy(s
 		  FIELD_PREP(MSMON_CFG_MON_SEL_RIS, ris->ris_idx);
 	mpam_write_monsel_reg(msc, CFG_MON_SEL, mon_sel);
 
-	_mpam_write_monsel_reg(msc, mon_reg, MSMON___NRDY);
-	now = _mpam_read_monsel_reg(msc, mon_reg);
+	_mpam_write_monsel_reg(msc, MSMON_CSU, MSMON___NRDY);
+	now = _mpam_read_monsel_reg(msc, MSMON_CSU);
 	can_set = now & MSMON___NRDY;
 
-	_mpam_write_monsel_reg(msc, mon_reg, 0);
-	now = _mpam_read_monsel_reg(msc, mon_reg);
+	_mpam_write_monsel_reg(msc, MSMON_CSU, 0);
+	now = _mpam_read_monsel_reg(msc, MSMON_CSU);
 	can_clear = !(now & MSMON___NRDY);
 	mpam_mon_sel_unlock(msc);
 
 	return (!can_set || !can_clear);
 }
 
-#define mpam_ris_hw_probe_hw_nrdy(_ris, _mon_reg)			\
-	_mpam_ris_hw_probe_hw_nrdy(_ris, MSMON_##_mon_reg)
-
 static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
 {
 	int err;
@@ -770,20 +767,18 @@ static void mpam_ris_hw_probe(struct mpa
 					mpam_set_feature(mpam_feat_msmon_csu_xcl, props);
 
 				/* Is NRDY hardware managed? */
-				hw_managed = mpam_ris_hw_probe_hw_nrdy(ris, CSU);
-				if (hw_managed)
-					mpam_set_feature(mpam_feat_msmon_csu_hw_nrdy, props);
-			}
+				hw_managed = mpam_ris_hw_probe_csu_nrdy(ris);
 
-			/*
-			 * Accept the missing firmware property if NRDY appears
-			 * un-implemented.
-			 */
-			if (err && mpam_has_feature(mpam_feat_msmon_csu_hw_nrdy, props))
-				dev_err_once(dev, "Counters are not usable because not-ready timeout was not provided by firmware.");
+				/*
+				 * Accept the missing firmware property if NRDY appears
+				 * un-implemented.
+				 */
+				if (err && hw_managed)
+					dev_err_once(dev, "Counters are not usable because not-ready timeout was not provided by firmware.");
+			}
 		}
 		if (FIELD_GET(MPAMF_MSMON_IDR_MSMON_MBWU, msmon_features)) {
-			bool has_long, hw_managed;
+			bool has_long;
 			u32 mbwumon_idr = mpam_read_partsel_reg(msc, MBWUMON_IDR);
 
 			props->num_mbwu_mon = FIELD_GET(MPAMF_MBWUMON_IDR_NUM_MON, mbwumon_idr);
@@ -802,16 +797,6 @@ static void mpam_ris_hw_probe(struct mpa
 				} else {
 					mpam_set_feature(mpam_feat_msmon_mbwu_31counter, props);
 				}
-
-				/* Is NRDY hardware managed? */
-				hw_managed = mpam_ris_hw_probe_hw_nrdy(ris, MBWU);
-				if (hw_managed)
-					mpam_set_feature(mpam_feat_msmon_mbwu_hw_nrdy, props);
-
-				/*
-				 * Don't warn about any missing firmware property for
-				 * MBWU NRDY - it doesn't make any sense!
-				 */
 			}
 		}
 	}
@@ -1078,7 +1063,6 @@ static void __ris_msmon_read(void *arg)
 	bool reset_on_next_read = false;
 	struct mpam_msc_ris *ris = m->ris;
 	struct msmon_mbwu_state *mbwu_state;
-	struct mpam_props *rprops = &ris->props;
 	struct mpam_msc *msc = m->ris->vmsc->msc;
 	u32 mon_sel, ctl_val, flt_val, cur_ctl, cur_flt;
 
@@ -1134,8 +1118,7 @@ static void __ris_msmon_read(void *arg)
 	switch (m->type) {
 	case mpam_feat_msmon_csu:
 		now = mpam_read_monsel_reg(msc, CSU);
-		if (mpam_has_feature(mpam_feat_msmon_csu_hw_nrdy, rprops))
-			nrdy = now & MSMON___NRDY;
+		nrdy = now & MSMON___NRDY;
 		now = FIELD_GET(MSMON___VALUE, now);
 		break;
 	case mpam_feat_msmon_mbwu_31counter:
@@ -1143,8 +1126,7 @@ static void __ris_msmon_read(void *arg)
 	case mpam_feat_msmon_mbwu_63counter:
 		if (m->type != mpam_feat_msmon_mbwu_31counter) {
 			now = mpam_msc_read_mbwu_l(msc);
-			if (mpam_has_feature(mpam_feat_msmon_mbwu_hw_nrdy, rprops))
-				nrdy = now & MSMON___L_NRDY;
+			nrdy = now & MSMON___L_NRDY;
 
 			if (m->type == mpam_feat_msmon_mbwu_63counter)
 				now = FIELD_GET(MSMON___LWD_VALUE, now);
@@ -1152,8 +1134,7 @@ static void __ris_msmon_read(void *arg)
 				now = FIELD_GET(MSMON___L_VALUE, now);
 		} else {
 			now = mpam_read_monsel_reg(msc, MBWU);
-			if (mpam_has_feature(mpam_feat_msmon_mbwu_hw_nrdy, rprops))
-				nrdy = now & MSMON___NRDY;
+			nrdy = now & MSMON___NRDY;
 			now = FIELD_GET(MSMON___VALUE, now);
 		}
 
--- a/drivers/resctrl/mpam_internal.h
+++ b/drivers/resctrl/mpam_internal.h
@@ -167,14 +167,12 @@ enum mpam_device_features {
 	mpam_feat_msmon_csu,
 	mpam_feat_msmon_csu_capture,
 	mpam_feat_msmon_csu_xcl,
-	mpam_feat_msmon_csu_hw_nrdy,
 	mpam_feat_msmon_mbwu,
 	mpam_feat_msmon_mbwu_31counter,
 	mpam_feat_msmon_mbwu_44counter,
 	mpam_feat_msmon_mbwu_63counter,
 	mpam_feat_msmon_mbwu_capture,
 	mpam_feat_msmon_mbwu_rwbw,
-	mpam_feat_msmon_mbwu_hw_nrdy,
 	mpam_feat_partid_nrw,
 	MPAM_FEATURE_LAST
 };


