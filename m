Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD62561AE;
	Tue, 15 Jul 2025 13:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587289; cv=none; b=Xl3GLZVpmYLSwZiKV0CM70L2yOX1nMVKMu4Ug7HCW1LFEB2gjzIiZCRhLH13iQCqEW54qCxRftuD6SDYnLI/BpxKMZvdC0dKQOa9BaDzuuoudTpewXg3KO11sJ0nbrsyDNUqFDvAi8n1COw2a4XbtA4WyeDgtv3k35+LL01lTDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587289; c=relaxed/simple;
	bh=gymZ/Fst5fKmTI6aG2s4e8MO13Cy9VwnbsW8ZMXgB7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLjWNMVY6xa8ljGQMz1JQgmUk1perWyJB9bw7rYBEdbpw03ClM6ghUz2m+eyL++ZJ/TqOMWUViHFIriiCm1fMJhSagWFyI8suWtdCH+Su0+/+3E9xxFOGedlfxSKj9onoKKRGXZe7sUG2+mB32bgYOhXkj/3G2oqaBkthnx87BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KT7/ITUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KT7/ITUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAFBC4CEE3;
	Tue, 15 Jul 2025 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587289;
	bh=gymZ/Fst5fKmTI6aG2s4e8MO13Cy9VwnbsW8ZMXgB7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KT7/ITURx4GjcpPfUbVLmca8/3ZUGtX7stlpXa/eR/Y69ofIDautmNDo6Q2mksbV5
	 gIJriiu5z7dX40+5hLcJ3qqYSqY4wrZUfTRkKtJIGhikjP1Vvvq8FvwlwiWGPT96G3
	 44G+hR5gib3QVC8ECK8chxRfNAd4uhP390Rq/9TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Achill Gilgenast <fossdd@pwned.life>,
	Luis Henriques <luis@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 37/88] kallsyms: fix build without execinfo
Date: Tue, 15 Jul 2025 15:14:13 +0200
Message-ID: <20250715130756.013086225@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 tools/include/linux/kallsyms.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/include/linux/kallsyms.h b/tools/include/linux/kallsyms.h
index 5a37ccbec54f..f61a01dd7eb7 100644
--- a/tools/include/linux/kallsyms.h
+++ b/tools/include/linux/kallsyms.h
@@ -18,6 +18,7 @@ static inline const char *kallsyms_lookup(unsigned long addr,
 	return NULL;
 }
 
+#ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
 #include <stdlib.h>
 static inline void print_ip_sym(const char *loglvl, unsigned long ip)
@@ -30,5 +31,8 @@ static inline void print_ip_sym(const char *loglvl, unsigned long ip)
 
 	free(name);
 }
+#else
+static inline void print_ip_sym(const char *loglvl, unsigned long ip) {}
+#endif
 
 #endif
-- 
2.50.1



