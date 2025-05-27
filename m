Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9B927FB2A;
	Tue, 27 May 2025 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367210; cv=none; b=NT97jJW+ajpHJ7NvoIgCYq1seZRamu7l4nWYU5DSXm6YHQnnBnSjY+XkN+KXNeF6Jv+IkzGVG4/fpJdwUbGL/1mSxuogu3d7hgqA9MqcstfNuf5ivsMrd9MsVx8WiyQ2rQzr5TidBmAmsxRzsDKUIplQwLWYI6/fsPKuTE5Jb6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367210; c=relaxed/simple;
	bh=yMESuVj9Oae0QvcVDQpvfgskInGYzV3aoFU06jKgkJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLKUQ1Q7sbi9KJRPJgQe6wgJrynfRgVXuWGQvRSlIHmwUg9gewqDbxRamlha+W5B3XofXDNC7Wi0HKE1yrgfzw3rfFwGvq6GJ9HnJtXYbYtDO+tNYhdXGpI3P0zNOheDdndR+JzqJjsIEggfuCsq5yeq9B/xCs9KLy5efL73yW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbIob96+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbIob96+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2D2C4CEE9;
	Tue, 27 May 2025 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367209;
	bh=yMESuVj9Oae0QvcVDQpvfgskInGYzV3aoFU06jKgkJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbIob96+0p5l1hHo9is1Wv16VRdzsuHoGGyr5tlCah3XP39SCpkJSgKCwLAihCvAt
	 BLBiFVT8Uso11S5IL8zTA2baJgM1VyVGW5OCQmQtKYm0d02E4tsvI3xtL0bIpBtnO1
	 b9QryBa/5v9djQ+gj52LQ7HAIgIencq7MdwwqZXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 283/783] drm/amd/display: Fix DMUB reset sequence for DCN401
Date: Tue, 27 May 2025 18:21:20 +0200
Message-ID: <20250527162524.612656989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 0dfcc2bf269010a6e093793034c048049a40ee93 ]

[WHY]
It should no longer use DMCUB_SOFT_RESET as it can result
in the memory request path becoming desynchronized.

