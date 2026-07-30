Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF22435AB0;
	Thu, 30 Jul 2026 14:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421734; cv=none; b=KKlVFydFJaz8CuI9UXU1vjQLPwyxx9nZDclimBXrBARMb3jbN/yXguxjdqjXCLtQT0rTT5es+b3UZRNGlKJObZnja8HZccbcHFo9eYpRWDaGAfJSeh4DFaxc6KNCR19f2CBgpIKoWyV6BnE+DvKjsOiEOLtKZZ1eJvOaM6jqNDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421734; c=relaxed/simple;
	bh=OlLILUR5RQMOE2hbYujekc6QLEf6TMuA63eD84j+qcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/KYNpaDspyiWRX01ypQjfuNL9FmgPelYPstXFW382ps8dum0iUJ66oGz3tmOR7GXewCV3upgr3PiF9bEvzcd2a1ww5qcJW6fZbSwGyPQDhIvmIEodAfegfTKBLVg/21np19BBMzkgFvK5+Q2hZvrcg/31JNOoKnwgYhyyrOlvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzQj5UYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzQj5UYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C5D1F000E9;
	Thu, 30 Jul 2026 14:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421733;
	bh=Yb9J8L8zQBjwNoPBpoQLSOmlMZAH2IlQrNQQrZcFnwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzQj5UYYOFilQ3rQCKgQMfzwnvRp8afEwhC0vQghup57fq8ogsj2ltRUNoLBXUeHx
	 ZZNuCokzpPWCX0WRad9pqQOZanXTZxQgl9RnNaPP/9RwtoJoWgZrNzj88DaCz07E1n
	 BGHR9tllqzOZZ6B6wYG685m8UBn0ciau5lZ/TGk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 202/744] arm_mpam: Fix software reset values of MPAMCFG_PRI
Date: Thu, 30 Jul 2026 16:07:55 +0200
Message-ID: <20260730141448.573737005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 9469764292e0d6825c9bf51d75682e3a623b9b6b ]

Priority partitioning is not supported other than to set the per-PARTID
defaults in MPAMCFG_PRI, INTPRI and DSPRI, to the highest priority. When 0
is the lowest priority, all ones is the highest priority. However, these
values are calculated with an extra higher bit set.

Luckily, there is still no chance of setting functional bits incorrectly.
When the priority widths are maximal, this is ensured as the fields have
width 16 and a u16 holds the value for each field. When the widths are
smaller, the higher order bits beyond the advertised widths,
MPAMF_PRI_IDR.DSPRI_WD and MPAMF_PRI_IDR.INTPRI_WD, in the priority fields
INTPRI and DSPRI are not used to calculate the priority.  It is not
specified whether these higher order bits are RAZ/WI or Res0 and so it is
desirable not to set them to avoid the chance of misleading reads.

Correct the priority reset values.

Fixes: 880df85d8673 ("arm_mpam: Probe and reset the rest of the features")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 988fc291241d23..54e9da3158a89d 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1535,12 +1535,9 @@ static u16 mpam_wa_t241_calc_min_from_max(struct mpam_props *props,
 static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 				      struct mpam_config *cfg)
 {
-	u32 pri_val = 0;
 	u16 cmax = MPAMCFG_CMAX_CMAX;
 	struct mpam_msc *msc = ris->vmsc->msc;
 	struct mpam_props *rprops = &ris->props;
-	u16 dspri = GENMASK(rprops->dspri_wd, 0);
-	u16 intpri = GENMASK(rprops->intpri_wd, 0);
 
 	mutex_lock(&msc->part_sel_lock);
 	__mpam_part_sel(ris->ris_idx, partid, msc);
@@ -1605,16 +1602,25 @@ static void mpam_reprogram_ris_partid(struct mpam_msc_ris *ris, u16 partid,
 
 	if (mpam_has_feature(mpam_feat_intpri_part, rprops) ||
 	    mpam_has_feature(mpam_feat_dspri_part, rprops)) {
-		/* aces high? */
-		if (!mpam_has_feature(mpam_feat_intpri_part_0_low, rprops))
-			intpri = 0;
-		if (!mpam_has_feature(mpam_feat_dspri_part_0_low, rprops))
-			dspri = 0;
+		u32 pri_val = 0;
+
+		if (mpam_has_feature(mpam_feat_intpri_part, rprops)) {
+			u16 intpri = GENMASK(rprops->intpri_wd - 1, 0);
+
+			/* aces high? */
+			if (!mpam_has_feature(mpam_feat_intpri_part_0_low, rprops))
+				intpri = 0;
 
-		if (mpam_has_feature(mpam_feat_intpri_part, rprops))
 			pri_val |= FIELD_PREP(MPAMCFG_PRI_INTPRI, intpri);
-		if (mpam_has_feature(mpam_feat_dspri_part, rprops))
+		}
+		if (mpam_has_feature(mpam_feat_dspri_part, rprops)) {
+			u16 dspri = GENMASK(rprops->dspri_wd - 1, 0);
+
+			if (!mpam_has_feature(mpam_feat_dspri_part_0_low, rprops))
+				dspri = 0;
+
 			pri_val |= FIELD_PREP(MPAMCFG_PRI_DSPRI, dspri);
+		}
 
 		mpam_write_partsel_reg(msc, PRI, pri_val);
 	}
-- 
2.53.0



