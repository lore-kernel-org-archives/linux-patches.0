Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBAA1DFE14;
	Wed, 19 Feb 2025 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957061; cv=none; b=EHqDz0OsqxA0MxpFBMfoEyNoYXynAIuGMmsFHfkpK+d8OSl8wou7wpWrzrIxqL2xRXCf2RvYDp5FhdOLsoZunWrZrOxHcgHyS51srg/+jygMseomu8/CeIvoBe2Top297KCW2dmZEuSYbU50Ad3Fj4xI8WE5S258qlpv3lQU36k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957061; c=relaxed/simple;
	bh=2aH7fhHMWpMgc9lwCb5UVW8aufeJf5zGhMG6AQaMMQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnRWzHfR54ioqDH45IiNnXmOcT8qSKplujPeHyVnM3d3N37x/vDRRlz3tdl6jtulsOz55nZ0d06XT9DO1KiNxldrmT8bA8LyrnlS85obLfnsJtAGPiHkqXOXLwli+Y8DHeh34AuYaGhY9ykW91BxLgsH9zHCMH2d0o8XHr1ISw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2f2teIDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2f2teIDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83558C4CED1;
	Wed, 19 Feb 2025 09:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957060;
	bh=2aH7fhHMWpMgc9lwCb5UVW8aufeJf5zGhMG6AQaMMQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2f2teIDphEEVDZkGTHg7gBjKq6ER6z/iaJVsvYrhQ+tUdRlNtRQZhcygeVxXty/07
	 0tINP1ns3JQDA2bBmmkKJDAdcV2dBCw+38ocAJLuOXmefDvKh62Fn4U2Ark/2KvF99
	 I+3+WhgSHSrgN91jmmjBh/iKyiS15yYeLyE2uHt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 395/578] kbuild: Move -Wenum-enum-conversion to W=2
Date: Wed, 19 Feb 2025 09:26:39 +0100
Message-ID: <20250219082708.564302392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,6 +38,10 @@ KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-type-limits
 KBUILD_CFLAGS += -Wno-shift-negative-value
 
+ifdef CONFIG_CC_IS_CLANG
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
+endif
+
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
 else
@@ -66,7 +70,6 @@ KBUILD_CFLAGS += -Wno-tautological-const
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
-KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif


