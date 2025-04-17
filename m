Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EFB252915;
	Thu, 17 Apr 2025 18:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914704; cv=none; b=nkwlVIl90IyQj3VOMr+aspnXDUX5C4SYEgesOuPyabNwV77a3ew2w17reCQGYhtTGNyDQU1DTcrs6+JMmkgQiLrkzzudp8ZgYCHvxVvktu01dpv/zAVjYFqOJJPfu0HHgr2mpQEOIolIO8L1xQsyO8MReMSJxmQh7AIBRfX9WO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914704; c=relaxed/simple;
	bh=EGaZ3yax8QsKE7fZY0seowdpLGXV5V1A8gXjWGj7juA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=av+uYp9Vv1E1VmzPIISa80vZW5gYpU4AGXttbolFB6y1HfIQDCVaIutIeBL8u5DjLVl5fL+cAkVmXDH7jHn659Vl8Kso8NsuIwGqqoVgFToxfkvMOcLrXeGgqomLg2YB4x0gLZ5eU2j7GjKI3112DRTOCBCURVQk1s7e8EAGkoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giTyTogZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giTyTogZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA76C4CEE7;
	Thu, 17 Apr 2025 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914703;
	bh=EGaZ3yax8QsKE7fZY0seowdpLGXV5V1A8gXjWGj7juA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giTyTogZYX6OE9eJrNn0arfBgleRJPac+Irw1mls2hbRC2ZwtUoBdReHMcJrwhvIa
	 +jDWUJYpWnbucqz8o8ZVIY/SgC+y0CWX28BVnbAxJYAnJfoVUZk6DbiOudPnmWD5j5
	 i7QcFVWaMDysYwMf5higUVGReWl6kxMd5klJVfEA=
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
Subject: [PATCH 6.13 303/414] arm64: mops: Do not dereference src reg for a set operation
Date: Thu, 17 Apr 2025 19:51:01 +0200
Message-ID: <20250417175123.618816824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