[HOW]
To ensure robustness in the reset sequence:
1) Extend timeout on the "halt" command sent via gpint, and check for
controller to enter "wait" as a stronger guarantee that there are no
requests to memory still in flight.
2) Remove usage of DMCUB_SOFT_RESET
3) Rely on PSP to reset the controller safely

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dmub/src/dmub_dcn401.c    | 47 ++++++++++++-------
 .../drm/amd/display/dmub/src/dmub_dcn401.h    |  3 +-
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.c
index 39a8cb6d7523c..e1c4fe1c6e3ee 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.c
@@ -63,8 +63,10 @@ static inline void dmub_dcn401_translate_addr(const union dmub_addr *addr_in,
 void dmub_dcn401_reset(struct dmub_srv *dmub)
 {
 	union dmub_gpint_data_register cmd;
-	const uint32_t timeout = 30;
-	uint32_t in_reset, scratch, i;
+	const uint32_t timeout_us = 1 * 1000 * 1000; //1s
+	const uint32_t poll_delay_us = 1; //1us
+	uint32_t i = 0;
+	uint32_t in_reset, scratch, pwait_mode;
 
 	REG_GET(DMCUB_CNTL2, DMCUB_SOFT_RESET, &in_reset);
 
@@ -75,32 +77,35 @@ void dmub_dcn401_reset(struct dmub_srv *dmub)
 
 		dmub->hw_funcs.set_gpint(dmub, cmd);
 
-		/**
-		 * Timeout covers both the ACK and the wait
-		 * for remaining work to finish.
-		 *
-		 * This is mostly bound by the PHY disable sequence.
-		 * Each register check will be greater than 1us, so
-		 * don't bother using udelay.
-		 */
-
-		for (i = 0; i < timeout; ++i) {
+		for (i = 0; i < timeout_us; i++) {
 			if (dmub->hw_funcs.is_gpint_acked(dmub, cmd))
 				break;
+
+			udelay(poll_delay_us);
 		}
 
-		for (i = 0; i < timeout; ++i) {
+		for (; i < timeout_us; i++) {
 			scratch = dmub->hw_funcs.get_gpint_response(dmub);
 			if (scratch == DMUB_GPINT__STOP_FW_RESPONSE)
 				break;
+
+			udelay(poll_delay_us);
 		}
 
-		/* Force reset in case we timed out, DMCUB is likely hung. */
+		for (; i < timeout_us; i++) {
+			REG_GET(DMCUB_CNTL, DMCUB_PWAIT_MODE_STATUS, &pwait_mode);
+			if (pwait_mode & (1 << 0))
+				break;
+
+			udelay(poll_delay_us);
+		}
+	}
+
+	if (i >= timeout_us) {
+		/* timeout should never occur */
+		BREAK_TO_DEBUGGER();
 	}
 
-	REG_UPDATE(DMCUB_CNTL2, DMCUB_SOFT_RESET, 1);
-	REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
-	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
 	REG_WRITE(DMCUB_INBOX1_RPTR, 0);
 	REG_WRITE(DMCUB_INBOX1_WPTR, 0);
 	REG_WRITE(DMCUB_OUTBOX1_RPTR, 0);
@@ -131,7 +136,10 @@ void dmub_dcn401_backdoor_load(struct dmub_srv *dmub,
 
 	dmub_dcn401_get_fb_base_offset(dmub, &fb_base, &fb_offset);
 
+	/* reset and disable DMCUB and MMHUBBUB DMUIF */
 	REG_UPDATE(DMCUB_SEC_CNTL, DMCUB_SEC_RESET, 1);
+	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
+	REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
 
 	dmub_dcn401_translate_addr(&cw0->offset, fb_base, fb_offset, &offset);
 
@@ -151,6 +159,7 @@ void dmub_dcn401_backdoor_load(struct dmub_srv *dmub,
 			DMCUB_REGION3_CW1_TOP_ADDRESS, cw1->region.top,
 			DMCUB_REGION3_CW1_ENABLE, 1);
 
+	/* release DMCUB reset only to prevent premature execution */
 	REG_UPDATE_2(DMCUB_SEC_CNTL, DMCUB_SEC_RESET, 0, DMCUB_MEM_UNIT_ID,
 			0x20);
 }
@@ -161,7 +170,10 @@ void dmub_dcn401_backdoor_load_zfb_mode(struct dmub_srv *dmub,
 {
 	union dmub_addr offset;
 
+	/* reset and disable DMCUB and MMHUBBUB DMUIF */
 	REG_UPDATE(DMCUB_SEC_CNTL, DMCUB_SEC_RESET, 1);
+	REG_UPDATE(MMHUBBUB_SOFT_RESET, DMUIF_SOFT_RESET, 1);
+	REG_UPDATE(DMCUB_CNTL, DMCUB_ENABLE, 0);
 
 	offset = cw0->offset;
 
@@ -181,6 +193,7 @@ void dmub_dcn401_backdoor_load_zfb_mode(struct dmub_srv *dmub,
 			DMCUB_REGION3_CW1_TOP_ADDRESS, cw1->region.top,
 			DMCUB_REGION3_CW1_ENABLE, 1);
 
+	/* release DMCUB reset only to prevent premature execution */
 	REG_UPDATE_2(DMCUB_SEC_CNTL, DMCUB_SEC_RESET, 0, DMCUB_MEM_UNIT_ID,
 			0x20);
 }
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.h b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.h
index 4c8843b796950..31f95b27e227d 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.h
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_dcn401.h
@@ -169,7 +169,8 @@ struct dmub_srv;
 	DMUB_SF(HOST_INTERRUPT_CSR, HOST_REG_INBOX0_RSP_INT_EN) \
 	DMUB_SF(HOST_INTERRUPT_CSR, HOST_REG_OUTBOX0_RDY_INT_ACK) \
 	DMUB_SF(HOST_INTERRUPT_CSR, HOST_REG_OUTBOX0_RDY_INT_STAT) \
-	DMUB_SF(HOST_INTERRUPT_CSR, HOST_REG_OUTBOX0_RDY_INT_EN)
+	DMUB_SF(HOST_INTERRUPT_CSR, HOST_REG_OUTBOX0_RDY_INT_EN) \
+	DMUB_SF(DMCUB_CNTL, DMCUB_PWAIT_MODE_STATUS)
 
 struct dmub_srv_dcn401_reg_offset {
 #define DMUB_SR(reg) uint32_t reg;
-- 
2.39.5



