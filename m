Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED062698AE;
	Tue,  8 Apr 2025 12:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115597; cv=none; b=ltCbcVg4dEPSeqRfs3CPAxkmOK6YANlUjjepQ9aomziWSkMeN7i0e2CFzJblxvlWwgB9EXkE4SeoCQ7UldqCp40vpw38YdzGwzgGnrgJIyf5MpOQOChEo6v6UdKqiX1RvzozwaOB66GC0bsDOv6gofe8Nk4GNYaUWYF6HeLV0XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115597; c=relaxed/simple;
	bh=6TKCyjYMbtH8v55URAKgdggVWb9HMu5p6QdKa0umPJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWJI9nsFtWiO54s0dLio9vyoKXMgPlo16Jc8Q2YBM2efFvRBH76LSxT+S+OhdNvjFqJzBfwriQajSK+CZTGlvEhndg+T21Kz3pvV2Ud7ywtCoyjLh5bkrnzOZEHd+TAwxwDBzk7f/Dns/wKh+qzJWOD1FzXt8klnNTsuMSbZKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TApcQ5mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TApcQ5mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E5BC4CEEA;
	Tue,  8 Apr 2025 12:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115597;
	bh=6TKCyjYMbtH8v55URAKgdggVWb9HMu5p6QdKa0umPJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TApcQ5mY9GxkMJ/SPEzEAfNsGoxK0I8zPOWpTt8SCTu85e8CjJ+BJnlKLRo1NBwjA
	 HZPA6Cr45FZmgiiHceAd5cND6VEIxNMlhOS2vObVfwysff4b3LtxO5IfLWEsGaW3gn
	 scEvKB+DR45TucVUUSbgT5lGEdP/1AnKPHuJh02k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Spassov <stanspas@amazon.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/204] x86/fpu: Fix guest FPU state buffer allocation size
Date: Tue,  8 Apr 2025 12:48:56 +0200
Message-ID: <20250408104820.478987021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f1446f532b17b..cbaa3afdd223f 100644
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



