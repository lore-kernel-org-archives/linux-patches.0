Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BD2612D7;
	Tue, 20 Feb 2024 21:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465208; cv=none; b=N5xlfcRGmsbva3MjvwFQkNbmpOoGiZl/edzmUdtJp67xXhH2e1sgAg6+qNKjaWdoP4AqY2unOIvSyweKvwOWAVnOxr3KehBdHXRoQJ4GulijLIx1yZF/ePw5BTjkNY7aJX/lZQVXsTFn/FQo3/sB2TcoMtNA7EVyLCT7lVL6gzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465208; c=relaxed/simple;
	bh=uiUFFT1hjSTJZ5aArdi3mIlesffHqMa/BVgiU1VBJoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPZkcb8plR6Bc172Q722BVAw2QnfvXq6GmzTrmCyQJPJ1arm02V5VTBQmj8oa/pqEL8Qbg1SdcXkKO70uosTeZ72e6ixRiplBz5QqPXo8kx3PlspWKhJnACOM0Ro+G8hFZYsbpSq6gUI4cz8PP4uTjya1k4xppefZJ7TdT43nSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0b4THgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0b4THgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB112C433F1;
	Tue, 20 Feb 2024 21:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465208;
	bh=uiUFFT1hjSTJZ5aArdi3mIlesffHqMa/BVgiU1VBJoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0b4THgM0DrRgQkNVwrBAoppC5BhI+3L82a1ucMYpClGXZZJl05EvxDGPkgKdX1nS
	 XT29puNYaivJlPgJ6rvCEaVgrf7/iyZc8gEVsWb+RX9ashRORatY60/o7cmYXhefkb
	 H1lH268sYF1OhplxklGESMGoSP5RW/QJHSUpFdTM=
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
Subject: [PATCH 6.7 271/309] tools/rv: Fix Makefile compiler options for clang
Date: Tue, 20 Feb 2024 21:57:10 +0100
Message-ID: <20240220205641.617132330@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 tools/verification/rv/Makefile |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/verification/rv/Makefile
+++ b/tools/verification/rv/Makefile
@@ -28,10 +28,15 @@ FOPTS	:=	-flto=auto -ffat-lto-objects -f
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


