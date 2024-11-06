Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483AD1DFE3A;
	Wed,  6 Nov 2024 12:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896577; cv=none; b=m7OyknwS1Psv8FXkWVOOv7z/pno7MQE1Hs1B926a5hM2fQ+nzv7I0U2P2HX2kkcPvh50MfFGNHeWfagkQatW4E3JyqiqB1eHdZlvc8jWOIdoz+iHRMapICPnCmqUIYwWXMEx5ec/16tucKY7EwYHUixcke/xUl7JtyNfq8HDXXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896577; c=relaxed/simple;
	bh=n30uP4sah7ov+QFcCs/ogu9THSTcAiPx5U6krFwILpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBS8Ea75YUvlURS9hxWfZDDLRN+0QUK4+WM0r6tJvYC7OvGaVA0397c5h3z+CZtG2YLKNMxOGg3x/Pm2yeG2F+X9zirr5Fk/QvsnArc0lzmhHQjFSG5YRllmXa6N1Ubp8/KJYhzBdl4MgMiZq4H4ajiIIs8pS7vplVLSghee+Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP/XKUOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP/XKUOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C92C4CED4;
	Wed,  6 Nov 2024 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896577;
	bh=n30uP4sah7ov+QFcCs/ogu9THSTcAiPx5U6krFwILpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP/XKUOaorCs721P+p817K9JZ5q1+l9U84fwy8eJE54KBtimEACG2lDRAlmLflil3
	 1vbOuYGhXpalSfnNfi4MuJX95sjM0O9ATTpCWOhXB4lNLctYKaNtuheocGzw9XxRxL
	 QVmb5TQf9Vu8zw69CbsBM+G7kUpBvwXKOlkHsk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>,
	Akshata Jahagirdar <akshata.jahagirdar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 239/245] drm/xe/xe2: Add performance turning changes
Date: Wed,  6 Nov 2024 13:04:52 +0100
Message-ID: <20241106120325.151413759@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shekhar Chauhan <shekhar.chauhan@intel.com>

commit ecabb5e6ce54711c28706fc794d77adb3ecd0605 upstream.

Update performance tuning according to the hardware spec.

Bspec: 72161
Signed-off-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Sai Teja Pottumuttu <sai.teja.pottumuttu@intel.com>
Reviewed-by: Akshata Jahagirdar <akshata.jahagirdar@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240805053710.877119-1-shekhar.chauhan@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    4 ++++
 drivers/gpu/drm/xe/xe_tuning.c       |    8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -80,6 +80,9 @@
 #define   LE_CACHEABILITY_MASK			REG_GENMASK(1, 0)
 #define   LE_CACHEABILITY(value)		REG_FIELD_PREP(LE_CACHEABILITY_MASK, value)
 
+#define STATELESS_COMPRESSION_CTRL		XE_REG(0x4148)
+#define   UNIFIED_COMPRESSION_FORMAT		REG_GENMASK(3, 0)
+
 #define XE2_GAMREQSTRM_CTRL			XE_REG(0x4194)
 #define   CG_DIS_CNTLBUS			REG_BIT(6)
 
@@ -194,6 +197,7 @@
 #define GSCPSMI_BASE				XE_REG(0x880c)
 
 #define CCCHKNREG1				XE_REG_MCR(0x8828)
+#define   L3CMPCTRL				REG_BIT(23)
 #define   ENCOMPPERFFIX				REG_BIT(18)
 
 /* Fuse readout registers for GT */
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -39,7 +39,8 @@ static const struct xe_rtp_entry_sr gt_t
 	},
 	{ XE_RTP_NAME("Tuning: Compression Overfetch"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED)),
-	  XE_RTP_ACTIONS(CLR(CCCHKNREG1, ENCOMPPERFFIX)),
+	  XE_RTP_ACTIONS(CLR(CCCHKNREG1, ENCOMPPERFFIX),
+			 SET(CCCHKNREG1, L3CMPCTRL))
 	},
 	{ XE_RTP_NAME("Tuning: Enable compressible partial write overfetch in L3"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED)),
@@ -50,6 +51,11 @@ static const struct xe_rtp_entry_sr gt_t
 	  XE_RTP_ACTIONS(SET(L3SQCREG2,
 			     COMPMEMRD256BOVRFETCHEN))
 	},
+	{ XE_RTP_NAME("Tuning: Stateless compression control"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED)),
+	  XE_RTP_ACTIONS(FIELD_SET(STATELESS_COMPRESSION_CTRL, UNIFIED_COMPRESSION_FORMAT,
+				   REG_FIELD_PREP(UNIFIED_COMPRESSION_FORMAT, 0)))
+	},
 	{}
 };
 


