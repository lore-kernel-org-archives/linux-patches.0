Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C099B433BE;
	Tue, 14 May 2024 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682378; cv=none; b=Gj0P4VNpeu4hTZY2audgegC557Mqqb2jY1H+eTHWgOAWeMioVIyqVljEdxHsWEJtMnm+Fbp2COtZ6+w/mxKYqMD+2eMrAXndoKipwwuvUfyRtB+PFOes579mlGsNbheKm8Uy1/wUmMCCgnoU9nezHiTPLgwpMMDW1PHtEDJwkrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682378; c=relaxed/simple;
	bh=Q4rwUbnN1VbGLNdTqydLlzNlwLy9ZYT5783x9Zo5Gds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/Z1/IZdVHbejDiHNXHJCP9HIhmraT9Zq1uN8gtikcosYHy+VsPKIIM/mkADlieiTPNasZtH/qzABslAZrvxKkh1aVxqRVwXRCKDQ7Ae8SFHKFkDgiLC9pTYfRkhcccIP/zYSRBO1FWsM/OzsUA+m9uPBNv+H7NLxhL/m8y1vDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ed5hwT5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ed5hwT5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C54CC2BD10;
	Tue, 14 May 2024 10:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682378;
	bh=Q4rwUbnN1VbGLNdTqydLlzNlwLy9ZYT5783x9Zo5Gds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed5hwT5TBrHneaxLweO4VQbUGZoencFlnnAMr7taGwXTUTBK7xStiQ9aerzfiF0bK
	 gLDjf1DxTjF4YvMo35+icvWCpyOcr6b7YllWn3FlEgCaaMrCI8p9nxb6NcKHbihQFY
	 74YTTCVh+3eSHcAwa9qilqrMDsCdLmC/5aLVg070=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 051/336] s390/vdso: Add CFI for RA register to asm macro vdso_func
Date: Tue, 14 May 2024 12:14:15 +0200
Message-ID: <20240514101040.533112057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Remus <jremus@linux.ibm.com>

[ Upstream commit b961ec10b9f9719987470236feb50c967db5a652 ]

The return-address (RA) register r14 is specified as volatile in the
s390x ELF ABI [1]. Nevertheless proper CFI directives must be provided
for an unwinder to restore the return address, if the RA register
value is changed from its value at function entry, as it is the case.

[1]: s390x ELF ABI, https://github.com/IBM/s390x-abi/releases

Fixes: 4bff8cb54502 ("s390: convert to GENERIC_VDSO")
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/dwarf.h               | 1 +
 arch/s390/kernel/vdso64/vdso_user_wrapper.S | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/s390/include/asm/dwarf.h b/arch/s390/include/asm/dwarf.h
index 4f21ae561e4dd..390906b8e386e 100644
--- a/arch/s390/include/asm/dwarf.h
+++ b/arch/s390/include/asm/dwarf.h
@@ -9,6 +9,7 @@
 #define CFI_DEF_CFA_OFFSET	.cfi_def_cfa_offset
 #define CFI_ADJUST_CFA_OFFSET	.cfi_adjust_cfa_offset
 #define CFI_RESTORE		.cfi_restore
+#define CFI_REL_OFFSET		.cfi_rel_offset
 
 #ifdef CONFIG_AS_CFI_VAL_OFFSET
 #define CFI_VAL_OFFSET		.cfi_val_offset
diff --git a/arch/s390/kernel/vdso64/vdso_user_wrapper.S b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
index 57f62596e53b9..85247ef5a41b8 100644
--- a/arch/s390/kernel/vdso64/vdso_user_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
@@ -24,8 +24,10 @@ __kernel_\func:
 	CFI_DEF_CFA_OFFSET (STACK_FRAME_OVERHEAD + WRAPPER_FRAME_SIZE)
 	CFI_VAL_OFFSET 15, -STACK_FRAME_OVERHEAD
 	stg	%r14,STACK_FRAME_OVERHEAD(%r15)
+	CFI_REL_OFFSET 14, STACK_FRAME_OVERHEAD
 	brasl	%r14,__s390_vdso_\func
 	lg	%r14,STACK_FRAME_OVERHEAD(%r15)
+	CFI_RESTORE 14
 	aghi	%r15,WRAPPER_FRAME_SIZE
 	CFI_DEF_CFA_OFFSET STACK_FRAME_OVERHEAD
 	CFI_RESTORE 15
-- 
2.43.0



