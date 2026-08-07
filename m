Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563A338D3F2;
	Fri,  7 Aug 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115626; cv=none; b=f6FcWXDZ9ajtfgi3na5JNZDbpu4OVN14dtmyXkniR8pkBUcXLREdpb9P7trP+kxYd4+p3luMPC5H4HR/wYhXG9ZaNp8OnBzoriKLObBataJKy6b+ykrfNz/k2jxu2Uw65qjTl271RjmVU3TQNwvKE49qIOdG5v+l1mrKA6kP5eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115626; c=relaxed/simple;
	bh=NSut/lZWrgM7CBHz7gIn9s/atipt1d6uudG+IeuLDCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYpb9p0opPidBbtA+Plf8x4T/ro7DV9j+0anU4JbtemX9XTCPoLDLEH/Ra56Obrm9aJMU0vP7IXMlkxRmBu3TAlbJmiY2Ncx4KNhtf/9K6qjY30o6HlFwqpTbe5q87vZwST07FyUHI6QuXnigpXVxXLXcnvtRbIWHzexwXKhnGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izymLiSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izymLiSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7407C1F000E9;
	Fri,  7 Aug 2026 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115625;
	bh=Eno/3iQNwoAB+bvY1nVTYbECpUAR/8EJp6/3zgLEOl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izymLiSF+X9RpekEsH4AIf1WdpaQiuq7AgHlfPYLDBGuYJjb7OTrs/3ZGi1eT9ml3
	 dYsuTKoJN0ROIdRKF+AdS6xSamaHwx2LfdDhx4gULiC/NL6MrjeEguhE+uXO1bSvTV
	 wX2cnUbAt3p2tvaWWvGzC8lYk0ofbZHfeGcdwxMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 343/396] drm/xe/rtp: Refactor OAG MMIO trigger register whitelisting
Date: Fri,  7 Aug 2026 16:38:23 +0200
Message-ID: <20260807143431.684992538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 21763dc51150b..47fb3e74b567c 100644
--- a/drivers/gpu/drm/xe/xe_reg_whitelist.c
+++ b/drivers/gpu/drm/xe/xe_reg_whitelist.c
@@ -66,27 +66,24 @@ static const struct xe_rtp_entry_sr register_whitelist[] = {
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
 };
 
-- 
2.53.0



