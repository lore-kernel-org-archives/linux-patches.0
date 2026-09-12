Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56C6369224;
	Sat, 12 Sep 2026 09:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203792; cv=none; b=pZiIQcB/EIQocpmC1NFNUVASu+cQJQkzH8UXxSvg3XVi+Q+qmwMnaK2TpieVVBEnQJDDMv6xNMDKNYOrMpsJEal+n2VxXorZNuaQ3umcVHFBkHPCZEUs4soXR8jldMYnB2AUXUzeAXlAcReyZUmiULNyN7SfAykZYTNmbTuS6VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203792; c=relaxed/simple;
	bh=mVdIgygDZ/i4O3KEZMFGlrNissJrRcPwiSyKhfbKzu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drri8mN/a5LgToR2AE4b7RbMqgNZ0hyucbURPAXRj7JkbLkvC+3GUx0m6269pEHOmd8uNkl7JmGkA9Ex5dbVcSPgpng3GdH3bHNgE94AmH5WApkdaMk7IMPhOKfZ9iYpprUEBNkJsKjIpZeEkGzFn75wksv5scYbUlCcm4rfPc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0k9P0Ia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0k9P0Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E01F000FF;
	Sat, 12 Sep 2026 09:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203791;
	bh=1qkdfHnSeyev0WiC3Q6/QtR3/KqVyJ16A9GoZnpfwMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0k9P0IaOO6pGipUKtyZSuTGCAKmNMYGu7Vl0RJeP52WPujNQCHEQlSwdv9UFe9Ac
	 DdQGp9Lc2DWS8xsuuS700AVi5ps1a+/9eintFE3ZKNVvWFBHKW7yXUlUOGKHCPliQ3
	 PN7En53QlmtPiZfM9iElpRDZLvDqjZHkhcHV28To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1463/1815] selftests/bpf: Fix selftest build after filter.h update
Date: Sat, 12 Sep 2026 08:53:33 +0200
Message-ID: <20260912065723.355414465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit a2b83a8c8430b5a4cb43a1671c62535afcfce78d ]

Upstream commit 7a1f400ff5e5 ("tools: Ensure tools copy of
linux/filter.h exports the UAPI") caused selftests/bpf build to
fail [1] with:

  In file included from progs/arena_atomics.c:9:
  /codebuild/output/src2365462129/src/actions-runner/_work/bpf/bpf/tools/testing/selftests/bpf/../../../include/linux/filter.h:9:10: fatal error: 'uapi/linux/filter.h' file not found
      9 | #include <uapi/linux/filter.h>
        |          ^~~~~~~~~~~~~~~~~~~~~
  1 error generated.
    CLNG-BPF [test_progs] bind_perm.bpf.o
  make: *** [Makefile:888: /codebuild/output/src2365462129/src/actions-runner/_work/bpf/bpf/tools/testing/selftests/bpf/arena_atomics.bpf.o] Error 1
  make: *** Waiting for unfinished jobs....
    GEN-OBJ  [libarena] libarena.bpf.o
    GEN-SKEL [libarena] libarena.skel.h
  make: Leaving directory '/codebuild/output/src2365462129/src/actions-runner/_work/bpf/bpf/tools/testing/selftests/bpf'
  Process completed with exit code 2.

BPF selftest programs include the tools header directly, but
BPF_CFLAGS only exposes tools/include/uapi. Compiler therefore cannot
resolve the nested UAPI include.

Add tools/include after tools/include/uapi in BPF_CFLAGS. This
preserves the existing UAPI header precedence while allowing tools
headers to include uapi headers.

[1] https://github.com/kernel-patches/bpf/actions/runs/31806678733/job/94787271162

Fixes: 7a1f400ff5e5 ("tools: Ensure tools copy of linux/filter.h exports the UAPI")
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260814173522.2783625-1-ihor.solodrai@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 55d394438705a..5ae24ee101007 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -464,7 +464,7 @@ endif
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
 BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
-	     -I$(CURDIR)/libarena/include				\
+	     -I$(TOOLSINCDIR) -I$(CURDIR)/libarena/include		\
 	     -I$(abspath $(OUTPUT)/../usr/include)			\
 	     -std=gnu11		 					\
 	     -fno-strict-aliasing 					\
-- 
2.53.0



