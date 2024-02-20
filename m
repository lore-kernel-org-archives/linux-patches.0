Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3496612D7;
	Tue, 20 Feb 2024 21:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465230; cv=none; b=lKqM8lIFd4l6Pduk4/+3bc9fTmLRHJxiQFwfbsl7KG+w/7r1KibDEDSmp/kZSgNXZndn9kWxxUHdtGrXW3REqBUjEV+qqKVMui9kVeum5x8+BgYA9MSTggE68QrNr08wx8BfLKFYby2usj2hth4el9W9fHtyL5unOz/bUZR5z2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465230; c=relaxed/simple;
	bh=IVjcthMK0DiLPZ2PZZG+Rc6Dl+rq7tOisruH/fHrYUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZUDHpuZa0lHAs4iubEurS/t+xXd771mSg1PYp5azZuXgQeHLnhEr1quiP5N9Tm90dsdXxjKezH1mS5k75uP6VjEUwJP9G8ZQk06KZZLNrbgO1AehFzQUu6FyQQ6FUSaukA1vt/bS/oUY0450aU5i/uHOLuMDi0rZD4OUSrKJ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvUQ4aof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvUQ4aof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2758FC433F1;
	Tue, 20 Feb 2024 21:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465230;
	bh=IVjcthMK0DiLPZ2PZZG+Rc6Dl+rq7tOisruH/fHrYUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvUQ4aofH2/zmtZv1r8pD1jzKzSLeYuKLutXFKyefOf+xe7muRI8Ynw7WEvYgUtOB
	 WVSDkVoo7rV2XM4AedZCWuMo70I3+5vJG07jo3K2wXlqpgzR33JjtS4AnBnelsSWoa
	 jU7Vho5EARfXL4NiVrfo1uuCmZGV/WrfwSU+HUhM=
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
Subject: [PATCH 6.7 277/309] tools/rtla: Fix Makefile compiler options for clang
Date: Tue, 20 Feb 2024 21:57:16 +0100
Message-ID: <20240220205641.787437751@linuxfoundation.org>
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


