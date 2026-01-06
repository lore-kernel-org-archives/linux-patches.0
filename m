Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28EF2D73B9;
	Tue,  6 Jan 2026 17:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721219; cv=none; b=MxUrTvjdtnKOtN2T+SIUPf/khOJi7wz45rC2h26mGc5ei6mFXDo4zPpfqLQ2p4XCkZniKg6UtgIRbh7xUhtCAOMV7Zqy9BYXqARmP+iJQ71VSTC3BMeAjmk/FZw505rvHFcDzqYPo1EGo+XsjlguW6EteDd9FczN0sEVedQgrp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721219; c=relaxed/simple;
	bh=vphJJLFJG1VdY/rc0reyg0fBkzou+iuTsqBVIzL4WSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTXXtfXvPd677z/E+rYF0KVei72sD7bjmfrBP35CYbtLbPZmxpMJh7k8MRygqw9VTjLev1phvYa88d1WH4rJSQROR4EO17PhqYK0xXrt8dkkkGe0G37AR1L4PWfS3/19BHT1RnMI2ckrf27TjxjCkYh6yq4R54ZUXpN16O83J5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpKFHti4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpKFHti4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C7C116C6;
	Tue,  6 Jan 2026 17:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721219;
	bh=vphJJLFJG1VdY/rc0reyg0fBkzou+iuTsqBVIzL4WSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BpKFHti4oB+KlcRSZw8vVaUjkVeiWQhh1KJArScyUHfG7OP6SQN/SNBltROwUIXew
	 Zpi09LruOJLLy8SvRCntQeJjNs7C4oUr7a6RrnEZmuci38602XSdmZeEc8k5dXeQ2b
	 ezeeUUyFOFfgHj0jeHchrjOgmZxiiI1nlU49Wt2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Lancelot Six <lancelot.six@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 472/567] drm/amdkfd: Trap handler support for expert scheduling mode
Date: Tue,  6 Jan 2026 18:04:14 +0100
Message-ID: <20260106170508.812372449@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Jay Cornwall <jay.cornwall@amd.com>

commit b7851f8c66191cd23a0a08bd484465ad74bbbb7d upstream.

The trap may be entered with dependency checking disabled.
Wait for dependency counters and save/restore scheduling mode.

v2:

Use ttmp1 instead of ttmp11. ttmp11 is not zero-initialized.
While the trap handler does zero this field before use, a user-mode
second-level trap handler could not rely on this being zero when
using an older kernel mode driver.

v3:

Use ttmp11 primarily but copy to ttmp1 before jumping to the
second level trap handler. ttmp1 is inspectable by a debugger.
Unexpected bits in the unused space may regress existing software.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Lancelot Six <lancelot.six@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 423888879412e94725ca2bdccd89414887d98e31)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h         |   62 +++++++++--------
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm |   37 ++++++++++
 2 files changed, 73 insertions(+), 26 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h
