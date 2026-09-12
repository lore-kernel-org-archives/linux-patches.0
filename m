Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ADE369990;
	Sat, 12 Sep 2026 09:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204926; cv=none; b=Qb66gU8EXbQlK/25CJH+D4iO/Vw8QXIYN3mFPjHz4TgTySqW3BQbeAI6CsUb9YOIlKNU2jZUv0VbKVtVuhlDPwT2sLAPQ3R5g6KIR5GnfaEfWAOsmp0XF+CT32nTU48CRCgF/Bx0zkou/+9E+v5m1VioCXRvUfaJ+8HbMqF7W3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204926; c=relaxed/simple;
	bh=0ov+hljo2PDFHHg8+QE58pqFPFysiAyw9aEd0Oa07As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpwCiOpeMnwkPvPcwmFZnAfMmcpDbJYPy5T/BmwO74gnFdYmIBfw6AcXrnKoxH6yrznCp6ohyxIn5RwXVCQ+0DqdefSyq1DHna0OlNrQwkfGRmTScaGP4C6ud17mnUOA1GvSGF2espK+NMfCUkIoKqxixLm3AAwWmRynkEu4BWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Do75uvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Do75uvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052EF1F000FF;
	Sat, 12 Sep 2026 09:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204925;
	bh=3zJmao7eLpouIu/Lu+NWxkmcwAhQXu+FvbizZ2tDSdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Do75uvIF2+dc1gtuWgWhuuzAWQ6Zbk8FLYQVQVC+slzBnh/hcggHdBBJvzWOj5Xf
	 uwxDeogP5386kc/5v96AHmvrAwdcJuWG1YihqafSkAE/ddre3C09jyDx/kKL1Dm+IM
	 OGd4xk+8Lj2mTUTPBJjDjtwN7lX4lQLmD39CMqeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1713/1815] arm64: process: Fix context switching MTE store-only tag check
Date: Sat, 12 Sep 2026 08:57:43 +0200
Message-ID: <20260912065729.189449507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <vladimir.murzin@arm.com>

[ Upstream commit b8f070ac3167595069feb1f794c127b805115645 ]

SCTLR_EL1.TCSO0 is set when user opt-in for MTE store-only tag check
mode. However, it is not part of SCTLR_USER_MASK which imply that on
context switch we never clear SCTLR_EL1.TCSO0, so we are leaking that
setting into another task.

Fix that by including SCTLR_EL1_TCSO0_MASK into SCTLR_USER_MASK

Fixes: 4d51ff5bba00 ("arm64/kernel: Support store-only mte tag check")
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index c2a627f393144..6dfbcacd9ba09 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -264,7 +264,7 @@ static inline void task_set_sve_vl_onexec(struct task_struct *task,
 
 #define SCTLR_USER_MASK                                                        \
 	(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCTLR_ELx_ENDB |   \
-	 SCTLR_EL1_TCF0_MASK)
+	 SCTLR_EL1_TCF0_MASK | SCTLR_EL1_TCSO0_MASK)
 
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
-- 
2.53.0



