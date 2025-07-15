Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5432E3B01;
	Tue, 15 Jul 2025 13:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585633; cv=none; b=lz4/tEPvzEN6GEPxgbKjHG/D4rUb4O9RtJ80LR9nCnzCflC9LHzw8pAtO9+Bb66FRPq4HZySn5d9jPKCeVkOcWJuCc6nD11JxadBaDM7Gd806TKnsZdpHvnjalfxRp4XqdyNX3v7Tido9qa7WJIgd3aoBAX8SNY6PDqixb3zw+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585633; c=relaxed/simple;
	bh=K7mfySGqvbwbBxGc0soAFQv0PKZjGdOWkR14XuU4y3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djx/iE6siQsXk19FL3KtqaEjuqsANCClUH/4DyaHns954MLsDrlTb3hnatOMtUYyq+MpWbZiGDFdTrfopiSZnUOMhAkT+IV7e3I7gfQPiL8dFt6HdkdEW6SfFpmEE2Crgb1/rb2f1QvauFY/dWGyJNdkS9sDQjl1lO+VBaDta6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/b7UGqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/b7UGqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A742CC4CEF6;
	Tue, 15 Jul 2025 13:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585633;
	bh=K7mfySGqvbwbBxGc0soAFQv0PKZjGdOWkR14XuU4y3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/b7UGqrIfmHxRQIrkVuBsfW6Y2OYz80G8VMyOEz0uqlFsvb25wWgiV4y9JScDbMb
	 iLISijOlfFUByHWru3NqEmA+TqWna8VLrF6ozPKOMiF+BADkQDF/6ybe640s4gxwFY
	 7KXgjIUYGaEP10p7Ltl77kDbLnhNVIoGAv7vlduY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Achill Gilgenast <fossdd@pwned.life>,
	Luis Henriques <luis@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 086/163] kallsyms: fix build without execinfo
Date: Tue, 15 Jul 2025 15:12:34 +0200
Message-ID: <20250715130812.177109362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


