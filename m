Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F81325706;
	Sun,  7 Jun 2026 10:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829920; cv=none; b=DAr61w8kfThnvjcADexyirTaUHlg/bDZQT95nw8wIVfb0mvA6pb+l95zzIa3R+5kC67mWWZqw79h7imrHpUZzwL/PtxnNozhyaJitabTuR8g7mcfjQ79XEQt/xG+7OTmGCWZ06R10LPKZQLKpjeMA823Vkk94BYNAPSNwQeeWTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829920; c=relaxed/simple;
	bh=Jx9oc48iDYPp1zvs1hAOzbcFCSz4+DPpDBEQfJCx1B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS1i1NgO233Tf/ZZdIYR4uMCfr3ecPcwq3yVUmEg1OsuESqjuPVnTJa9hJqqdZN72kLtHk5m4ZeurWLGm1SmRWu3AuQ+fsQNoZde8JvIqIyr+TkLJ9gEfrjU6PsabIbT5ePbQNW8Qwcp/M31JGE0J6IJvpbPBkhrIJu03L77kdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDTZ0SrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDTZ0SrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054651F00893;
	Sun,  7 Jun 2026 10:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829919;
	bh=1Nhfz/qyi2U9QYtWKsKUEtZILHkj0c5zX2ogwA/pKsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDTZ0SrPczVvTek6oyXDHgI8wARKUHJooM3uN1VT/b1NC35uj7tIF/3BOtwrHM2zu
	 Piyxpj+oWyQzP4U8vouzW5sbc46izkz3z0lM+z/jbWelM+UMy26ndK5SPx3zQ7xaKQ
	 7zNp/Qcz3057y9VdILg8OBP7OUnl30hsZrcM5eAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Gerst <brgerst@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 266/307] x86/boot: Disable stack protector for early boot code
Date: Sun,  7 Jun 2026 12:01:03 +0200
Message-ID: <20260607095737.475342365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
Stable-dep-of: 917e3ad3321e ("x86/kexec: Disable KCOV instrumentation after load_segments()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f7918980667a33..f42c0903ef86d4 100644
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
2.53.0



