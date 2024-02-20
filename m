Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873BF152E11;
	Tue, 20 Feb 2024 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464034; cv=none; b=lkGJLCH5Q+emtXfphNLg6sYDHZh3KJ53eb8jNFEUqQ0TyvHX8mOb7V4k4NLO8KQPk13iNqkQjKDydTnCed234TqrFPhD6kRdSqpqVWBTR+MVo2vUlUiiXF890sOZfN89qVOJ1w6Bqn+xQmFnsiHxFxdHLfUnYjzAnmD9Be2sOj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464034; c=relaxed/simple;
	bh=8MvRY5buUueUKFjmGGmq0512sd3Qw7HBBx8mPXul0y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1fh84pSTkHvVmcuF22lkn0TVKYPOoftk/hzo0ynpX7vww3LCESl3sXnUxYwn017HwC+iQ3P1S02CIEWUYtYB7rX295L/93aIQUHD8dAZkTp3gzNFiWLPI9vswGhEWUnUaU0kqy5Z8mZFVuglKMcMtgdCicX1SP3L4NHLltPutA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vhc0Jjoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vhc0Jjoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2192CC433C7;
	Tue, 20 Feb 2024 21:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464032;
	bh=8MvRY5buUueUKFjmGGmq0512sd3Qw7HBBx8mPXul0y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vhc0JjozngKk+Y0poIwK+tOSLKpvxG3wpVpLrZBTr0tqqC49BaPxBoyuDTiXLIX0V
	 YiIfdRbnH29yvFa7/m30hvWyaD/ZyKsgV5nwEORtj6XPJCIcfecaSw3NKfBH2iVLEo
	 bd9Lw2wkjg4/qDbBXYPdFtJ3FYEP9kVcd+U4hd3E=
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
Subject: [PATCH 6.6 230/331] tools/rtla: Fix uninitialized bucket/data->bucket_size warning
Date: Tue, 20 Feb 2024 21:55:46 +0100
Message-ID: <20240220205645.010064239@linuxfoundation.org>
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
@@ -135,8 +135,7 @@ static void osnoise_hist_update_multiple
 	if (params->output_divisor)
 		duration = duration / params->output_divisor;
 
-	if (data->bucket_size)
-		bucket = duration / data->bucket_size;
+	bucket = duration / data->bucket_size;
 
 	total_duration = duration * count;
 
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -178,8 +178,7 @@ timerlat_hist_update(struct osnoise_tool
 	if (params->output_divisor)
 		latency = latency / params->output_divisor;
 
-	if (data->bucket_size)
-		bucket = latency / data->bucket_size;
+	bucket = latency / data->bucket_size;
 
 	if (!context) {
 		hist = data->hist[cpu].irq;


