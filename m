Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465BE1F19A;
	Mon,  2 Oct 2023 19:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F9EC433C8;
	Mon,  2 Oct 2023 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696276354;
	bh=+548pRRoJGnyq+La0+LmV2WoZSprlMO8hwf3zOhMwFk=;
	h=From:Date:Subject:To:Cc:From;
	b=EqWiZsTStPaTnLlG9Ln2clf5JhEUOwWSlMzPCtk4SJrcNKfaOPuRDpDojq0zQwdan
	 nfi4nA+wX8mlV0tc6uwgc4BZB+Xv0terRZxA+2HJF/TUrRkE9tqoWTG2Y71U1x8nNc
	 QRXdav27RnFhVkZVxyuT3LEutXi6JCYLnV3uo7l03ExaEyihCppDzoD12aDSBbPeTL
	 wRtGScA8HkXP6Ie9r0rgntcaf5Swu2pgQzzwkaZ7DbQkkjYjPh+Cq9vmEaLZO/b5yN
	 bo1xyjfX3FkR+SupPk6GkP/51ns2GbgSNebtR/FHYCmIpR7vyEVZ07TZThNxu26BDc
	 Wo2nHLe24lAfA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 02 Oct 2023 12:52:28 -0700
Subject: [PATCH] kbuild: Disable clang's
 -Wformat-{overflow,truncation}-non-kprintf
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231002-disable-wformat-truncation-overflow-non-kprintf-v1-1-35179205c8d9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHsfG2UC/x3NMQ6DMAyF4asgz7UUEoaoV6k6BOJQqzRBToBKi
 LvX6vgN/3snVBKmCvfuBKGdK5es6G8dTK+QZ0KOarDGut4Yi5FrGBfCIxX5hIZNtjyFphmWnSQ
 t5cCseK/CuSU0zpGPfhwiedDVVSjx9//4eF7XD8W1K/mBAAAA
To: masahiroy@kernel.org, ndesaulniers@google.com
Cc: nicolas@fjasle.eu, trix@redhat.com, linux-kbuild@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2683; i=nathan@kernel.org;
 h=from:subject:message-id; bh=+548pRRoJGnyq+La0+LmV2WoZSprlMO8hwf3zOhMwFk=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnS8k3mUdGPhA8usu6/ktx2yOy/1VRpSy/H73UvrP4Fs
 PrOyPraUcrCIMbBICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACbCy8/IsGnJ821tzOET4noy
 45wCVkjkODCXvV/M+C6GY/nyJl8DQYb/rteaSzWrOVLs1MrPsgc4cbTvdll3fIXm7Ed7pFdyK+h
 xAwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Recently, clang added support for -Wformat-overflow and
-Wformat-truncation. When building the kernel, it was discovered that
clang's implementation of these warnings handles the '%p' specifier,
which differs from GCC's implementation. This results in false positive
warnings due to the kernel's various '%p' extensions. Fortunately, the
clang developers placed this warning difference into a separate flag,
allowing the kernel to turn off the warning for '%p' unconditionally.

This is not currently an issue for a normal build, as -Wformat-overflow
and -Wformat-truncation are unconditionally disabled, which includes
this sub-warning. However, ever since commit 6d4ab2e97dcf ("extrawarn:
enable format and stringop overflow warnings in W=1"), these warnings
are in W=1 and the goal is to enable them in the normal build once they
are all eliminated. Disable the warnings for W=1 to avoid false
positives. This block should move with -Wformat-overflow and
-Wformat-truncation when they are enabled for a normal build.

Link: https://github.com/ClangBuiltLinux/linux/issues/1923
Link: https://github.com/llvm/llvm-project/issues/64871
Link: https://github.com/llvm/llvm-project/pull/65969
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=78512
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 scripts/Makefile.extrawarn | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 2fe6f2828d37..bad1baa2cfb4 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -106,6 +106,13 @@ KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
 KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
 KBUILD_CFLAGS += $(call cc-option, -Wformat-overflow)
 KBUILD_CFLAGS += $(call cc-option, -Wformat-truncation)
+# Clang checks for overflow/truncation with '%p', while GCC does not:
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=111219
+# The kernel has many extensions to '%p' that clang does not understand, so
+# always disable these warnings when '-Wformat-truncation' and
+# '-Wformat-overflow' are enabled.
+KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow-non-kprintf)
+KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation-non-kprintf)
 KBUILD_CFLAGS += $(call cc-option, -Wstringop-overflow)
 KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
 

---
base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
change-id: 20231002-disable-wformat-truncation-overflow-non-kprintf-033e8d8b4de8

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

