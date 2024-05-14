Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764E257CBC;
	Tue, 14 May 2024 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686217; cv=none; b=jsoQiV0pLV1ymJ24c8uhNbgiJY4/G4PHH31DuTj3RVlWr3ZjrrcD6Vy4PjMme//EXNYoBuMVzwkGU18Da22Vl7XpREeeEb9auD6+2ynAkQxZwZDN9lTLHxWUeYU+PLYxVSv4Svwbmn2UOnmxqbHuLi5tUlhis3/PjRWqC8SsLmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686217; c=relaxed/simple;
	bh=zbIvUhFPju41Phl9gJFCNba652ouMo3YXluXbOrt3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZydOrtHxgYHhlf2MBB2cuj3FVvoYZvaywTA83ESGXxRAPfb/4kLEyoZ3hX1OPAhQ0Rw2CN5qTCUQiIl2M5i/zEzUoRfkIaKAQ9+URqJPVlDXPvuKVwrXLIOzSqMmO59ZhKRXQTCQgh33t4BBjG2zGd0HTSKW3obWP7vNvZfukLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXRtZPIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXRtZPIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D6AC2BD10;
	Tue, 14 May 2024 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686217;
	bh=zbIvUhFPju41Phl9gJFCNba652ouMo3YXluXbOrt3RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXRtZPIyXNeN0017D2Qho1fQmWw1cJ0BOUW7iy4I8qmijJyelIksWIwQ0pp4DipV5
	 ifXEboC7jTKbHRNQNKPimtWiNOTABODfLo3zfhlWPt4mZMfLhE+DYL3ALk3r1W1NaB
	 p+fWSUWzxcEj177JXjRMx4gQNeVUQQvsbWYGjLBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Remus <jremus@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/236] s390/vdso: Add CFI for RA register to asm macro vdso_func
Date: Tue, 14 May 2024 12:17:04 +0200
Message-ID: <20240514101022.710711267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97f0c0a669a59..0625381359df4 100644
--- a/arch/s390/kernel/vdso64/vdso_user_wrapper.S
+++ b/arch/s390/kernel/vdso64/vdso_user_wrapper.S
@@ -23,8 +23,10 @@ __kernel_\func:
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



