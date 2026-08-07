Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D01546EC60;
	Fri,  7 Aug 2026 15:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117741; cv=none; b=MW2J5kpnSCfqdrjmGHP0zfoVxc1mGqEOEXYTTdhh8VwM4+oZ3sFXz6HcINK76GcBTRfDn5A0vEtoVj+0/hiCEY0PxB6qVVNKulv64obzVTrjGQlHRbm+Y/lBDZoy+e1ilEMfR4s1vmiO9x0ACS+NYdvPSeYqfpvmjis85GQvnWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117741; c=relaxed/simple;
	bh=gCFAeSDfHDqD5dSabDl5UzlltmQ0qPCXC/To2e/5QhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/7F9zA9L7SGcZqAsjToycIbqjxbgREB4MdqiWdCfsje9CdsEJLLE7wLyezXGtMnCSopqTGRl54niwrhnj7DTm8ZFR5RLBFVDkr8tr4TtFslPSigwG/Z9VVoM30/oDlYMQMYuazzi/RWwQqINXJhepCMFWo8eQ4N0u8riQQFCr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZA5qrjiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZA5qrjiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AD01F000E9;
	Fri,  7 Aug 2026 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117740;
	bh=qtQbccKxpgMJwoWoKt339W1ZmA1Vhr5ecKngfKVHMdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZA5qrjiAowvkRhX58HFDfDRyYzfHuRHFp8UlOnezWU0peXngX02YJAR1bhllOF2ql
	 SME4GipDnsG7d4n5MFXz0iiXG+DRgYDDPckTYDEBYVKZXur0ZCpPollApech5TSu/v
	 lYlD2QzsfSvXqYVvXS2DZWVclidNaMWJnnW1SvMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 425/438] drm/xe/rtp: Ensure locking/ref counting for OA whitelists
Date: Fri,  7 Aug 2026 16:40:21 +0200
Message-ID: <20260807143437.026571600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit ef78e2a22f72c892fd6663f0760abd208d49a3e2 ]

Since multiple OA streams might be open in parallel on a gt, ensure that
proper locking is in place. Also ensure that OA registers are whitelisted
when the first OA stream is open and de-whitelisted after the last OA
stream is closed.

Fixes: 828a8eaf37c3 ("drm/xe/oa: Add MMIO trigger support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20260615224227.34880-10-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa_types.h      | 3 +++
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_oa_types.h b/drivers/gpu/drm/xe/xe_oa_types.h
index b03ffd5134834..c0ddfae755b6a 100644
--- a/drivers/gpu/drm/xe/xe_oa_types.h
+++ b/drivers/gpu/drm/xe/xe_oa_types.h
@@ -126,6 +126,9 @@ struct xe_oa_gt {
 
 	/** @oa_unit: array of oa_units */
 	struct xe_oa_unit *oa_unit;
+
+	/** @whitelist_count: number of open streams for which oa registers are whitelisted */
+	u32 whitelist_count;
 };
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 2ecf273c5f401..dad47988bdf6d 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -242,6 +242,10 @@ void xe_reg_whitelist_oa_regs(struct xe_gt *gt)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 
+	lockdep_assert_held(&gt->oa.gt_lock);
+	if (gt->oa.whitelist_count++)
+		return;
+
 	for_each_hw_engine(hwe, gt, id)
 		__whitelist_oa_regs(hwe, true);
 }
@@ -257,6 +261,11 @@ void xe_reg_dewhitelist_oa_regs(struct xe_gt *gt)
 	struct xe_hw_engine *hwe;
 	enum xe_hw_engine_id id;
 
+	lockdep_assert_held(&gt->oa.gt_lock);
+	xe_assert(gt_to_xe(gt), gt->oa.whitelist_count);
+	if (--gt->oa.whitelist_count)
+		return;
+
 	for_each_hw_engine(hwe, gt, id)
 		__whitelist_oa_regs(hwe, false);
 }
-- 
2.53.0



