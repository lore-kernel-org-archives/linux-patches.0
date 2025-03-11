Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A7F15820C;
	Tue, 11 Mar 2025 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706884; cv=none; b=o+uHXDJOTam55QwfSsX5F9p9n8G9RIJMT8BSezfpnvGdtDxjlCWAnAL0FurgWLc0nOhCRuk4JDAF+IDkNHX6V+Oae8DnSx7ubS7p8c7Gy2catI4BL3AGNO3Dl6kkfgs4M12/PwAGQyVjQxFPgTe4TNGQVUriCd4vS/rLOuWd7hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706884; c=relaxed/simple;
	bh=VRH0uEjLB4SvSTiFwSy/omoo0MJJKlUzjaTJvVm6eUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ9Eiac/MfRJbYXEGv2tuEvVB6xVACL0eAwvH6T3quL7VnaeuGrNMjxrIINC8WfPE3+Vhe5Pygaz9neFQ4eJpv+a7HoV3DeOpJHnxvu1g2fBl2waSvoWp/m8haScj2Ao8HQ5grU8Yxm/iwXDA5BYpVu769Din+imacTVgnPlAko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9z4sHmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9z4sHmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BCAC4CEE9;
	Tue, 11 Mar 2025 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706883;
	bh=VRH0uEjLB4SvSTiFwSy/omoo0MJJKlUzjaTJvVm6eUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9z4sHmXFPEhSpA9YG1q6u9aJMpOHIGdRTIMJ1IHr2AlQvzq/XqUpdrB5bhGhgayO
	 IZKehejlG730oqKNgg3d44YctM2hH9yfpkD/vfEYQH9Io6kFV5HRHRKwdZQg7ULoDR
	 3LCJ1iRXWj4eVqQjlPzVpvFFkELR1O1TAOGMC8jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 200/462] kbuild: Move -Wenum-enum-conversion to W=2
Date: Tue, 11 Mar 2025 15:57:46 +0100
Message-ID: <20250311145806.257500169@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,6 +37,10 @@ KBUILD_CFLAGS += -Wno-missing-field-init
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-type-limits
 
+ifdef CONFIG_CC_IS_CLANG
+KBUILD_CFLAGS += -Wno-enum-enum-conversion
+endif
+
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
 
 else
@@ -54,7 +58,6 @@ KBUILD_CFLAGS += -Wno-tautological-const
 KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 KBUILD_CFLAGS += $(call cc-disable-warning, cast-function-type-strict)
 KBUILD_CFLAGS += -Wno-enum-compare-conditional
-KBUILD_CFLAGS += -Wno-enum-enum-conversion
 endif
 
 endif


