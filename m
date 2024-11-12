Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E041320EA2D;
	Tue, 12 Nov 2024 10:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407527; cv=none; b=TV29Q6Ag2kFzTJG/nKjutkZGWaiDoeeo7KsszdPz9K9f87E/EQ9zBv2BCgMaJ/Nu9arj0XKvz8He5hy33WTInr8M3G9G1nbGbIGa8zojrmHHzS9Wr6jAedig2FYdQ+Yhkd+A9qi1Utd/gQZ/pcZYqyKVLceowOA75GSlEu1g5Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407527; c=relaxed/simple;
	bh=9bPAjIX56uwVg8wRMbdN2fZOVJgA5Vm+lfwwyNJC2R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcE7ZmU1frm70VD7q2OSggkbH+7Tf3ufdMXawQGQjrrYNlKw7WekTUig14x7+hA5SXPXqtL6rT4JwC1T0m0mEgtI1ZrxQaB1zuTVaQcGsIo7NpRRb8SQSHvlucaYE95GBUW7I49cSBohvYFhMvXL0f/+ek4n9b8+hOTblKkynQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuDdLTBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuDdLTBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62865C4CED4;
	Tue, 12 Nov 2024 10:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407526;
	bh=9bPAjIX56uwVg8wRMbdN2fZOVJgA5Vm+lfwwyNJC2R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuDdLTBca+6J4HzPaZnHAdWM46s6GaNfMTf+9v98Km39qt51JcRl4gzRuAQaLazNA
	 jLS5+M3LjvuRFeysoYtTV0XjgnBtpNPmq3zCYSqcmQ44g4n16SDfN8tfzd8312Zp3e
	 jdqlk/laKYd8j75GNV6bFZSxGMPXgWzw4xHbT38k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mahmoud Adam <mngyadam@amazon.com>
Subject: [PATCH 6.1 79/98] kselftest/arm64: Initialise current at build time in signal tests
Date: Tue, 12 Nov 2024 11:21:34 +0100
Message-ID: <20241112101847.262352209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 6e4b4f0eca88e47def703f90a403fef5b96730d5 upstream.

When building with clang the toolchain refuses to link the signals
testcases since the assembly code has a reference to current which has
no initialiser so is placed in the BSS:

  /tmp/signals-af2042.o: in function `fake_sigreturn':
  <unknown>:51:(.text+0x40): relocation truncated to fit: R_AARCH64_LD_PREL_LO19 against symbol `current' defined in .bss section in /tmp/test_signals-ec1160.o

Since the first statement in main() initialises current we may as well
fix this by moving the initialisation to build time so the variable
doesn't end up in the BSS.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20230111-arm64-kselftest-clang-v1-4-89c69d377727@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/arm64/signal/test_signals.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/testing/selftests/arm64/signal/test_signals.c
+++ b/tools/testing/selftests/arm64/signal/test_signals.c
@@ -12,12 +12,10 @@
 #include "test_signals.h"
 #include "test_signals_utils.h"
 
-struct tdescr *current;
+struct tdescr *current = &tde;
 
 int main(int argc, char *argv[])
 {
-	current = &tde;
-
 	ksft_print_msg("%s :: %s\n", current->name, current->descr);
 	if (test_setup(current) && test_init(current)) {
 		test_run(current);


