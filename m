Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522024FBFF;
	Mon, 23 Jun 2025 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685749; cv=none; b=s8R8f0gRtQuSzuoeQVObI1il47oDdr+9iRWhwYSEFI06brK8HHV8iKzF17Ukm5itViB98f1d0tMg9HPNN2C6APgDNrGsHZKpRcV5tSNA3shJ8Uz3MxNnjQmrOB4232Z2KOYXrRLWkQx5vH9IAVSgfmzPljBXF+7zbOpuXmPGS9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685749; c=relaxed/simple;
	bh=GvdJgakxtL+4vmd7m/s98YhMyinqb1c3YFZihKs/H+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLiIJy+42DnLeZF+JtURqHDFO1sGqFvHAuPMKQgPLeH4O+0lDzgRRjWi2/L2y8nMjwvl8BdIonP+LJOJfkAdodtiuCL736wq6Dc608BuzMuNcbCfHtQbNfJo63J7iQVHpgcwC/gLGDPba/jtA8X+4fIRDkpkUeGjvZLIQmAucgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSChmR7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSChmR7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B375C4CEF0;
	Mon, 23 Jun 2025 13:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685749;
	bh=GvdJgakxtL+4vmd7m/s98YhMyinqb1c3YFZihKs/H+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSChmR7kncCYioG8jNTFiiLb3jYXJ/ey45I/MvXrCKpJ5dGnXczr5ijn7PR/rvQhj
	 Rd8YMzN3QJBuhFkWkPnumgpCUB6U2oRyKRwqq2dLlVpum8VoJe9aA+Livsw02uob9b
	 J05UQX3fzFWLg1Atb1vL8FSt9HgLlMOxWjXa1QOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 283/592] drm/amd/display: Fix Vertical Interrupt definitions for dcn32, dcn401
Date: Mon, 23 Jun 2025 15:04:01 +0200
Message-ID: <20250623130707.082404560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit e8cc149ed906a371a5962ff8065393bae28165c9 ]

[WHY&HOW]
- VUPDATE_NO_LOCK should be used in place of VUPDATE always
- Add VERTICAL_INTERRUPT1 and VERTICAL_INTERRUPT2 definitions

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/irq/dcn32/irq_service_dcn32.c  | 61 ++++++++++++++-----
 .../dc/irq/dcn401/irq_service_dcn401.c        | 60 +++++++++++++-----
 drivers/gpu/drm/amd/display/dc/irq_types.h    |  9 +++
 3 files changed, 101 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/irq/dcn32/irq_service_dcn32.c b/drivers/gpu/drm/amd/display/dc/irq/dcn32/irq_service_dcn32.c
index f0ac0aeeac512..f839afacd5a5c 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn32/irq_service_dcn32.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn32/irq_service_dcn32.c
@@ -191,6 +191,16 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 	.ack = NULL
 };
 
+static struct irq_source_info_funcs vline1_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
+static struct irq_source_info_funcs vline2_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
 #undef BASE_INNER
 #define BASE_INNER(seg) DCN_BASE__INST0_SEG ## seg
 
@@ -259,6 +269,13 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 		.funcs = &pflip_irq_info_funcs\
 	}
 
+#define vblank_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_VBLANK1 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_INT_EN,\
+			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_EVENT_CLEAR),\
+		.funcs = &vblank_irq_info_funcs\
+	}
 /* vupdate_no_lock_int_entry maps to DC_IRQ_SOURCE_VUPDATEx, to match semantic
  * of DCE's DC_IRQ_SOURCE_VUPDATEx.
  */
@@ -270,14 +287,6 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 		.funcs = &vupdate_no_lock_irq_info_funcs\
 	}
 
-#define vblank_int_entry(reg_num)\
-	[DC_IRQ_SOURCE_VBLANK1 + reg_num] = {\
-		IRQ_REG_ENTRY(OTG, reg_num,\
-			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_INT_EN,\
-			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_EVENT_CLEAR),\
-		.funcs = &vblank_irq_info_funcs\
-}
-
 #define vline0_int_entry(reg_num)\
 	[DC_IRQ_SOURCE_DC1_VLINE0 + reg_num] = {\
 		IRQ_REG_ENTRY(OTG, reg_num,\
@@ -285,6 +294,20 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 			OTG_VERTICAL_INTERRUPT0_CONTROL, OTG_VERTICAL_INTERRUPT0_CLEAR),\
 		.funcs = &vline0_irq_info_funcs\
 	}
