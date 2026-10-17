Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7252D73A6;
	Sat, 17 Oct 2026 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256886; cv=none; b=eN8SnrXXTdDIdpt/wKv9cnGA6aGX31/6VyYgdDyzBQM6CPxdRJFghVVsvWj9I2AzUSgx2iIvTchaKQj5ewlGtNb3eVN/sQBIbMrZr5G6HpgXkQPkVMHhQJEFwn3d5wPFhR8a7LfB5Cyz3Vhwrh+TZhycmdfuWxNamH/oivuIyBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256886; c=relaxed/simple;
	bh=PmsqaCEBVRfs/j9qp0ne0VAWAd8jJX/NhqmneHjo4Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw5+EWYLVPVN0blnGFuqD93BymiSjptd1d0W+8uDf2VwiO7L1VAQAMUECfl+G4bve1UckcZyG0qn/ZDX9GQgRPY4dijFRx9zeKxEUaIQ4AJ0wQi26wuVwUiRSdR4bvT+5H/gCYic+Y81ocGAfp9ilv4k72youlDwK+O50Gpo2Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tf/D1/Gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tf/D1/Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACD61F000C4;
	Sat, 17 Oct 2026 17:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256885;
	bh=tp4xbBMTvQJLp48KHb8UbBLXamDZRP/ZyIJURllpvdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf/D1/GrQdpkiZdk+JJNfcRl0P0W+SdkH+82qE/8DQ0m/WeFs5MGcET/xaPYXAYEl
	 gYrdBh5X0wtfkb7Hnz+W4KwAHdsgXtvrGpSAOSNqgnUoLOZu/FzUX9G58VY0Onyl6G
	 vrsO7Fe+CCHd8Yzeu+FKLXNU+axhI6SKv3ZuvT4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0381/1674] arm64/fpsimd: signal: Forbid non-streaming SVE payload on SME-only systems
Date: Sat, 17 Oct 2026 17:44:13 +0200
Message-ID: <20261017160440.895181838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit e060d9069b49fe55f38057dfe592068014652671 ]

When system_supports_sme() is true but system_supports_sve() is false,
restoring a specifically crafted SVE signal context can result in the
task erroneously having non-streaming SVE state. Subsequent attempts to
manipulate the task's FPSIMD/SVE/SME state can result in a variety of
problems, including fatal EL1 UNDEFs.

In such configurations, the kernel always creates an SVE signal context
when delivering a signal, and this can only be in one of two states:

(1) SVE_SIG_FLAG_SM is set, and an SVE payload is present containing
    streaming mode SVE state. The recorded VL is the task's live
    streaming VL.

(2) SVE_SIG_FLAG_SM is clear, and an SVE payload is not present. The
    FPSIMD context contains the non-streaming mode FPSIMD state. The
    recorded VL is 0.

Currently restore_sve_fpsimd_context() correctly rejects cases where
SVE_SIG_FLAG_SM is set and an SVE payload is not present, but fails to
reject cases where SVE_SIG_FLAG_SM is clear and an SVE payload is
present. Consequently, restore_sve_fpsimd_context() can place the task
in a state where it has non-streaming SVE state even when this is not
supported by HW.

For example, this can cause a later EL1 UNDEF when the kernel attempts to
restore the task's ZCR_EL1 value:

