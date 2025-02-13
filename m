Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F0B26B098;
	Thu, 13 Feb 2025 15:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460629; cv=none; b=OvBFzT0yaGAGsrqQo0axmVYMQkTFz2y5g3Ij6JDvnsSZ9mbqD8+JFdIP1aUBigleEGxeVecOk+ng6wPvC45sia6WU1xB1UFZPD7+6lsJwtk1gIQsYpXN+i/p2znLQN/mFNUyfbRBZcY8KxOwoG2IoiGbNU7iBXv4x0v8Ae/qwPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460629; c=relaxed/simple;
	bh=Tz/iim0aZ/B8Ql4pvO26A01tW+xpw8uXll7hm+YoOho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZu2w9fpdCw0kBguue0O1hvH3fuIeyGbpNcUm3kCPkTbUmhkt9jgENTkExY10Uht4mEapfFs66eVqCCJXWk+dtiphXWHqWYJukfS9YY9AU1LgU8MeTO7hH9CTSEkW0b2oajf7PW6uU6AraxXhff3AlmSX7EaccYB/B+pnFLllIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0qHtCe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0qHtCe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A0C4CEE5;
	Thu, 13 Feb 2025 15:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460628;
	bh=Tz/iim0aZ/B8Ql4pvO26A01tW+xpw8uXll7hm+YoOho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0qHtCe1RMTDV0X5/hZFxn3C5Y9fnCR/rPI5V5XKxwbtbpA+8L+m9xSR0YvABqKKp
	 d3OXGJ8jhsgAYdrdCGzHSKcJ3wuOXrzOe9ewI8Iw+zfwwACfSpGZ0sDFclyML5aSN4
	 BS/bwUCp3RyGKTk05XE7bTMaHdSkkgjp8zHZwKPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 166/273] kbuild: Move -Wenum-enum-conversion to W=2
Date: Thu, 13 Feb 2025 15:28:58 +0100
Message-ID: <20250213142413.890897882@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,7 +144,6 @@ KBUILD_CFLAGS += -Wno-tautological-const
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
-KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif
@@ -176,6 +175,10 @@ KBUILD_CFLAGS += -Wno-type-limits
 KBUILD_CFLAGS += -Wno-shift-negative-value
 
 ifdef CONFIG_CC_IS_CLANG
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
+endif
+
+ifdef CONFIG_CC_IS_CLANG
 KBUILD_CFLAGS += -Wno-initializer-overrides
 else
 KBUILD_CFLAGS += -Wno-maybe-uninitialized


