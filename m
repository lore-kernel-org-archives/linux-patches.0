Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFF338389;
	Thu, 13 Feb 2025 15:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458943; cv=none; b=cWT26JByXet/0v8ZodB2VNGkubNUwlzLQAjgaQqd8Y0qztZyqpIjLqG7g1ZxvJyJ7CisJhcyoxKtmSQ8a9zlnnreqwZ3zfezBmX8A3zzryRZDnPgS5WvIoyAXzKOh8wX9kH04cnXwDd4aFvUoLvd8OBbx+stF1HHzg9MiioFCXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458943; c=relaxed/simple;
	bh=KeEOf5YjgwBe0yU16sPUk2GJ7qXfk7v/hAaIMZ9TvQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obBFPXhcxVIAebXJhxC2rm7z6RBNGwuU2vWyh4CfxHSbiia42Pqvaa5DJdBr/ZRPmtk15YtIy2NXr59wDM2g941oAFPW4kZ74Npeprez2jAvBQBzmYG2nUqK9xq9YFZKwQNhp/ek1ZaJNJymamTmVazfzD2hEDcRPsbJL6+0x/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD+KjFJC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD+KjFJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3ACC4CED1;
	Thu, 13 Feb 2025 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458943;
	bh=KeEOf5YjgwBe0yU16sPUk2GJ7qXfk7v/hAaIMZ9TvQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD+KjFJCi3oSgVy28Mq0p3ktoFBZneZAtPQYfSV20I8JJWHNJOb5ojyMlNw7NP/lV
	 BE+Kbw2IZWzc7v/m4MgQ86bGGZFOyPK+MAxjapqprHtXT0UVPVLurSvH7RVStDqvbj
	 u038wx3a+b2YTNUNWCHBiRorMWN9WxA34w30G06Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 122/443] drm/xe/oa: Preserve oa_ctrl unused bits
Date: Thu, 13 Feb 2025 15:24:47 +0100
Message-ID: <20250213142445.319645262@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

[ Upstream commit 588c20079e17dae9e1f49ba42981a05de1c9136e ]

UMD's have interest in setting unused bits of the oa_ctrl register "out of
band" for certain experiments. To facilitate this, don't clobber previous
oa_ctrl unused bits, i.e. rmw the values rather than simply write them.

Fixes: e936f885f1e9 ("drm/xe/oa/uapi: Expose OA stream fd")
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250117032155.3048063-1-ashutosh.dixit@intel.com
(cherry picked from commit cfa9d40db8c30d894171010fe765d96e9bc6a47e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_oa_regs.h |  6 ++++++
 drivers/gpu/drm/xe/xe_oa.c           | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_oa_regs.h b/drivers/gpu/drm/xe/regs/xe_oa_regs.h
index a9b0091cb7ee1..6d31573ed1765 100644
--- a/drivers/gpu/drm/xe/regs/xe_oa_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_oa_regs.h
@@ -59,6 +59,10 @@
 /* Common to all OA units */
 #define  OA_OACONTROL_REPORT_BC_MASK		REG_GENMASK(9, 9)
 #define  OA_OACONTROL_COUNTER_SIZE_MASK		REG_GENMASK(8, 8)
+#define  OAG_OACONTROL_USED_BITS \
+	(OAG_OACONTROL_OA_PES_DISAG_EN | OAG_OACONTROL_OA_CCS_SELECT_MASK | \
+	 OAG_OACONTROL_OA_COUNTER_SEL_MASK | OAG_OACONTROL_OA_COUNTER_ENABLE | \
+	 OA_OACONTROL_REPORT_BC_MASK | OA_OACONTROL_COUNTER_SIZE_MASK)
 
 #define OAG_OA_DEBUG XE_REG(0xdaf8, XE_REG_OPTION_MASKED)
 #define  OAG_OA_DEBUG_DISABLE_MMIO_TRG			REG_BIT(14)
@@ -85,6 +89,8 @@
 #define OAM_CONTEXT_CONTROL_OFFSET		(0x1bc)
 #define OAM_CONTROL_OFFSET			(0x194)
 #define  OAM_CONTROL_COUNTER_SEL_MASK		REG_GENMASK(3, 1)
+#define  OAM_OACONTROL_USED_BITS \
+	(OAM_CONTROL_COUNTER_SEL_MASK | OAG_OACONTROL_OA_COUNTER_ENABLE)
 #define OAM_DEBUG_OFFSET			(0x198)
 #define OAM_STATUS_OFFSET			(0x19c)
 #define OAM_MMIO_TRG_OFFSET			(0x1d0)
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 678fa40e4cea7..d8af82dcdce4b 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -445,6 +445,12 @@ static u32 __oa_ccs_select(struct xe_oa_stream *stream)
 	return val;
 }
 
+static u32 __oactrl_used_bits(struct xe_oa_stream *stream)
+{
+	return stream->hwe->oa_unit->type == DRM_XE_OA_UNIT_TYPE_OAG ?
+		OAG_OACONTROL_USED_BITS : OAM_OACONTROL_USED_BITS;
+}
+
 static void xe_oa_enable(struct xe_oa_stream *stream)
 {
 	const struct xe_oa_format *format = stream->oa_buffer.format;
@@ -465,14 +471,14 @@ static void xe_oa_enable(struct xe_oa_stream *stream)
 	    stream->hwe->oa_unit->type == DRM_XE_OA_UNIT_TYPE_OAG)
 		val |= OAG_OACONTROL_OA_PES_DISAG_EN;
 
-	xe_mmio_write32(&stream->gt->mmio, regs->oa_ctrl, val);
+	xe_mmio_rmw32(&stream->gt->mmio, regs->oa_ctrl, __oactrl_used_bits(stream), val);
 }
 
 static void xe_oa_disable(struct xe_oa_stream *stream)
 {
 	struct xe_mmio *mmio = &stream->gt->mmio;
 
-	xe_mmio_write32(mmio, __oa_regs(stream)->oa_ctrl, 0);
+	xe_mmio_rmw32(mmio, __oa_regs(stream)->oa_ctrl, __oactrl_used_bits(stream), 0);
 	if (xe_mmio_wait32(mmio, __oa_regs(stream)->oa_ctrl,
 			   OAG_OACONTROL_OA_COUNTER_ENABLE, 0, 50000, NULL, false))
 		drm_err(&stream->oa->xe->drm,
@@ -2569,6 +2575,8 @@ static void __xe_oa_init_oa_units(struct xe_gt *gt)
 			u->type = DRM_XE_OA_UNIT_TYPE_OAM;
 		}
 
+		xe_mmio_write32(&gt->mmio, u->regs.oa_ctrl, 0);
+
 		/* Ensure MMIO trigger remains disabled till there is a stream */
 		xe_mmio_write32(&gt->mmio, u->regs.oa_debug,
 				oag_configure_mmio_trigger(NULL, false));
-- 
2.39.5