@@ -3640,14 +3640,18 @@ static const uint32_t cwsr_trap_gfx9_4_3
 };
 
 static const uint32_t cwsr_trap_gfx12_hex[] = {
-	0xbfa00001, 0xbfa002a2,
-	0xb0804009, 0xb8f8f804,
+	0xbfa00001, 0xbfa002b2,
+	0xb0804009, 0xb8eef81a,
+	0xbf880000, 0xb980081a,
+	0x00000000, 0xb8f8f804,
+	0x9177ff77, 0x0c000000,
+	0x846e9a6e, 0x8c776e77,
 	0x9178ff78, 0x00008c00,
 	0xb8fbf811, 0x8b6eff78,
 	0x00004000, 0xbfa10008,
 	0x8b6eff7b, 0x00000080,
 	0xbfa20018, 0x8b6ea07b,
-	0xbfa20042, 0xbf830010,
+	0xbfa2004a, 0xbf830010,
 	0xb8fbf811, 0xbfa0fffb,
 	0x8b6eff7b, 0x00000bd0,
 	0xbfa20010, 0xb8eef812,
@@ -3658,28 +3662,32 @@ static const uint32_t cwsr_trap_gfx12_he
 	0xf0000000, 0xbfa20005,
 	0x8b6fff6f, 0x00000200,
 	0xbfa20002, 0x8b6ea07b,
-	0xbfa2002c, 0xbefa4d82,
+	0xbfa20034, 0xbefa4d82,
 	0xbf8a0000, 0x84fa887a,
 	0xbf0d8f7b, 0xbfa10002,
 	0x8c7bff7b, 0xffff0000,
-	0xf4601bbd, 0xf8000010,
-	0xbf8a0000, 0x846e976e,
-	0x9177ff77, 0x00800000,
-	0x8c776e77, 0xf4603bbd,
-	0xf8000000, 0xbf8a0000,
-	0xf4603ebd, 0xf8000008,
-	0xbf8a0000, 0x8bee6e6e,
-	0xbfa10001, 0xbe80486e,
-	0x8b6eff6d, 0xf0000000,
-	0xbfa20009, 0xb8eef811,
-	0x8b6eff6e, 0x00000080,
-	0xbfa20007, 0x8c78ff78,
-	0x00004000, 0x80ec886c,
-	0x82ed806d, 0xbfa00002,
-	0x806c846c, 0x826d806d,
-	0x8b6dff6d, 0x0000ffff,
-	0x8bfe7e7e, 0x8bea6a6a,
-	0x85788978, 0xb9783244,
+	0x8b6eff77, 0x0c000000,
+	0x916dff6d, 0x0c000000,
+	0x8c6d6e6d, 0xf4601bbd,
+	0xf8000010, 0xbf8a0000,
+	0x846e976e, 0x9177ff77,
+	0x00800000, 0x8c776e77,
+	0xf4603bbd, 0xf8000000,
+	0xbf8a0000, 0xf4603ebd,
+	0xf8000008, 0xbf8a0000,
+	0x8bee6e6e, 0xbfa10001,
+	0xbe80486e, 0x8b6eff6d,
+	0xf0000000, 0xbfa20009,
+	0xb8eef811, 0x8b6eff6e,
+	0x00000080, 0xbfa20007,
+	0x8c78ff78, 0x00004000,
+	0x80ec886c, 0x82ed806d,
+	0xbfa00002, 0x806c846c,
+	0x826d806d, 0x8b6dff6d,
+	0x0000ffff, 0x8bfe7e7e,
+	0x8bea6a6a, 0x85788978,
+	0x936eff77, 0x0002001a,
+	0xb96ef81a, 0xb9783244,
 	0xbe804a6c, 0xb8faf802,
 	0xbf0d987a, 0xbfa10001,
 	0xbfb00000, 0x8b6dff6d,
@@ -3977,7 +3985,7 @@ static const uint32_t cwsr_trap_gfx12_he
 	0x008ce800, 0x00000000,
 	0x807d817d, 0x8070ff70,
 	0x00000080, 0xbf0a7b7d,
-	0xbfa2fff7, 0xbfa0016e,
+	0xbfa2fff7, 0xbfa00171,
 	0xbef4007e, 0x8b75ff7f,
 	0x0000ffff, 0x8c75ff75,
 	0x00040000, 0xbef60080,
@@ -4159,10 +4167,12 @@ static const uint32_t cwsr_trap_gfx12_he
 	0xf8000074, 0xbf8a0000,
 	0x8b6dff6d, 0x0000ffff,
 	0x8bfe7e7e, 0x8bea6a6a,
-	0xb97af804, 0xbe804ec2,
-	0xbf94fffe, 0xbe804a6c,
+	0x936eff77, 0x0002001a,
+	0xb96ef81a, 0xb97af804,
 	0xbe804ec2, 0xbf94fffe,
-	0xbfb10000, 0xbf9f0000,
+	0xbe804a6c, 0xbe804ec2,
+	0xbf94fffe, 0xbfb10000,
 	0xbf9f0000, 0xbf9f0000,
 	0xbf9f0000, 0xbf9f0000,
+	0xbf9f0000, 0x00000000,
 };
--- a/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm
+++ b/drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx12.asm
@@ -78,9 +78,16 @@ var SQ_WAVE_EXCP_FLAG_PRIV_RESTORE_PART_
 var SQ_WAVE_EXCP_FLAG_PRIV_RESTORE_PART_2_SIZE	= SQ_WAVE_EXCP_FLAG_PRIV_HOST_TRAP_SHIFT - SQ_WAVE_EXCP_FLAG_PRIV_ILLEGAL_INST_SHIFT
 var SQ_WAVE_EXCP_FLAG_PRIV_RESTORE_PART_3_SHIFT	= SQ_WAVE_EXCP_FLAG_PRIV_WAVE_START_SHIFT
 var SQ_WAVE_EXCP_FLAG_PRIV_RESTORE_PART_3_SIZE	= 32 - SQ_WAVE_EXCP_FLAG_PRIV_RESTORE_PART_3_SHIFT
+
+var SQ_WAVE_SCHED_MODE_DEP_MODE_SHIFT		= 0
+var SQ_WAVE_SCHED_MODE_DEP_MODE_SIZE		= 2
+
 var BARRIER_STATE_SIGNAL_OFFSET			= 16
 var BARRIER_STATE_VALID_OFFSET			= 0
 
