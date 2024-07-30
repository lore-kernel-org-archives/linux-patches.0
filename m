Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3417629A2;
	Tue, 30 Jul 2024 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354914; cv=none; b=b/cMMdtpfcQfWU2sObdH9JAQcx4MgkfRVrpfv7/a4BJAlWKrPSGbn71UAFS8fD7vvf0RVpn3X7832/Hp6XjK/4kQ9UjN3h4j2E+pr2So8IWsFctgZG3Pyn7jGgXIOy7zFCF7Ua7nO7gPlX+Iuo0Y9cgFfhal2R97b+KYm4CDcJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354914; c=relaxed/simple;
	bh=8sa2zeYcgvNkNnzuO/URGpJSCOX44pgQBWKxEjZSkMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbGTNVHyEYijy7/Qi89M3BM3v2AiFr7QO0YsisKvWicuGfWeuX1YCm5I9b0NhAxU1OAsRLv3LSlBX3N+N493iz4Hpp07ycJlzqy8Gfge7HwBc8c1sHA6Up3fUbd4iQCsik15CTsTHpif1O98EfmMSGmbQpoF2K6279kyqUzIX/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pTo/Rqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pTo/Rqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EE2C32782;
	Tue, 30 Jul 2024 15:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354914;
	bh=8sa2zeYcgvNkNnzuO/URGpJSCOX44pgQBWKxEjZSkMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pTo/RqdPXu4Nc6BPl9kRHFH5um2iztROtTcQelQ4QsHIkLXcvd2LN4QIiRTh8bXe
	 sXDJrsVPaNcEE8seHD5nByBxmrphiZSs4MhSE8De3bNBLSlU0Awl8279TSKn2elzS6
	 GM/pCnfau+VQ4e7IeDhPqaLcIK9FHhW1CiHeGdQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/568] x86/kconfig: Add as-instr64 macro to properly evaluate AS_WRUSS
Date: Tue, 30 Jul 2024 17:41:57 +0200
Message-ID: <20240730151640.220231506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 469169803d52a5d8f0dc781090638e851a7d22b1 ]

Some instructions are only available on the 64-bit architecture.

Bi-arch compilers that default to -m32 need the explicit -m64 option
to evaluate them properly.

Fixes: 18e66b695e78 ("x86/shstk: Add Kconfig option for shadow stack")
Closes: https://lore.kernel.org/all/20240612-as-instr-opt-wrussq-v2-1-bd950f7eead7@gmail.com/
Reported-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://lore.kernel.org/r/20240612050257.3670768-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.assembler | 2 +-
 scripts/Kconfig.include    | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 8ad41da301e53..16d0b022d6fff 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -26,6 +26,6 @@ config AS_GFNI
 	  Supported by binutils >= 2.30 and LLVM integrated assembler
 
 config AS_WRUSS
-	def_bool $(as-instr,wrussq %rax$(comma)(%rbx))
+	def_bool $(as-instr64,wrussq %rax$(comma)(%rbx))
 	help
 	  Supported by binutils >= 2.31 and LLVM integrated assembler
diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index 3ee8ecfb8c044..3500a3d62f0df 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -33,7 +33,8 @@ ld-option = $(success,$(LD) -v $(1))
 
 # $(as-instr,<instr>)
 # Return y if the assembler supports <instr>, n otherwise
-as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o /dev/null -)
+as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) $(2) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o /dev/null -)
+as-instr64 = $(as-instr,$(1),$(m64-flag))
 
 # check if $(CC) and $(LD) exist
 $(error-if,$(failure,command -v $(CC)),C compiler '$(CC)' not found)
-- 
2.43.0



