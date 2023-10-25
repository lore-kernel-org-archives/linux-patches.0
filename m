Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD761A29F;
	Wed, 25 Oct 2023 17:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sko4Z2dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8124C433C8;
	Wed, 25 Oct 2023 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698254506;
	bh=Dc1DV8LrDzEF5Fm79ag/CEvG7l8MFk55p7SvmLsQ/8s=;
	h=From:Date:Subject:To:Cc:From;
	b=sko4Z2dKG8pIE9+uzvICRMvyUqgzAs7xkStx5qogZIfTmLA2qUHmaofiEvjUtWtIM
	 wAhBVTaps+E5FFR3CaoIwdjiniLg73T6gUSxWnmhc1fgRWsOZJ68KCM5H8O9icwGCv
	 Fzd/5doSGwAHEIgvaKMy5HZOXAccFoakhxRPyMSetczczumcnh7pJmckTe4/NVSRXs
	 Q7kTx8qNqX6bT6/V3Z7If9TDfggHVsMcH1+CMGLbqwZ+Axp31B6j92PTFdr8/PHIjp
	 krhSTPOz8ZwyywuGiUuDzxM4RWnZPgycRFUdqY8US5tmvEpEU2hbS0Oa8/VSHBAkVU
	 ekGbpCTmV2n8Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 25 Oct 2023 10:21:28 -0700
Subject: [PATCH] arm64: Restrict CPU_BIG_ENDIAN to GNU as or LLVM IAS 15.x
 or newer
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231025-disable-arm64-be-ias-b4-llvm-15-v1-1-b25263ed8b23@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJdOOWUC/x2NSQrDMAwAvxJ0rsD7oV8pPViNnAictFgQAiZ/j
 +lxGJjpoNyEFZ5Th8aHqHz3AfYxwWfN+8Io82BwxnlrXMRZNFNlzG1LAWn4rEgBaz02tBEpFW+
 KLy4Qw6j8Ghc5/4fX+7pu6TPQZ3EAAAA=
To: catalin.marinas@arm.com, will@kernel.org
Cc: mark.rutland@arm.com, ndesaulniers@google.com, trix@redhat.com, 
 linux-arm-kernel@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1315; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Dc1DV8LrDzEF5Fm79ag/CEvG7l8MFk55p7SvmLsQ/8s=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKmWfisnhkxU7fs1f4ndyVcHAgvqZF54fnXNe/KkYsWaw
 ++8lwcwdJSyMIhxMMiKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJLD/PyHDWMcPmg/nEyCum
 0VwLWrc9f3D88Ofz+1nMbJdN3/8u53cnI8OmGWvu356xdU/t9rBg7ht7ZwhtmC1VmDM5acVdy+l
 LImYxAAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

A recent refactoring in the arm64 tree exposed an assembler bug in LLVM
with regards to the generation of NOPs for arm64 big endian, resulting
in near-immediate crashes on boot in QEMU.

Restrict CONFIG_CPU_BIG_ENDIAN to a known good assembler, which is
either GNU as or LLVM's IAS 15.0.0 and newer, which contains the linked
commit.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1948
Link: https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index adf2f8a327be..92d33ece4c45 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1360,6 +1360,8 @@ choice
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
 	depends on !LD_IS_LLD || LLD_VERSION >= 130000
+	# https://github.com/llvm/llvm-project/commit/1379b150991f70a5782e9a143c2ba5308da1161c
+	depends on AS_IS_GNU || AS_VERSION >= 150000
 	help
 	  Say Y if you plan on running a kernel with a big-endian userspace.
 

---
base-commit: 22e877699642285c47f5d7d83b2d59815c29ebe8
change-id: 20231025-disable-arm64-be-ias-b4-llvm-15-b6f30f3f24be

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

