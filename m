Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A63151CD6;
	Tue, 20 Feb 2024 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464014; cv=none; b=dsdPg3iq89YpVbdhio+2UaMBAKdSMmD+qui+VjQUChtWn9FI0LPAu2KRLttLIAdV4/IjjxzI/4umUNjJmOjC3FuwFmWkZkedb8+qUMDtVRAbP2uvppXr1rHhSnjxCLNI2a/YnCOS2OSyNrNEqsjiqf80Ou2MLar3aF1F17xHprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464014; c=relaxed/simple;
	bh=V3s7D5EeHbCboAKDkGSb5nwb48axuLtYD9iHvMbifUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Obv5Aolj3tSqinZhwKoRwS97N9KaI4h9nNb/vC1Wdmp8cLorYk1FTqfQPRCnjnoI8HmFgx4fWnzO0l7I1lZyETO1hoz7i8GtXWbzpJbna/3/hoO4ZzW16X7gYejro1OaC+LTGkCubXOoS75+hrx5fCATExYXGi3ho0nJ29jeEgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4sZQbBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4sZQbBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A577C433F1;
	Tue, 20 Feb 2024 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464014;
	bh=V3s7D5EeHbCboAKDkGSb5nwb48axuLtYD9iHvMbifUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4sZQbBx3zu75NSnImtHd9VRVGtmje7PYfUCABZXuHHNzYnwevRUsqAs1Otcu8QCB
	 23BgO5dV9PMKTdXxuJVxUV3oMZXvkKGhSL/rkaldgOO30tiofWAAcroONVEdgEhFMq
	 KhbByvzAxb1iYu2Xqri0vktObd+91Zv/Cj+jyU9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Donald Zickus <dzickus@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.6 225/331] tools/rv: Fix Makefile compiler options for clang
Date: Tue, 20 Feb 2024 21:55:41 +0100
Message-ID: <20240220205644.823574474@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit f9b2c87105c989a7b259c6da87673ada96dce2f8 upstream.

The following errors are showing up when compiling rv with clang:

 $ make HOSTCC=clang CC=clang LLVM_IAS=1
 [...]
  clang -O -g -DVERSION=\"6.8.0-rc1\" -flto=auto -ffat-lto-objects
  -fexceptions -fstack-protector-strong -fasynchronous-unwind-tables
  -fstack-clash-protection  -Wall -Werror=format-security
  -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS
  -Wno-maybe-uninitialized $(pkg-config --cflags libtracefs)
  -I include   -c -o src/utils.o src/utils.c
  clang: warning: optimization flag '-ffat-lto-objects' is not supported [-Wignored-optimization-argument]
  warning: unknown warning option '-Wno-maybe-uninitialized'; did you mean '-Wno-uninitialized'? [-Wunknown-warning-option]
  1 warning generated.

  clang -o rv -ggdb  src/in_kernel.o src/rv.o src/trace.o src/utils.o $(pkg-config --libs libtracefs)
  src/in_kernel.o: file not recognized: file format not recognized
  clang: error: linker command failed with exit code 1 (use -v to see invocation)
  make: *** [Makefile:110: rv] Error 1

Solve these issues by:
  - removing -ffat-lto-objects and -Wno-maybe-uninitialized if using clang
  - informing the linker about -flto=auto

Link: https://lkml.kernel.org/r/ed94a8ddc2ca8c8ef663cfb7ae9dd196c4a66b33.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Fixes: 4bc4b131d44c ("rv: Add rv tool")
Suggested-by: Donald Zickus <dzickus@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/verification/rv/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/verification/rv/Makefile b/tools/verification/rv/Makefile
index 3d0f3888a58c..485f8aeddbe0 100644
--- a/tools/verification/rv/Makefile
+++ b/tools/verification/rv/Makefile
@@ -28,10 +28,15 @@ FOPTS	:=	-flto=auto -ffat-lto-objects -fexceptions -fstack-protector-strong \
 		-fasynchronous-unwind-tables -fstack-clash-protection
 WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
 
+ifeq ($(CC),clang)
+  FOPTS := $(filter-out -ffat-lto-objects, $(FOPTS))
+  WOPTS := $(filter-out -Wno-maybe-uninitialized, $(WOPTS))
+endif
+
 TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
 
 CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS) $(EXTRA_CFLAGS) -I include
-LDFLAGS	:=	-ggdb $(EXTRA_LDFLAGS)
+LDFLAGS	:=	-flto=auto -ggdb $(EXTRA_LDFLAGS)
 LIBS	:=	$$($(PKG_CONFIG) --libs libtracefs)
 
 SRC	:=	$(wildcard src/*.c)
-- 
2.43.2



