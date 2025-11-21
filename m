Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBA3350D43;
	Fri, 21 Nov 2025 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733523; cv=none; b=VbUyGuhvF+nyVPq5wKvAS8lwZnW4TPp9rBoujUu9PE2gMpYViO/uu4rFkeymR7EV7mrCdd2ac4pGKkYycj9CgN6yonvTBWvjgu+sovol3w1BP85mwIOKm2Wjab1Bd8hEDS9J974CUqUSw2A7RdGvyWWhsir/tZI36J4aNqEvTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733523; c=relaxed/simple;
	bh=bqte0bTzV6tCIlhsJa46upJRbhIYKPeQRen6UeXKq0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA5Q4h5RxQL3XX7UJfLWHsriXwKjI166XUijgeNZyWha52aQQpo3IMH2lz7KJEe/6iXAdbi7uiWRZnPjl/7z+tEidlvUhY6KMrMHpYbvHas3ZNiLpr/o8oqUE1IcOEmZD/LgzJeOQwINGHWO8C4/cySSXfRDJIH6LZoz2nhjkuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgFFdzP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgFFdzP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C12BC4CEF1;
	Fri, 21 Nov 2025 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733523;
	bh=bqte0bTzV6tCIlhsJa46upJRbhIYKPeQRen6UeXKq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgFFdzP9zuFS+HgvPBgpy2p2e9cwZXwMXSKxcIODR2TkoAE69qUWgSjgfuBVgiDC6
	 85RU/umXv1GjD1D+8e3awKcpmAYh4pWa/6VnGliXpZkDjRpT+XsIWRTcD8K24dp9QU
	 flIbNCU9eXObAueJla2k4cZVPLvPuxy5DyYnH9hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 464/529] gcov: add support for GCC 15
Date: Fri, 21 Nov 2025 14:12:43 +0100
Message-ID: <20251121130247.520160385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


