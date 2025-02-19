Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5DA1E2852;
	Wed, 19 Feb 2025 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954244; cv=none; b=oTGbSUqqVQQV1tN5XKSuKyb2on2ub5rrKWxhNiKjal6nGYaBZSTQprBX6mp+XQGYPYLIEUAaNKVzdMOWrV4JukmuNQPTuEUKQTgf14bHZkF8McL+7IEo/3+d5mvcMvm/LHJ9ynnw+XDHFqJxN2wWNBndnW3Uwbhty8d+q5IZcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954244; c=relaxed/simple;
	bh=P2k9zu+8fBb9RR8bBG+0h7OW1qCtb8y+zprDekD/5Dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL4KVaag19mgUHHRiZ65JiS5imaOiO79FlHJKNMw7O2bCLgYoJcx+biXVf8WpRxBkRy2qNWGIlSn01QvI4hgsbN1uMxGtnxqx4Cazv6IsuCNZh+p+UJfHGfLzov0MSEZXnxACVXBL8cu1I2118g1pU7B66FbsGhqiDEIMGvDpyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5e99GXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5e99GXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7464BC4CEE6;
	Wed, 19 Feb 2025 08:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954243;
	bh=P2k9zu+8fBb9RR8bBG+0h7OW1qCtb8y+zprDekD/5Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5e99GXh3g1tw4rLSSxWYAL/j1SPPZXRx6M3cno40lGFBocXHOf6hZIvNlIBEOOb/
	 9iT9lA2JWEIcXrhKkDYCHewQkOsyfVzCfETpM2gbj1Wi06CRbn28QcjI8a0PJQmXUP
	 YKw7WBIQZcA8kHH6l0QkaaL1YWjWKrvhICnFUPoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Jelinek <jakub@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 110/274] kbuild: Use -fzero-init-padding-bits=all
Date: Wed, 19 Feb 2025 09:26:04 +0100
Message-ID: <20250219082613.923274641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit dce4aab8441d285b9a78b33753e0bf583c1320ee ]

GCC 15 introduces a regression in "= { 0 }" style initialization of
unions that Linux has depended on for eliminating uninitialized variable
contents. GCC does not seem likely to fix it[1], instead suggesting[2]
that affected projects start using -fzero-init-padding-bits=unions.

To avoid future surprises beyond just the current situation with unions,
enable -fzero-init-padding-bits=all when available (GCC 15+). This will
correctly zero padding bits in unions and structs that might have been
left uninitialized, and will make sure there is no immediate regression
in union initializations. As seen in the stackinit KUnit selftest union
cases, which were passing before, were failing under GCC 15:

    not ok 18 test_small_start_old_zero
    ok 29 test_small_start_dynamic_partial # SKIP XFAIL uninit bytes: 63
    ok 32 test_small_start_assigned_dynamic_partial # SKIP XFAIL uninit bytes: 63
    ok 67 test_small_start_static_partial # SKIP XFAIL uninit bytes: 63
    ok 70 test_small_start_static_all # SKIP XFAIL uninit bytes: 56
    ok 73 test_small_start_dynamic_all # SKIP XFAIL uninit bytes: 56
    ok 82 test_small_start_assigned_static_partial # SKIP XFAIL uninit bytes: 63
    ok 85 test_small_start_assigned_static_all # SKIP XFAIL uninit bytes: 56
    ok 88 test_small_start_assigned_dynamic_all # SKIP XFAIL uninit bytes: 56

The above all now pass again with -fzero-init-padding-bits=all added.

This also fixes the following cases for struct initialization that had
been XFAIL until now because there was no compiler support beyond the
larger "-ftrivial-auto-var-init=zero" option:

    ok 38 test_small_hole_static_all # SKIP XFAIL uninit bytes: 3
    ok 39 test_big_hole_static_all # SKIP XFAIL uninit bytes: 124
    ok 40 test_trailing_hole_static_all # SKIP XFAIL uninit bytes: 7
    ok 42 test_small_hole_dynamic_all # SKIP XFAIL uninit bytes: 3
    ok 43 test_big_hole_dynamic_all # SKIP XFAIL uninit bytes: 124
    ok 44 test_trailing_hole_dynamic_all # SKIP XFAIL uninit bytes: 7
    ok 58 test_small_hole_assigned_static_all # SKIP XFAIL uninit bytes: 3
    ok 59 test_big_hole_assigned_static_all # SKIP XFAIL uninit bytes: 124
    ok 60 test_trailing_hole_assigned_static_all # SKIP XFAIL uninit bytes: 7
    ok 62 test_small_hole_assigned_dynamic_all # SKIP XFAIL uninit bytes: 3
    ok 63 test_big_hole_assigned_dynamic_all # SKIP XFAIL uninit bytes: 124
    ok 64 test_trailing_hole_assigned_dynamic_all # SKIP XFAIL uninit bytes: 7

All of the above now pass when built under GCC 15. Tests can be seen
with:

    ./tools/testing/kunit/kunit.py run stackinit --arch=x86_64 \
        --make_option CC=gcc-15

Clang continues to fully initialize these kinds of variables[3] without
additional flags.

Suggested-by: Jakub Jelinek <jakub@redhat.com>
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=118403 [1]
Link: https://lore.kernel.org/linux-toolchains/Z0hRrrNU3Q+ro2T7@tucnak/ [2]
Link: https://github.com/llvm/llvm-project/commit/7a086e1b2dc05f54afae3591614feede727601fa [3]
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20250127191031.245214-3-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.extrawarn | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d75897559d184..dc081cf46d211 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -82,6 +82,9 @@ KBUILD_CFLAGS += $(call cc-option,-Werror=designated-init)
 # Warn if there is an enum types mismatch
 KBUILD_CFLAGS += $(call cc-option,-Wenum-conversion)
 
+# Explicitly clear padding bits during variable initialization
+KBUILD_CFLAGS += $(call cc-option,-fzero-init-padding-bits=all)
+
 KBUILD_CFLAGS += -Wextra
 KBUILD_CFLAGS += -Wunused
 
-- 
2.39.5



