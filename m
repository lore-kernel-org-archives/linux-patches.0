Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED638C2C0;
	Fri,  7 Aug 2026 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114594; cv=none; b=RXi1HmE+M0y31y0qdkZK13EtDxQv0WJn/8oqamRSww+R+gtFkESen4kKDff08M7mX/snsLdkYMWhgf2f3aaikCakQ6GgLit71KCyqknoH6xyTfl47oqa8ugFK6cnvvCRqQUrhJE+d16DjNgHC5pT0sff9IoFOQ02WTCJBX2Buqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114594; c=relaxed/simple;
	bh=QTZyKpjBVXMo4fvjuwstwA4MdaECIVxcdyFzTsastN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrDNGkfceBGOCwtjlxgM6pCeXM+eoYzA8AqXX6dFnbTX/dqirmCFzcy9tG6JRBWyp8lv14zuV2+kJS4Jplc86ukonjRRmXYnLVR+Iet6uO0cPXQtSUTm9Cg4hZbIkwpeeJW20LQsbllhefQ60BeGLv3AQSILbpOjAwFQZ/Ph16c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSHTiTpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSHTiTpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37A01F000E9;
	Fri,  7 Aug 2026 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114590;
	bh=wDutxiHvemzHdW9NxLrKoCSyPFZBsl6TjjFkBLsRTTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSHTiTpKBK1Hg7Kxk7GLkV+sUuAC1l9L+rtxcyjzV5P7SmxpocXbBUAG0rwTmDhq6
	 4hJA4beQK7GwDprYa2bUypm69Ctq2DNkTuthFC5NSSRqaotHkj4pnBMwrU32PEosPO
	 RFq/lELnPU8iCYIvR4/Lo/ecKuIEpCU5JbtPXDe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/337] drm/xe/rtp: Refactor OAG MMIO trigger register whitelisting
Date: Fri,  7 Aug 2026 16:37:56 +0200
Message-ID: <20260807143424.456606663@linuxfoundation.org>
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

[ Upstream commit ed455775c5a68b75e5f6ad6c8e0e3e9c98fd3f64 ]

Minor refactor of OAG MMIO trigger register whitelisting for code reuse
with OAM MMIO trigger register whitelisting.

Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://patch.msgid.link/20251202025115.373546-5-ashutosh.dixit@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_whitelist.c | 29 ++++++++++++---------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_whitelist.c b/drivers/gpu/drm/xe/xe_reg_whitelist.c
index 3de0a867149da..d88261921ae46 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -64,27 +64,24 @@ static const struct xe_rtp_entry_sr register_whitelist[] = {
 		       ENGINE_CLASS(RENDER)),
 	  XE_RTP_ACTIONS(WHITELIST(CSBE_DEBUG_STATUS(RENDER_RING_BASE), 0))
 	},
-	{ XE_RTP_NAME("oa_reg_render"),
+
+#define WHITELIST_OA_MMIO_TRG(trg, status, head) \
+	WHITELIST(trg, RING_FORCE_TO_NONPRIV_ACCESS_RW), \
+	WHITELIST(status, RING_FORCE_TO_NONPRIV_ACCESS_RD), \
+	WHITELIST(head, RING_FORCE_TO_NONPRIV_ACCESS_RD | RING_FORCE_TO_NONPRIV_RANGE_4)
+
+#define WHITELIST_OAG_MMIO_TRG \
+	WHITELIST_OA_MMIO_TRG(OAG_MMIOTRIGGER, OAG_OASTATUS, OAG_OAHEADPTR)
+
+	{ XE_RTP_NAME("oag_mmio_trg_rcs"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, XE_RTP_END_VERSION_UNDEFINED),
 		       ENGINE_CLASS(RENDER)),
-	  XE_RTP_ACTIONS(WHITELIST(OAG_MMIOTRIGGER,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RW),
-			 WHITELIST(OAG_OASTATUS,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RD),
-			 WHITELIST(OAG_OAHEADPTR,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RD |
-				   RING_FORCE_TO_NONPRIV_RANGE_4))
+	  XE_RTP_ACTIONS(WHITELIST_OAG_MMIO_TRG)
 	},
-	{ XE_RTP_NAME("oa_reg_compute"),
+	{ XE_RTP_NAME("oag_mmio_trg_ccs"),
 	  XE_RTP_RULES(GRAPHICS_VERSION_RANGE(1200, XE_RTP_END_VERSION_UNDEFINED),
 		       ENGINE_CLASS(COMPUTE)),
-	  XE_RTP_ACTIONS(WHITELIST(OAG_MMIOTRIGGER,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RW),
-			 WHITELIST(OAG_OASTATUS,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RD),
-			 WHITELIST(OAG_OAHEADPTR,
-				   RING_FORCE_TO_NONPRIV_ACCESS_RD |
-				   RING_FORCE_TO_NONPRIV_RANGE_4))
+	  XE_RTP_ACTIONS(WHITELIST_OAG_MMIO_TRG)
 	},
 	{}
 };
-- 
2.53.0



