Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C7E2571DE;
	Thu, 17 Apr 2025 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915943; cv=none; b=hGUBGNY3XjXsDR8Pv0/9dmsoW38FLBo0fCnYOasJoLrKcTBnUfVF/NU4FzaPBR03A7OkjZ0vGtRL8U39K8sZUx6G11AZ+3naKo9mmqIQdhbd6kTzDP40tGjWyHZWbVMaNebgO/gf5MXBym4lwQ0b0ZDOItcMsKGTYu9Gkgc5SJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915943; c=relaxed/simple;
	bh=INkbw7bu2Bb+ERSTOnOvubQ7zCygHBA66TdHnqpQBNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHO04xPxtUuMeETwzmMSXHvaiL2e8emD7cv/Nl+o3H0LsXZURNOATg6i1r2y9yDD7kRrHZxpFBY8RH/PsZd3NVWKhoAycTMeIXq6Lj9jFPPHobT8WkVV4g849vgfOLj2eYHhrFcecUACPIRo5aXwaLe0dvt3k+c6pBpqxKKbtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7UTeGO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7UTeGO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA93C4CEE4;
	Thu, 17 Apr 2025 18:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915943;
	bh=INkbw7bu2Bb+ERSTOnOvubQ7zCygHBA66TdHnqpQBNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7UTeGO7+/B56DxqaUIHo581ZxAi7BiIrPMAqo2UguB0Dc25PnCgW7Mgec1PkLi+I
	 /ntkvyXHVM7wlo/SJajyPlgOfxyrmOLFsTsPIjI3Ei5YgYLPS1Kl3XlKX1Tddl2l+k
	 +9/XifITCP76wa2wgDR43VajvYzWu9+mEYgArW2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Keir Fraser <keirf@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 284/393] arm64: mops: Do not dereference src reg for a set operation
Date: Thu, 17 Apr 2025 19:51:33 +0200
Message-ID: <20250417175119.032182140@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keir Fraser <keirf@google.com>

commit a13bfa4fe0d6949cea14718df2d1fe84c38cd113 upstream.

The source register is not used for SET* and reading it can result in
a UBSAN out-of-bounds array access error, specifically when the MOPS
exception is taken from a SET* sequence with XZR (reg 31) as the
source. Architecturally this is the only case where a src/dst/size
field in the ESR can be reported as 31.

Prior to 2de451a329cf662b the code in do_el0_mops() was benign as the
use of pt_regs_read_reg() prevented the out-of-bounds access.

Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
Cc: <stable@vger.kernel.org> # 6.12.x
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Keir Fraser <keirf@google.com>
Reviewed-by: Kristina Martšenko <kristina.martsenko@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250326110448.3792396-1-keirf@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/traps.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
index d780d1bd2eac..82cf1f879c61 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -109,10 +109,9 @@ static inline void arm64_mops_reset_regs(struct user_pt_regs *regs, unsigned lon
 	int dstreg = ESR_ELx_MOPS_ISS_DESTREG(esr);
 	int srcreg = ESR_ELx_MOPS_ISS_SRCREG(esr);
 	int sizereg = ESR_ELx_MOPS_ISS_SIZEREG(esr);
-	unsigned long dst, src, size;
+	unsigned long dst, size;
 
 	dst = regs->regs[dstreg];
-	src = regs->regs[srcreg];
 	size = regs->regs[sizereg];
 
 	/*
@@ -129,6 +128,7 @@ static inline void arm64_mops_reset_regs(struct user_pt_regs *regs, unsigned lon
 		}
 	} else {
 		/* CPY* instruction */
+		unsigned long src = regs->regs[srcreg];
 		if (!(option_a ^ wrong_option)) {
 			/* Format is from Option B */
 			if (regs->pstate & PSR_N_BIT) {
-- 
2.49.0



