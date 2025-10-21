Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CF6279DAB;
	Tue, 21 Oct 2025 20:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077620; cv=none; b=Bi2PQjcmkbVE9d0ClrLg0adkLP6iPWHtdT8g5trc5fJZyadObbFm8QU+KGw3IfDWs9A2GywOCiXFf5jPXURhSJHfo+zYKC3RK45tyN5o7KKAbOsnJCpe0WO2GOoesAdR5tIk11RdpT4/BGWGrrgZ3MkE1qEViK/218ZIJFcu19M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077620; c=relaxed/simple;
	bh=N7zQqSlafgBSsp2sSjATkYmM/bGCaRwnQXCV5NStkx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3j0qhx4OV7d7TAlZtyG2C8nv6aB0UuTB8LJQl7tCUeuRwuX27e4+7+qnquuc90zoeFG8jYOK5VrIzvor2S+HYEWYjO9wTtiujDwmLRzmmzSykYcsv3vTm0qDPWCckIyC9YuJ3LLBLEKEc/ZjdIk4fBFGpKkDeq9y++kJ8HPIsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsxvM5D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsxvM5D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E520DC4CEF1;
	Tue, 21 Oct 2025 20:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077620;
	bh=N7zQqSlafgBSsp2sSjATkYmM/bGCaRwnQXCV5NStkx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsxvM5D3e/uyljlYkxqiRiPZMnUhBOXYss3dPqUiiwEtaAJHgygM4J7djRX9+DhYQ
	 U46neMIpXHp5qG+4QYK6ka9F2MdqDvtBgeVbiynIpclXymsB8G05s1Hrm9G/cyfOba
	 mshcLL/B3/6Qs4QSAmuEMH94Gs11Ic6OXECYqoAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.17 138/159] arm64: debug: always unmask interrupts in el0_softstp()
Date: Tue, 21 Oct 2025 21:51:55 +0200
Message-ID: <20251021195046.461640467@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

commit ea0d55ae4b3207c33691a73da3443b1fd379f1d2 upstream.

We intend that EL0 exception handlers unmask all DAIF exceptions
before calling exit_to_user_mode().

When completing single-step of a suspended breakpoint, we do not call
local_daif_restore(DAIF_PROCCTX) before calling exit_to_user_mode(),
leaving all DAIF exceptions masked.

When pseudo-NMIs are not in use this is benign.

When pseudo-NMIs are in use, this is unsound. At this point interrupts
are masked by both DAIF.IF and PMR_EL1, and subsequent irq flag
manipulation may not work correctly. For example, a subsequent
local_irq_enable() within exit_to_user_mode_loop() will only unmask
interrupts via PMR_EL1 (leaving those masked via DAIF.IF), and
anything depending on interrupts being unmasked (e.g. delivery of
signals) will not work correctly.

This was detected by CONFIG_ARM64_DEBUG_PRIORITY_MASKING.

Move the call to `try_step_suspended_breakpoints()` outside of the check
so that interrupts can be unmasked even if we don't call the step handler.

Fixes: 0ac7584c08ce ("arm64: debug: split single stepping exception entry")
Cc: <stable@vger.kernel.org> # 6.17
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
[catalin.marinas@arm.com: added Mark's rewritten commit log and some whitespace]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ada.coupriediaz@arm.com: Fix conflict for v6.17 stable]
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry-common.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -832,6 +832,8 @@ static void noinstr el0_breakpt(struct p
 
 static void noinstr el0_softstp(struct pt_regs *regs, unsigned long esr)
 {
+	bool step_done;
+
 	if (!is_ttbr0_addr(regs->pc))
 		arm64_apply_bp_hardening();
 
@@ -842,10 +844,10 @@ static void noinstr el0_softstp(struct p
 	 * If we are stepping a suspended breakpoint there's nothing more to do:
 	 * the single-step is complete.
 	 */
-	if (!try_step_suspended_breakpoints(regs)) {
-		local_daif_restore(DAIF_PROCCTX);
+	step_done = try_step_suspended_breakpoints(regs);
+	local_daif_restore(DAIF_PROCCTX);
+	if (!step_done)
 		do_el0_softstep(esr, regs);
-	}
 	exit_to_user_mode(regs);
 }
 


