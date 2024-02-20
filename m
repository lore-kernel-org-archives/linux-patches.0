Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E1A14F9C8;
	Tue, 20 Feb 2024 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463144; cv=none; b=A1rr8WMe6FfSP42KQXfioYlnl2Nb+ME+VMoVsxMBhC40atKGjMN+PKeVk2/Gu/fZa9WnFCx/TsCTOQJquAV+pva1CmggHZiDWTbWd5eG8RbxZdStfLuSWLMPkfkK+Cb3YJ5mLxokoIxWMO2HcTg6uPZxsIKnc4W3+jGpg8cVTyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463144; c=relaxed/simple;
	bh=XKBSvgp6z0TdqMBw0pxx5WPzG74JHAlKEMYRH6buzd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeGg9nzKfpuTaCRgSIS6SqnKOy2nCANOSA7PUNi5X0zsT49xdx3Q1qjf8CNLg4VvqzhgJ/zzImv02p0bl82S1zZP7urNT62xvtUCLIl2Ju337CfDiF4YoAMH0BFIbXVhDf2XCmWS3lUqeDJx9RXADvWTkF7GfvAYZfenIhQ1ImI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+n02gQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+n02gQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC210C433F1;
	Tue, 20 Feb 2024 21:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463144;
	bh=XKBSvgp6z0TdqMBw0pxx5WPzG74JHAlKEMYRH6buzd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+n02gQGv4ByFvanE0OCHFYZmHvVg3hrnyvqY37CbSWDhQiNxi3M73y0EEf5DjliW
	 xNOYo4jtaGvudC+6Ascsdy6HQgnqWGFJbzY7LJESKcIrcSDIptTVaGUbnutsE7PWCB
	 rTQc9sWp0qzZChcWWF+n4FM5C5j3o6GrMlXn6ZhQ=
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
Subject: [PATCH 6.1 150/197] tools/rtla: Fix uninitialized bucket/data->bucket_size warning
Date: Tue, 20 Feb 2024 21:51:49 +0100
Message-ID: <20240220204845.563176358@linuxfoundation.org>
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

commit 64dc40f7523369912d7adb22c8cb655f71610505 upstream.

When compiling rtla with clang, I am getting the following warnings:

$ make HOSTCC=clang CC=clang LLVM_IAS=1

[..]
clang -O -g -DVERSION=\"6.8.0-rc3\" -flto=auto -fexceptions
	-fstack-protector-strong -fasynchronous-unwind-tables
	-fstack-clash-protection  -Wall -Werror=format-security
	-Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS
	$(pkg-config --cflags libtracefs)
	-c -o src/osnoise_hist.o src/osnoise_hist.c
src/osnoise_hist.c:138:6: warning: variable 'bucket' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
  138 |         if (data->bucket_size)
      |             ^~~~~~~~~~~~~~~~~
src/osnoise_hist.c:149:6: note: uninitialized use occurs here
  149 |         if (bucket < entries)
      |             ^~~~~~
src/osnoise_hist.c:138:2: note: remove the 'if' if its condition is always true
  138 |         if (data->bucket_size)
      |         ^~~~~~~~~~~~~~~~~~~~~~
  139 |                 bucket = duration / data->bucket_size;
src/osnoise_hist.c:132:12: note: initialize the variable 'bucket' to silence this warning
  132 |         int bucket;
      |                   ^
      |                    = 0
1 warning generated.

[...]

clang -O -g -DVERSION=\"6.8.0-rc3\" -flto=auto -fexceptions
	-fstack-protector-strong -fasynchronous-unwind-tables
	-fstack-clash-protection  -Wall -Werror=format-security
	-Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS
	$(pkg-config --cflags libtracefs)
	-c -o src/timerlat_hist.o src/timerlat_hist.c
src/timerlat_hist.c:181:6: warning: variable 'bucket' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
  181 |         if (data->bucket_size)
      |             ^~~~~~~~~~~~~~~~~
src/timerlat_hist.c:204:6: note: uninitialized use occurs here
  204 |         if (bucket < entries)
      |             ^~~~~~
src/timerlat_hist.c:181:2: note: remove the 'if' if its condition is always true
  181 |         if (data->bucket_size)
      |         ^~~~~~~~~~~~~~~~~~~~~~
  182 |                 bucket = latency / data->bucket_size;
src/timerlat_hist.c:175:12: note: initialize the variable 'bucket' to silence this warning
  175 |         int bucket;
      |                   ^
      |                    = 0
1 warning generated.

This is a legit warning, but data->bucket_size is always > 0 (see
timerlat_hist_parse_args()), so the if is not necessary.

Remove the unneeded if (data->bucket_size) to avoid the warning.

Link: https://lkml.kernel.org/r/6e1b1665cd99042ae705b3e0fc410858c4c42346.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Donald Zickus <dzickus@redhat.com>
Fixes: 1eeb6328e8b3 ("rtla/timerlat: Add timerlat hist mode")
Fixes: 829a6c0b5698 ("rtla/osnoise: Add the hist mode")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise_hist.c  |    3 +--
 tools/tracing/rtla/src/timerlat_hist.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -129,8 +129,7 @@ static void osnoise_hist_update_multiple
 	if (params->output_divisor)
 		duration = duration / params->output_divisor;
 
-	if (data->bucket_size)
-		bucket = duration / data->bucket_size;
+	bucket = duration / data->bucket_size;
 
 	total_duration = duration * count;
 
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -151,8 +151,7 @@ timerlat_hist_update(struct osnoise_tool
 	if (params->output_divisor)
 		latency = latency / params->output_divisor;
 
-	if (data->bucket_size)
-		bucket = latency / data->bucket_size;
+	bucket = latency / data->bucket_size;
 
 	if (!thread) {
 		hist = data->hist[cpu].irq;