+#define vline1_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_DC1_VLINE1 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_VERTICAL_INTERRUPT1_CONTROL, OTG_VERTICAL_INTERRUPT1_INT_ENABLE,\
+			OTG_VERTICAL_INTERRUPT1_CONTROL, OTG_VERTICAL_INTERRUPT1_CLEAR),\
+		.funcs = &vline1_irq_info_funcs\
+	}
+#define vline2_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_DC1_VLINE2 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_VERTICAL_INTERRUPT2_CONTROL, OTG_VERTICAL_INTERRUPT2_INT_ENABLE,\
+			OTG_VERTICAL_INTERRUPT2_CONTROL, OTG_VERTICAL_INTERRUPT2_CLEAR),\
+		.funcs = &vline2_irq_info_funcs\
+	}
 #define dmub_outbox_int_entry()\
 	[DC_IRQ_SOURCE_DMCUB_OUTBOX] = {\
 		IRQ_REG_ENTRY_DMUB(\
@@ -387,21 +410,29 @@ irq_source_info_dcn32[DAL_IRQ_SOURCES_NUMBER] = {
 	dc_underflow_int_entry(6),
 	[DC_IRQ_SOURCE_DMCU_SCP] = dummy_irq_entry(),
 	[DC_IRQ_SOURCE_VBIOS_SW] = dummy_irq_entry(),
-	vupdate_no_lock_int_entry(0),
-	vupdate_no_lock_int_entry(1),
-	vupdate_no_lock_int_entry(2),
-	vupdate_no_lock_int_entry(3),
 	vblank_int_entry(0),
 	vblank_int_entry(1),
 	vblank_int_entry(2),
 	vblank_int_entry(3),
+	[DC_IRQ_SOURCE_DC5_VLINE1] = dummy_irq_entry(),
+	[DC_IRQ_SOURCE_DC6_VLINE1] = dummy_irq_entry(),
+	dmub_outbox_int_entry(),
+	vupdate_no_lock_int_entry(0),
+	vupdate_no_lock_int_entry(1),
+	vupdate_no_lock_int_entry(2),
+	vupdate_no_lock_int_entry(3),
 	vline0_int_entry(0),
 	vline0_int_entry(1),
 	vline0_int_entry(2),
 	vline0_int_entry(3),
-	[DC_IRQ_SOURCE_DC5_VLINE1] = dummy_irq_entry(),
-	[DC_IRQ_SOURCE_DC6_VLINE1] = dummy_irq_entry(),
-	dmub_outbox_int_entry(),
+	vline1_int_entry(0),
+	vline1_int_entry(1),
+	vline1_int_entry(2),
+	vline1_int_entry(3),
+	vline2_int_entry(0),
+	vline2_int_entry(1),
+	vline2_int_entry(2),
+	vline2_int_entry(3)
 };
 
 static const struct irq_service_funcs irq_service_funcs_dcn32 = {
diff --git a/drivers/gpu/drm/amd/display/dc/irq/dcn401/irq_service_dcn401.c b/drivers/gpu/drm/amd/display/dc/irq/dcn401/irq_service_dcn401.c
index b43c9524b0de1..8499e505cf3ef 100644
--- a/drivers/gpu/drm/amd/display/dc/irq/dcn401/irq_service_dcn401.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn401/irq_service_dcn401.c
@@ -171,6 +171,16 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 	.ack = NULL
 };
 
+static struct irq_source_info_funcs vline1_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
+static struct irq_source_info_funcs vline2_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
 #undef BASE_INNER
 #define BASE_INNER(seg) DCN_BASE__INST0_SEG ## seg
 
@@ -239,6 +249,13 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 		.funcs = &pflip_irq_info_funcs\
 	}
 
+#define vblank_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_VBLANK1 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_INT_EN,\
+			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_EVENT_CLEAR),\
+		.funcs = &vblank_irq_info_funcs\
+	}
 /* vupdate_no_lock_int_entry maps to DC_IRQ_SOURCE_VUPDATEx, to match semantic
  * of DCE's DC_IRQ_SOURCE_VUPDATEx.
  */
@@ -250,13 +267,6 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 		.funcs = &vupdate_no_lock_irq_info_funcs\
 	}
 
