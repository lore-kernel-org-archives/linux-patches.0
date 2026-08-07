Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2BF3382C5;
	Fri,  7 Aug 2026 14:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114486; cv=none; b=dvPXK7QhlV+ZcxuhL/jSQJD2gNaXLOfbkHas7Pz1BGoAqrjcsZ+AwMRWp19Srf2B1UU4x6fASODaEpUgCn4xbbF2bXy9f6rgJPGbApNxD/5XWnTqd2qTCsKlsFeHngKChrQyZvNRBDIzLwDeG+3CrFFKAg9b9GnG6C5iUqmi/CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114486; c=relaxed/simple;
	bh=VLBdXVqRsPLHFII8bzkzsPzvmI0mrt88BWADLj1pPSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLeflO3m7WCArPCsAo6oTKG/KRFfMPNtkjFp0/txn4AldelLWcZgW7NphdH5Wl42HwduuCm1aHsd6lzeRWZCnILvLRpdi8/ru3bI5581v1Tn9Odr+OBV5QsNjHtxu71yWtN6x2x041sP58kyGsDpJYFDXvpMhKjjQzeDuXaEK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owcaSQa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owcaSQa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FB71F00A3A;
	Fri,  7 Aug 2026 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114484;
	bh=aXrKX2OLr53JsYPsJvKi80cdnIkTIrwK4ic+YF2R7kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owcaSQa/WnDU9sXas8fLErZqOfdADTPfgZFEZBkVzvbZlpa1V+xfu26dmoFPqE/3O
	 GQGKNdlBZ2NIaUsc4J1NOhjseSkR6YsjUPmz/d1WzK/KtYRcf2a8lSXTagQFyqc5Dj
	 F+6OWtMniBXVDtssPFLk0GE9ppcSmYorntuldhnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/337] drm/xe/rtp: Toggle deny bit to (de-)whitelist OA regs
Date: Fri,  7 Aug 2026 16:38:04 +0200
Message-ID: <20260807143424.628285287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit b422babd77fac2c96b92db484050e460899bddaf ]

Whitelist or de-whitelist OA registers by setting or resetting the 'deny'
bit in OA nonpriv registers and writing new register values to HW.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-7-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index a3a45f470faa1..39f577a0cac71 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -162,6 +162,21 @@ void xe_reg_whitelist_process_engine(struct xe_hw_engine *hwe)
 	whitelist_apply_to_hwe(hwe, &hwe->oa_whitelist, &hwe->reg_sr, first_oa_slot);
 }
 
+__maybe_unused static void __whitelist_oa_regs(struct xe_hw_engine *hwe, bool whitelist)
+{
+	struct xe_reg_sr_entry *entry;
+	unsigned long reg;
+
+	xa_for_each(&hwe->oa_sr.xa, reg, entry) {
+		if (whitelist)
+			entry->set_bits &= ~RING_FORCE_TO_NONPRIV_DENY;
+		else
+			entry->set_bits |= RING_FORCE_TO_NONPRIV_DENY;
+	}
+
+	xe_reg_sr_apply_mmio(&hwe->oa_sr, hwe->gt);
+}
+
 /**
  * xe_reg_whitelist_print_entry - print one whitelist entry
  * @p: DRM printer
-- 
2.53.0



