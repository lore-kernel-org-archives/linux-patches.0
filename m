Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A779527CCF0;
	Tue, 27 May 2025 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367560; cv=none; b=nMSQA9aAeUhZoPye6uMd/Z0XB3+MwUKE9T2eLRfHef2lSUcAWUKa+JS/2YSKzFOJum2s0B3xrpImqALVevwu1P+PuRh077lfafSbvcDEhF+4Whq4CnazzoFiSpLA2pWN7ug+Tx6YseDGKEs5nQY8b431UhN3MY6g9gVcWWfZNeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367560; c=relaxed/simple;
	bh=I2TZYDGk8iAgR/cSktuCls1myrtpd3TXDVCCxrl4wXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf8KmIMWo4gOvCuBpDjOKy/enRNf+LP3VeKunk8uNPDnyeJ/Gwd42Uwt/X0HVl0ixcwuFgKO6OgwFRcyjoyDuW7r4WzcJluSVeJbRQ54ImeowWTBiG1u5MVpPyWhL4jgJc+TkCPtCKc+OBW5yKXFFwK0b0Fe+Mb0ENMS4DESi4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjdfkVZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjdfkVZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CC2C4CEE9;
	Tue, 27 May 2025 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367558;
	bh=I2TZYDGk8iAgR/cSktuCls1myrtpd3TXDVCCxrl4wXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjdfkVZo+7D7Nm2s2BgHf6Y/33C/v1T+sy1ps1qb87b6HYm6HNkZ3+Gt+3aXgCiIU
	 eNx9SOxRSzIREahkgYoiV4mseZkieN+8IJaYJu0muxzaYCdAZdlQqhl1IfItE8+kOp
	 LYejxxNMYCT0+91G+5H24Jl+U4tE51Xw1cYLtgUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 426/783] x86/boot: Disable stack protector for early boot code
Date: Tue, 27 May 2025 18:23:43 +0200
Message-ID: <20250527162530.470565771@linuxfoundation.org>
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

From: Brian Gerst <brgerst@gmail.com>

[ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]

On 64-bit, this will prevent crashes when the canary access is changed
from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses from
the identity-mapped early boot code will target the wrong address with
zero-based percpu.  KASLR could then shift that address to an unmapped
page causing a crash on boot.

This early boot code runs well before user-space is active and does not
need stack protector enabled.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b43eb7e384eba..84cfa179802c3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
 
+CFLAGS_head32.o := -fno-stack-protector
+CFLAGS_head64.o := -fno-stack-protector
 CFLAGS_irq.o := -I $(src)/../include/asm/trace
 
 obj-y			+= head_$(BITS).o
-- 
2.39.5



