Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB0D1BB6B4;
	Tue, 30 Jul 2024 15:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355064; cv=none; b=qwODpWmwzc7g6gGkqmdz3Lg11/LOeo9vtlExECOWebqBLy3QF+nLJNQmx1WyIybEyptcVug3XTVehxtT9mgacMA0EwuDMvbNyYZ/m342+ZMfsPcWoMGFJyYvF/+FCRAnM14Fi8MK+4itMkgSG1DRQSd54ViS2ikyguxZJaDJxQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355064; c=relaxed/simple;
	bh=f6uWlieRgYdVKEVvB8l/ka1HzEByQsyqV2MgC6Bztp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3xAxrTE1pc8aJ61x1lCEEGrSvXx8rxbBUDF2Q+WCCyKAEXWdyNrPxIjYMlYYfwlFHf/lKzyHTYraVkMbZn+ZVLCEQW1VTiqtbO6U3zKe6T50LaHtpzJhAIa8k0kFwppVdY/FLUkvgJ9vQvYUYJOJVBW4pAkb3pMe9rT5o8RSNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lon6aHEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lon6aHEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C24AC32782;
	Tue, 30 Jul 2024 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355064;
	bh=f6uWlieRgYdVKEVvB8l/ka1HzEByQsyqV2MgC6Bztp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lon6aHEjlFtjEMk6ISb/F4ubRZqYvcg+gXvabgPkOD7XCipWdkVqQTjRROuwDwX3W
	 rws7VUILp1s+NyXmCCVwL5zWFmg0ptlN7JAiqQZhJtsl1JmXzhe4pb37X/6AYENp4x
	 sHq5n603QcFQurC6uWCU0oUFdA82GDZ4IbsXl5+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 016/809] x86/kconfig: Add as-instr64 macro to properly evaluate AS_WRUSS
Date: Tue, 30 Jul 2024 17:38:12 +0200
Message-ID: <20240730151725.301481360@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 59aedf32c4eaa..6d20a6ce0507d 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -36,6 +36,6 @@ config AS_VPCLMULQDQ
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



