Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09C62E339E;
	Tue, 15 Jul 2025 13:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586319; cv=none; b=KqIdCQQug33UVqYGDaDna85rr0D0RgPbFGSR73tTlgvftsBBJ3pmsxhC7Va/L3TP0Oko4xOA6lIaBchttSPZAnsr2GPDhiDjyZ4O8lfJB63iMTjkqUfpdUv8nVb8WdFEfwSjnUF9yer5eOqrXpu/u7UmEjj/YLF85R/b4b9cRrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586319; c=relaxed/simple;
	bh=rwtmENF5e1TQFqbrnlECGSw7bQyEKol+VRsj1n48Xeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipAGH3M2ghzdcLxtGj6L1nFtMau42Yx3qzSQPRlg+NLLSY+uYQ3Or2jXybs5U1hVqu9f/8bMbp5E+v5MBbBD2/vshfQqnI7TU3CATEqEq1pN46Mk5oBxjbh0T06pktHCMVrPFB6Lzno5sViPzYKaZ0UWC/vfHyP8zVgmgblZapQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1OPs0VI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1OPs0VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05319C4CEE3;
	Tue, 15 Jul 2025 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586319;
	bh=rwtmENF5e1TQFqbrnlECGSw7bQyEKol+VRsj1n48Xeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1OPs0VIDBjd12NkezH3EPXxeV3YOMVNVRw0krmwSZnS0tvMawkGDjs+vxQfOLOPB
	 PQlKpEYNixusUNE3abyxNCnBjJ7CYY2GZ/ulAFvmGSF3i8LWilwiE5xauoZbfZbVKj
	 /ZrlfdMZ+s0uw1GJh1kGPlzL0hDf7jlb2ZRdFbpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/148] kbuild: use -MMD instead of -MD to exclude system headers from dependency
Date: Tue, 15 Jul 2025 15:12:22 +0200
Message-ID: <20250715130801.124129326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 30a7729771731971839cc969d2a321e6ea7a144b ]

This omits system headers from the generated header dependency.

System headers are not updated unless you upgrade the compiler. Nor do
they contain CONFIG options, so fixdep does not need to parse them.

Having said that, the effect of this optimization will be quite small
because the kernel code generally does not include system headers
except <stdarg.h>. Host programs include a lot of system headers,
but there are not so many in the kernel tree.

At first, keeping system headers in .*.cmd files might be useful to
detect the compiler update, but there is no guarantee that <stdarg.h>
is included from every file. So, I implemented a more reliable way in
the previous commit.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 02e9a22ceef0 ("kbuild: hdrcheck: fix cross build with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Kbuild.include | 2 +-
 scripts/Makefile.host  | 4 ++--
 scripts/Makefile.lib   | 8 ++++----
 usr/include/Makefile   | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 5d247d8f1e044..82eb69f07b356 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -16,7 +16,7 @@ pound := \#
 dot-target = $(dir $@).$(notdir $@)
 
 ###
-# The temporary file to save gcc -MD generated dependencies must not
+# The temporary file to save gcc -MMD generated dependencies must not
 # contain a comma
 depfile = $(subst $(comma),_,$(dot-target).d)
 
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 4c51c95d40f47..a0a4af508f155 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -92,8 +92,8 @@ _hostcxx_flags += -I $(objtree)/$(obj)
 endif
 endif
 
-hostc_flags    = -Wp,-MD,$(depfile) $(_hostc_flags)
-hostcxx_flags  = -Wp,-MD,$(depfile) $(_hostcxx_flags)
+hostc_flags    = -Wp,-MMD,$(depfile) $(_hostc_flags)
+hostcxx_flags  = -Wp,-MMD,$(depfile) $(_hostcxx_flags)
 
 #####
 # Compile programs on the host
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index a6d0044328b1f..9339fadb6a169 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -160,22 +160,22 @@ modkern_aflags = $(if $(part-of-module),				\
 			$(KBUILD_AFLAGS_MODULE) $(AFLAGS_MODULE),	\
 			$(KBUILD_AFLAGS_KERNEL) $(AFLAGS_KERNEL))
 
-c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+c_flags        = -Wp,-MMD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 -include $(srctree)/include/linux/compiler_types.h       \
 		 $(_c_flags) $(modkern_cflags)                           \
 		 $(basename_flags) $(modname_flags)
 
-a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+a_flags        = -Wp,-MMD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(_a_flags) $(modkern_aflags)
 
-cpp_flags      = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
+cpp_flags      = -Wp,-MMD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(_cpp_flags)
 
 ld_flags       = $(KBUILD_LDFLAGS) $(ldflags-y) $(LDFLAGS_$(@F))
 
 DTC_INCLUDE    := $(srctree)/scripts/dtc/include-prefixes
 
-dtc_cpp_flags  = -Wp,-MD,$(depfile).pre.tmp -nostdinc                    \
+dtc_cpp_flags  = -Wp,-MMD,$(depfile).pre.tmp -nostdinc                    \
 		 $(addprefix -I,$(DTC_INCLUDE))                          \
 		 -undef -D__DTS__
 
diff --git a/usr/include/Makefile b/usr/include/Makefile
index e2840579156a9..6c4b79d4558d6 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -8,7 +8,7 @@
 # We cannot go as far as adding -Wpedantic since it emits too many warnings.
 UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
 
-override c_flags = $(UAPI_CFLAGS) -Wp,-MD,$(depfile) -I$(objtree)/usr/include
+override c_flags = $(UAPI_CFLAGS) -Wp,-MMD,$(depfile) -I$(objtree)/usr/include
 
 # The following are excluded for now because they fail to build.
 #
-- 
2.39.5



