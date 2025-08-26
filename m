Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0808035206D;
	Tue, 26 Aug 2025 14:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219370; cv=none; b=FVI/ZwuyTVY9wTeqsxN7k5bbqIfp3kBsna0Bqos/x3FACrcYQav/2vQP4amZKXynxaTheIyi+ChvXnRu9R14y8CnPo5aOPsRqxEngnc1wF+5mcHf7YYXVsEOItY2zwMhnyD/btQKBDjYAGy2mm6QeGqSm6k8Jd2Bov3CCZemaOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219370; c=relaxed/simple;
	bh=/jS8Wd+Jk+DX27th5xnmNB4wLZgH9D/AcQKNK8yae4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmh4MbcgCvrB+eEMpqTahtPvuCHYPiYzQUUceijAkU8tE8WP2DVLeJSNUljwX86tyqJOQtdgmQOp1vT8zyeIFvloUTOylGeVlYUnM5Il+5jpOg6PvhgZhM8TwO/dB68pqmTy0smw+4qzo3Z8c2JBLphsOuCxe/TfLkGteWj+piY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IIxBpofs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IIxBpofs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDE3C4CEF1;
	Tue, 26 Aug 2025 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219369;
	bh=/jS8Wd+Jk+DX27th5xnmNB4wLZgH9D/AcQKNK8yae4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IIxBpofsAZ/nunhmnO1+8XLH8DrywgNBppJp2Xq7kOA5q1uP2G61ZpLeyAgoxNq6k
	 ClCqE1aVyvuLQdcZ4rnm9ZvKo2Z1a25TBGPtoZaYTMYIIclGRXQOm7Y4QbzQJF0HyK
	 L5r3v1LU8s9mMMkUo1fGHAY7pc6RaDKRrKsnBY0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 324/403] kbuild: Update assembler calls to use proper flags and language target
Date: Tue, 26 Aug 2025 13:10:50 +0200
Message-ID: <20250826110915.765579826@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Desaulniers <ndesaulniers@google.com>

commit d5c8d6e0fa61401a729e9eb6a9c7077b2d3aebb0 upstream.

as-instr uses KBUILD_AFLAGS, but as-option uses KBUILD_CFLAGS. This can
cause as-option to fail unexpectedly when CONFIG_WERROR is set, because
clang will emit -Werror,-Wunused-command-line-argument for various -m
and -f flags in KBUILD_CFLAGS for assembler sources.

Callers of as-option and as-instr should be adding flags to
KBUILD_AFLAGS / aflags-y, not KBUILD_CFLAGS / cflags-y. Use
KBUILD_AFLAGS in all macros to clear up the initial problem.

Unfortunately, -Wunused-command-line-argument can still be triggered
with clang by the presence of warning flags or macro definitions because
'-x assembler' is used, instead of '-x assembler-with-cpp', which will
consume these flags. Switch to '-x assembler-with-cpp' in places where
'-x assembler' is used, as the compiler is always used as the driver for
out of line assembler sources in the kernel.

Finally, add -Werror to these macros so that they behave consistently
whether or not CONFIG_WERROR is set.

[nathan: Reworded and expanded on problems in commit message
         Use '-x assembler-with-cpp' in a couple more places]

Link: https://github.com/ClangBuiltLinux/linux/issues/1699
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Kbuild.include |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -99,16 +99,16 @@ try-run = $(shell set -e;		\
 	fi)
 
 # as-option
-# Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
+# Usage: aflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
 
 as-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -x assembler /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) -Werror $(KBUILD_AFLAGS) $(1) -c -x assembler-with-cpp /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
-# Usage: cflags-y += $(call as-instr,instr,option1,option2)
+# Usage: aflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) -Werror $(KBUILD_AFLAGS) -c -x assembler-with-cpp -o "$$TMP" -,$(2),$(3))
 
 # __cc-option
 # Usage: MY_CFLAGS += $(call __cc-option,$(CC),$(MY_CFLAGS),-march=winchip-c6,-march=i586)