+var TTMP11_SCHED_MODE_SHIFT			= 26
+var TTMP11_SCHED_MODE_SIZE			= 2
+var TTMP11_SCHED_MODE_MASK			= 0xC000000
 var TTMP11_DEBUG_TRAP_ENABLED_SHIFT		= 23
 var TTMP11_DEBUG_TRAP_ENABLED_MASK		= 0x800000
 
@@ -160,8 +167,19 @@ L_JUMP_TO_RESTORE:
 	s_branch	L_RESTORE
 
 L_SKIP_RESTORE:
+	// Assume most relaxed scheduling mode is set. Save and revert to normal mode.
+	s_getreg_b32	ttmp2, hwreg(HW_REG_WAVE_SCHED_MODE)
+	s_wait_alu	0
+	s_setreg_imm32_b32	hwreg(HW_REG_WAVE_SCHED_MODE, \
+		SQ_WAVE_SCHED_MODE_DEP_MODE_SHIFT, SQ_WAVE_SCHED_MODE_DEP_MODE_SIZE), 0
+
 	s_getreg_b32	s_save_state_priv, hwreg(HW_REG_WAVE_STATE_PRIV)	//save STATUS since we will change SCC
 
+	// Save SCHED_MODE[1:0] into ttmp11[27:26].
+	s_andn2_b32	ttmp11, ttmp11, TTMP11_SCHED_MODE_MASK
+	s_lshl_b32	ttmp2, ttmp2, TTMP11_SCHED_MODE_SHIFT
+	s_or_b32	ttmp11, ttmp11, ttmp2
+
 	// Clear SPI_PRIO: do not save with elevated priority.
 	// Clear ECC_ERR: prevents SQC store and triggers FATAL_HALT if setreg'd.
 	s_andn2_b32	s_save_state_priv, s_save_state_priv, SQ_WAVE_STATE_PRIV_ALWAYS_CLEAR_MASK
@@ -238,6 +256,13 @@ L_FETCH_2ND_TRAP:
 	s_cbranch_scc0	L_NO_SIGN_EXTEND_TMA
 	s_or_b32	ttmp15, ttmp15, 0xFFFF0000
 L_NO_SIGN_EXTEND_TMA:
+#if ASIC_FAMILY == CHIP_GFX12
+	// Move SCHED_MODE[1:0] from ttmp11 to unused bits in ttmp1[27:26] (return PC_HI).
+	// The second-level trap will restore from ttmp1 for backwards compatibility.
+	s_and_b32	ttmp2, ttmp11, TTMP11_SCHED_MODE_MASK
+	s_andn2_b32	ttmp1, ttmp1, TTMP11_SCHED_MODE_MASK
+	s_or_b32	ttmp1, ttmp1, ttmp2
+#endif
 
 	s_load_dword    ttmp2, [ttmp14, ttmp15], 0x10 scope:SCOPE_SYS		// debug trap enabled flag
 	s_wait_idle
@@ -287,6 +312,10 @@ L_EXIT_TRAP:
 	// STATE_PRIV.BARRIER_COMPLETE may have changed since we read it.
 	// Only restore fields which the trap handler changes.
 	s_lshr_b32	s_save_state_priv, s_save_state_priv, SQ_WAVE_STATE_PRIV_SCC_SHIFT
+
+	// Assume relaxed scheduling mode after this point.
+	restore_sched_mode(ttmp2)
+
 	s_setreg_b32	hwreg(HW_REG_WAVE_STATE_PRIV, SQ_WAVE_STATE_PRIV_SCC_SHIFT, \
 		SQ_WAVE_STATE_PRIV_POISON_ERR_SHIFT - SQ_WAVE_STATE_PRIV_SCC_SHIFT + 1), s_save_state_priv
 
@@ -1043,6 +1072,9 @@ L_SKIP_BARRIER_RESTORE:
 	s_and_b64	exec, exec, exec					// Restore STATUS.EXECZ, not writable by s_setreg_b32
 	s_and_b64	vcc, vcc, vcc						// Restore STATUS.VCCZ, not writable by s_setreg_b32
 
+	// Assume relaxed scheduling mode after this point.
+	restore_sched_mode(s_restore_tmp)
+
 	s_setreg_b32	hwreg(HW_REG_WAVE_STATE_PRIV), s_restore_state_priv	// SCC is included, which is changed by previous salu
 
 	// Make barrier and LDS state visible to all waves in the group.
@@ -1134,3 +1166,8 @@ function valu_sgpr_hazard
 	end
 #endif
 end
+
+function restore_sched_mode(s_tmp)
+	s_bfe_u32	s_tmp, ttmp11, (TTMP11_SCHED_MODE_SHIFT | (TTMP11_SCHED_MODE_SIZE << 0x10))
+	s_setreg_b32	hwreg(HW_REG_WAVE_SCHED_MODE), s_tmp
+end


