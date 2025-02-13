Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDA7211468;
	Thu, 13 Feb 2025 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457954; cv=none; b=gCEyf/LyGkDT4e1m/r/XHyOL05k+hiBl4bXV9LkMr0nM8NRbv9QFIU4fIFsYhpNzjanYpgIcAgjg0HzRMZeImpuduN9O0yTuIjotfEvkxuIQr9hZOGAx7T88HM7SsExGmWP9hv0cUOO66B7yT9/BMCN+vFVL7UrCN8m9ZHVcI28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457954; c=relaxed/simple;
	bh=0qaQafI86SFbZJsDPC+W8MATH++Rqly7HYxaWC5u03Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIZ5j7tWpSe2C1ZQKGBLhcjhZOozdSqCSsdv2g3y9aKZF4zrReChlAvAeOgF1XWdQXHpdyHXohg5HYmSgOT5zm9xJNN3eXlTpnfDPQGgq6pZHv1joG4WCqdDBvgRW6P7TvJv4aR6bK53R7/H2M/sYycgfOonKN0R6+8EpVjVbT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yaOMqCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yaOMqCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2BCC4CED1;
	Thu, 13 Feb 2025 14:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457953;
	bh=0qaQafI86SFbZJsDPC+W8MATH++Rqly7HYxaWC5u03Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yaOMqCRql8H7MhRuuSf11DNGcmS3W4ls6JaPejTwh8zzrKIO6Tu5oBJp13We1zFb
	 wVlkGNf2DtJx+Nmeso/NaZuCSIvyl2olEAJYlOxLpbYZVe6sM9Er+6sIo1/qLDRklT
	 ZCi69MW670D63HuTF9hnWVyzmgUV9RDRqvAkJp0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 260/422] kbuild: Move -Wenum-enum-conversion to W=2
Date: Thu, 13 Feb 2025 15:26:49 +0100
Message-ID: <20250213142446.574045838@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


