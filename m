Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201B02FB63A;
	Wed,  3 Dec 2025 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778199; cv=none; b=SjWOGi7wa+i4FRKtbCQJ3Qaxa5q+CdDTeMNnTevbB/ZXm5HbOee/uy3xJEp1oukitALCan1mlf0ihAqRC1wydgQw8NPjX0mELqIIMB7Zoav890vY5D4LZqao9Qo64fMdXlJbsoquP/h+Ua3sfCyT/X4EKSe2mbV2Wtog/zsyR9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778199; c=relaxed/simple;
	bh=DsvOM8grsm3CB0tDT+kaTj3a2uAdb3gzX0QLqZzMrXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n08rjOV2pWDQNK6Pui1QfyIfTasWPm4ATX4pw+QRXNM2K+DTP6BJeCOqszTWKzVM8KNUUdOrvgFIwTI4x/YKJhzHkBEcKn67mgNGQwCxWUXNi+cHaUmEAUQjTsS7QCijNhvaIChQ+Nl0Z9nJQEmwcEI0uD4+8Tgy43ISD8qjQRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhPCREga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhPCREga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FB6C116B1;
	Wed,  3 Dec 2025 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778199;
	bh=DsvOM8grsm3CB0tDT+kaTj3a2uAdb3gzX0QLqZzMrXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhPCREgaKK2a6USq1qRaZc0no/6hWb3e1626ab+z5zYYCfShx7jotIgzlqGq6xpYw
	 221rF9hQuEJAVc1Q8E/4tBQVTYTBk88Y0vGWz1wYmwCcTfHun+yTJcYnRnsijgiiUK
	 p+nvK3Kweih0CZ/yrh5HgcYpf/T65aA702OS1qMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 272/392] gcov: add support for GCC 15
Date: Wed,  3 Dec 2025 16:27:02 +0100
Message-ID: <20251203152424.173219151@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit ec4d11fc4b2dd4a2fa8c9d801ee9753b74623554 upstream.

Using gcov on kernels compiled with GCC 15 results in truncated 16-byte
long .gcda files with no usable data.  To fix this, update GCOV_COUNTERS
to match the value defined by GCC 15.

Tested with GCC 14.3.0 and GCC 15.2.0.

Link: https://lkml.kernel.org/r/20251028115125.1319410-1-oberpar@linux.ibm.com
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reported-by: Matthieu Baerts <matttbe@kernel.org>
Closes: https://github.com/linux-test-project/lcov/issues/445
Tested-by: Matthieu Baerts <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/gcov/gcc_4_7.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/gcov/gcc_4_7.c
+++ b/kernel/gcov/gcc_4_7.c
@@ -18,7 +18,9 @@
 #include <linux/mm.h>
 #include "gcov.h"
 
-#if (__GNUC__ >= 14)
+#if (__GNUC__ >= 15)
+#define GCOV_COUNTERS			10
+#elif (__GNUC__ >= 14)
 #define GCOV_COUNTERS			9
 #elif (__GNUC__ >= 10)
 #define GCOV_COUNTERS			8


