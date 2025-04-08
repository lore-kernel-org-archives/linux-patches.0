Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC7826981C;
	Tue,  8 Apr 2025 11:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113079; cv=none; b=NCz6Bu+PCHu9GtA67bppD2eGybOww9Owz2c4+lRtXdROSW1ALzEmWdmYo/6x736IotNAcrDmvi9H51mm2WcZo8dK6itxYiyAWNeZjrGBtLC7xOrh1LDx8kGfkbT4VP9EtO2CA5tiswQdyk0drlW6g5F+NwTXY+0JDCAgebjLiS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113079; c=relaxed/simple;
	bh=dv8RmClQFZkzfzaPbh5EyvP7PBI3/l3mp51fmm682ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jeOaa5DbZgGLyW9zpSSzSz4SG6V2se7ZwLGhY/aaKmBdjL5syH2sgw5/+WEwHoVhjuikX//gak/5fsjD6M8wON/zdvtFzKbMgL8zmwt2YEjvPwSNhqCJuWkMoMyymIDOlcZctGEV7tUIUYNXzSy+9NKNHaMIG7vzDhjlsFPV2Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0osEg1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0osEg1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74A7C4CEE5;
	Tue,  8 Apr 2025 11:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113079;
	bh=dv8RmClQFZkzfzaPbh5EyvP7PBI3/l3mp51fmm682ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0osEg1pbh41pqf+TT6B1ihSqH8dLqay66DYrqvdRtgrKOKNstkXHKR7sxbYj+A5m
	 JgQxb0z2+8vJHXkrYL4WoHMQUfZBJL7NS33rrc/feU2tuyw0RgqUuvgMvrCDWGl9cm
	 XVhNgSN+A4L/tIa5KWbPRU0LQsVxSvxKUaXn98ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Spassov <stanspas@amazon.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/268] x86/fpu: Fix guest FPU state buffer allocation size
Date: Tue,  8 Apr 2025 12:46:58 +0200
Message-ID: <20250408104828.703616026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4b414b0ab0692..db200990b5569 100644
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



