Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E073EE1DA;
	Wed, 20 May 2026 17:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297366; cv=none; b=RUbE9kW+FTOgh9bXPEKcMMsQlL/asj6AH2QvtXLDC4v4qZys0ZPmOLdoxQN/b3XZKiEg03nwVfDZFIEUYBCpc1O0fcX3Xnn02EVJMWWnJOv7+7+Rf4g/kUJlSUIlYQ+p2aol8bA2a7l8Rk764JL7qWe5DXkrzfZfa/ODZ4YawoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297366; c=relaxed/simple;
	bh=KNYWEwDDBtafrXnNbdXa5nmVFutOnfzInpwnLyeUj60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3pD65AuYHiYqs80KhhuEPC+uUb26gCM5MfgFuM/4FAegaMI/ngFz3udo2sJjOmcI3m42CkApkFWWeGYNHd0aHlzjt7u5+nLkEPlOc1ATxxwsH+DgJGaDyyWNv2AFeE5clIRWvC4YZ0jV2LTvieM2Q0E9UMnrAvAI8W7U7akL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ8dzNmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ8dzNmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872D31F000E9;
	Wed, 20 May 2026 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297365;
	bh=/ClRZtC5nXDBPDXUrXHb5KWlOJM551pyugGY9+CGS4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJ8dzNmK4B+nKnZ7wL6UkeYBprqzQg2aPOqa5URnbOY2qtdx5BLMR0tLzf+DckDCZ
	 nlibuRmLczLEf8/rILXTiqu0SCMzZR2B/L87AJbkC/Zb8zTaiChgHE+MFtKGPYd0Y7
	 +3oGClDH7JQSpVzWPNV7uKomdB5YyzINUPyuVAFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 1139/1146] arm_mpam: Improve check for whether or not NRDY is hardware managed
Date: Wed, 20 May 2026 18:23:09 +0200
Message-ID: <20260520162214.031540394@linuxfoundation.org>
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

commit ccad6001be5c38426ccf45790c411467ad3c03c6 upstream.

mpam_ris_hw_probe_csu_nrdy() sets and clears MSMON_CSU.NRDY and checks
whether it's configuration sticks. However, hardware isn't given a chance
to disagree. Based on rule LRTGP, in MPAM specification IHI0099 version
B.b, the hardware will set NRDY if it needs time to establish a count after
a configuration change.

Enable the monitor so that NRDY becomes relevant and change the
configuration after clearing NRDY to try and coax the hardware into setting
it.

Fixes: 8c90dc68a5de ("arm_mpam: Probe the hardware features resctrl supports")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/resctrl/mpam_devices.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -634,8 +634,7 @@ static struct mpam_msc_ris *mpam_get_or_
  */
 static bool mpam_ris_hw_probe_csu_nrdy(struct mpam_msc_ris *ris)
 {
-	u32 now;
-	u32 mon_sel;
+	u32 now, mon_sel, ctl_val;
 	bool can_set, can_clear;
 	struct mpam_msc *msc = ris->vmsc->msc;
 
@@ -646,11 +645,21 @@ static bool mpam_ris_hw_probe_csu_nrdy(s
 		  FIELD_PREP(MSMON_CFG_MON_SEL_RIS, ris->ris_idx);
 	mpam_write_monsel_reg(msc, CFG_MON_SEL, mon_sel);
 
+	/* Hardware might ignore nrdy if it's not enabled */
+	ctl_val = MSMON_CFG_CSU_CTL_TYPE_CSU;
+	ctl_val |= MSMON_CFG_x_CTL_MATCH_PARTID;
+	ctl_val |= MSMON_CFG_x_CTL_MATCH_PMG;
+	ctl_val |= MSMON_CFG_x_CTL_EN;
+	mpam_write_monsel_reg(msc, CFG_CSU_FLT, 0);
+	mpam_write_monsel_reg(msc, CFG_CSU_CTL, ctl_val);
+
 	_mpam_write_monsel_reg(msc, MSMON_CSU, MSMON___NRDY);
 	now = _mpam_read_monsel_reg(msc, MSMON_CSU);
 	can_set = now & MSMON___NRDY;
 
 	_mpam_write_monsel_reg(msc, MSMON_CSU, 0);
+	/* Configuration change to try and coax hardware into setting nrdy */
+	mpam_write_monsel_reg(msc, CFG_CSU_FLT, 0x1);
 	now = _mpam_read_monsel_reg(msc, MSMON_CSU);
 	can_clear = !(now & MSMON___NRDY);
 	mpam_mon_sel_unlock(msc);


