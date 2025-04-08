Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50326B2B5;
	Tue,  8 Apr 2025 12:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116195; cv=none; b=HsWk+93M7wt6KtY0GzUpFK7PTRUbkTDpD7eMZGkNyeWM7xg41Y0dztMXRX89CfX3wDLBYiZMljYJqzVSQ8z1WHK1Zm4eEf61uBApzl5ux4Lr0aTQs9+R1fOGSNDZjjNQA3dwsmgjXEfcZpT4QRwaLTLpgQFu8mBcZtqeg/N1yWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116195; c=relaxed/simple;
	bh=x8WBdLnVFSYmGsaiisaLVDIo8RRIeWsj8Y6w/wA5WA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+4ABPaP5PcnoSPKfcrAgo4ULHZ1Kc3AZdoyaWTRbozbeujPtfr+USmqwL2Nf4ig/NtwE+fk7Gw9IAF3jOzpNK2Gm5P+B9udUhMyQKS+hRIwEwn1LKWGvXigpd5zG0ojCxZSGoi5bD192YDPv/TqL1cZGTihdm2mPl154/189VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3Bo4H+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3Bo4H+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA90C4CEE5;
	Tue,  8 Apr 2025 12:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116195;
	bh=x8WBdLnVFSYmGsaiisaLVDIo8RRIeWsj8Y6w/wA5WA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3Bo4H+t2QYhImpwQ8JG2oRtsp0h5Bkb4g+V0lEeVpWeusKA1NVIEeNwTsvOU6dAs
	 nfOlEkM2uh70fFmPtJmAsUHzy0nx9I91Uj3lLbTT7eulLVSit8IKzwsKqrZYIJC4vh
	 S0iY7Gos1md/mGso0HrEsage03rAsa2jsLbVX92I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Spassov <stanspas@amazon.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/423] x86/fpu: Fix guest FPU state buffer allocation size
Date: Tue,  8 Apr 2025 12:45:36 +0200
Message-ID: <20250408104845.958918329@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Spassov <stanspas@amazon.de>

[ Upstream commit 1937e18cc3cf27e2b3ef70e8c161437051ab7608 ]

Ongoing work on an optimization to batch-preallocate vCPU state buffers
for KVM revealed a mismatch between the allocation sizes used in
fpu_alloc_guest_fpstate() and fpstate_realloc(). While the former
allocates a buffer sized to fit the default set of XSAVE features
in UABI form (as per fpu_user_cfg), the latter uses its ksize argument
derived (for the requested set of features) in the same way as the sizes
found in fpu_kernel_cfg, i.e. using the compacted in-kernel
representation.

The correct size to use for guest FPU state should indeed be the
kernel one as seen in fpstate_realloc(). The original issue likely
went unnoticed through a combination of UABI size typically being
larger than or equal to kernel size, and/or both amounting to the
same number of allocated 4K pages.

Fixes: 69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup")
Signed-off-by: Stanislav Spassov <stanspas@amazon.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250218141045.85201-1-stanspas@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 1209c7aebb211..36df548acc403 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -220,7 +220,7 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	struct fpstate *fpstate;
 	unsigned int size;
 
-	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	size = fpu_kernel_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
 	fpstate = vzalloc(size);
 	if (!fpstate)
 		return false;
-- 
2.39.5



