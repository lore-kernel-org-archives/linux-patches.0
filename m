Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045BE33E36A;
	Wed,  3 Dec 2025 16:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779901; cv=none; b=JcE7E5fAneX//Qpt3T/tCPrCS7o6zcq0/Bvht7oIa4NYpo7hIlJpWG6t+YCBFS5Kx8qS0mi575moblRvBQSVxOabghMDuLxOSVoXuyZXxSZBigcv89dXks9TZVl1Y9r0bILbDuWWlTZHuOlJQ7TMBn7z+vhR4GqlYuilXBjgbQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779901; c=relaxed/simple;
	bh=4lV0apCaPBcIGeYdFUq+Ntm2f7k6QBDZLAcoInOqOII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq6NWv/SCiuc9uLtcw70ZHfFhgtptkNH9CkHOx/cNN8PVozMFZsWgHcIbEgrIrv0H3H8CkPPvJFvtA8FIdh39GgkuzG+wJMzhzOR05qTBRvovEosrpp7xGdavzC23r5Ce16hpem8oml1p85Mj/kx1AIeMiNVNRwA9/VeNllSS6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ar75an/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ar75an/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B71C4CEF5;
	Wed,  3 Dec 2025 16:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779900;
	bh=4lV0apCaPBcIGeYdFUq+Ntm2f7k6QBDZLAcoInOqOII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ar75an/p42JbLjUa02TmKddh5rLyEPgAFJ7yOcRmMP6H30GwD26RD0Vv64GGZSFWh
	 Fr3+u1qW6XrFwi4hYbE8tGoB82uPHc+WC0C/cuS/9UN4l9REHtBWnQZsn13vFSSOAB
	 iAKwuXSLCdlzfH6YyLM3CsHzodd2KYzMME+Xu6VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 397/568] gcov: add support for GCC 15
Date: Wed,  3 Dec 2025 16:26:39 +0100
Message-ID: <20251203152455.231985745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


