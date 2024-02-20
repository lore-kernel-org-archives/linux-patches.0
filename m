Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593BC612D7;
	Tue, 20 Feb 2024 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465205; cv=none; b=bTwMMDIiXXumvjWkCozX7Kz/A5wRAixzAgDuugV63BkWR0EQwH2eMmBz+ZXeZ+ni9RWR24YEgnMNwAHHKx8NoZMwl15p97GDrFTl36EWFGUigSdWsyrTZ3MqqSCJ/U+JqVUh/RMtMdWavOCOlG+LjmZm9l1LvVK2og4PTog5CZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465205; c=relaxed/simple;
	bh=WoSEjZ/zdWqmp25KCMyA4B7g/S/bD4L371gUM2mjceI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zzb+3kYXWnmj8emKWgIJsOcXnpiAmOoWfgbnhm/3krTGNPP6dSAlBZxM+WmBOhyruPQubUpnQKS4lnlaUK0y9R63SYGHwuQPYlulnaHOHEIyjW+jk7XU0yMJFcxaFLdLWMubgLjGbchSB1rVokZUd5Ci2BCkOu7IrVJ4Z4qP84k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qimRxR2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qimRxR2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA75BC433F1;
	Tue, 20 Feb 2024 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465205;
	bh=WoSEjZ/zdWqmp25KCMyA4B7g/S/bD4L371gUM2mjceI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qimRxR2ykz7pgO+kg6CVkv+jJXpHdPVsmdKTqMcpBy8HNobeq71NxR8Xhzl/N8iD+
	 Te0sMMDPW+eRXT7okqbVtvM6ILV8uiGTViYv/DzuNzsT6FLsxKTuYsAjQtC4LFDDyO
	 nIpVX39p3z3JngVsVylNrMPqLqSSRyY+4K9ket1c=
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
Subject: [PATCH 6.7 270/309] tools/rv: Fix curr_reactor uninitialized variable
Date: Tue, 20 Feb 2024 21:57:09 +0100
Message-ID: <20240220205641.588504779@linuxfoundation.org>
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

commit 61ec586bc0815959d3314cf7ce242529c977b357 upstream.

clang is reporting:

$ make HOSTCC=clang CC=clang LLVM_IAS=1

clang -O -g -DVERSION=\"6.8.0-rc3\" -flto=auto -fexceptions
	-fstack-protector-strong -fasynchronous-unwind-tables
	-fstack-clash-protection  -Wall -Werror=format-security
	-Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS
	$(pkg-config --cflags libtracefs)  -I include
	-c -o src/in_kernel.o src/in_kernel.c
[...]

src/in_kernel.c:227:6: warning: variable 'curr_reactor' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
  227 |         if (!end)
      |             ^~~~
src/in_kernel.c:242:9: note: uninitialized use occurs here
  242 |         return curr_reactor;
      |                ^~~~~~~~~~~~
src/in_kernel.c:227:2: note: remove the 'if' if its condition is always false
  227 |         if (!end)
      |         ^~~~~~~~~
  228 |                 goto out_free;
      |                 ~~~~~~~~~~~~~
src/in_kernel.c:221:6: warning: variable 'curr_reactor' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
  221 |         if (!start)
      |             ^~~~~~
src/in_kernel.c:242:9: note: uninitialized use occurs here
  242 |         return curr_reactor;
      |                ^~~~~~~~~~~~
src/in_kernel.c:221:2: note: remove the 'if' if its condition is always false
  221 |         if (!start)
      |         ^~~~~~~~~~~
  222 |                 goto out_free;
      |                 ~~~~~~~~~~~~~
src/in_kernel.c:215:20: note: initialize the variable 'curr_reactor' to silence this warning
  215 |         char *curr_reactor;
      |                           ^
      |                            = NULL
2 warnings generated.

Which is correct. Setting curr_reactor to NULL avoids the problem.

Link: https://lkml.kernel.org/r/3a35551149e5ee0cb0950035afcb8082c3b5d05b.1707217097.git.bristot@kernel.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Donald Zickus <dzickus@redhat.com>
Fixes: 6d60f89691fc ("tools/rv: Add in-kernel monitor interface")
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/verification/rv/src/in_kernel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -210,9 +210,9 @@ static char *ikm_read_reactor(char *moni
 static char *ikm_get_current_reactor(char *monitor_name)
 {
 	char *reactors = ikm_read_reactor(monitor_name);
+	char *curr_reactor = NULL;
 	char *start;
 	char *end;
-	char *curr_reactor;
 
 	if (!reactors)
 		return NULL;


