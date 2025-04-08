Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851FE1FBCB2;
	Tue,  8 Apr 2025 11:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110305; cv=none; b=pElFLvgTTi40p37LnzDvPr/MgsyVLT1edhp3kqVzYCRpc/xIAQjJtQlKQVJcAeDTrm6srkuBya5FM2OvyqcD+SVaKBAO/gfvu43f2KYDEHQyagHKHxajOBZczBsDpQNGx85HVcWJvJcq4geq8isH601UdY2feMpufwjJVYkqheQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110305; c=relaxed/simple;
	bh=xOROn5HtkrK6hdawbmVVKpm1lvXHyDkp3jy6k2sDkj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEmX/BZAHsEhhtjHjh6opbeSCCKPDOhl/Xr9FQg/FOV06mGo7j+NCm7ks6cJoJELb6HqYOe3ICDrzjDEL45CiyTT6gYe+MDrPblAoOsPdujBmnLSZA5cH51kTOTSME+bejMui8QXM0fGcivFIH7DXgSRAzwXn3AV1F1TyWw3eIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFxCpCCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFxCpCCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131EDC4CEE7;
	Tue,  8 Apr 2025 11:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110305;
	bh=xOROn5HtkrK6hdawbmVVKpm1lvXHyDkp3jy6k2sDkj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFxCpCCrAa+bImUP4tpcc5LRmJFXfxDOOlnR+BwjS+VuYUNOdIBpfy51sHhkhSWG5
	 bEvlCLHLVe+T9Ac2dCha3iEDDkIu5ku4CL8SjLhHjxFYt97Q4T/u7jG/nAxnKXXMbK
	 GVrTUBmH5MsUDa1q5fBX+dqP3xlna4fYqG7hPwnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Spassov <stanspas@amazon.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 016/731] x86/fpu: Fix guest FPU state buffer allocation size
Date: Tue,  8 Apr 2025 12:38:33 +0200
Message-ID: <20250408104914.638611096@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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



