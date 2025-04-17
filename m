Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43F118C034;
	Thu, 17 Apr 2025 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913508; cv=none; b=cYz7AMSj2WTHrgLTJmBlhuh9NN3KhGCB1W71CVKRriUPeoMuOQvcTp0F0sEhLP4ueN17cswgd/LTQUcHyYRVgGHEvxU5UTl93JknB2S4k3ypKpoBGBDtiD7VLaYCdUkevRHdaMTEHtG06lTVemat/9jz+hQJ+CTkfSq6HgpWuWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913508; c=relaxed/simple;
	bh=zjTSJ4UbahFBPGP3XIE1YUa9rhtY28HUKqxCD830BNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+kfG/QiRZBnlPPRDANsGy3lbcIZgbJc5E46zCJgyUOrK7s/VjBAiXt/md/wUXX365SSgbuQTGTHusujC94LpjYJgyqL5/dwJPvBNvo1z7L73xWtQX6brNPLnW3oeddliFdIm5Z/YzFsnRcemn4RrZCDhlAvBxLNX8o9oyj92LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faPhu5nN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faPhu5nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7552EC4CEE4;
	Thu, 17 Apr 2025 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913507;
	bh=zjTSJ4UbahFBPGP3XIE1YUa9rhtY28HUKqxCD830BNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faPhu5nNNflAuIIVddBW4OVvS4fYyqEZ7Jp1JFDkWGzCJshd4ucpmGlzEcj5IVepo
	 14pIdiEJi+1XR12xwShZ1nKTYVL4sl7QCya2OvGX90Lk+UI7VJg5L0j4d6RLSFeeLE
	 gvNSU6YSs7UNOhpGQ49I/UptuwhA7/TEBqeW9pcI=
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
Subject: [PATCH 6.14 334/449] arm64: mops: Do not dereference src reg for a set operation
Date: Thu, 17 Apr 2025 19:50:22 +0200
Message-ID: <20250417175131.621070704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/include/asm/traps.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -109,10 +109,9 @@ static inline void arm64_mops_reset_regs
 	int dstreg = ESR_ELx_MOPS_ISS_DESTREG(esr);
 	int srcreg = ESR_ELx_MOPS_ISS_SRCREG(esr);
 	int sizereg = ESR_ELx_MOPS_ISS_SIZEREG(esr);
-	unsigned long dst, src, size;
+	unsigned long dst, size;
 
 	dst = regs->regs[dstreg];
-	src = regs->regs[srcreg];
 	size = regs->regs[sizereg];
 
 	/*
@@ -129,6 +128,7 @@ static inline void arm64_mops_reset_regs
 		}
 	} else {
 		/* CPY* instruction */
+		unsigned long src = regs->regs[srcreg];
 		if (!(option_a ^ wrong_option)) {
 			/* Format is from Option B */
 			if (regs->pstate & PSR_N_BIT) {


