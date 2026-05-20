Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2389A3403F4;
	Wed, 20 May 2026 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297361; cv=none; b=dDyEqQrEauMJwMHN23YaPFJj7Q2TFIV3c4YekQPQo/0D+Cxm1T/apr6Kb9fg+fe8UGMLwzGA1Hs8VfLmDEUjN97HPUrLE+0YcivLzAOeikAcv4SCt4WZOvQVn8c/RtQiTVM0x21BYAsM0PJqRLX0QIYFVin2dszPF/9O6XLbIj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297361; c=relaxed/simple;
	bh=jzD2M0qG2KjQor3Vt04rdQ6qELumCa0pVGRx1MoOSrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgmRVN0rQ+eqY3rJBdjyLV9gfkqib+dLP6RUXyzfNFAScghMFd2HzePhLBskApqdE3vJWnSwjYC3/0mixfGNbA0wdZmDPHdzoScMuqEYUaUZJLGjWH7r1XhE2qXC4FJYBoXSdmLsKpr5Rj296auNwK1u8/8LPFKzMO4VguGHLdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+mU/U3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+mU/U3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C4D1F000E9;
	Wed, 20 May 2026 17:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297359;
	bh=OhTb8PmuAISOBYEuUTgrl0uaczXhkRc/aKJt60BQfP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+mU/U3T3QsU+TLht7zCsSmlv9mkPNkIGvri/+00CjlDPJkMMSdAJrIeZ4PHOt+LM
	 4ZeFRTR19Io2XncQBYRSHlUt3sxS4P4heGm7MrD5mMWDdNUbv/7mhnzLP4d/UquLNn
	 NnKzzmw/Y35l0Pux+EHCe9eLiZjiWNEHkrsv13Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 1137/1146] arm_mpam: Fix monitor instance selection when checking for hardware NRDY
Date: Wed, 20 May 2026 18:23:07 +0200
Message-ID: <20260520162213.986037717@linuxfoundation.org>
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

commit 1ef2a89584b7b788b2603590d886db076b2f24cc upstream.

In _mpam_ris_hw_probe_hw_nrdy() a new register value to select the first
monitor and relevant RIS is prepared in mon_sel. However, it is written to
the monitor value register, e.g. MSMON_CSU, rather than MSMON_CFG_MON_SEL.

As MSMON_CFG_MON_SEL is a 32 bit register update the type of mon_sel to
u32.  Write mon_sel to the intended register, MSMON_CFG_MON_SEL.

Fixes: 8c90dc68a5de ("arm_mpam: Probe the hardware features resctrl supports")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/resctrl/mpam_devices.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -635,7 +635,7 @@ static struct mpam_msc_ris *mpam_get_or_
 static bool _mpam_ris_hw_probe_hw_nrdy(struct mpam_msc_ris *ris, u32 mon_reg)
 {
 	u32 now;
-	u64 mon_sel;
+	u32 mon_sel;
 	bool can_set, can_clear;
 	struct mpam_msc *msc = ris->vmsc->msc;
 
@@ -644,7 +644,7 @@ static bool _mpam_ris_hw_probe_hw_nrdy(s
 
 	mon_sel = FIELD_PREP(MSMON_CFG_MON_SEL_MON_SEL, 0) |
 		  FIELD_PREP(MSMON_CFG_MON_SEL_RIS, ris->ris_idx);
-	_mpam_write_monsel_reg(msc, mon_reg, mon_sel);
+	mpam_write_monsel_reg(msc, CFG_MON_SEL, mon_sel);
 
 	_mpam_write_monsel_reg(msc, mon_reg, MSMON___NRDY);
 	now = _mpam_read_monsel_reg(msc, mon_reg);


