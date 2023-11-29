Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C686B4CB3A;
	Wed, 29 Nov 2023 22:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRDN1qEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC07C433C7;
	Wed, 29 Nov 2023 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701296278;
	bh=KFgXr/RumUIJadwpEcu//GyTiF0kTEm+5XAlvLCCz7E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nRDN1qEEHl7dFz/5CrWxL+r3hOnCBzr4/9zCXF9X4gp74LrAI6/zTeROZM3mYs4ob
	 c3g8vMdugy9aZ0I6f/XXFWt/W2NjaMbek0PPZM+B5TbXRz1dsMJVZgOdMh/QA9pCqN
	 6pHCSYKAy1aYymF/77P3siivTkUp3eO9fso96jF1l3WUnsCtYgBzPDBsiJ5+7iDk35
	 EpAfyCMtQJoBKiinmKJ8RM6BquawBzW5MHJSupZg0UwUH2ncH2KOlrZjjKrHmrdces
	 /o/eamEOxhWJFEnzsz4l/bYJRuV/U/uZVuBTn4D0VawMwPDMjgaKFpjB37/us+1Zor
	 Q1X241pIp8KqQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 29 Nov 2023 15:17:41 -0700
Subject: [PATCH v3 1/3] x86/tools: objdump_reformat.awk: Ensure regex
 matches fwait
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231129-objdump-reformat-llvm-v3-1-0d855e79314d@kernel.org>
References: <20231129-objdump-reformat-llvm-v3-0-0d855e79314d@kernel.org>
In-Reply-To: <20231129-objdump-reformat-llvm-v3-0-0d855e79314d@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, ndesaulniers@google.com, keescook@chromium.org, 
 samuelzeter@gmail.com, mhiramat@kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1649; i=nathan@kernel.org;
 h=from:subject:message-id; bh=zK2t0BsgpjdtAaQUa63zamoD0D6aFJDYhxA7YOLDI9o=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKnpOyYzvbzN/zgk+u1Zk/hyKYOHB0yKlJ+VCJxWi392L
 G0al/2TjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRFhOGn4yhgY//zFDyeqWV
 cvnjxocrhd8w+jYlmy3KNe6s3abjnMPI0L5a4L3cgZIp7BMfNBeXicsKPpVquS7dt+2I0LIN2mt
 WMQAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

From: Samuel Zeter <samuelzeter@gmail.com>

If there is "wait" mnemonic in the line being parsed, it is incorrectly
handled by the script, and an extra line of "fwait" in
objdump_reformat's output is inserted. As insn_decoder_test relies upon
the formatted output, the test fails.

This is reproducible when disassembling with llvm-objdump:

Pre-processed lines:
ffffffff81033e72: 9b                    wait
ffffffff81033e73: 48 c7 c7 89 50 42 82  movq

After objdump_reformat.awk:
ffffffff81033e72:       9b      fwait
ffffffff81033e72:                               wait
ffffffff81033e73:       48 c7 c7 89 50 42 82    movq

The regex match now accepts spaces or tabs, along with the "fwait"
instruction.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1364
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Samuel Zeter <samuelzeter@gmail.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/tools/objdump_reformat.awk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/tools/objdump_reformat.awk b/arch/x86/tools/objdump_reformat.awk
index f418c91b71f0..276e572a6f60 100644
--- a/arch/x86/tools/objdump_reformat.awk
+++ b/arch/x86/tools/objdump_reformat.awk
@@ -12,7 +12,7 @@ BEGIN {
 	prev_hex = ""
 	prev_mnemonic = ""
 	bad_expr = "(\\(bad\\)|^rex|^.byte|^rep(z|nz)$|^lock$|^es$|^cs$|^ss$|^ds$|^fs$|^gs$|^data(16|32)$|^addr(16|32|64))"
-	fwait_expr = "^9b "
+	fwait_expr = "^9b[ \t]*fwait"
 	fwait_str="9b\tfwait"
 }
 

-- 
2.43.0

