Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC9C125B2;
	Mon,  9 Feb 2026 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647836; cv=none; b=pkg8D4d1wfxH9La5DC6RToqa6oF7EeHuhwnRSPmIhSEDeRIPTuASfmlEuBKrO9qaMRHzGdbEVNeTQwlaOV3zHye/01Fe4la51E9oBWdnhLNeQjM342m1UMOAonkMx/uJ3M5EodXF97LyCSN5WoF9pID8jLVU9VFt0VFs5IiInB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647836; c=relaxed/simple;
	bh=tRmGc22vd1qdtqErgYl5x3ckrvKVxRFTNh5KQMmeAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+sYLdExjrffSCuWO4OnA36lTLnbu9Af95k5Gr9823Wpg9/N3GSUWIZ8HvccRoaFfD+Al0mn02xj1g4Ug0+qXEOkPWyDB/zv8sjVuP3KdZiV6eupDppMxjf99VkBmyjcwMsFz4eJT4iyl8IjG7ona//5L1CQbXOhm6/Ixrl9nIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvKBM0Oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvKBM0Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12689C116C6;
	Mon,  9 Feb 2026 14:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647836;
	bh=tRmGc22vd1qdtqErgYl5x3ckrvKVxRFTNh5KQMmeAXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvKBM0Oaye6t2ow1KKAI+S/08292RReixTBtYzIZ/o5PLhePvBv0dY5L5AWyHe4XV
	 VBN9ljiB9tQ8mBInb7kmXZPX6di1PYVXt07OqnAP9AzQGL9NG73tGh1KOzNeNqC8MR
	 nI9j+c3H/t0Dn1sv/qJ5l0rQnKaehEwSlmP2W86Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Gerlach <lukas.gerlach@cispa.de>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/113] riscv: Sanitize syscall table indexing under speculation
Date: Mon,  9 Feb 2026 15:23:12 +0100
Message-ID: <20260209142311.753862435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Lukas Gerlach <lukas.gerlach@cispa.de>

[ Upstream commit 25fd7ee7bf58ac3ec7be3c9f82ceff153451946c ]

The syscall number is a user-controlled value used to index into the
syscall table. Use array_index_nospec() to clamp this value after the
bounds check to prevent speculative out-of-bounds access and subsequent
data leakage via cache side channels.

Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
Link: https://patch.msgid.link/20251218191332.35849-3-lukas.gerlach@cispa.de
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 80230de167def..47afea4ff1a8d 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -339,8 +339,10 @@ void do_trap_ecall_u(struct pt_regs *regs)
 
 		add_random_kstack_offset();
 
-		if (syscall >= 0 && syscall < NR_syscalls)
+		if (syscall >= 0 && syscall < NR_syscalls) {
+			syscall = array_index_nospec(syscall, NR_syscalls);
 			syscall_handler(regs, syscall);
+		}
 
 		/*
 		 * Ultimately, this value will get limited by KSTACK_OFFSET_MAX(),
-- 
2.51.0



