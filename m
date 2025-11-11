Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8012505AA;
	Tue, 11 Nov 2025 01:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823092; cv=none; b=g7D4r9Xs44qRm2rGQdcOQ0e2ivoUEr5opTUzQy9HP4cCXJQ5VLZ1MbS9DTOQyAO8fvPaGecM1ocFMR7jlrEEwzB2xzQURJ6o+m+r80mld8I92pthjsyhC8JKqODQAXz9y4rF52ghtpWrC8hBcOdcs9Fe21xbdE/PMtD9Mp75GXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823092; c=relaxed/simple;
	bh=vytDEDe11inwnX6/nj/dHu19tARteHSaM+0daZ8DO08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYq1LSqhVgUPpsJWxuIyxkMxw4/Ti8WZb2+/5TWVwwPnYj4077AA2L8Al4gORu42d0yUGUF2QMLzxITtKphZg/6aOtHA7IJIKm0M+hWoPSpBSrT22y5yHDEPF/IUZ7+4ny1ZYAGj6f3NCS2lNgjVnrZvAeh3fiK4t7MZMd4bE6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQZKBMAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQZKBMAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF05C113D0;
	Tue, 11 Nov 2025 01:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823092;
	bh=vytDEDe11inwnX6/nj/dHu19tARteHSaM+0daZ8DO08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQZKBMAzNt5+5RNTmowOTnU3V2B7xu/FEkZl2dUjlMBwIWqo4W3/UVXHwaZmyfHGM
	 uFEVOAu1vvNEWdKNeqKzBGOb0cwHqaMFtAFuid8OTc3uSWkQVufcFHiaL0s8E64SxX
	 xmWf6OsJjl8aRVSxxqMDJlXaBiG9ToepjqfpJC0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sk Anirban <sk.anirban@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 229/849] drm/xe/ptl: Apply Wa_16026007364
Date: Tue, 11 Nov 2025 09:36:39 +0900
Message-ID: <20251111004541.978267129@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Sk Anirban <sk.anirban@intel.com>

[ Upstream commit d72779c29d82c6e371cea8b427550bd6923c2577 ]

As part of this WA GuC will save and restore value of two XE3_Media
control registers that were not included in the HW power context.

Signed-off-by: Sk Anirban <sk.anirban@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250716101622.3421480-2-sk.anirban@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h |  1 +
 drivers/gpu/drm/xe/xe_guc_ads.c       | 35 +++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_wa_oob.rules    |  1 +
 3 files changed, 37 insertions(+)

diff --git a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
index d7719d0e36ca7..45a321d0099f1 100644
--- a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
@@ -421,6 +421,7 @@ enum xe_guc_klv_ids {
 	GUC_WORKAROUND_KLV_ID_BACK_TO_BACK_RCS_ENGINE_RESET				= 0x9009,
 	GUC_WA_KLV_WAKE_POWER_DOMAINS_FOR_OUTBOUND_MMIO					= 0x900a,
 	GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH					= 0x900b,
+	GUC_WA_KLV_RESTORE_UNSAVED_MEDIA_CONTROL_REG					= 0x900c,
 };
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_guc_ads.c b/drivers/gpu/drm/xe/xe_guc_ads.c
index 131cfc56be00a..8ff8626227ae4 100644
--- a/drivers/gpu/drm/xe/xe_guc_ads.c
+++ b/drivers/gpu/drm/xe/xe_guc_ads.c
@@ -284,6 +284,35 @@ static size_t calculate_golden_lrc_size(struct xe_guc_ads *ads)
 	return total_size;
 }
 
+static void guc_waklv_enable_two_word(struct xe_guc_ads *ads,
+				      enum xe_guc_klv_ids klv_id,
+				      u32 value1,
+				      u32 value2,
+				      u32 *offset, u32 *remain)
+{
+	u32 size;
+	u32 klv_entry[] = {
+			/* 16:16 key/length */
+			FIELD_PREP(GUC_KLV_0_KEY, klv_id) |
+			FIELD_PREP(GUC_KLV_0_LEN, 2),
+			value1,
+			value2,
+			/* 2 dword data */
+	};
+
+	size = sizeof(klv_entry);
+
+	if (*remain < size) {
+		drm_warn(&ads_to_xe(ads)->drm,
+			 "w/a klv buffer too small to add klv id %d\n", klv_id);
+	} else {
+		xe_map_memcpy_to(ads_to_xe(ads), ads_to_map(ads), *offset,
+				 klv_entry, size);
+		*offset += size;
+		*remain -= size;
+	}
+}
+
 static void guc_waklv_enable_one_word(struct xe_guc_ads *ads,
 				      enum xe_guc_klv_ids klv_id,
 				      u32 value,
@@ -381,6 +410,12 @@ static void guc_waklv_init(struct xe_guc_ads *ads)
 		guc_waklv_enable_simple(ads,
 					GUC_WA_KLV_RESET_BB_STACK_PTR_ON_VF_SWITCH,
 					&offset, &remain);
+	if (GUC_FIRMWARE_VER(&gt->uc.guc) >= MAKE_GUC_VER(70, 47, 0) && XE_WA(gt, 16026007364))
+		guc_waklv_enable_two_word(ads,
+					  GUC_WA_KLV_RESTORE_UNSAVED_MEDIA_CONTROL_REG,
+					  0x0,
+					  0xF,
+					  &offset, &remain);
 
 	size = guc_ads_waklv_size(ads) - remain;
 	if (!size)
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 710f4423726c9..48c7a42e2fcad 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -73,3 +73,4 @@ no_media_l3	MEDIA_VERSION(3000)
 14022085890	GRAPHICS_VERSION(2001)
 
 15015404425_disable	PLATFORM(PANTHERLAKE), MEDIA_STEP(B0, FOREVER)
+16026007364    MEDIA_VERSION(3000)
-- 
2.51.0



