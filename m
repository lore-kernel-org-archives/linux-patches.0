Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A4226B080;
	Thu, 13 Feb 2025 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459507; cv=none; b=Thb6pt3tz4pGU1vLl1V3vQfmmL1jSJHIGXD/bW2zDOqqqKxEbhULDFviGrNJQd0D8WrkVxM5wacZEfatEzw777KYv8HLDmwuWi4hOmKut4/uC0nsL7jKmF26c4yzLMRMu0ayEp8QKkY/XTirbE1o0SRqmZh0wvtbmJ3kG1TBtSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459507; c=relaxed/simple;
	bh=AuxTdjiR63C4qKam2flALtCV/JM2l1JNtX5t3xsG4u0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhVWqFYjtCUK9lFmq3o7DVgSZN3Ozw1H5F06Q3D3w82UG3x+2vW55wqYs7grKJeLAEO1MC1VmWFs8i0UgQY6Gx3UnNuuu0l1oVQNS9C1i/q7RShzljx2Nmr9Eg5SgFep8rMl+6Xga+2BopWJLdagV8gs1LfkyXuxw/QO6T2ct0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STjau+3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STjau+3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C0C4CEE4;
	Thu, 13 Feb 2025 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459507;
	bh=AuxTdjiR63C4qKam2flALtCV/JM2l1JNtX5t3xsG4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STjau+3nrPgt/Hgq3+y6PmwKGunxJTTPFS28jqyEZkOFy6Wk40ywBd+ixevrR2WQm
	 7lX6jbuE7yoqOMCb2sbT5O4wGG4xx0vgEN2Lf9GdD/UfKf8D8RoS6FCXCmngM8Obva
	 a6e39uEeYUBSgy57uvBTG4JAlPslwTuD9Auy5SMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.13 286/443] kbuild: Move -Wenum-enum-conversion to W=2
Date: Thu, 13 Feb 2025 15:27:31 +0100
Message-ID: <20250213142451.649026129@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 8f6629c004b193d23612641c3607e785819e97ab upstream.

-Wenum-enum-conversion was strengthened in clang-19 to warn for C, which
caused the kernel to move it to W=1 in commit 75b5ab134bb5 ("kbuild:
Move -Wenum-{compare-conditional,enum-conversion} into W=1") because
there were numerous instances that would break builds with -Werror.
Unfortunately, this is not a full solution, as more and more developers,
subsystems, and distributors are building with W=1 as well, so they
continue to see the numerous instances of this warning.

Since the move to W=1, there have not been many new instances that have
appeared through various build reports and the ones that have appeared
seem to be following similar existing patterns, suggesting that most
instances of this warning will not be real issues. The only alternatives
for silencing this warning are adding casts (which is generally seen as
an ugly practice) or refactoring the enums to macro defines or a unified
enum (which may be undesirable because of type safety in other parts of
the code).

Move the warning to W=2, where warnings that occur frequently but may be
relevant should reside.

Cc: stable@vger.kernel.org
Fixes: 75b5ab134bb5 ("kbuild: Move -Wenum-{compare-conditional,enum-conversion} into W=1")
Link: https://lore.kernel.org/ZwRA9SOcOjjLJcpi@google.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.extrawarn |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -130,7 +130,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
-KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif
@@ -154,6 +153,10 @@ KBUILD_CFLAGS += -Wno-missing-field-init
 KBUILD_CFLAGS += -Wno-type-limits
 KBUILD_CFLAGS += -Wno-shift-negative-value
 
+ifdef CONFIG_CC_IS_CLANG
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
+endif
+
 ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif


