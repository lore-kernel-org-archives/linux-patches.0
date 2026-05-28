Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424AA3164B7;
	Thu, 28 May 2026 20:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998977; cv=none; b=W/ehpwOZOceLPigYQCu91NeWCATl8I4t8OfeBJoqhCTl5uIMokqfhhSpUSvpMgZN3GJnSW+x0q9wwTAmKcjyIN1A+60rqRGVOcXHTTBLUklImqt669Xrz+nUWp/JchqHcbiVLcDkbZkKn1DJzHdxPv50V2jCAkFpsKDN4VZqVYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998977; c=relaxed/simple;
	bh=Osl9jKsOO6FAb/8vgSED4lX6gzRdwbF/QhykGw33csk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKOvaN/pKffe+9H3qJN8Ts6T/XFW3tOy/H6bdR1vjFV0QXxOD124FnT4cJp7cehM9Vx9X37cX+hCLzH7YQr8laQM4ICDVWcDmPREHKjn9q66xKIpxy2IEN8Wl4u20QgB/9BdNwTs8Pu8Z5u6Kt/nYxkmIKTsQYg6hFbCweZR2D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sls+fXZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sls+fXZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8AC1F000E9;
	Thu, 28 May 2026 20:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998976;
	bh=A/1c/uNF2mhb8NTxyJ0uOduqpjdR73fMWXXPITr4OvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sls+fXZvEiQXFdf4vsnG1nsPreIcUSKJrgqmHdlAD0Pp+Bh7UKcwgi/2ZqsBan/qB
	 R5LYZmAj7fOg9Fj9aMDFdYC81Ji5XfhSNIS02f+urjLZq9YpGtY/5klDW1ua0DokKu
	 7i4hvId8ZZdy99ICfXPtKQpM/1x0BOsNYtQ1NPRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 365/461] drm/xe/tuning: Apply windower hardware filtering setting on Xe3 and Xe3p
Date: Thu, 28 May 2026 21:48:14 +0200
Message-ID: <20260528194658.004220616@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 8ccf5f6b2295164962bbee5b0770f4366fd9bee2 ]

A recent bspec tuning guide update asks us to program
COMMON_SLICE_CHICKEN4[5] on Xe3 and Xe3p platforms.  Add this setting to
our LRC tuning RTP table so that the setting will become part of each
context's LRC.

Bspec: 72161, 55902
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260224235055.3038710-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Stable-dep-of: 6df5678b6a94 ("drm/xe: Define and use MCR version of COMMON_SLICE_CHICKEN4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h | 1 +
 drivers/gpu/drm/xe/xe_tuning.c       | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/regs/xe_gt_regs.h b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
index dd06487c87edc..e9a82029f5066 100644
--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -170,6 +170,7 @@
 #define COMMON_SLICE_CHICKEN4			XE_REG(0x7300, XE_REG_OPTION_MASKED)
 #define   SBE_PUSH_CONSTANT_BEHIND_FIX_ENABLE	REG_BIT(12)
 #define   DISABLE_TDC_LOAD_BALANCING_CALC	REG_BIT(6)
+#define   HW_FILTERING				REG_BIT(5)
 
 #define COMMON_SLICE_CHICKEN3				XE_REG(0x7304, XE_REG_OPTION_MASKED)
 #define XEHP_COMMON_SLICE_CHICKEN3			XE_REG_MCR(0x7304, XE_REG_OPTION_MASKED)
diff --git a/drivers/gpu/drm/xe/xe_tuning.c b/drivers/gpu/drm/xe/xe_tuning.c
index 5766fa7742d31..314cbe70d2f2a 100644
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -110,6 +110,11 @@ static const struct xe_rtp_entry_sr engine_tunings[] = {
 };
 
 static const struct xe_rtp_entry_sr lrc_tunings[] = {
+	{ XE_RTP_NAME("Tuning: Windower HW Filtering"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(3000, 3599), ENGINE_CLASS(RENDER)),
+	  XE_RTP_ACTIONS(SET(COMMON_SLICE_CHICKEN4, HW_FILTERING))
+	},
+
 	/* DG2 */
 
 	{ XE_RTP_NAME("Tuning: L3 cache"),
-- 
2.53.0



