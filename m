Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3242D6419;
	Tue, 15 Jul 2025 13:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585901; cv=none; b=THKA6JqkxHuBJLjTVo6uCTvXgAmtWbnjzXUyPnVzEpY2T77yRLVC5aukA7uM7v4ih8lX9JB0Pg0kUQDLqvT0pny/RHdCQjhmkeSGMO1q/eUm0eeHz+IbTb9zT3SZMpWA3pvK0YYxaZYEBsDi8UMlJQIyhV8hMCEAEhTLBND8RWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585901; c=relaxed/simple;
	bh=cxSKuYPxuZqSnOpkuY8Hc9MmKfBqo6v0aGcQY/WB9T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qG/GzP8NOSyERMd4IbB0OGPLxLFneHEBMu5MqrLxTbQ6xH/2qRrVd4FJqDnHcuEl99PmhsVuvHN2j7bhhY79G4cIuPMjJWM/ZfUSoSwzsdH0IhHlHULqRnGlVxtIKR8nybNKWbEwyBHXUeHDzsoulYaJkRYcAE5Qbg2wywa0KbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2+0Z/kV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2+0Z/kV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610F1C4CEF1;
	Tue, 15 Jul 2025 13:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585901;
	bh=cxSKuYPxuZqSnOpkuY8Hc9MmKfBqo6v0aGcQY/WB9T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2+0Z/kVyHs69vdDRH/M7vKsMXUYf5JG7NjkQ9VfEyL3Fbfr1PEWPMT4Qe70WqJoU
	 ao39sOrUL6PMIOTp9yGlcvFtPtsblml7ONvkNAtbOXoC6BoGvxVE1FyuMAZd81OhBb
	 J5KwZ2njw6q8i4K67QX258NEur6MGe163AfVtdqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Achill Gilgenast <fossdd@pwned.life>,
	Luis Henriques <luis@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 051/109] kallsyms: fix build without execinfo
Date: Tue, 15 Jul 2025 15:13:07 +0200
Message-ID: <20250715130800.918603388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


