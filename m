Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA7818C00E;
	Wed,  6 Nov 2024 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896574; cv=none; b=iIAJ4eVMYaAKthoJxotXw2oDnqKM+I7WjQYA83yN9+xtnUfZnsOCPAMArJSuhU9YzLhwCIX7+Fz6kW7eWIWrnry/vOOhSkFTx2Fn7Jur5jBSCp0dn+V4ZVWpb6i64HwxZNPZ3qtdJVx3nJG+BxBpeGn1INP7vwAQHLwQGzqiUXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896574; c=relaxed/simple;
	bh=becQgweGYlG0BTGLNbemcb40RJxrm+siogthUpkD5jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8sB0qzY5bYqfT5Q52m2vPGu/4TdzUjcBsrY+87HUsSbNbDfVksSLTMgOju1thMIPhx2Hq/tafdM04Aa1rWZ7ze0HsyWYGWGsYJxUv0kK+/jFhL7UKTiDnRu5cnJU6gDvZFXZYUOsj/R/mWSwIiRGXfiJqkXZPCxE40Ej8IQl+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0p+5BBzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0p+5BBzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB4C4CECD;
	Wed,  6 Nov 2024 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896574;
	bh=becQgweGYlG0BTGLNbemcb40RJxrm+siogthUpkD5jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0p+5BBzqG5bP0x0qC4d3gtwboZ3cBBfFb6R/mCANsU7jYJc/A75jLmUTVW2WXkSTV
	 HOZ8Ynz1i/M/Q9IVJSDd7jl3GhAb35zEIOa+AyAcyPLUnYiSlaXDlVXFuKsZBl2BiX
	 2Dap4UtqCNRmNPdoVJQJOuYqyTBL+SurWgXv14z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akshata Jahagirdar <akshata.jahagirdar@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 238/245] drm/xe/xe2: Introduce performance changes
Date: Wed,  6 Nov 2024 13:04:51 +0100
Message-ID: <20241106120325.124458445@linuxfoundation.org>
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

From: Akshata Jahagirdar <akshata.jahagirdar@intel.com>

commit 2009e808bc3e0df6d4d83e2271bc25ae63a4ac05 upstream.

Add Compression Performance Improvement Changes in Xe2

v2: Rebase

v3: Rebase, updated as per latest changes on bspec,
    Removed unnecessary default actions (Matt)
    formatting nits (Tejas)

v4: Formatting nits, removed default set action for bit 14 (Matt)

Bspec: 72161
Signed-off-by: Akshata Jahagirdar <akshata.jahagirdar@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c2dd753fdc55df6a6432026f2df9c2684a0d25c1.1722607628.git.akshata.jahagirdar@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/regs/xe_gt_regs.h |    3 +++
 drivers/gpu/drm/xe/xe_tuning.c       |    5 +++++
 2 files changed, 8 insertions(+)

--- a/drivers/gpu/drm/xe/regs/xe_gt_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_gt_regs.h
@@ -368,6 +368,9 @@
 #define XEHP_L3NODEARBCFG			XE_REG_MCR(0xb0b4)
 #define   XEHP_LNESPARE				REG_BIT(19)
 
+#define L3SQCREG2				XE_REG_MCR(0xb104)
+#define   COMPMEMRD256BOVRFETCHEN		REG_BIT(20)
+
 #define L3SQCREG3				XE_REG_MCR(0xb108)
 #define   COMPPWOVERFETCHEN			REG_BIT(28)
 
--- a/drivers/gpu/drm/xe/xe_tuning.c
+++ b/drivers/gpu/drm/xe/xe_tuning.c
@@ -45,6 +45,11 @@ static const struct xe_rtp_entry_sr gt_t
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED)),
 	  XE_RTP_ACTIONS(SET(L3SQCREG3, COMPPWOVERFETCHEN))
 	},
+	{ XE_RTP_NAME("Tuning: L2 Overfetch Compressible Only"),
+	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(2001, XE_RTP_END_VERSION_UNDEFINED)),
+	  XE_RTP_ACTIONS(SET(L3SQCREG2,
+			     COMPMEMRD256BOVRFETCHEN))
+	},
 	{}
 };
 


