Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6E2E6100;
	Tue, 15 Jul 2025 13:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586917; cv=none; b=EUWWEFFG45xVa8bxuhlfBHRwnoH2bM9l7v8+0CWcPLwDves1OWxJD1ZF076TzcOxQSiWj9EKS1n/YY4hBAN2y3/od8XiS6PDUM5AnhZ4L1bRawPNoxK14o6X1F6AqXzbT5gpAypR6XXGrgPnB29aXQ7Slf31aco419/LSppW2Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586917; c=relaxed/simple;
	bh=AobKhIJOOcobIKHaHVfGPaLQlP7XDeSkY+oN1ygrZpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0OM9aWWYv49Q7llliemP3DUnv/qMs7coP0GlGi1aFlnyO9oQ+IzTwxVJIQbenezM/fz66u2msdwSGmVZ37iLizZn6CCjdCTEIgUjE4mOv/g9LU3tpalmamShozajrjSIB5uPsD08W4BiSo52U/q5ClwPa/13tEcWCUyvztIEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeI/zfla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeI/zfla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB8CC4CEE3;
	Tue, 15 Jul 2025 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586917;
	bh=AobKhIJOOcobIKHaHVfGPaLQlP7XDeSkY+oN1ygrZpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeI/zfla+P1nEbNkqcbyfm6pWhGN762zB6VSC2e/6E0w9VmG97hybrnHLo2oqLNLo
	 CefrtpyeAhs75T1do/yb9AY50p71xgLPVG/ULKZ28bSdAut4q02bgRl+rC9DKod7k3
	 JVlNp6L+tTOgWyJUplqOPVKTqsYnfd+TpKI8lvbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Achill Gilgenast <fossdd@pwned.life>,
	Luis Henriques <luis@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 098/192] kallsyms: fix build without execinfo
Date: Tue, 15 Jul 2025 15:13:13 +0200
Message-ID: <20250715130818.828653969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Achill Gilgenast <fossdd@pwned.life>

commit a95743b53031b015e8949e845a9f6fdfb2656347 upstream.

Some libc's like musl libc don't provide execinfo.h since it's not part of
POSIX.  In order to fix compilation on musl, only include execinfo.h if
available (HAVE_BACKTRACE_SUPPORT)

This was discovered with c104c16073b7 ("Kunit to check the longest symbol
length") which starts to include linux/kallsyms.h with Alpine Linux'
configs.

Link: https://lkml.kernel.org/r/20250622014608.448718-1-fossdd@pwned.life
Fixes: c104c16073b7 ("Kunit to check the longest symbol length")
Signed-off-by: Achill Gilgenast <fossdd@pwned.life>
Cc: Luis Henriques <luis@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/kallsyms.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/include/linux/kallsyms.h
+++ b/tools/include/linux/kallsyms.h
@@ -18,6 +18,7 @@ static inline const char *kallsyms_looku
 	return NULL;
 }
 
+#ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #include <stdlib.h>
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
@@ -30,5 +31,8 @@ static inline void print_ip_sym(const ch
 
 	free(name);
 }
+#else
+static inline void print_ip_sym(const char *loglvl, unsigned long ip) {}
+#endif
 
 #endif