| # ./sme-sigcontext-to-sve
| Internal error: Oops - Undefined instruction: 0000000002000000 [#1]  SMP
| Modules linked in:
| CPU: 0 UID: 0 PID: 131 Comm: sme-sigcontext- Not tainted 7.3.0-rc1 #1 PREEMPT
| Hardware name: linux,dummy-virt (DT)
| pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
| pc : fpsimd_restore_current_state+0x258/0x458
| lr : exit_to_user_mode_loop+0xb8/0x188
| sp : ffff80008056be40
| x29: ffff80008056be40 x28: fff00000c1670000 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: ffff80008056bec0 x22: 0000000000000008 x21: 0000000000000040
| x20: 0000000000000081 x19: 0000000008800010 x18: 0000000000000000
| x17: 0000fffffd412570 x16: 0000000000001000 x15: 0000fffffd4123b0
| x14: 0000fffffd412780 x13: 0000fffffd412be8 x12: 0000000047435300
| x11: 0000fffffd412570 x10: 0000000000000000 x9 : 0000000045585401
| x8 : fff00000c18a6c44 x7 : 0000000000000000 x6 : 0000000000000002
| x5 : 0000000000000002 x4 : ffff800080568000 x3 : 0000000000000001
| x2 : 0000000008800010 x1 : fff00000c1670000 x0 : 0000000008800000
| Call trace:
|  fpsimd_restore_current_state+0x258/0x458 (P)
|  exit_to_user_mode_loop+0xb8/0x188
|  el0_svc+0x1cc/0x1d0
|  el0t_64_sync_handler+0xa0/0xe4
|  el0t_64_sync+0x198/0x19c
| Code: d5384101 f9400020 53175c03 36b80de0 (d5381202)
| ---[ end trace 0000000000000000 ]---
| Kernel panic - not syncing: Oops - Undefined instruction: Fatal exception in interrupt
| Kernel Offset: 0x291fb1000000 from 0xffff800080000000
| PHYS_OFFSET: 0x40000000
| CPU features: 0x0,00000000,0052802f,ffb88f43,3afcf73f
| Memory Limit: none

Rework restore_sve_fpsimd_context() to reject cases where
SVE_SIG_FLAG_SM is clear and an SVE payload is not present. As
parse_user_sigframe() rejects SVE signal frames when neither SVE nor SME
are supported, it isn't necessary for restore_sve_fpsimd_context() to
handle the case where neither are supported.

Fixes: 7dde62f0687c  ("arm64/signal: Always accept SVE signal frames on SME only systems")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/signal.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 032afb40dfa77..506d4b9f725c1 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -286,6 +286,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	unsigned int vl, vq;
 	struct user_fpsimd_state fpsimd;
 	u16 user_vl, flags;
+	bool fpsimd_only;
 	bool sm;
 
 	if (user->sve_size < sizeof(*user->sve))
@@ -296,19 +297,33 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (err)
 		return err;
 
+	fpsimd_only = (user->sve_size == sizeof(*user->sve));
 	sm = flags & SVE_SIG_FLAG_SM;
+
 	if (sm) {
 		if (!system_supports_sme())
 			return -EINVAL;
 
+		/*
+		 * Streaming SVE state is always preserved with an SVE payload.
+		 * Only accept streaming state which has an SVE payload.
+		 */
+		if (fpsimd_only)
+			return -EINVAL;
+
 		vl = task_get_sme_vl(current);
 	} else {
 		/*
-		 * A SME only system use SVE for streaming mode so can
-		 * have a SVE formatted context with a zero VL and no
-		 * payload data.
+		 * Non-streaming SVE state may be preserved without an SVE
+		 * payload, in which case all state is saved in the FPSIMD
+		 * context.
+		 *
+		 * On SME-only systems, non-streaming (FPSIMD-only) state is
+		 * always preserved without an SVE payload, and with VL==0. On
+		 * such systems, only accept non-streaming state without an SVE
+		 * payload.
 		 */
-		if (!system_supports_sve() && !system_supports_sme())
+		if (!system_supports_sve() && !fpsimd_only)
 			return -EINVAL;
 
 		vl = task_get_sve_vl(current);
@@ -317,16 +332,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (user_vl != vl)
 		return -EINVAL;
 
-	/*
-	 * Non-streaming SVE state may be preserved without an SVE payload, in
-	 * which case the SVE context only has a header with VL==0, and all
-	 * state can be restored from the FPSIMD context.
-	 *
-	 * Streaming SVE state is always preserved with an SVE payload. For
-	 * consistency and robustness, reject restoring streaming SVE state
-	 * without an SVE payload.
-	 */
-	if (!sm && user->sve_size == sizeof(*user->sve))
+	if (fpsimd_only)
 		return restore_fpsimd_context(user);
 
 	vq = sve_vq_from_vl(vl);
-- 
2.53.0



