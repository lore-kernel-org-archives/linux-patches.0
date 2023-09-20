Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E66168A9
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBB9C433C8;
	Wed, 20 Sep 2023 12:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214016;
	bh=Mi8brR+j9h9EyPvu/PcGfQVwyz++fSg+ogHFkfsOB3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYz+j9Py0R5LrWaiGPNGyxvbbrUoRNd64eTZQP8BymUWDzVPPyBTo7d6gcvDBoJo2
	 HJqfNGjwcGSTaaXigOGXniEA9au3NMFWSbjUYxPrdq0Wymwn0RMXSNOs3otBVuTikx
	 o1flF/RgVdVRC0iRi8UzfHctgruvG8mWQlnAgQ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/110] x86/purgatory: Remove LTO flags
Date: Wed, 20 Sep 2023 13:32:19 +0200
Message-ID: <20230920112833.450985490@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit 75b2f7e4c9e0fd750a5a27ca9736d1daa7a3762a ]

-flto* implies -ffunction-sections. With LTO enabled, ld.lld generates
multiple .text sections for purgatory.ro:

  $ readelf -S purgatory.ro  | grep " .text"
    [ 1] .text             PROGBITS         0000000000000000  00000040
    [ 7] .text.purgatory   PROGBITS         0000000000000000  000020e0
    [ 9] .text.warn        PROGBITS         0000000000000000  000021c0
    [13] .text.sha256_upda PROGBITS         0000000000000000  000022f0
    [15] .text.sha224_upda PROGBITS         0000000000000000  00002be0
    [17] .text.sha256_fina PROGBITS         0000000000000000  00002bf0
    [19] .text.sha224_fina PROGBITS         0000000000000000  00002cc0

This causes WARNING from kexec_purgatory_setup_sechdrs():

  WARNING: CPU: 26 PID: 110894 at kernel/kexec_file.c:919
  kexec_load_purgatory+0x37f/0x390

Fix this by disabling LTO for purgatory.

[ AFAICT, x86 is the only arch that supports LTO and purgatory. ]

We could also fix this with an explicit linker script to rejoin .text.*
sections back into .text. However, given the benefit of LTOing purgatory
is small, simply disable the production of more .text.* sections for now.

Fixes: b33fff07e3e3 ("x86, build: allow LTO to be selected")
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Link: https://lore.kernel.org/r/20230914170138.995606-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/purgatory/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index dc0b91c1db04b..7a7701d1e18d0 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -19,6 +19,10 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 # optimization flags.
 KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%,$(KBUILD_CFLAGS))
 
+# When LTO is enabled, llvm emits many text sections, which is not supported
+# by kexec. Remove -flto=* flags.
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO),$(KBUILD_CFLAGS))
+
 # When linking purgatory.ro with -r unresolved symbols are not checked,
 # also link a purgatory.chk binary without -r to check for unresolved symbols.
 PURGATORY_LDFLAGS := -e purgatory_start -nostdlib -z nodefaultlib
-- 
2.40.1