-#define vblank_int_entry(reg_num)\
-	[DC_IRQ_SOURCE_VBLANK1 + reg_num] = {\
-		IRQ_REG_ENTRY(OTG, reg_num,\
-			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_INT_EN,\
-			OTG_GLOBAL_SYNC_STATUS, VSTARTUP_EVENT_CLEAR),\
-		.funcs = &vblank_irq_info_funcs\
-	}
 #define vline0_int_entry(reg_num)\
 	[DC_IRQ_SOURCE_DC1_VLINE0 + reg_num] = {\
 		IRQ_REG_ENTRY(OTG, reg_num,\
@@ -264,6 +274,20 @@ static struct irq_source_info_funcs vline0_irq_info_funcs = {
 			OTG_VERTICAL_INTERRUPT0_CONTROL, OTG_VERTICAL_INTERRUPT0_CLEAR),\
 		.funcs = &vline0_irq_info_funcs\
 	}
+#define vline1_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_DC1_VLINE1 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_VERTICAL_INTERRUPT1_CONTROL, OTG_VERTICAL_INTERRUPT1_INT_ENABLE,\
+			OTG_VERTICAL_INTERRUPT1_CONTROL, OTG_VERTICAL_INTERRUPT1_CLEAR),\
+		.funcs = &vline1_irq_info_funcs\
+	}
+#define vline2_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_DC1_VLINE2 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_VERTICAL_INTERRUPT2_CONTROL, OTG_VERTICAL_INTERRUPT2_INT_ENABLE,\
+			OTG_VERTICAL_INTERRUPT2_CONTROL, OTG_VERTICAL_INTERRUPT2_CLEAR),\
+		.funcs = &vline2_irq_info_funcs\
+	}
 #define dmub_outbox_int_entry()\
 	[DC_IRQ_SOURCE_DMCUB_OUTBOX] = {\
 		IRQ_REG_ENTRY_DMUB(\
@@ -364,21 +388,29 @@ irq_source_info_dcn401[DAL_IRQ_SOURCES_NUMBER] = {
 	dc_underflow_int_entry(6),
 	[DC_IRQ_SOURCE_DMCU_SCP] = dummy_irq_entry(),
 	[DC_IRQ_SOURCE_VBIOS_SW] = dummy_irq_entry(),
-	vupdate_no_lock_int_entry(0),
-	vupdate_no_lock_int_entry(1),
-	vupdate_no_lock_int_entry(2),
-	vupdate_no_lock_int_entry(3),
 	vblank_int_entry(0),
 	vblank_int_entry(1),
 	vblank_int_entry(2),
 	vblank_int_entry(3),
+	[DC_IRQ_SOURCE_DC5_VLINE1] = dummy_irq_entry(),
+	[DC_IRQ_SOURCE_DC6_VLINE1] = dummy_irq_entry(),
+	dmub_outbox_int_entry(),
+	vupdate_no_lock_int_entry(0),
+	vupdate_no_lock_int_entry(1),
+	vupdate_no_lock_int_entry(2),
+	vupdate_no_lock_int_entry(3),
 	vline0_int_entry(0),
 	vline0_int_entry(1),
 	vline0_int_entry(2),
 	vline0_int_entry(3),
-	[DC_IRQ_SOURCE_DC5_VLINE1] = dummy_irq_entry(),
-	[DC_IRQ_SOURCE_DC6_VLINE1] = dummy_irq_entry(),
-	dmub_outbox_int_entry(),
+	vline1_int_entry(0),
+	vline1_int_entry(1),
+	vline1_int_entry(2),
+	vline1_int_entry(3),
+	vline2_int_entry(0),
+	vline2_int_entry(1),
+	vline2_int_entry(2),
+	vline2_int_entry(3),
 };
 
 static const struct irq_service_funcs irq_service_funcs_dcn401 = {
diff --git a/drivers/gpu/drm/amd/display/dc/irq_types.h b/drivers/gpu/drm/amd/display/dc/irq_types.h
index 110f656d43aee..eadab0a2afebe 100644
--- a/drivers/gpu/drm/amd/display/dc/irq_types.h
+++ b/drivers/gpu/drm/amd/display/dc/irq_types.h
@@ -161,6 +161,13 @@ enum dc_irq_source {
 	DC_IRQ_SOURCE_DPCX_TX_PHYE,
 	DC_IRQ_SOURCE_DPCX_TX_PHYF,
 
+	DC_IRQ_SOURCE_DC1_VLINE2,
+	DC_IRQ_SOURCE_DC2_VLINE2,
+	DC_IRQ_SOURCE_DC3_VLINE2,
+	DC_IRQ_SOURCE_DC4_VLINE2,
+	DC_IRQ_SOURCE_DC5_VLINE2,
+	DC_IRQ_SOURCE_DC6_VLINE2,
+
 	DAL_IRQ_SOURCES_NUMBER
 };
 
@@ -170,6 +177,8 @@ enum irq_type
 	IRQ_TYPE_VUPDATE = DC_IRQ_SOURCE_VUPDATE1,
 	IRQ_TYPE_VBLANK = DC_IRQ_SOURCE_VBLANK1,
 	IRQ_TYPE_VLINE0 = DC_IRQ_SOURCE_DC1_VLINE0,
+	IRQ_TYPE_VLINE1 = DC_IRQ_SOURCE_DC1_VLINE1,
+	IRQ_TYPE_VLINE2 = DC_IRQ_SOURCE_DC1_VLINE2,
 	IRQ_TYPE_DCUNDERFLOW = DC_IRQ_SOURCE_DC1UNDERFLOW,
 };
 
-- 
2.39.5



