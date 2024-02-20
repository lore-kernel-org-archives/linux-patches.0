Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EA014AD12;
	Tue, 20 Feb 2024 21:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463147; cv=none; b=H90bL2NtVwm+9y15ja0vFLO8g15u9o592y3VHCelSlk7aJxhOjPXPYHYf5BMR+Ld0CBqp5DnOqKq/M/C9l57eC+dHFWmyRxynvp/YseOAAeuuRvwcLyb4uwQDnt4qqr6+xAlEEBYa/jVk90x75Pqr9ZFz8kpNlqCnBlQ1wkL+qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463147; c=relaxed/simple;
	bh=LrU/1AqmsWNDvct4tMHdNi37AkdnuasRlf2S75Wq/5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzYAC8QZxdL6soNT30hXQLTzLWaHZYATfFX0Dons6Y7I6mneTEc6H4wVobAWZXd9LFZboXgbW11NJWuk7A/Kj+Fd3JgOnuqaZMmxw2YehistjI1AyXjV9kFlO+GJkDkpnrRDgDcK1nyeHK6l67NXV0pONNWUlTjwKuOZitmGM04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBtnOd6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBtnOd6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD861C433C7;
	Tue, 20 Feb 2024 21:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463147;
	bh=LrU/1AqmsWNDvct4tMHdNi37AkdnuasRlf2S75Wq/5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBtnOd6HBgGYCOCnuUVvQdT+/vNidVY/gdMXCj8kScTx5ieNCQuygxN0jnb51b1Jk
	 gWyj7VmeUSqpQx6wO4MFPpQEY6cfx4jXtRuDpMhM3idx9t/cFDDztNIHMteBYhepxG
	 6ROFdQwlb9dh/I3eJuRzwVia5eSqAmipoxPg5v7U=
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
Subject: [PATCH 6.1 151/197] tools/rtla: Fix Makefile compiler options for clang
Date: Tue, 20 Feb 2024 21:51:50 +0100
Message-ID: <20240220204845.593575022@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bristot de Oliveira <bristot@kernel.org>

commit bc4cbc9d260ba8358ca63662919f4bb223cb603b upstream.

The following errors are showing up when compiling rtla with clang:

 $ make HOSTCC=clang CC=clang LLVM_IAS=1
 [...]

  clang -O -g -DVERSION=\"6.8.0-rc1\" -flto=auto -ffat-lto-objects
	-fexceptions -fstack-protector-strong
	-fasynchronous-unwind-tables -fstack-clash-protection  -Wall
	-Werror=format-security -Wp,-D_FORTIFY_SOURCE=2
	-Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
	$(pkg-config --cflags libtracefs)    -c -o src/utils.o src/utils.c

  clang: warning: optimization flag '-ffat-lto-objects' is not supported [-Wignored-optimization-argument]
  warning: unknown warning option '-Wno-maybe-uninitialized'; did you mean '-Wno-uninitialized'? [-Wunknown-warning-option]
  1 warning generated.

  clang -o rtla -ggdb  src/osnoise.o src/osnoise_hist.o src/osnoise_top.o
  src/rtla.o src/timerlat_aa.o src/timerlat.o src/timerlat_hist.o
  src/timerlat_top.o src/timerlat_u.o src/trace.o src/utils.o $(pkg-config --libs libtracefs)

  src/osnoise.o: file not recognized: file format not recognized
  clang: error: linker command failed with exit code 1 (use -v to see invocation)
  make: *** [Makefile:110: rtla] Error 1

Solve these issues by:
  - removing -ffat-lto-objects and -Wno-maybe-uninitialized if using clang
  - informing the linker about -flto=auto

Link: https://lore.kernel.org/linux-trace-kernel/567ac1b94effc228ce9a0225b9df7232a9b35b55.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Fixes: 1a7b22ab15eb ("tools/rtla: Build with EXTRA_{C,LD}FLAGS")
Suggested-by: Donald Zickus <dzickus@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/Makefile |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -28,10 +28,15 @@ FOPTS	:=	-flto=auto -ffat-lto-objects -f
 		-fasynchronous-unwind-tables -fstack-clash-protection
 WOPTS	:= 	-Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -Wno-maybe-uninitialized
 
+ifeq ($(CC),clang)
+  FOPTS := $(filter-out -ffat-lto-objects, $(FOPTS))
+  WOPTS := $(filter-out -Wno-maybe-uninitialized, $(WOPTS))
+endif
+
 TRACEFS_HEADERS	:= $$($(PKG_CONFIG) --cflags libtracefs)
 
 CFLAGS	:=	-O -g -DVERSION=\"$(VERSION)\" $(FOPTS) $(MOPTS) $(WOPTS) $(TRACEFS_HEADERS) $(EXTRA_CFLAGS)
-LDFLAGS	:=	-ggdb $(EXTRA_LDFLAGS)
+LDFLAGS	:=	-flto=auto -ggdb $(EXTRA_LDFLAGS)
 LIBS	:=	$$($(PKG_CONFIG) --libs libtracefs)
 
 SRC	:=	$(wildcard src/*.c)


