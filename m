Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEF1151CEF;
	Tue, 20 Feb 2024 21:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464011; cv=none; b=MmiXC8/dBztoOK4L6VjhqKhmDit8/fJk3lEYpRvkFJ2cGBSuJjQ/0FSy/PNGo6fPp5Y/BAM2AdHKJ9w3IKVi+OoomgugtiP/T/DWFPdZXyCQYcwIVHTDSnUD1EFGa3FrH30kKS2GVgnEraSY3l94VvBw7ylafEN/5f6S4dCvjOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464011; c=relaxed/simple;
	bh=7E2GcgfiXiwBlA1ZtzCjif4AeJkwLU1zxSgjLI9uEt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBWQMYTT3ELGHfLmkY4wXiG/7x9/Jl2U59vLiBmfpG+VU9mXzbYAY/71nit5EE5jjnn69KBzjIXtE3lmTyf+1qTNPgs6oOzhNjHu2wFJYMlX8l+yTKGCFFHeVf+VMGQ69U1E44mR/08FJ2V2T66Oiv42C3ThX9aDOPI8vo4RAY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrP25U4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrP25U4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC21C433F1;
	Tue, 20 Feb 2024 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464011;
	bh=7E2GcgfiXiwBlA1ZtzCjif4AeJkwLU1zxSgjLI9uEt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrP25U4y344YpUdwElMiagPNBdduitWoeiTR+VAyeF3D3A6BZT2oyxmmedQ64NuEz
	 Um6EoPT31/sq1fw+WJxCqgRYV80EY8lk/lk8PvhGS14YDRGOCuMDqy+4LSz2ON/3RN
	 RRIWB++khT7GnmRfGtnmGEKLHKE7LSipBjWGtj3k=
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
Subject: [PATCH 6.6 224/331] tools/rv: Fix curr_reactor uninitialized variable
Date: Tue, 20 Feb 2024 21:55:40 +0100
Message-ID: <20240220205644.787301176@linuxfoundation.org>
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


